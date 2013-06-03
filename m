Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C954C29DF8
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:29:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD66B8F8040
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 22:29:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	B9FFaq4gGeBEWK9o for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 22:29:01 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: fix log recovery transaction item reordering
Date: Mon,  3 Jun 2013 15:28:47 +1000
Message-Id: <1370237332-24757-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-1-git-send-email-david@fromorbit.com>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

There are several constraints that inode allocation and unlink
logging impose on log recovery. These all stem from the fact that
inode alloc/unlink are logged in buffers, but all other inode
changes are logged in inode items. Hence there are ordering
constraints that recovery must follow to ensure the correct result
occurs.

As it turns out, this ordering has been working mostly by chance
than good management. The existing code moves all buffers except
cancelled buffers to the head of the list, and everything else to
the tail of the list. The problem with this is that is interleaves
inode items with the buffer cancellation items, and hence whether
the inode item in an cancelled buffer gets replayed is essentially
left to chance.

Further, this ordering causes problems for log recovery when inode
CRCs are enabled. It typically replays the inode unlink buffer long before
it replays the inode core changes, and so the CRC recorded in an
unlink buffer is going to be invalid and hence any attempt to
validate the inode in the buffer is going to fail. Hence we really
need to enforce the ordering that the inode alloc/unlink code has
expected log recovery to have since inode chunk de-allocation was
introduced back in 2003...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |   65 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d6204d1..83088d9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1599,10 +1599,43 @@ xlog_recover_add_to_trans(
 }
 
 /*
- * Sort the log items in the transaction. Cancelled buffers need
- * to be put first so they are processed before any items that might
- * modify the buffers. If they are cancelled, then the modifications
- * don't need to be replayed.
+ * Sort the log items in the transaction.
+ *
+ * The ordering constraints are defined by the inode allocation and unlink
+ * behaviour. The rules are:
+ *
+ *	1. Every item is only logged once in a given transaction. Hence it
+ *	   represents the last logged state of the item. Hence ordering is
+ *	   dependent on the order in which operations need to be performed so
+ *	   required initial conditions are always met.
+ *
+ *	2. Cancelled buffers are recorded in pass 1 in a separate table and
+ *	   there's nothing to replay from them so we can simply cull them
+ *	   from the transaction. However, we can't do that until after we've
+ *	   replayed all the other items because they may be dependent on the
+ *	   cancelled buffer and replaying the cancelled buffer can remove it
+ *	   form the cancelled buffer table. Hence they have tobe done last.
+ *
+ *	3. Inode allocation buffers must be replayed before inode items that
+ *	   read the buffer and replay changes into it.
+ *
+ *	4. Inode unlink buffers must be replayed after inode items are replayed.
+ *	   This ensures that inodes are completely flushed to the inode buffer
+ *	   in a "free" state before we remove the unlinked inode list pointer.
+ *
+ * Hence the ordering needs to be inode allocation buffers first, inode items
+ * second, inode unlink buffers third and cancelled buffers last.
+ *
+ * But there's a problem with that - we can't tell an inode allocation buffer
+ * apart from a regular buffer, so we can't separate them. We can, however,
+ * tell an inode unlink buffer from the others, and so we can separate them out
+ * from all the other buffers and move them to last.
+ *
+ * Hence, 4 lists, in order from head to tail:
+ * 	- buffer_list for all buffers except cancelled/inode unlink buffers
+ * 	- item_list for all non-buffer items
+ * 	- inode_buffer_list for inode unlink buffers
+ * 	- cancel_list for the cancelled buffers
  */
 STATIC int
 xlog_recover_reorder_trans(
@@ -1612,6 +1645,10 @@ xlog_recover_reorder_trans(
 {
 	xlog_recover_item_t	*item, *n;
 	LIST_HEAD(sort_list);
+	LIST_HEAD(cancel_list);
+	LIST_HEAD(buffer_list);
+	LIST_HEAD(inode_buffer_list);
+	LIST_HEAD(inode_list);
 
 	list_splice_init(&trans->r_itemq, &sort_list);
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
@@ -1619,12 +1656,18 @@ xlog_recover_reorder_trans(
 
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
-			if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
+			if (buf_f->blf_flags & XFS_BLF_CANCEL) {
 				trace_xfs_log_recover_item_reorder_head(log,
 							trans, item, pass);
-				list_move(&item->ri_list, &trans->r_itemq);
+				list_move(&item->ri_list, &cancel_list);
 				break;
 			}
+			if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
+				list_move(&item->ri_list, &inode_buffer_list);
+				break;
+			}
+			list_move_tail(&item->ri_list, &buffer_list);
+			break;
 		case XFS_LI_INODE:
 		case XFS_LI_DQUOT:
 		case XFS_LI_QUOTAOFF:
@@ -1632,7 +1675,7 @@ xlog_recover_reorder_trans(
 		case XFS_LI_EFI:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
-			list_move_tail(&item->ri_list, &trans->r_itemq);
+			list_move_tail(&item->ri_list, &inode_list);
 			break;
 		default:
 			xfs_warn(log->l_mp,
@@ -1643,6 +1686,14 @@ xlog_recover_reorder_trans(
 		}
 	}
 	ASSERT(list_empty(&sort_list));
+	if (!list_empty(&buffer_list))
+		list_splice(&buffer_list, &trans->r_itemq);
+	if (!list_empty(&inode_list))
+		list_splice_tail(&inode_list, &trans->r_itemq);
+	if (!list_empty(&inode_buffer_list))
+		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
+	if (!list_empty(&cancel_list))
+		list_splice_tail(&cancel_list, &trans->r_itemq);
 	return 0;
 }
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
