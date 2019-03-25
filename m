Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfCYTk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 15:40:26 -0400
Date: Mon, 25 Mar 2019 12:40:21 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325194021.GJ10344@bombadil.infradead.org>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard>
 <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia>
 <20190325164129.GH10344@bombadil.infradead.org>
 <CAOQ4uximHOCM8Fo_WctXAjpft31OS+VBcjUqteuK6kjn+nVoKA@mail.gmail.com>
 <20190325182239.GI10344@bombadil.infradead.org>
 <CAOQ4uxicH-f4TBx_anwWfTb=z6xDvV=dW3HFwG8+eKkqwKMuPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxicH-f4TBx_anwWfTb=z6xDvV=dW3HFwG8+eKkqwKMuPw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 09:18:51PM +0200, Amir Goldstein wrote:
> On Mon, Mar 25, 2019 at 8:22 PM Matthew Wilcox <willy@infradead.org> wrote:
> > On Mon, Mar 25, 2019 at 07:30:39PM +0200, Amir Goldstein wrote:
> > > On Mon, Mar 25, 2019 at 6:41 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > > I think it is a bug that we only wake readers at the front of the queue;
> > > > I think we would get better performance if we wake all readers.  ie here:
> 
> So I have no access to the test machine of former tests right now,
> but when running the same filebench randomrw workload
> (8 writers, 8 readers) on VM with 2 CPUs and SSD drive, results
> are not looking good for this patch:
> 
> --- v5.1-rc1 / xfs ---
> rand-write1          852404ops    14202ops/s 110.9mb/s      0.6ms/op
> [0.01ms - 553.45ms]
> rand-read1           26117ops      435ops/s   3.4mb/s     18.4ms/op
> [0.04ms - 632.29ms]
> 61.088: IO Summary: 878521 ops 14636.774 ops/s 435/14202 rd/wr
> 114.3mb/s   1.1ms/op
> 
> --- v5.1-rc1 / xfs + patch above ---
> rand-write1          1117998ops    18621ops/s 145.5mb/s      0.4ms/op
> [0.01ms - 788.19ms]
> rand-read1           7089ops      118ops/s   0.9mb/s     67.4ms/op
> [0.03ms - 792.67ms]
> 61.091: IO Summary: 1125087 ops 18738.961 ops/s 118/18621 rd/wr
> 146.4mb/s   0.8ms/op
> 
> --- v5.1-rc1 / xfs + remove XFS_IOLOCK_SHARED from
> xfs_file_buffered_aio_read ---
> rand-write1          1025826ops    17091ops/s 133.5mb/s      0.5ms/op
> [0.01ms - 909.20ms]
> rand-read1           115162ops     1919ops/s  15.0mb/s      4.2ms/op
> [0.00ms - 157.46ms]
> 61.084: IO Summary: 1140988 ops 19009.369 ops/s 1919/17091 rd/wr
> 148.5mb/s   0.8ms/op
> 
> --- v5.1-rc1 / ext4 ---
> rand-write1          867926ops    14459ops/s 113.0mb/s      0.6ms/op
> [0.01ms - 886.89ms]
> rand-read1           121893ops     2031ops/s  15.9mb/s      3.9ms/op
> [0.00ms - 149.24ms]
> 61.102: IO Summary: 989819 ops 16489.132 ops/s 2031/14459 rd/wr
> 128.8mb/s   1.0ms/op
> 
> So rw_semaphore fix is not in the ballpark, not even looking in the
> right direction...
> 
> Any other ideas to try?

Sure!  Maybe the problem is walking the list over and over.  So add new
readers to the front of the list if the head of the list is a reader;
otherwise add them to the tail of the list.

(this won't have quite the same effect as the previous patch because
new readers coming in while the head of the list is a writer will still
get jumbled with new writers, but it should be better than we have now,
assuming the problem is that readers are being delayed behind writers).

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index fbe96341beee..56dbbaea90ee 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -250,8 +250,15 @@ __rwsem_down_read_failed_common(struct rw_semaphore *sem, int state)
 			return sem;
 		}
 		adjustment += RWSEM_WAITING_BIAS;
+		list_add_tail(&waiter.list, &sem->wait_list);
+	} else {
+		struct rwsem_waiter *first = list_first_entry(&sem->wait_list,
+				typeof(*first), list);
+		if (first->type == RWSEM_WAITING_FOR_READ)
+			list_add(&waiter.list, &sem->wait_list);
+		else
+			list_add_tail(&waiter.list, &sem->wait_list);
 	}
-	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = atomic_long_add_return(adjustment, &sem->count);
