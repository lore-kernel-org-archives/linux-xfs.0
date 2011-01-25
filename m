Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8ovDL224491 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:50:57 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFC321DC15C4
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:53:19 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CYbvv6lE5km5lPrG for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:53:19 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PheeI-0003xd-Q4
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:53:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Phebw-0007gK-IY
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: fix efi item leak on forced shutdown
Date: Tue, 25 Jan 2011 19:50:38 +1100
Message-Id: <1295945444-29488-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

After test 139, kmemleak shows:

unreferenced object 0xffff880078b405d8 (size 400):
  comm "xfs_io", pid 4904, jiffies 4294909383 (age 1186.728s)
  hex dump (first 32 bytes):
    60 c1 17 79 00 88 ff ff 60 c1 17 79 00 88 ff ff  `..y....`..y....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81afb04d>] kmemleak_alloc+0x2d/0x60
    [<ffffffff8115c6cf>] kmem_cache_alloc+0x13f/0x2b0
    [<ffffffff814aaa97>] kmem_zone_alloc+0x77/0xf0
    [<ffffffff814aab2e>] kmem_zone_zalloc+0x1e/0x50
    [<ffffffff8147cd6b>] xfs_efi_init+0x4b/0xb0
    [<ffffffff814a4ee8>] xfs_trans_get_efi+0x58/0x90
    [<ffffffff81455fab>] xfs_bmap_finish+0x8b/0x1d0
    [<ffffffff814851b4>] xfs_itruncate_finish+0x2c4/0x5d0
    [<ffffffff814a970f>] xfs_setattr+0x8df/0xa70
    [<ffffffff814b5c7b>] xfs_vn_setattr+0x1b/0x20
    [<ffffffff8117dc00>] notify_change+0x170/0x2e0
    [<ffffffff81163bf6>] do_truncate+0x66/0xa0
    [<ffffffff81163d0b>] sys_ftruncate+0xdb/0xe0
    [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

The cause of the leak is that the "remove" parameter of IOP_UNPIN()
is never set when a CIL push is aborted. This means that the EFI
item is never freed if it was in the push being cancelled. The
problem is specific to delayed logging.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c |    1 -
 fs/xfs/xfs_trans.c        |   35 ++++++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 75f2ef6..effbb41 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -138,7 +138,6 @@ xfs_efi_item_unpin(
 
 	if (remove) {
 		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
-		xfs_trans_del_item(lip);
 		xfs_efi_item_free(efip);
 		return;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 33dbc4e..27ecb74 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1446,6 +1446,14 @@ xfs_log_item_batch_insert(
  * Bulk operation version of xfs_trans_committed that takes a log vector of
  * items to insert into the AIL. This uses bulk AIL insertion techniques to
  * minimise lock traffic.
+ *
+ * If we are called with the aborted flag set, it is because a log write during
+ * a CIL checkpoint commit has failed. In this case, all the items in the
+ * checkpoint have already gone through IOP_COMMITED and IOP_UNLOCK, which
+ * means that checkpoint commit abort handling is treated exactly the same
+ * as an iclog write error even though we haven't started any IO yet. Hence in
+ * this case all we need to do is IOP_COMMITTED processing, followed by an
+ * IOP_UNPIN(aborted) call.
  */
 void
 xfs_trans_committed_bulk(
@@ -1472,6 +1480,16 @@ xfs_trans_committed_bulk(
 		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
 			continue;
 
+		/*
+		 * if we are aborting the operation, no point in inserting the
+		 * object into the AIL as we are in a shutdown situation.
+		 */
+		if (aborted) {
+			ASSERT(XFS_FORCED_SHUTDOWN(ailp->xa_mount));
+			IOP_UNPIN(lip, aborted);
+			continue;
+		}
+
 		if (item_lsn != commit_lsn) {
 
 			/*
@@ -1503,22 +1521,29 @@ xfs_trans_committed_bulk(
 }
 
 /*
- * Called from the trans_commit code when we notice that
- * the filesystem is in the middle of a forced shutdown.
+ * Called from the trans_commit code when we notice that the filesystem is in
+ * the middle of a forced shutdown.
+ *
+ * When we are called here, we have already pinned all the items in the
+ * transaction. However, neither IOP_COMMITTING or IOP_UNLOCK has been called
+ * so we can simply walk the items in the transaction, unlink them from the
+ * transaction, unpin them with an abort flag and then free the items.
  */
 STATIC void
 xfs_trans_uncommit(
 	struct xfs_trans	*tp,
 	uint			flags)
 {
-	struct xfs_log_item_desc *lidp;
+	struct xfs_log_item_desc *lidp, *n;
 
-	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+	list_for_each_entry_safe(lidp, n, &tp->t_items, lid_trans) {
 		/*
 		 * Unpin all but those that aren't dirty.
 		 */
-		if (lidp->lid_flags & XFS_LID_DIRTY)
+		if (lidp->lid_flags & XFS_LID_DIRTY) {
+			xfs_trans_del_item(lidp->lid_item);
 			IOP_UNPIN(lidp->lid_item, 1);
+		}
 	}
 
 	xfs_trans_unreserve_and_mod_sb(tp);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
