Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:38599 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751593AbcLIEm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 23:42:28 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cFD0o-00030H-Ev
        for linux-xfs@vger.kernel.org; Fri, 09 Dec 2016 15:42:22 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cFD0o-0000Al-Dp
        for linux-xfs@vger.kernel.org; Fri, 09 Dec 2016 15:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: icreate transactions should be replayed first
Date: Fri,  9 Dec 2016 15:42:22 +1100
Message-Id: <20161209044222.618-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There is an ordering problem that results in icreate transactions
being replayed after the inode items that depend on the create being
replayed. This can result in inode replay reporting corruption or
being skipped because the underlying buffer has not be initialised
correctly when the inode change is replayed.

Whilst touching the reorder code, fix the name of the catch-all log
item list from "inode_list" to "item_list" and clean up the comments
around ICREATE item ordering.

This problem was found by inspection when looking into another
recovery problem Eric was seeing.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4a98762ec8b4..450702d6b994 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1851,7 +1851,7 @@ xlog_clear_stale_blocks(
  *	   from the transaction. However, we can't do that until after we've
  *	   replayed all the other items because they may be dependent on the
  *	   cancelled buffer and replaying the cancelled buffer can remove it
- *	   form the cancelled buffer table. Hence they have tobe done last.
+ *	   form the cancelled buffer table. Hence they have to be done last.
  *
  *	3. Inode allocation buffers must be replayed before inode items that
  *	   read the buffer and replay changes into it. For filesystems using the
@@ -1866,13 +1866,14 @@ xlog_clear_stale_blocks(
  * Hence the ordering needs to be inode allocation buffers first, inode items
  * second, inode unlink buffers third and cancelled buffers last.
  *
- * But there's a problem with that - we can't tell an inode allocation buffer
- * apart from a regular buffer, so we can't separate them. We can, however,
- * tell an inode unlink buffer from the others, and so we can separate them out
- * from all the other buffers and move them to last.
+ * But there's a problem with that for v4 filesystems - we can't tell an inode
+ * allocation buffer apart from a regular buffer, so we can't separate them. We
+ * can, however, tell an inode unlink buffer from the others, and so we can
+ * separate them out from all the other buffers and move them to last.
  *
  * Hence, 4 lists, in order from head to tail:
  *	- buffer_list for all buffers except cancelled/inode unlink buffers
+ *	  and contains ICREATE items at it's head.
  *	- item_list for all non-buffer items
  *	- inode_buffer_list for inode unlink buffers
  *	- cancel_list for the cancelled buffers
@@ -1881,9 +1882,10 @@ xlog_clear_stale_blocks(
  * ordering is preserved within the lists. Adding objects to the head of the
  * list means when we traverse from the head we walk them in last-to-first
  * order. For cancelled buffers and inode unlink buffers this doesn't matter,
- * but for all other items there may be specific ordering that we need to
- * preserve.
+ * for ICREATE operations we know they need to come first, but for all other
+ * items there may be specific ordering that we need to preserve.
  */
+
 STATIC int
 xlog_recover_reorder_trans(
 	struct xlog		*log,
@@ -1896,7 +1898,7 @@ xlog_recover_reorder_trans(
 	LIST_HEAD(cancel_list);
 	LIST_HEAD(buffer_list);
 	LIST_HEAD(inode_buffer_list);
-	LIST_HEAD(inode_list);
+	LIST_HEAD(item_list);
 
 	list_splice_init(&trans->r_itemq, &sort_list);
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
@@ -1904,7 +1906,7 @@ xlog_recover_reorder_trans(
 
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_ICREATE:
-			list_move_tail(&item->ri_list, &buffer_list);
+			list_move(&item->ri_list, &buffer_list);
 			break;
 		case XFS_LI_BUF:
 			if (buf_f->blf_flags & XFS_BLF_CANCEL) {
@@ -1932,7 +1934,7 @@ xlog_recover_reorder_trans(
 		case XFS_LI_BUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
-			list_move_tail(&item->ri_list, &inode_list);
+			list_move_tail(&item->ri_list, &item_list);
 			break;
 		default:
 			xfs_warn(log->l_mp,
@@ -1953,8 +1955,8 @@ xlog_recover_reorder_trans(
 	ASSERT(list_empty(&sort_list));
 	if (!list_empty(&buffer_list))
 		list_splice(&buffer_list, &trans->r_itemq);
-	if (!list_empty(&inode_list))
-		list_splice_tail(&inode_list, &trans->r_itemq);
+	if (!list_empty(&item_list))
+		list_splice_tail(&item_list, &trans->r_itemq);
 	if (!list_empty(&inode_buffer_list))
 		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
 	if (!list_empty(&cancel_list))
-- 
2.10.2

