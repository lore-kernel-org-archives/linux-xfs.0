Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43599 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfCYTTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 15:19:03 -0400
MIME-Version: 1.0
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard> <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia> <20190325164129.GH10344@bombadil.infradead.org>
 <CAOQ4uximHOCM8Fo_WctXAjpft31OS+VBcjUqteuK6kjn+nVoKA@mail.gmail.com> <20190325182239.GI10344@bombadil.infradead.org>
In-Reply-To: <20190325182239.GI10344@bombadil.infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Mar 2019 21:18:51 +0200
Message-ID: <CAOQ4uxicH-f4TBx_anwWfTb=z6xDvV=dW3HFwG8+eKkqwKMuPw@mail.gmail.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 8:22 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Mar 25, 2019 at 07:30:39PM +0200, Amir Goldstein wrote:
> > On Mon, Mar 25, 2019 at 6:41 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Mon, Mar 25, 2019 at 08:47:31AM -0700, Darrick J. Wong wrote:
> > > > Hmmm.... so it looks like the rw_semaphore behavior has shifted over
> > > > time, then?
> > >
> > > Yes.
> > >
> > > > I thought rwsem was supposed to queue read and write waiters in order,
> > > > at least on x86?  Though I suppose that might not matter much since we
> > > > can only run one writer at a time vs. waking up all the readers at once.
> > > > Now I'm wondering if there ever was a time when the readers all got
> > > > batched to the front and starved the writers, but eh I haven't drank
> > > > enough coffee to remember things like that. :P
> > > >
> > > > (I wonder what would happen if rw_semaphore decided to wake up some
> > > > number of the readers in the rwsem wait_list, not just the ones at the
> > > > front...)
> > >
> > > rwsems currently allow a limited amount of queue-jumping; if a semaphore
> > > is currently not acquired (it's in transition between two owners), a
> > > running process can acquire it.
> > >
> > > I think it is a bug that we only wake readers at the front of the queue;
> > > I think we would get better performance if we wake all readers.  ie here:
> > >
> > >         /*
> > > -        * Grant an infinite number of read locks to the readers at the front
> > > -        * of the queue. We know that woken will be at least 1 as we accounted
> > > +        * Grant an infinite number of read locks.  We know that woken will
> > > +        * be at least 1 as we accounted
> > >          * for above. Note we increment the 'active part' of the count by the
> > >          * number of readers before waking any processes up.
> > >          */
> > >         list_for_each_entry_safe(waiter, tmp, &sem->wait_list, list) {
> > >                 struct task_struct *tsk;
> > >
> > > -               if (waiter->type == RWSEM_WAITING_FOR_WRITE)
> > > -                       break;
> > >
> > > Amir, it seems like you have a good test-case for trying this out ...
> >
> > Sure, but please explain. Why are you waking up the writers?
>
> Oh ... duh.  I didn't mean to wake up the writers.  I meant ...
>
>                if (waiter->type == RWSEM_WAITING_FOR_WRITE)
> -                       break;
> +                       continue;
>

So I have no access to the test machine of former tests right now,
but when running the same filebench randomrw workload
(8 writers, 8 readers) on VM with 2 CPUs and SSD drive, results
are not looking good for this patch:

--- v5.1-rc1 / xfs ---
rand-write1          852404ops    14202ops/s 110.9mb/s      0.6ms/op
[0.01ms - 553.45ms]
rand-read1           26117ops      435ops/s   3.4mb/s     18.4ms/op
[0.04ms - 632.29ms]
61.088: IO Summary: 878521 ops 14636.774 ops/s 435/14202 rd/wr
114.3mb/s   1.1ms/op

--- v5.1-rc1 / xfs + patch above ---
rand-write1          1117998ops    18621ops/s 145.5mb/s      0.4ms/op
[0.01ms - 788.19ms]
rand-read1           7089ops      118ops/s   0.9mb/s     67.4ms/op
[0.03ms - 792.67ms]
61.091: IO Summary: 1125087 ops 18738.961 ops/s 118/18621 rd/wr
146.4mb/s   0.8ms/op

--- v5.1-rc1 / xfs + remove XFS_IOLOCK_SHARED from
xfs_file_buffered_aio_read ---
rand-write1          1025826ops    17091ops/s 133.5mb/s      0.5ms/op
[0.01ms - 909.20ms]
rand-read1           115162ops     1919ops/s  15.0mb/s      4.2ms/op
[0.00ms - 157.46ms]
61.084: IO Summary: 1140988 ops 19009.369 ops/s 1919/17091 rd/wr
148.5mb/s   0.8ms/op

--- v5.1-rc1 / ext4 ---
rand-write1          867926ops    14459ops/s 113.0mb/s      0.6ms/op
[0.01ms - 886.89ms]
rand-read1           121893ops     2031ops/s  15.9mb/s      3.9ms/op
[0.00ms - 149.24ms]
61.102: IO Summary: 989819 ops 16489.132 ops/s 2031/14459 rd/wr
128.8mb/s   1.0ms/op

So rw_semaphore fix is not in the ballpark, not even looking in the
right direction...

Any other ideas to try?

Thanks,
Amir.
