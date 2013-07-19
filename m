Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6289480B1
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E76D3AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BDfmBjhig38ELX4r for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004II-Nj
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002Jl-Mk
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/49] libxfs: sync attr code with kernel
Date: Fri, 19 Jul 2013 16:44:44 +1000
Message-Id: <1374216324-8781-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_attr.c      | 6 +++---
 libxfs/xfs_attr_leaf.c | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cfc2f4b..8fe892e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -65,7 +65,7 @@ xfs_attr_name_to_xname(
 	return 0;
 }
 
-STATIC int
+int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
 {
@@ -268,7 +268,6 @@ xfs_attr_set_int(
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-
 	error = xfs_trans_reserve(args.trans, args.total,
 				  XFS_ATTRSETM_LOG_RES(mp) +
 				  XFS_ATTRSETRT_LOG_RES(mp) * args.total,
@@ -587,6 +586,7 @@ xfs_attr_remove(
 	return xfs_attr_remove_int(dp, &xname, flags);
 }
 
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
@@ -854,7 +854,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error == ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
-		return(error);
+		return error;
 	}
 
 	xfs_attr3_leaf_remove(bp, args);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 4e2951b..49a1764 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -51,7 +51,6 @@ STATIC int xfs_attr3_leaf_figure_balance(xfs_da_state_t *state,
 			int *number_entries_in_blk1,
 			int *number_usedbytes_in_blk1);
 
-
 /*
  * Utility routines.
  */
@@ -1120,7 +1119,6 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_leaf_map *map;
 	struct xfs_mount	*mp;
 	int			tmp;
 	int			i;
@@ -1219,7 +1217,7 @@ xfs_attr3_leaf_add_work(
 	tmp = (ichdr->count - 1) * sizeof(xfs_attr_leaf_entry_t)
 					+ xfs_attr3_leaf_hdr_size(leaf);
 
-	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		if (ichdr->freemap[i].base == tmp) {
 			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
 			ichdr->freemap[i].size -= sizeof(xfs_attr_leaf_entry_t);
@@ -2337,7 +2335,7 @@ xfs_attr3_leaf_moveents(
 		 * Move the remaining entries down to fill the hole,
 		 * then zero the entries at the top.
 		 */
-		tmp  = (ichdr_s->count - count) - sizeof(xfs_attr_leaf_entry_t);
+		tmp  = (ichdr_s->count - count) * sizeof(xfs_attr_leaf_entry_t);
 		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s + count];
 		entry_d = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
 		memmove(entry_d, entry_s, tmp);
@@ -2431,6 +2429,7 @@ xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize, int *local)
 	return size;
 }
 
+
 /*========================================================================
  * Manage the INCOMPLETE flag in a leaf entry
  *========================================================================*/
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
