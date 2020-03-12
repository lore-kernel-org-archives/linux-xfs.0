Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4F6C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A21B206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="byWIgDg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgCLDp5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:45:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43764 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:45:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3dQiW123548;
        Thu, 12 Mar 2020 03:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HXVrwCqITxKwjNZbnmkgUTYYMqwL5HuYjNScGd1i+wo=;
 b=byWIgDg7ugH4uyg/RaM7KHQPm8TBOA8g5kPel9SDnjKcTNQYfWubDa62KphqEWl4OnNv
 k+gjaRfgzW+cBYcpj5dSUSJVBkyrtxhDRVrZuPMEtFfNh4J9oxIFbNN2k6Fgxg9TMUc1
 k3eVs9E0qeZkJjliDPLQ0g+Wny1n4EVI5mmS6qNnQlV7oW3JbvssqGq9tVdxS+hWgyIf
 4KbmSFKTreCnKoQdj/Wiiqo+w09cMsdgJOBQTGOzGBf3M7MhWAjrtF/8fZnrQDh+zf0U
 c5NaaPy+dMfXoInnsMAl9KFeSauecp8tdREVFkE74eZUNoEuVNVCINF0iOIk2LLdBgNg 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yp7hmbj6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3c7Au054744;
        Thu, 12 Mar 2020 03:45:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8p5r0tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3jpW4017207;
        Thu, 12 Mar 2020 03:45:51 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:50 -0700
Subject: [PATCH 3/7] xfs: support bulk loading of staged btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 11 Mar 2020 20:45:49 -0700
Message-ID: <158398474975.1308059.5474941693856744742.stgit@magnolia>
In-Reply-To: <158398473036.1308059.18353233923283406961.stgit@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=3 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new btree function that enables us to bulk load a btree cursor.
This will be used by the upcoming online repair patches to generate new
btrees.  This avoids the programmatic inefficiency of calling
xfs_btree_insert in a loop (which generates a lot of log traffic) in
favor of stamping out new btree blocks with ordered buffers, and then
committing both the new root and scheduling the removal of the old btree
blocks in a single transaction commit.

The design of this new generic code is based off the btree rebuilding
code in xfs_repair's phase 5 code, with the explicit goal of enabling us
to share that code between scrub and repair.  It has the additional
feature of being able to control btree block loading factors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  604 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |   68 +++++
 fs/xfs/xfs_trace.c        |    1 
 fs/xfs/xfs_trace.h        |   85 ++++++
 4 files changed, 757 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4e1d4f184d4b..d579d8e99046 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1324,7 +1324,7 @@ STATIC void
 xfs_btree_copy_ptrs(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*dst_ptr,
-	union xfs_btree_ptr	*src_ptr,
+	const union xfs_btree_ptr *src_ptr,
 	int			numptrs)
 {
 	ASSERT(numptrs >= 0);
@@ -5179,3 +5179,605 @@ xfs_btree_commit_ifakeroot(
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 	cur->bc_tp = tp;
 }
+
+/*
+ * Bulk Loading of Staged Btrees
+ * =============================
+ *
+ * This interface is used with a staged btree cursor to create a totally new
+ * btree with a large number of records (i.e. more than what would fit in a
+ * single root block).  When the creation is complete, the new root can be
+ * linked atomically into the filesystem by committing the staged cursor.
+ *
+ * Creation of a new btree proceeds roughly as follows:
+ *
+ * The first step is to initialize an appropriate fake btree root structure and
+ * then construct a staged btree cursor.  Refer to the block comments about
+ * "Bulk Loading for AG Btrees" and "Bulk Loading for Inode-Rooted Btrees" for
+ * more information about how to do this.
+ *
+ * The second step is to initialize a struct xfs_btree_bload context as
+ * documented in the structure definition.
+ *
+ * The third step is to call xfs_btree_bload_compute_geometry to compute the
+ * height of and the number of blocks needed to construct the btree.  See the
+ * section "Computing the Geometry of the New Btree" for details about this
+ * computation.
+ *
+ * In step four, the caller must allocate xfs_btree_bload.nr_blocks blocks and
+ * save them for later use by ->claim_block().  Bulk loading requires all
+ * blocks to be allocated beforehand to avoid ENOSPC failures midway through a
+ * rebuild, and to minimize seek distances of the new btree.
+ *
+ * Step five is to call xfs_btree_bload() to start constructing the btree.
+ *
+ * The final step is to commit the staging btree cursor, which logs the new
+ * btree root and turns the staging cursor into a regular cursor.  The caller
+ * is responsible for cleaning up the previous btree blocks, if any.
+ *
+ * Computing the Geometry of the New Btree
+ * =======================================
+ *
+ * The number of items placed in each btree block is computed via the following
+ * algorithm: For leaf levels, the number of items for the level is nr_records
+ * in the bload structure.  For node levels, the number of items for the level
+ * is the number of blocks in the next lower level of the tree.  For each
+ * level, the desired number of items per block is defined as:
+ *
+ * desired = max(minrecs, maxrecs - slack factor)
+ *
+ * The number of blocks for the level is defined to be:
+ *
+ * blocks = floor(nr_items / desired)
+ *
+ * Note this is rounded down so that the npb calculation below will never fall
+ * below minrecs.  The number of items that will actually be loaded into each
+ * btree block is defined as:
+ *
+ * npb =  nr_items / blocks
+ *
+ * Some of the leftmost blocks in the level will contain one extra record as
+ * needed to handle uneven division.  If the number of records in any block
+ * would exceed maxrecs for that level, blocks is incremented and npb is
+ * recalculated.
+ *
+ * In other words, we compute the number of blocks needed to satisfy a given
+ * loading level, then spread the items as evenly as possible.
+ *
+ * The height and number of fs blocks required to create the btree are computed
+ * and returned via btree_height and nr_blocks.
+ */
+
+/*
+ * Put a btree block that we're loading onto the ordered list and release it.
+ * The btree blocks will be written to disk when bulk loading is finished.
+ */
+static void
+xfs_btree_bload_drop_buf(
+	struct list_head	*buffers_list,
+	struct xfs_buf		**bpp)
+{
+	if (*bpp == NULL)
+		return;
+
+	xfs_buf_delwri_queue(*bpp, buffers_list);
+	xfs_buf_relse(*bpp);
+	*bpp = NULL;
+}
+
+/*
+ * Allocate and initialize one btree block for bulk loading.
+ *
+ * The new btree block will have its level and numrecs fields set to the values
+ * of the level and nr_this_block parameters, respectively.  On exit, ptrp,
+ * bpp, and blockp will all point to the new block.
+ */
+STATIC int
+xfs_btree_bload_prep_block(
+	struct xfs_btree_cur		*cur,
+	struct xfs_btree_bload		*bbl,
+	unsigned int			level,
+	unsigned int			nr_this_block,
+	union xfs_btree_ptr		*ptrp,
+	struct xfs_buf			**bpp,
+	struct xfs_btree_block		**blockp,
+	void				*priv)
+{
+	union xfs_btree_ptr		new_ptr;
+	struct xfs_buf			*new_bp;
+	struct xfs_btree_block		*new_block;
+	int				ret;
+
+	ASSERT(*bpp == NULL);
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+		size_t			new_size;
+
+		/* Allocate a new incore btree root block. */
+		new_size = bbl->iroot_size(cur, nr_this_block, priv);
+		ifp->if_broot = kmem_zalloc(new_size, 0);
+		ifp->if_broot_bytes = (int)new_size;
+		ifp->if_flags |= XFS_IFBROOT;
+
+		/* Initialize it and send it out. */
+		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
+				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
+				nr_this_block, cur->bc_ino.ip->i_ino,
+				cur->bc_flags);
+
+		*bpp = NULL;
+		*blockp = ifp->if_broot;
+		xfs_btree_set_ptr_null(cur, ptrp);
+		return 0;
+	}
+
+	/* Claim one of the caller's preallocated blocks. */
+	xfs_btree_set_ptr_null(cur, &new_ptr);
+	ret = bbl->claim_block(cur, &new_ptr, priv);
+	if (ret)
+		return ret;
+
+	ASSERT(!xfs_btree_ptr_is_null(cur, &new_ptr));
+
+	ret = xfs_btree_get_buf_block(cur, &new_ptr, &new_block, &new_bp);
+	if (ret)
+		return ret;
+
+	/* Initialize the btree block. */
+	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
+	if (*blockp)
+		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
+	xfs_btree_set_sibling(cur, new_block, ptrp, XFS_BB_LEFTSIB);
+
+	/* Set the out parameters. */
+	*bpp = new_bp;
+	*blockp = new_block;
+	xfs_btree_copy_ptrs(cur, ptrp, &new_ptr, 1);
+	return 0;
+}
+
+/* Load one leaf block. */
+STATIC int
+xfs_btree_bload_leaf(
+	struct xfs_btree_cur		*cur,
+	unsigned int			recs_this_block,
+	xfs_btree_bload_get_record_fn	get_record,
+	struct xfs_btree_block		*block,
+	void				*priv)
+{
+	unsigned int			j;
+	int				ret;
+
+	/* Fill the leaf block with records. */
+	for (j = 1; j <= recs_this_block; j++) {
+		union xfs_btree_rec	*block_rec;
+
+		ret = get_record(cur, priv);
+		if (ret)
+			return ret;
+		block_rec = xfs_btree_rec_addr(cur, j, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return 0;
+}
+
+/*
+ * Load one node block with key/ptr pairs.
+ *
+ * child_ptr must point to a block within the next level down in the tree.  A
+ * key/ptr entry will be created in the new node block to the block pointed to
+ * by child_ptr.  On exit, child_ptr points to the next block on the child
+ * level that needs processing.
+ */
+STATIC int
+xfs_btree_bload_node(
+	struct xfs_btree_cur	*cur,
+	unsigned int		recs_this_block,
+	union xfs_btree_ptr	*child_ptr,
+	struct xfs_btree_block	*block)
+{
+	unsigned int		j;
+	int			ret;
+
+	/* Fill the node block with keys and pointers. */
+	for (j = 1; j <= recs_this_block; j++) {
+		union xfs_btree_key	child_key;
+		union xfs_btree_ptr	*block_ptr;
+		union xfs_btree_key	*block_key;
+		struct xfs_btree_block	*child_block;
+		struct xfs_buf		*child_bp;
+
+		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
+
+		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
+				&child_bp);
+		if (ret)
+			return ret;
+
+		block_ptr = xfs_btree_ptr_addr(cur, j, block);
+		xfs_btree_copy_ptrs(cur, block_ptr, child_ptr, 1);
+
+		block_key = xfs_btree_key_addr(cur, j, block);
+		xfs_btree_get_keys(cur, child_block, &child_key);
+		xfs_btree_copy_keys(cur, block_key, &child_key, 1);
+
+		xfs_btree_get_sibling(cur, child_block, child_ptr,
+				XFS_BB_RIGHTSIB);
+		xfs_buf_relse(child_bp);
+	}
+
+	return 0;
+}
+
+/*
+ * Compute the maximum number of records (or keyptrs) per block that we want to
+ * install at this level in the btree.  Caller is responsible for having set
+ * @cur->bc_ino.forksize to the desired fork size, if appropriate.
+ */
+STATIC unsigned int
+xfs_btree_bload_max_npb(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_bload	*bbl,
+	unsigned int		level)
+{
+	unsigned int		ret;
+
+	if (level == cur->bc_nlevels - 1 && cur->bc_ops->get_dmaxrecs)
+		return cur->bc_ops->get_dmaxrecs(cur, level);
+
+	ret = cur->bc_ops->get_maxrecs(cur, level);
+	if (level == 0)
+		ret -= bbl->leaf_slack;
+	else
+		ret -= bbl->node_slack;
+	return ret;
+}
+
+/*
+ * Compute the desired number of records (or keyptrs) per block that we want to
+ * install at this level in the btree, which must be somewhere between minrecs
+ * and max_npb.  The caller is free to install fewer records per block.
+ */
+STATIC unsigned int
+xfs_btree_bload_desired_npb(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_bload	*bbl,
+	unsigned int		level)
+{
+	unsigned int		npb = xfs_btree_bload_max_npb(cur, bbl, level);
+
+	/* Root blocks are not subject to minrecs rules. */
+	if (level == cur->bc_nlevels - 1)
+		return max(1U, npb);
+
+	return max_t(unsigned int, cur->bc_ops->get_minrecs(cur, level), npb);
+}
+
+/*
+ * Compute the number of records to be stored in each block at this level and
+ * the number of blocks for this level.  For leaf levels, we must populate an
+ * empty root block even if there are no records, so we have to have at least
+ * one block.
+ */
+STATIC void
+xfs_btree_bload_level_geometry(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_bload	*bbl,
+	unsigned int		level,
+	uint64_t		nr_this_level,
+	unsigned int		*avg_per_block,
+	uint64_t		*blocks,
+	uint64_t		*blocks_with_extra)
+{
+	uint64_t		npb;
+	uint64_t		dontcare;
+	unsigned int		desired_npb;
+	unsigned int		maxnr;
+
+	maxnr = cur->bc_ops->get_maxrecs(cur, level);
+
+	/*
+	 * Compute the number of blocks we need to fill each block with the
+	 * desired number of records/keyptrs per block.  Because desired_npb
+	 * could be minrecs, we use regular integer division (which rounds
+	 * the block count down) so that in the next step the effective # of
+	 * items per block will never be less than desired_npb.
+	 */
+	desired_npb = xfs_btree_bload_desired_npb(cur, bbl, level);
+	*blocks = div64_u64_rem(nr_this_level, desired_npb, &dontcare);
+	*blocks = max(1ULL, *blocks);
+
+	/*
+	 * Compute the number of records that we will actually put in each
+	 * block, assuming that we want to spread the records evenly between
+	 * the blocks.  Take care that the effective # of items per block (npb)
+	 * won't exceed maxrecs even for the blocks that get an extra record,
+	 * since desired_npb could be maxrecs, and in the previous step we
+	 * rounded the block count down.
+	 */
+	npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
+	if (npb > maxnr || (npb == maxnr && *blocks_with_extra > 0)) {
+		(*blocks)++;
+		npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
+	}
+
+	*avg_per_block = min_t(uint64_t, npb, nr_this_level);
+
+	trace_xfs_btree_bload_level_geometry(cur, level, nr_this_level,
+			*avg_per_block, desired_npb, *blocks,
+			*blocks_with_extra);
+}
+
+/*
+ * Ensure a slack value is appropriate for the btree.
+ *
+ * If the slack value is negative, set slack so that we fill the block to
+ * halfway between minrecs and maxrecs.  Make sure the slack is never so large
+ * that we can underflow minrecs.
+ */
+static void
+xfs_btree_bload_ensure_slack(
+	struct xfs_btree_cur	*cur,
+	int			*slack,
+	int			level)
+{
+	int			maxr;
+	int			minr;
+
+	maxr = cur->bc_ops->get_maxrecs(cur, level);
+	minr = cur->bc_ops->get_minrecs(cur, level);
+
+	/*
+	 * If slack is negative, automatically set slack so that we load the
+	 * btree block approximately halfway between minrecs and maxrecs.
+	 * Generally, this will net us 75% loading.
+	 */
+	if (*slack < 0)
+		*slack = maxr - ((maxr + minr) >> 1);
+
+	*slack = min(*slack, maxr - minr);
+}
+
+/*
+ * Prepare a btree cursor for a bulk load operation by computing the geometry
+ * fields in bbl.  Caller must ensure that the btree cursor is a staging
+ * cursor.  This function can be called multiple times.
+ */
+int
+xfs_btree_bload_compute_geometry(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_bload	*bbl,
+	uint64_t		nr_records)
+{
+	uint64_t		nr_blocks = 0;
+	uint64_t		nr_this_level;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	/*
+	 * Make sure that the slack values make sense for btree blocks that are
+	 * full disk blocks.  We do this by setting the btree nlevels to 3,
+	 * because inode-rooted btrees will return different minrecs/maxrecs
+	 * values for the root block.  Note that slack settings are not applied
+	 * to inode roots.
+	 */
+	cur->bc_nlevels = 3;
+	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
+	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
+
+	bbl->nr_records = nr_this_level = nr_records;
+	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+		uint64_t	level_blocks;
+		uint64_t	dontcare64;
+		unsigned int	level = cur->bc_nlevels - 1;
+		unsigned int	avg_per_block;
+
+		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
+				&avg_per_block, &level_blocks, &dontcare64);
+
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			/*
+			 * If all the items we want to store at this level
+			 * would fit in the inode root block, then we have our
+			 * btree root and are done.
+			 *
+			 * Note that bmap btrees forbid records in the root.
+			 */
+			if (level != 0 && nr_this_level <= avg_per_block) {
+				nr_blocks++;
+				break;
+			}
+
+			/*
+			 * Otherwise, we have to store all the items for this
+			 * level in traditional btree blocks and therefore need
+			 * another level of btree to point to those blocks.
+			 *
+			 * We have to re-compute the geometry for each level of
+			 * an inode-rooted btree because the geometry differs
+			 * between a btree root in an inode fork and a
+			 * traditional btree block.
+			 *
+			 * This distinction is made in the btree code based on
+			 * whether level == bc_nlevels - 1.  Based on the
+			 * previous root block size check against the root
+			 * block geometry, we know that we aren't yet ready to
+			 * populate the root.  Increment bc_nevels and
+			 * recalculate the geometry for a traditional
+			 * block-based btree level.
+			 */
+			cur->bc_nlevels++;
+			xfs_btree_bload_level_geometry(cur, bbl, level,
+					nr_this_level, &avg_per_block,
+					&level_blocks, &dontcare64);
+		} else {
+			/*
+			 * If all the items we want to store at this level
+			 * would fit in a single root block, we're done.
+			 */
+			if (nr_this_level <= avg_per_block) {
+				nr_blocks++;
+				break;
+			}
+
+			/* Otherwise, we need another level of btree. */
+			cur->bc_nlevels++;
+		}
+
+		nr_blocks += level_blocks;
+		nr_this_level = level_blocks;
+	}
+
+	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+		return -EOVERFLOW;
+
+	bbl->btree_height = cur->bc_nlevels;
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		bbl->nr_blocks = nr_blocks - 1;
+	else
+		bbl->nr_blocks = nr_blocks;
+	return 0;
+}
+
+/* Bulk load a btree given the parameters and geometry established in bbl. */
+int
+xfs_btree_bload(
+	struct xfs_btree_cur		*cur,
+	struct xfs_btree_bload		*bbl,
+	void				*priv)
+{
+	struct list_head		buffers_list;
+	union xfs_btree_ptr		child_ptr;
+	union xfs_btree_ptr		ptr;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_btree_block		*block = NULL;
+	uint64_t			nr_this_level = bbl->nr_records;
+	uint64_t			blocks;
+	uint64_t			i;
+	uint64_t			blocks_with_extra;
+	uint64_t			total_blocks = 0;
+	unsigned int			avg_per_block;
+	unsigned int			level = 0;
+	int				ret;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	INIT_LIST_HEAD(&buffers_list);
+	cur->bc_nlevels = bbl->btree_height;
+	xfs_btree_set_ptr_null(cur, &child_ptr);
+	xfs_btree_set_ptr_null(cur, &ptr);
+
+	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
+			&avg_per_block, &blocks, &blocks_with_extra);
+
+	/* Load each leaf block. */
+	for (i = 0; i < blocks; i++) {
+		unsigned int		nr_this_block = avg_per_block;
+
+		if (i < blocks_with_extra)
+			nr_this_block++;
+
+		xfs_btree_bload_drop_buf(&buffers_list, &bp);
+
+		ret = xfs_btree_bload_prep_block(cur, bbl, level,
+				nr_this_block, &ptr, &bp, &block, priv);
+		if (ret)
+			goto out;
+
+		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
+				nr_this_block);
+
+		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_record,
+				block, priv);
+		if (ret)
+			goto out;
+
+		/*
+		 * Record the leftmost leaf pointer so we know where to start
+		 * with the first node level.
+		 */
+		if (i == 0)
+			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
+	}
+	total_blocks += blocks;
+	xfs_btree_bload_drop_buf(&buffers_list, &bp);
+
+	/* Populate the internal btree nodes. */
+	for (level = 1; level < cur->bc_nlevels; level++) {
+		union xfs_btree_ptr	first_ptr;
+
+		nr_this_level = blocks;
+		block = NULL;
+		xfs_btree_set_ptr_null(cur, &ptr);
+
+		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
+				&avg_per_block, &blocks, &blocks_with_extra);
+
+		/* Load each node block. */
+		for (i = 0; i < blocks; i++) {
+			unsigned int	nr_this_block = avg_per_block;
+
+			if (i < blocks_with_extra)
+				nr_this_block++;
+
+			xfs_btree_bload_drop_buf(&buffers_list, &bp);
+
+			ret = xfs_btree_bload_prep_block(cur, bbl, level,
+					nr_this_block, &ptr, &bp, &block,
+					priv);
+			if (ret)
+				goto out;
+
+			trace_xfs_btree_bload_block(cur, level, i, blocks,
+					&ptr, nr_this_block);
+
+			ret = xfs_btree_bload_node(cur, nr_this_block,
+					&child_ptr, block);
+			if (ret)
+				goto out;
+
+			/*
+			 * Record the leftmost node pointer so that we know
+			 * where to start the next node level above this one.
+			 */
+			if (i == 0)
+				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
+		}
+		total_blocks += blocks;
+		xfs_btree_bload_drop_buf(&buffers_list, &bp);
+		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
+	}
+
+	/* Initialize the new root. */
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
+		cur->bc_ino.ifake->if_levels = cur->bc_nlevels;
+		cur->bc_ino.ifake->if_blocks = total_blocks - 1;
+	} else {
+		cur->bc_ag.afake->af_root = be32_to_cpu(ptr.s);
+		cur->bc_ag.afake->af_levels = cur->bc_nlevels;
+		cur->bc_ag.afake->af_blocks = total_blocks;
+	}
+
+	/*
+	 * Write the new blocks to disk.  If the ordered list isn't empty after
+	 * that, then something went wrong and we have to fail.  This should
+	 * never happen, but we'll check anyway.
+	 */
+	ret = xfs_buf_delwri_submit(&buffers_list);
+	if (ret)
+		goto out;
+	if (!list_empty(&buffers_list)) {
+		ASSERT(list_empty(&buffers_list));
+		ret = -EIO;
+	}
+
+out:
+	xfs_buf_delwri_cancel(&buffers_list);
+	if (bp)
+		xfs_buf_relse(bp);
+	return ret;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 047067f52063..c2de439a6f0d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -574,4 +574,72 @@ void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
 void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		int whichfork, const struct xfs_btree_ops *ops);
 
+/* Bulk loading of staged btrees. */
+typedef int (*xfs_btree_bload_get_record_fn)(struct xfs_btree_cur *cur, void *priv);
+typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
+		union xfs_btree_ptr *ptr, void *priv);
+typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
+		unsigned int nr_this_level, void *priv);
+
+struct xfs_btree_bload {
+	/*
+	 * This function will be called nr_records times to load records into
+	 * the btree.  The function does this by setting the cursor's bc_rec
+	 * field in in-core format.  Records must be returned in sort order.
+	 */
+	xfs_btree_bload_get_record_fn	get_record;
+
+	/*
+	 * This function will be called nr_blocks times to obtain a pointer
+	 * to a new btree block on disk.  Callers must preallocate all space
+	 * for the new btree before calling xfs_btree_bload, and this function
+	 * is what claims that reservation.
+	 */
+	xfs_btree_bload_claim_block_fn	claim_block;
+
+	/*
+	 * This function should return the size of the in-core btree root
+	 * block.  It is only necessary for XFS_BTREE_ROOT_IN_INODE btree
+	 * types.
+	 */
+	xfs_btree_bload_iroot_size_fn	iroot_size;
+
+	/*
+	 * The caller should set this to the number of records that will be
+	 * stored in the new btree.
+	 */
+	uint64_t			nr_records;
+
+	/*
+	 * Number of free records to leave in each leaf block.  If the caller
+	 * sets this to -1, the slack value will be calculated to be be halfway
+	 * between maxrecs and minrecs.  This typically leaves the block 75%
+	 * full.  Note that slack values are not enforced on inode root blocks.
+	 */
+	int				leaf_slack;
+
+	/*
+	 * Number of free key/ptrs pairs to leave in each node block.  This
+	 * field has the same semantics as leaf_slack.
+	 */
+	int				node_slack;
+
+	/*
+	 * The xfs_btree_bload_compute_geometry function will set this to the
+	 * number of btree blocks needed to store nr_records records.
+	 */
+	uint64_t			nr_blocks;
+
+	/*
+	 * The xfs_btree_bload_compute_geometry function will set this to the
+	 * height of the new btree.
+	 */
+	unsigned int			btree_height;
+};
+
+int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
+		struct xfs_btree_bload *bbl, uint64_t nr_records);
+int xfs_btree_bload(struct xfs_btree_cur *cur, struct xfs_btree_bload *bbl,
+		void *priv);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index bc85b89f88ca..9b5e58a92381 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 05db0398f040..efc7751550d9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -35,6 +35,7 @@ struct xfs_icreate_log;
 struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
+union xfs_btree_ptr;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3666,6 +3667,90 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 		  __entry->blocks)
 )
 
+TRACE_EVENT(xfs_btree_bload_level_geometry,
+	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
+		 uint64_t nr_this_level, unsigned int nr_per_block,
+		 unsigned int desired_npb, uint64_t blocks,
+		 uint64_t blocks_with_extra),
+	TP_ARGS(cur, level, nr_this_level, nr_per_block, desired_npb, blocks,
+		blocks_with_extra),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(unsigned int, level)
+		__field(unsigned int, nlevels)
+		__field(uint64_t, nr_this_level)
+		__field(unsigned int, nr_per_block)
+		__field(unsigned int, desired_npb)
+		__field(unsigned long long, blocks)
+		__field(unsigned long long, blocks_with_extra)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->nlevels = cur->bc_nlevels;
+		__entry->nr_this_level = nr_this_level;
+		__entry->nr_per_block = nr_per_block;
+		__entry->desired_npb = desired_npb;
+		__entry->blocks = blocks;
+		__entry->blocks_with_extra = blocks_with_extra;
+	),
+	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->level,
+		  __entry->nlevels,
+		  __entry->nr_this_level,
+		  __entry->nr_per_block,
+		  __entry->desired_npb,
+		  __entry->blocks,
+		  __entry->blocks_with_extra)
+)
+
+TRACE_EVENT(xfs_btree_bload_block,
+	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
+		 uint64_t block_idx, uint64_t nr_blocks,
+		 union xfs_btree_ptr *ptr, unsigned int nr_records),
+	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(unsigned int, level)
+		__field(unsigned long long, block_idx)
+		__field(unsigned long long, nr_blocks)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(unsigned int, nr_records)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->block_idx = block_idx;
+		__entry->nr_blocks = nr_blocks;
+		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
+
+			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
+			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
+		} else {
+			__entry->agno = cur->bc_ag.agno;
+			__entry->agbno = be32_to_cpu(ptr->s);
+		}
+		__entry->nr_records = nr_records;
+	),
+	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->level,
+		  __entry->block_idx,
+		  __entry->nr_blocks,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->nr_records)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

