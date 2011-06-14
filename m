Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EM5tqr134392 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 17:05:56 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CFE11B2F295
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 15:05:52 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hJLfiBRSsOW7kiOa for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2011 15:05:52 -0700 (PDT)
Date: Tue, 14 Jun 2011 17:05:50 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: suse xfs patches
Message-ID: <20110614220550.GA9138@baloo.cartoons>
References: <20110614201238.GA17586@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20110614201238.GA17586@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: neilb@suse.de, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 14, 2011 at 04:12:38PM -0400, Christoph Hellwig wrote:
> Hi Neil, hi Goldwyn,
> 
> if you find issue with XFS and commit local patches to the SLES tree
> it would be very much appreciated if you could actually send them
> upstream, including an explanation of what you are running into.
> 

Yes sure. I suppose you are refering to the patch attached.
I did not send it upstream because the upstream code had taken a
different approach and the patch was relevant to the SLES kernel
tree only.

FWIW, SGI was involved.

The upstream commits were 90810b9e82a36c3c57c1aeb8b2918b242a130b26 and
ff57ab21995a8636cfc72efeebb09cc6034d756f

-- 
Goldwyn

--d6Gm4EdcadzBjdND
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="xfs-make-xfsbufd-less-aggressive.patch"

From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: XFS - Make xfsbufd less aggressive
References: bnc#649473
Patch-mainline: no

xfsbufd and flush threads are in contention of the xfs_buf_t because
flush thread needs to read a buffer (usually for btree metadata)
which is locked for I/O by xfsbufd for writes. This could block
writes for a long time.

After a run of heavy writes (approx 10 minutes), the vmscan code
shrinks slabs, which instructs xfsbufd to flush the slab cache
as well. xfsbufd receives flush requests. However, this is too 
aggressive for xfsbufd, and causes more contention with flush
threads. To make things worse, the xfsbufd_wakeup returns
zero which does not account to the objects it will free.

This patch makes the flushes less aggressive by returning the count
of objects in the list, and force flushes only when priority > 0.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: NeilBrown <neilb@suse.de>

---
 fs/xfs/linux-2.6/xfs_buf.c |   17 +++++++++++++----
 fs/xfs/linux-2.6/xfs_buf.h |    3 +++
 2 files changed, 16 insertions(+), 4 deletions(-)

--- linux-2.6.32-SLE11-SP1.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6.32-SLE11-SP1/fs/xfs/linux-2.6/xfs_buf.c
@@ -411,7 +411,7 @@ _xfs_buf_lookup_pages(
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
-			xfsbufd_wakeup(0, gfp_mask);
+			xfsbufd_wakeup(1, gfp_mask);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
@@ -1565,6 +1565,7 @@ xfs_alloc_delwrite_queue(
 	INIT_LIST_HEAD(&btp->bt_list);
 	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
 	spin_lock_init(&btp->bt_delwrite_lock);
+	atomic_set(&btp->bt_qcount, 0);
 	btp->bt_flags = 0;
 	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd");
 	if (IS_ERR(btp->bt_task)) {
@@ -1627,6 +1628,7 @@ xfs_buf_delwri_queue(
 
 	bp->b_flags |= _XBF_DELWRI_Q;
 	list_add_tail(&bp->b_list, dwq);
+	atomic_inc(&bp->b_target->bt_qcount);
 	bp->b_queuetime = jiffies;
 	spin_unlock(dwlk);
 
@@ -1669,16 +1671,22 @@ xfsbufd_wakeup(
 	gfp_t			mask)
 {
 	xfs_buftarg_t		*btp;
+	int count = 0;
 
 	spin_lock(&xfs_buftarg_lock);
 	list_for_each_entry(btp, &xfs_buftarg_list, bt_list) {
 		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
 			continue;
-		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
-		wake_up_process(btp->bt_task);
+		if (list_empty(&btp->bt_delwrite_queue))
+			continue;
+		count += atomic_read(&btp->bt_qcount);
+		if (priority) {
+			set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
+			wake_up_process(btp->bt_task);
+		}
 	}
 	spin_unlock(&xfs_buftarg_lock);
-	return 0;
+	return count;
 }
 
 /*
@@ -1715,6 +1723,7 @@ xfs_buf_delwri_split(
 					 _XBF_RUN_QUEUES);
 			bp->b_flags |= XBF_WRITE;
 			list_move_tail(&bp->b_list, list);
+			atomic_dec(&bp->b_target->bt_qcount);
 		} else
 			skipped++;
 	}
--- linux-2.6.32-SLE11-SP1.orig/fs/xfs/linux-2.6/xfs_buf.h
+++ linux-2.6.32-SLE11-SP1/fs/xfs/linux-2.6/xfs_buf.h
@@ -125,6 +125,9 @@ typedef struct xfs_buftarg {
 	struct list_head	bt_delwrite_queue;
 	spinlock_t		bt_delwrite_lock;
 	unsigned long		bt_flags;
+#ifndef __GENKSYMS__
+	atomic_t		bt_qcount;
+#endif
 } xfs_buftarg_t;
 
 /*

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--d6Gm4EdcadzBjdND--
