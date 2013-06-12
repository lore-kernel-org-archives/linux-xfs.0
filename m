Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2149F8027
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9C9C8F8065
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	p1avjQlQ25eDsZPH for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQ3-0001Bt-Td
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006np-P9
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/22] libxfs: sync attr code with kernel
Date: Wed, 12 Jun 2013 20:36:30 +1000
Message-Id: <1371033394-26006-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_attr.c      |    6 +++---
 libxfs/xfs_attr_leaf.c |   48 ++++++++++++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 23 deletions(-)

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
index 0226b3d..d8da950 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -51,7 +51,6 @@ STATIC int xfs_attr3_leaf_figure_balance(xfs_da_state_t *state,
 			int *number_entries_in_blk1,
 			int *number_usedbytes_in_blk1);
 
-
 /*
  * Utility routines.
  */
@@ -1122,7 +1121,6 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_leaf_map *map;
 	struct xfs_mount	*mp;
 	int			tmp;
 	int			i;
@@ -1221,7 +1219,7 @@ xfs_attr3_leaf_add_work(
 	tmp = (ichdr->count - 1) * sizeof(xfs_attr_leaf_entry_t)
 					+ xfs_attr3_leaf_hdr_size(leaf);
 
-	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		if (ichdr->freemap[i].base == tmp) {
 			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
 			ichdr->freemap[i].size -= sizeof(xfs_attr_leaf_entry_t);
@@ -1237,11 +1235,12 @@ xfs_attr3_leaf_add_work(
 STATIC void
 xfs_attr3_leaf_compact(
 	struct xfs_da_args	*args,
-	struct xfs_attr3_icleaf_hdr *ichdr_d,
+	struct xfs_attr3_icleaf_hdr *ichdr_dst,
 	struct xfs_buf		*bp)
 {
-	xfs_attr_leafblock_t	*leaf_s, *leaf_d;
-	struct xfs_attr3_icleaf_hdr ichdr_s;
+	struct xfs_attr_leafblock *leaf_src;
+	struct xfs_attr_leafblock *leaf_dst;
+	struct xfs_attr3_icleaf_hdr ichdr_src;
 	struct xfs_trans	*trans = args->trans;
 	struct xfs_mount	*mp = trans->t_mountp;
 	char			*tmpbuffer;
@@ -1249,29 +1248,37 @@ xfs_attr3_leaf_compact(
 	trace_xfs_attr_leaf_compact(args);
 
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(mp), KM_SLEEP);
-	ASSERT(tmpbuffer != NULL);
 	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(mp));
 	memset(bp->b_addr, 0, XFS_LBSIZE(mp));
+	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
+	leaf_dst = bp->b_addr;
 
 	/*
-	 * Copy basic information
+	 * Copy the on-disk header back into the destination buffer to ensure
+	 * all the information in the header that is not part of the incore
+	 * header structure is preserved.
 	 */
-	leaf_s = (xfs_attr_leafblock_t *)tmpbuffer;
-	leaf_d = bp->b_addr;
-	ichdr_s = *ichdr_d;	/* struct copy */
-	ichdr_d->firstused = XFS_LBSIZE(mp);
-	ichdr_d->usedbytes = 0;
-	ichdr_d->count = 0;
-	ichdr_d->holes = 0;
-	ichdr_d->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_s);
-	ichdr_d->freemap[0].size = ichdr_d->firstused - ichdr_d->freemap[0].base;
+	memcpy(bp->b_addr, tmpbuffer, xfs_attr3_leaf_hdr_size(leaf_src));
+
+	/* Initialise the incore headers */
+	ichdr_src = *ichdr_dst;	/* struct copy */
+	ichdr_dst->firstused = XFS_LBSIZE(mp);
+	ichdr_dst->usedbytes = 0;
+	ichdr_dst->count = 0;
+	ichdr_dst->holes = 0;
+	ichdr_dst->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_src);
+	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
+						ichdr_dst->freemap[0].base;
+
+	/* write the header back to initialise the underlying buffer */
+	xfs_attr3_leaf_hdr_to_disk(leaf_dst, ichdr_dst);
 
 	/*
 	 * Copy all entry's in the same (sorted) order,
 	 * but allocate name/value pairs packed and in sequence.
 	 */
-	xfs_attr3_leaf_moveents(leaf_s, &ichdr_s, 0, leaf_d, ichdr_d, 0,
-				ichdr_s.count, mp);
+	xfs_attr3_leaf_moveents(leaf_src, &ichdr_src, 0, leaf_dst, ichdr_dst, 0,
+				ichdr_src.count, mp);
 	/*
 	 * this logs the entire buffer, but the caller must write the header
 	 * back to the buffer when it is finished modifying it.
@@ -2329,7 +2336,7 @@ xfs_attr3_leaf_moveents(
 		 * Move the remaining entries down to fill the hole,
 		 * then zero the entries at the top.
 		 */
-		tmp  = (ichdr_s->count - count) - sizeof(xfs_attr_leaf_entry_t);
+		tmp  = (ichdr_s->count - count) * sizeof(xfs_attr_leaf_entry_t);
 		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s + count];
 		entry_d = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
 		memmove(entry_d, entry_s, tmp);
@@ -2423,6 +2430,7 @@ xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize, int *local)
 	return size;
 }
 
+
 /*========================================================================
  * Manage the INCOMPLETE flag in a leaf entry
  *========================================================================*/
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
