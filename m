Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E3FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E62020738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NS0A/1TF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgFBE2L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBE2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524GPLI106416;
        Tue, 2 Jun 2020 04:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DzbuKbNAUtUkU56MlypVzIu6g4Dq5Vgo66gDSHhStj8=;
 b=NS0A/1TFtSll/7pmc/Ukg7w3nScMViaAMxj/xVCZUipnFlMczoLKUopEqxnvk6SW6Udy
 j9QiehMrz74GQSa0kwq/Ai45cGGQ2SXOCd4cTcr3+XOqp28Jir852GQt87uBfI/zW5+2
 dAieEOAG0k4GorqrL8ljD2Bt1oAZzmxIooZSTLyymhpNwylZId6hkJib4/ajlggHdzeY
 wEC//thaHzP0TU5iL5xBTgHG2HgHjmQA91im6UvotSUXyG1CqrOIeWG9kyK/ID9G2j6/
 x+ryIapZlNjwsewPVMRyWop1YxB427OoPO+zupp3WEOfFpYc+2ff3RRbgoPpe5YJ+WoZ oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1tcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:28:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HvtS040109;
        Tue, 2 Jun 2020 04:28:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31c18sghsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:28:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524S5sr022111;
        Tue, 2 Jun 2020 04:28:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:28:05 -0700
Subject: [PATCH 11/12] xfs_repair: remove old btree rebuild support code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:28:04 -0700
Message-ID: <159107208399.315004.5025037583246701950.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=2 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This code isn't needed anymore, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  242 -------------------------------------------------------
 1 file changed, 242 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index ad009416..439c1065 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -21,52 +21,6 @@
 #include "bulkload.h"
 #include "agbtree.h"
 
-/*
- * we maintain the current slice (path from root to leaf)
- * of the btree incore.  when we need a new block, we ask
- * the block allocator for the address of a block on that
- * level, map the block in, and set up the appropriate
- * pointers (child, silbing, etc.) and keys that should
- * point to the new block.
- */
-typedef struct bt_stat_level  {
-	/*
-	 * set in setup_cursor routine and maintained in the tree-building
-	 * routines
-	 */
-	xfs_buf_t		*buf_p;		/* 2 buffer pointers to ... */
-	xfs_buf_t		*prev_buf_p;
-	xfs_agblock_t		agbno;		/* current block being filled */
-	xfs_agblock_t		prev_agbno;	/* previous block */
-	/*
-	 * set in calculate/init cursor routines for each btree level
-	 */
-	int			num_recs_tot;	/* # tree recs in level */
-	int			num_blocks;	/* # tree blocks in level */
-	int			num_recs_pb;	/* num_recs_tot / num_blocks */
-	int			modulo;		/* num_recs_tot % num_blocks */
-} bt_stat_level_t;
-
-typedef struct bt_status  {
-	int			init;		/* cursor set up once? */
-	int			num_levels;	/* # of levels in btree */
-	xfs_extlen_t		num_tot_blocks;	/* # blocks alloc'ed for tree */
-	xfs_extlen_t		num_free_blocks;/* # blocks currently unused */
-
-	xfs_agblock_t		root;		/* root block */
-	/*
-	 * list of blocks to be used to set up this tree
-	 * and pointer to the first unused block on the list
-	 */
-	xfs_agblock_t		*btree_blocks;		/* block list */
-	xfs_agblock_t		*free_btree_blocks;	/* first unused block */
-	/*
-	 * per-level status info
-	 */
-	bt_stat_level_t		level[XFS_BTREE_MAXLEVELS];
-	uint64_t		owner;		/* owner */
-} bt_status_t;
-
 static uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
 static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
 static uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
@@ -164,202 +118,6 @@ mk_incore_fstree(
 	return(num_extents);
 }
 
-static xfs_agblock_t
-get_next_blockaddr(xfs_agnumber_t agno, int level, bt_status_t *curs)
-{
-	ASSERT(curs->free_btree_blocks < curs->btree_blocks +
-						curs->num_tot_blocks);
-	ASSERT(curs->num_free_blocks > 0);
-
-	curs->num_free_blocks--;
-	return(*curs->free_btree_blocks++);
-}
-
-/*
- * set up the dynamically allocated block allocation data in the btree
- * cursor that depends on the info in the static portion of the cursor.
- * allocates space from the incore bno/bcnt extent trees and sets up
- * the first path up the left side of the tree.  Also sets up the
- * cursor pointer to the btree root.   called by init_freespace_cursor()
- * and init_ino_cursor()
- */
-static void
-setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
-{
-	int			j;
-	unsigned int		u;
-	xfs_extlen_t		big_extent_len;
-	xfs_agblock_t		big_extent_start;
-	extent_tree_node_t	*ext_ptr;
-	extent_tree_node_t	*bno_ext_ptr;
-	xfs_extlen_t		blocks_allocated;
-	xfs_agblock_t		*agb_ptr;
-	int			error;
-
-	/*
-	 * get the number of blocks we need to allocate, then
-	 * set up block number array, set the free block pointer
-	 * to the first block in the array, and null the array
-	 */
-	big_extent_len = curs->num_tot_blocks;
-	blocks_allocated = 0;
-
-	ASSERT(big_extent_len > 0);
-
-	if ((curs->btree_blocks = malloc(sizeof(xfs_agblock_t)
-					* big_extent_len)) == NULL)
-		do_error(_("could not set up btree block array\n"));
-
-	agb_ptr = curs->free_btree_blocks = curs->btree_blocks;
-
-	for (j = 0; j < curs->num_free_blocks; j++, agb_ptr++)
-		*agb_ptr = NULLAGBLOCK;
-
-	/*
-	 * grab the smallest extent and use it up, then get the
-	 * next smallest.  This mimics the init_*_cursor code.
-	 */
-	ext_ptr =  findfirst_bcnt_extent(agno);
-
-	agb_ptr = curs->btree_blocks;
-
-	/*
-	 * set up the free block array
-	 */
-	while (blocks_allocated < big_extent_len)  {
-		if (!ext_ptr)
-			do_error(
-_("error - not enough free space in filesystem\n"));
-		/*
-		 * use up the extent we've got
-		 */
-		for (u = 0; u < ext_ptr->ex_blockcount &&
-				blocks_allocated < big_extent_len; u++)  {
-			ASSERT(agb_ptr < curs->btree_blocks
-					+ curs->num_tot_blocks);
-			*agb_ptr++ = ext_ptr->ex_startblock + u;
-			blocks_allocated++;
-		}
-
-		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, u,
-				curs->owner);
-		if (error)
-			do_error(_("could not set up btree rmaps: %s\n"),
-				strerror(-error));
-
-		/*
-		 * if we only used part of this last extent, then we
-		 * need only to reset the extent in the extent
-		 * trees and we're done
-		 */
-		if (u < ext_ptr->ex_blockcount)  {
-			big_extent_start = ext_ptr->ex_startblock + u;
-			big_extent_len = ext_ptr->ex_blockcount - u;
-
-			ASSERT(big_extent_len > 0);
-
-			bno_ext_ptr = find_bno_extent(agno,
-						ext_ptr->ex_startblock);
-			ASSERT(bno_ext_ptr != NULL);
-			get_bno_extent(agno, bno_ext_ptr);
-			release_extent_tree_node(bno_ext_ptr);
-
-			ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
-					ext_ptr->ex_blockcount);
-			release_extent_tree_node(ext_ptr);
-#ifdef XR_BLD_FREE_TRACE
-			fprintf(stderr, "releasing extent: %u [%u %u]\n",
-				agno, ext_ptr->ex_startblock,
-				ext_ptr->ex_blockcount);
-			fprintf(stderr, "blocks_allocated = %d\n",
-				blocks_allocated);
-#endif
-
-			add_bno_extent(agno, big_extent_start, big_extent_len);
-			add_bcnt_extent(agno, big_extent_start, big_extent_len);
-
-			return;
-		}
-		/*
-		 * delete the used-up extent from both extent trees and
-		 * find next biggest extent
-		 */
-#ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "releasing extent: %u [%u %u]\n",
-			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
-#endif
-		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
-		ASSERT(bno_ext_ptr != NULL);
-		get_bno_extent(agno, bno_ext_ptr);
-		release_extent_tree_node(bno_ext_ptr);
-
-		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
-				ext_ptr->ex_blockcount);
-		ASSERT(ext_ptr != NULL);
-		release_extent_tree_node(ext_ptr);
-
-		ext_ptr = findfirst_bcnt_extent(agno);
-	}
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "blocks_allocated = %d\n",
-		blocks_allocated);
-#endif
-}
-
-static void
-write_cursor(bt_status_t *curs)
-{
-	int i;
-
-	for (i = 0; i < curs->num_levels; i++)  {
-#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
-		fprintf(stderr, "writing bt block %u\n", curs->level[i].agbno);
-#endif
-		if (curs->level[i].prev_buf_p != NULL)  {
-			ASSERT(curs->level[i].prev_agbno != NULLAGBLOCK);
-#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
-			fprintf(stderr, "writing bt prev block %u\n",
-						curs->level[i].prev_agbno);
-#endif
-			libxfs_buf_mark_dirty(curs->level[i].prev_buf_p);
-			libxfs_buf_relse(curs->level[i].prev_buf_p);
-		}
-		libxfs_buf_mark_dirty(curs->level[i].buf_p);
-		libxfs_buf_relse(curs->level[i].buf_p);
-	}
-}
-
-static void
-finish_cursor(bt_status_t *curs)
-{
-	ASSERT(curs->num_free_blocks == 0);
-	free(curs->btree_blocks);
-}
-
-/* Map btnum to buffer ops for the types that need it. */
-static const struct xfs_buf_ops *
-btnum_to_ops(
-	xfs_btnum_t	btnum)
-{
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-		return &xfs_bnobt_buf_ops;
-	case XFS_BTNUM_CNT:
-		return &xfs_cntbt_buf_ops;
-	case XFS_BTNUM_INO:
-		return &xfs_inobt_buf_ops;
-	case XFS_BTNUM_FINO:
-		return &xfs_finobt_buf_ops;
-	case XFS_BTNUM_RMAP:
-		return &xfs_rmapbt_buf_ops;
-	case XFS_BTNUM_REFC:
-		return &xfs_refcountbt_buf_ops;
-	default:
-		ASSERT(0);
-		return NULL;
-	}
-}
-
 /*
  * XXX: yet more code that can be shared with mkfs, growfs.
  */

