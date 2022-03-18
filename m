Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AEBC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 21:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237606AbiCRVoU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 17:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiCRVoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 17:44:16 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6723252A7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 14:42:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D6F2210E50B1;
        Sat, 19 Mar 2022 08:42:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nVKN3-0075lQ-MV; Sat, 19 Mar 2022 08:42:53 +1100
Date:   Sat, 19 Mar 2022 08:42:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <20220318214253.GG1544202@dread.disaster.area>
References: <YjSNTd+U3HBq/Gsv@bfoster>
 <YjSvG0wgm6epCa8X@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <YjSvG0wgm6epCa8X@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6234fcdf
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=20KFwNOVAAAA:8 a=4DY0DV959iWK73p_WEwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 12:11:07PM -0400, Brian Foster wrote:
> On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> > Hi,
> > 
> > I'm not sure if this is known and/or fixed already, but it didn't look
> > familiar so here is a report. I hit a splat when testing Willy's
> > prospective folio bookmark change and it turns out it replicates on
> > Linus' current master (551acdc3c3d2). This initially reproduced on
> > xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> > xfs/006, but when I attempted to reproduce the latter a second time I
> > hit what looks like the same problem as xfs/264. Both tests seem to
> > involve some form of error injection, so possibly the same underlying
> > problem. The GPF splat from xfs/264 is below.
> > 
> 
> Darrick pointed out this [1] series on IRC (particularly the final
> patch) so I gave that a try. I _think_ that addresses the GPF issue
> given it was nearly 100% reproducible before and I didn't see it in a
> few iterations, but once I started a test loop for a longer test I ran
> into the aforementioned soft lockup again. A snippet of that one is
> below [2]. When this occurs, the task appears to be stuck (i.e. the
> warning repeats) indefinitely.
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/20220317053907.164160-1-david@fromorbit.com/
> [2] Soft lockup warning from xfs/264 with patches from [1] applied:
> 
> watchdog: BUG: soft lockup - CPU#52 stuck for 134s! [kworker/52:1H:1881]
> Modules linked in: rfkill rpcrdma sunrpc intel_rapl_msr intel_rapl_common rdma_ucm ib_srpt ib_isert iscsi_target_mod i10nm_edac target_core_mod x86_pkg_temp_thermal intel_powerclamp ib_iser coretemp libiscsi scsi_transport_iscsi kvm_intel rdma_cm ib_umad ipmi_ssif ib_ipoib iw_cm ib_cm kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul acpi_ipmi mlx5_ib ghash_clmulni_intel bnxt_re ipmi_si rapl intel_cstate ib_uverbs ipmi_devintf mei_me isst_if_mmio isst_if_mbox_pci i2c_i801 nd_pmem ib_core intel_uncore wmi_bmof pcspkr isst_if_common mei i2c_smbus intel_pch_thermal ipmi_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg mlx5_core lpfc mgag200 i2c_algo_bit drm_shmem_helper nvmet_fc drm_kms_helper nvmet nvme_fc mlxfw nvme_fabrics syscopyarea sysfillrect pci_hyperv_intf sysimgblt fb_sys_fops nvme_core ahci tls t10_pi libahci crc32c_intel psample scsi_transport_fc bnxt_en drm megaraid_sas tg3 libata wmi nfit libnvdimm dm_mirror dm_region_hash
>  dm_log dm_mod
> CPU: 52 PID: 1881 Comm: kworker/52:1H Tainted: G S           L    5.17.0-rc8+ #17
> Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
> Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
> RIP: 0010:native_queued_spin_lock_slowpath+0x1b0/0x1e0
> Code: c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00 48 03 04 cd e0 ba 00 8c 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 0a 48 85 c9 0f 84 6b ff ff ff 0f 0d 09
> RSP: 0018:ff4ed0b360e4bb48 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: ff3413f05c684540 RCX: 0000000000001719
> RDX: ff34142ebfeb0d40 RSI: ffffffff8bf826f6 RDI: ffffffff8bf54147
> RBP: ff34142ebfeb0d40 R08: ff34142ebfeb0a68 R09: 00000000000001bc
> R10: 00000000000001d1 R11: 0000000000000abd R12: 0000000000d40000
> R13: 0000000000000008 R14: ff3413f04cd84000 R15: ff3413f059404400
> FS:  0000000000000000(0000) GS:ff34142ebfe80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9200514f70 CR3: 0000000216c16005 CR4: 0000000000771ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  _raw_spin_lock+0x2c/0x30
>  xfs_trans_ail_delete+0x2a/0xd0 [xfs]

So what is running around in a tight circle holding the AIL lock?

Or what assert failed before this while holding the AIL lock?

>  xfs_buf_item_done+0x22/0x30 [xfs]
>  xfs_buf_ioend+0x71/0x5e0 [xfs]
>  xfs_trans_committed_bulk+0x167/0x2c0 [xfs]
>  ? enqueue_entity+0x121/0x4d0
>  ? enqueue_task_fair+0x417/0x530
>  ? resched_curr+0x23/0xc0
>  ? check_preempt_curr+0x3f/0x70
>  ? _raw_spin_unlock_irqrestore+0x1f/0x31
>  ? __wake_up_common_lock+0x87/0xc0
>  xlog_cil_committed+0x29c/0x2d0 [xfs]
>  ? _raw_spin_unlock_irqrestore+0x1f/0x31
>  ? __wake_up_common_lock+0x87/0xc0
>  xlog_cil_process_committed+0x69/0x80 [xfs]
>  xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
>  xlog_force_shutdown+0xd0/0x110 [xfs]

The stack trace here looks mangled - it's missing functions between
xfs_trans_committed_bulk() and xfs_buf_ioend()

xfs_trans_committed_bulk(abort = true)
  xfs_trans_committed_bulk
    lip->li_iop->iop_unpin(remove = true)
      xfs_buf_item_unpin()
        xfs_buf_ioend_fail()
	  xfs_buf_ioend()
	    xfs_buf_item_done()

Unless, of course, the xfs_buf_ioend symbol is wrongly detected
because it's the last function call in xfs_buf_item_unpin(). That
would give a stack of

xfs_trans_committed_bulk(abort = true)
  xfs_trans_committed_bulk
    lip->li_iop->iop_unpin(remove = true)
      xfs_buf_item_unpin()
        xfs_buf_item_done()

Which is the stale inode buffer release path. Which has a problem
as I mention here:

https://lore.kernel.org/linux-xfs/20220317053907.164160-8-david@fromorbit.com/

@@ -720,6 +721,17 @@ xfs_iflush_ail_updates(
 		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn)
 			continue;
 
+		/*
+		 * dgc: Not sure how this happens, but it happens very
+		 * occassionaly via generic/388.  xfs_iflush_abort() also
+		 * silently handles this same "under writeback but not in AIL at
+		 * shutdown" condition via xfs_trans_ail_delete().
+		 */
+		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
+			ASSERT(xlog_is_shutdown(lip->li_log));
+			continue;
+		}
+

THe symptoms that this worked around were double AIL unlocks, AIL
list corruptions, and bp->b_li_list corruptions leading to
xfs_buf_inode_iodone() getting stuck in an endless loop whilst
holding the AIL lock, leading to soft lookups exactly like this one.

I now know what is causing this problem - it is xfs_iflush_abort()
being called from xfs_inode_reclaim() that removes the inode from
buffer list without holding the buffer lock.

Hence a traversal in xfs_iflush_cluster or xfs_buf_inode_iodone
can store the next inode in the list in n, n then gets aborted by
reclaim and removed from the lsit, and then the list traversal moves
onto n, and it's now an empty list because it was removed. Hence
the list traversal gets stuck forever on n because n->next = n.....

If this sort of thing happens in xfs_iflush_ail_updates(), we can
either do a double AIL removal which fires an assert with the AIL
lock held, or we get stuck spinning on n with
the AIL lock held. Either way, they both lead to softlockups on the
AIL lock like this one.

'echo l > sysrq-trigger' is your friend in these situations - you'll
see if there's a process spinning with the lock held on some other
CPU...

This situation is a regression introduced in the async inode reclaim
patch series:

https://lore.kernel.org/linux-xfs/20200622081605.1818434-1-david@fromorbit.com/

And is a locking screwup with xfs_iflush_abort() being called
without holding the inode cluster buffer lock. It was a thinko
w.r.t. list removal and traversal using the inode item lock. The bug
has been there since June 2020, and it's only now that we have
peeled back the shutdown onion a couple of layers further that it is
manifesting.

I have a prototype patch (below) to fix this - the locking is not
pretty, but the AIL corruptions and soft lockups have gone away in
my testing only to be replaced with a whole new set of g/388
failures *I have never seen before*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: locking on b_io_list is broken for inodes

From: Dave Chinner <dchinner@redhat.com>

Most buffer io list operations are run with the bp->b_lock held, but
xfs_iflush_abort() can be called without the buffer lock being held
resulting in inodes being removed from the buffer list while other
list operations are occurring. This causes problems with corrupted
bp->b_io_list inode lists during filesystem shutdown, leading to
traversals that never end, double removals from the AIL, etc.

Fix this by passing the buffer to xfs_iflush_abort() if we have
it locked. If the inode is attached to the buffer, we're going to
have to remove it from the buffer list and we'd have to get the
buffer off the inode log item to do that anyway.

If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
then we can determine if the inode has a log item and if it is
attached to a buffer before we do anything else. If it does have an
attached buffer, we can lock it safely (because the inode has a
reference to it) and then perform the inode abort.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c     |   2 +-
 fs/xfs/xfs_inode.c      |   4 +-
 fs/xfs/xfs_inode_item.c | 123 ++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_inode_item.h |   2 +-
 4 files changed, 87 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4148cdf7ce4a..ec907be2d5b1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -883,7 +883,7 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
-		xfs_iflush_abort(ip);
+		xfs_iflush_abort(ip, NULL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aab55a06ece7..de8815211a7a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3612,7 +3612,7 @@ xfs_iflush_cluster(
 
 	/*
 	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
-	 * can remove itself from the list.
+	 * will remove itself from the list.
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = (struct xfs_inode_log_item *)lip;
@@ -3662,7 +3662,7 @@ xfs_iflush_cluster(
 		 */
 		if (xlog_is_shutdown(mp->m_log)) {
 			xfs_iunpin_wait(ip);
-			xfs_iflush_abort(ip);
+			xfs_iflush_abort(ip, bp);
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			error = -EIO;
 			continue;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 11158fa81a09..89fa1fd9ed5b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -721,17 +721,6 @@ xfs_iflush_ail_updates(
 		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn)
 			continue;
 
-		/*
-		 * dgc: Not sure how this happens, but it happens very
-		 * occassionaly via generic/388.  xfs_iflush_abort() also
-		 * silently handles this same "under writeback but not in AIL at
-		 * shutdown" condition via xfs_trans_ail_delete().
-		 */
-		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
-			ASSERT(xlog_is_shutdown(lip->li_log));
-			continue;
-		}
-
 		lsn = xfs_ail_delete_one(ailp, lip);
 		if (!tail_lsn && lsn)
 			tail_lsn = lsn;
@@ -799,7 +788,7 @@ xfs_buf_inode_iodone(
 		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 
 		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
-			xfs_iflush_abort(iip->ili_inode);
+			xfs_iflush_abort(iip->ili_inode, bp);
 			continue;
 		}
 		if (!iip->ili_last_fields)
@@ -834,44 +823,98 @@ xfs_buf_inode_io_fail(
 }
 
 /*
- * This is the inode flushing abort routine.  It is called when
- * the filesystem is shutting down to clean up the inode state.  It is
- * responsible for removing the inode item from the AIL if it has not been
- * re-logged and clearing the inode's flush state.
+ * Abort flushing the inode.
+ *
+ * There are two cases where this is called. The first is when the inode cluster
+ * buffer has been removed and the inodes attached to it have been marked
+ * XFS_ISTALE. Inode cluster buffer IO completion will be called on the buffer to mark the stale
+ * inodes clean and remove them from the AIL without doing IO on them. The inode
+ * should always have a log item attached if it is ISTALE, and we should always
+ * be passed the locked buffer the inodes are attached to.
+ *
+ * The second case is log shutdown. When the log has been shut down, we need
+ * to abort any flush that is in progress, mark the inode clean and remove it
+ * from the AIL. We may get passed clean inodes without log items, as well as
+ * clean inodes with log items that aren't attached to cluster buffers. And
+ * depending on whether we are called from, we may or may not have a locked
+ * buffer passed to us.
+ *
+ * If we don't have a locked buffer, we try to get it from the inode log item.
+ * If there is a buffer attached to the ili, then we have a reference to the
+ * buffer and we can safely lock it, then remove the inode from the buffer.
  */
 void
 xfs_iflush_abort(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_buf		*locked_bp)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_buf		*bp = NULL;
+	struct xfs_buf		*ibp;
 
-	if (iip) {
-		/*
-		 * Clear the failed bit before removing the item from the AIL so
-		 * xfs_trans_ail_delete() doesn't try to clear and release the
-		 * buffer attached to the log item before we are done with it.
-		 */
-		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
-		xfs_trans_ail_delete(&iip->ili_item, 0);
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
+	}
 
-		/*
-		 * Clear the inode logging fields so no more flushes are
-		 * attempted.
-		 */
-		spin_lock(&iip->ili_lock);
-		iip->ili_last_fields = 0;
-		iip->ili_fields = 0;
-		iip->ili_fsync_fields = 0;
-		iip->ili_flush_lsn = 0;
-		bp = iip->ili_item.li_buf;
-		iip->ili_item.li_buf = NULL;
-		list_del_init(&iip->ili_item.li_bio_list);
+	/*
+	 * Capture the associated buffer and lock it if the caller didn't
+	 * pass us the locked buffer to begin with.
+	 */
+	spin_lock(&iip->ili_lock);
+	ibp = iip->ili_item.li_buf;
+	if (!locked_bp && ibp) {
+		xfs_buf_hold(ibp);
 		spin_unlock(&iip->ili_lock);
+		xfs_buf_lock(ibp);
+		spin_lock(&iip->ili_lock);
+		if (!iip->ili_item.li_buf) {
+			/*
+			 * Raced with another removal, hold the only reference
+			 * to ibp now.
+			 */
+			ASSERT(list_empty(&iip->ili_item.li_bio_list));
+		} else {
+			/*
+			 * Got two references to ibp, drop one now. The other
+			 * ges dropped when we are done.
+			 */
+			ASSERT(iip->ili_item.li_buf == ibp);
+			xfs_buf_rele(ibp);
+		}
+	} else {
+		ASSERT(!ibp || ibp == locked_bp);
 	}
+
+	/*
+	 * Clear the inode logging fields so no more flushes are attempted.
+	 * If we are on a buffer list, it is now safe to remove it because
+	 * the buffer is guaranteed to be locked.
+	 */
+	iip->ili_last_fields = 0;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	iip->ili_flush_lsn = 0;
+	iip->ili_item.li_buf = NULL;
+	list_del_init(&iip->ili_item.li_bio_list);
+	spin_unlock(&iip->ili_lock);
+
+	/*
+	 * Clear the failed bit before removing the item from the AIL so
+	 * xfs_trans_ail_delete() doesn't try to clear and release the buffer
+	 * attached to the log item before we are done with it.
+	 */
+	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
+	xfs_trans_ail_delete(&iip->ili_item, 0);
+
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
-	if (bp)
-		xfs_buf_rele(bp);
+
+	/* we can now release the buffer reference the inode log item held. */
+	if (ibp) {
+		if (!locked_bp)
+			xfs_buf_unlock(ibp);
+		xfs_buf_rele(ibp);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 1a302000d604..01e5845c7f3d 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -43,7 +43,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
-extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_abort(struct xfs_inode *, struct xfs_buf *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
