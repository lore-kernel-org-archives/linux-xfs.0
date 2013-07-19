Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAA088019
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BDE9AC011
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IUVFMIZ8eyqK0uAA for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004IJ-OI
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002Jq-NN
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/49] libxfs: sync dir2 kernel differences
Date: Fri, 19 Jul 2013 16:44:45 +1000
Message-Id: <1374216324-8781-11-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_dir2.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2_data.c | 20 ++++++++++----------
 libxfs/xfs_dir2_leaf.c |  4 ++--
 libxfs/xfs_dir2_node.c | 30 ++++++++++++++----------------
 4 files changed, 71 insertions(+), 28 deletions(-)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 6a4027f..830fe3e 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -392,6 +392,51 @@ xfs_dir_replace(
 }
 
 /*
+ * See if this entry can be added to the directory without allocating space.
+ * First checks that the caller couldn't reserve enough space (resblks = 0).
+ */
+int
+xfs_dir_canenter(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*dp,
+	struct xfs_name	*name,		/* name of entry to add */
+	uint		resblks)
+{
+	xfs_da_args_t	args;
+	int		rval;
+	int		v;		/* type-checking value */
+
+	if (resblks)
+		return 0;
+
+	ASSERT(S_ISDIR(dp->i_d.di_mode));
+
+	memset(&args, 0, sizeof(xfs_da_args_t));
+	args.name = name->name;
+	args.namelen = name->len;
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.dp = dp;
+	args.whichfork = XFS_DATA_FORK;
+	args.trans = tp;
+	args.op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
+							XFS_DA_OP_OKNOENT;
+
+	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
+		rval = xfs_dir2_sf_addname(&args);
+	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
+		return rval;
+	else if (v)
+		rval = xfs_dir2_block_addname(&args);
+	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
+		return rval;
+	else if (v)
+		rval = xfs_dir2_leaf_addname(&args);
+	else
+		rval = xfs_dir2_node_addname(&args);
+	return rval;
+}
+
+/*
  * Utility routines.
  */
 
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 155352c..064ddb2 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -53,15 +53,15 @@ __xfs_dir3_data_check(
 	bf = xfs_dir3_data_bestfree_p(hdr);
 	p = (char *)xfs_dir3_data_entry_p(hdr);
 
-	switch (be32_to_cpu(hdr->magic)) {
-	case XFS_DIR2_BLOCK_MAGIC:
-	case XFS_DIR3_BLOCK_MAGIC:
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
 		break;
-	case XFS_DIR2_DATA_MAGIC:
-	case XFS_DIR3_DATA_MAGIC:
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		endp = (char *)hdr + mp->m_dirblksize;
 		break;
 	default:
@@ -209,14 +209,14 @@ xfs_dir3_data_reada_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
 
-	switch (be32_to_cpu(hdr->magic)) {
-	case XFS_DIR2_BLOCK_MAGIC:
-	case XFS_DIR3_BLOCK_MAGIC:
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
 		bp->b_ops = &xfs_dir3_block_buf_ops;
 		bp->b_ops->verify_read(bp);
 		return;
-	case XFS_DIR2_DATA_MAGIC:
-	case XFS_DIR3_DATA_MAGIC:
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 		xfs_dir3_data_verify(bp);
 		return;
 	default:
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index a287bb1..8c20b9e 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -247,14 +247,14 @@ xfs_dir3_leaf1_write_verify(
 	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
 }
 
-void
+static void
 xfs_dir3_leafn_read_verify(
 	struct xfs_buf	*bp)
 {
 	__read_verify(bp, XFS_DIR2_LEAFN_MAGIC);
 }
 
-void
+static void
 xfs_dir3_leafn_write_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index bdce1b3..222f08c 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -257,7 +257,6 @@ xfs_dir3_free_get_buf(
 		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
-
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
 	xfs_dir3_free_hdr_to_disk(bp->b_addr, &hdr);
@@ -978,7 +977,7 @@ xfs_dir2_leafn_rebalance(
 	xfs_dir2_leaf_t		*leaf1;		/* first leaf structure */
 	xfs_dir2_leaf_t		*leaf2;		/* second leaf structure */
 	int			mid;		/* midpoint leaf index */
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	int			oldstale;	/* old count of stale leaves */
 #endif
 	int			oldsum;		/* old total leaf count */
@@ -1007,7 +1006,7 @@ xfs_dir2_leafn_rebalance(
 	ents2 = xfs_dir3_leaf_ents_p(leaf2);
 
 	oldsum = hdr1.count + hdr2.count;
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	oldstale = hdr1.stale + hdr2.stale;
 #endif
 	mid = oldsum >> 1;
@@ -1101,7 +1100,6 @@ xfs_dir3_data_block_free(
 	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
 
-
 	xfs_dir3_free_hdr_from_disk(&freehdr, free);
 
 	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
@@ -1115,12 +1113,14 @@ xfs_dir3_data_block_free(
 		return 0;
 	}
 
-	/*
-	 * One less used entry in the free table. Unused is not converted
-	 * because we only need to know if it zero
-	 */
+	/* One less used entry in the free table. */
 	freehdr.nused--;
 
+	/*
+	 * If this was the last entry in the table, we can trim the table size
+	 * back.  There might be other entries at the end referring to
+	 * non-existent data blocks, get those too.
+	 */
 	if (findex == freehdr.nvalid - 1) {
 		int	i;		/* free entry index */
 
@@ -1159,7 +1159,6 @@ xfs_dir3_data_block_free(
 		 */
 	}
 
-
 	/* Log the free entry that changed, unless we got rid of it.  */
 	if (logfree)
 		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
@@ -1275,9 +1274,8 @@ xfs_dir2_leafn_remove(
 	{
 		struct xfs_dir3_icfree_hdr freehdr;
 		xfs_dir3_free_hdr_from_disk(&freehdr, free);
-		ASSERT(freehdr.firstdb ==
-				       xfs_dir3_free_max_bests(mp) *
-				       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
+		ASSERT(freehdr.firstdb == xfs_dir3_free_max_bests(mp) *
+					  (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
 	}
 #endif
 		/*
@@ -1425,7 +1423,7 @@ xfs_dir2_leafn_toosmall(
 	leaf = blk->bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = xfs_dir3_leaf_ents_p(leaf);
-	xfs_dir3_leaf_check(mp, blk->bp);
+	xfs_dir3_leaf_check(state->args->dp->i_mount, blk->bp);
 
 	count = leafhdr.count - leafhdr.stale;
 	bytes = xfs_dir3_leaf_hdr_size(leaf) + count * sizeof(ents[0]);
@@ -1795,9 +1793,9 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Look at the current free entry.  Is it good enough?
 		 *
-		 * The bests initialisation should be wher eteh bufer is read in
+		 * The bests initialisation should be where the bufer is read in
 		 * the above branch. But gcc is too stupid to realise that bests
-		 * iand the freehdr are actually initialised if they are placed
+		 * and the freehdr are actually initialised if they are placed
 		 * there, so we have to do it here to avoid warnings. Blech.
 		 */
 		bests = xfs_dir3_free_bests_p(mp, free);
@@ -1863,7 +1861,7 @@ xfs_dir2_node_addname_int(
 		 * If there wasn't a freespace block, the read will
 		 * return a NULL fbp.  Allocate and initialize a new one.
 		 */
-		if(!fbp) {
+		if (!fbp) {
 			error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE,
 						    &fbno);
 			if (error)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
