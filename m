Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F59C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3065F20708
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UJEm1vOo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgETBvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:51:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:51:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1mHOw168132;
        Wed, 20 May 2020 01:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=12vYurWbv/sTmJ+aeywfOJLG1ooklnsVMGol709F+iA=;
 b=UJEm1vOoB+OTd19iKRWWM3niM0IataIjUfjbKIxnYtfjdZWPng5qsSgFL42rxbQ9Rv2R
 5pDaCCRf5oOZKI2+n+cXaCCWOJSBCgO465TuVY1t9PVqaK1crK0tQ2wgt0UhusiS4hEh
 skQNYQ8rtiswWLmRlGqbGUtqyWrna/1Usak4n5mtysJ91f2h2ocP6jdZW3Qu2Txwuotm
 gA7GqGFCUWVhAI/edr0blAelNXM+7gwWyw6WuEshJ+9Kh7r0QibOOQYQDF+fpRWM9/3V
 CwK3CzYsPmo0sqgSIH2M0d7jLZ/hJZU8PTQj/b315dtP9oX7mxR0PYBBQKRuKpK0XELw gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284m0hpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:51:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1n2Cb140922;
        Wed, 20 May 2020 01:51:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t35ys3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:51:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1p3ZX026479;
        Wed, 20 May 2020 01:51:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:51:03 -0700
Subject: [PATCH 3/9] xfs_repair: create a new class of btree rebuild cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 19 May 2020 18:51:02 -0700
Message-ID: <158993946213.983175.9823091723787830102.stgit@magnolia>
In-Reply-To: <158993944270.983175.4120094597556662259.stgit@magnolia>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some new support structures and functions to assist phase5 in
using the btree bulk loader to reconstruct metadata btrees.  This is the
first step in removing the open-coded rebuilding code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  239 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 218 insertions(+), 21 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 84c05a13..8f5e5f59 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -18,6 +18,7 @@
 #include "progress.h"
 #include "slab.h"
 #include "rmap.h"
+#include "bload.h"
 
 /*
  * we maintain the current slice (path from root to leaf)
@@ -65,6 +66,23 @@ typedef struct bt_status  {
 	uint64_t		owner;		/* owner */
 } bt_status_t;
 
+/* Context for rebuilding a per-AG btree. */
+struct bt_rebuild {
+	/* Fake root for staging and space preallocations. */
+	struct xrep_newbt	newbt;
+
+	/* Geometry of the new btree. */
+	struct xfs_btree_bload	bload;
+
+	/* Staging btree cursor for the new tree. */
+	struct xfs_btree_cur	*cur;
+
+	/* Tree-specific data. */
+	union {
+		struct xfs_slab_cursor	*slab_cursor;
+	};
+};
+
 /*
  * extra metadata for the agi
  */
@@ -306,6 +324,156 @@ _("error - not enough free space in filesystem\n"));
 #endif
 }
 
+/*
+ * Estimate proper slack values for a btree that's being reloaded.
+ *
+ * Under most circumstances, we'll take whatever default loading value the
+ * btree bulk loading code calculates for us.  However, there are some
+ * exceptions to this rule:
+ *
+ * (1) If someone turned one of the debug knobs.
+ * (2) The AG has less than ~9% space free.
+ *
+ * Note that we actually use 3/32 for the comparison to avoid division.
+ */
+static void
+estimate_ag_bload_slack(
+	struct repair_ctx	*sc,
+	struct xfs_btree_bload	*bload,
+	unsigned int		free)
+{
+	/*
+	 * The global values are set to -1 (i.e. take the bload defaults)
+	 * unless someone has set them otherwise, so we just pull the values
+	 * here.
+	 */
+	bload->leaf_slack = bload_leaf_slack;
+	bload->node_slack = bload_node_slack;
+
+	/* No further changes if there's more than 3/32ths space left. */
+	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
+		return;
+
+	/* We're low on space; load the btrees as tightly as possible. */
+	if (bload->leaf_slack < 0)
+		bload->leaf_slack = 0;
+	if (bload->node_slack < 0)
+		bload->node_slack = 0;
+}
+
+/* Initialize a btree rebuild context. */
+static void
+init_rebuild(
+	struct repair_ctx		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_agblock_t			free_space,
+	struct bt_rebuild		*btr)
+{
+	memset(btr, 0, sizeof(struct bt_rebuild));
+
+	xrep_newbt_init_bare(&btr->newbt, sc);
+	btr->newbt.oinfo = *oinfo; /* struct copy */
+	estimate_ag_bload_slack(sc, &btr->bload, free_space);
+}
+
+/*
+ * Update this free space record to reflect the blocks we stole from the
+ * beginning of the record.
+ */
+static void
+consume_freespace(
+	xfs_agnumber_t		agno,
+	struct extent_tree_node	*ext_ptr,
+	uint32_t		len)
+{
+	struct extent_tree_node	*bno_ext_ptr;
+	xfs_agblock_t		new_start = ext_ptr->ex_startblock + len;
+	xfs_extlen_t		new_len = ext_ptr->ex_blockcount - len;
+
+	/* Delete the used-up extent from both extent trees. */
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "releasing extent: %u [%u %u]\n", agno,
+			ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
+#endif
+	bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
+	ASSERT(bno_ext_ptr != NULL);
+	get_bno_extent(agno, bno_ext_ptr);
+	release_extent_tree_node(bno_ext_ptr);
+
+	ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
+			ext_ptr->ex_blockcount);
+	release_extent_tree_node(ext_ptr);
+
+	/*
+	 * If we only used part of this last extent, then we must reinsert the
+	 * extent in the extent trees.
+	 */
+	if (new_len > 0) {
+		add_bno_extent(agno, new_start, new_len);
+		add_bcnt_extent(agno, new_start, new_len);
+	}
+}
+
+/* Reserve blocks for the new btree. */
+static void
+setup_rebuild(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr,
+	uint32_t		nr_blocks)
+{
+	struct extent_tree_node	*ext_ptr;
+	uint32_t		blocks_allocated = 0;
+	uint32_t		len;
+	int			error;
+
+	while (blocks_allocated < nr_blocks)  {
+		/*
+		 * Grab the smallest extent and use it up, then get the
+		 * next smallest.  This mimics the init_*_cursor code.
+		 */
+		ext_ptr =  findfirst_bcnt_extent(agno);
+		if (!ext_ptr)
+			do_error(
+_("error - not enough free space in filesystem\n"));
+
+		/* Use up the extent we've got. */
+		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
+		error = xrep_newbt_add_blocks(&btr->newbt,
+				XFS_AGB_TO_FSB(mp, agno,
+					       ext_ptr->ex_startblock),
+				len);
+		if (error)
+			do_error(_("could not set up btree reservation: %s\n"),
+				strerror(-error));
+
+		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
+				btr->newbt.oinfo.oi_owner);
+		if (error)
+			do_error(_("could not set up btree rmaps: %s\n"),
+				strerror(-error));
+
+		consume_freespace(agno, ext_ptr, len);
+		blocks_allocated += len;
+	}
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "blocks_allocated = %d\n",
+		blocks_allocated);
+#endif
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+static int
+rebuild_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct bt_rebuild	*btr = priv;
+
+	return xrep_newbt_claim_block(cur, &btr->newbt, ptr);
+}
+
 static void
 write_cursor(bt_status_t *curs)
 {
@@ -336,6 +504,34 @@ finish_cursor(bt_status_t *curs)
 	free(curs->btree_blocks);
 }
 
+/*
+ * Scoop up leftovers from a rebuild cursor for later freeing, then free the
+ * rebuild context.
+ */
+static void
+finish_rebuild(
+	struct xfs_mount	*mp,
+	struct bt_rebuild	*btr,
+	struct xfs_slab		*lost_fsb)
+{
+	struct xrep_newbt_resv	*resv, *n;
+
+	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
+		while (resv->used < resv->len) {
+			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
+			int		error;
+
+			error = slab_add(lost_fsb, &fsb);
+			if (error)
+				do_error(
+_("Insufficient memory saving lost blocks.\n"));
+			resv->used++;
+		}
+	}
+
+	xrep_newbt_destroy(&btr->newbt, 0);
+}
+
 /*
  * We need to leave some free records in the tree for the corner case of
  * setting up the AGFL. This may require allocation of blocks, and as
@@ -2287,28 +2483,29 @@ keep_fsinos(xfs_mount_t *mp)
 
 static void
 phase5_func(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno,
-	struct xfs_slab	*lost_fsb)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_slab		*lost_fsb)
 {
-	uint64_t	num_inos;
-	uint64_t	num_free_inos;
-	uint64_t	finobt_num_inos;
-	uint64_t	finobt_num_free_inos;
-	bt_status_t	bno_btree_curs;
-	bt_status_t	bcnt_btree_curs;
-	bt_status_t	ino_btree_curs;
-	bt_status_t	fino_btree_curs;
-	bt_status_t	rmap_btree_curs;
-	bt_status_t	refcnt_btree_curs;
-	int		extra_blocks = 0;
-	uint		num_freeblocks;
-	xfs_extlen_t	freeblks1;
+	struct repair_ctx	sc = { .mp = mp, };
+	struct agi_stat		agi_stat = {0,};
+	uint64_t		num_inos;
+	uint64_t		num_free_inos;
+	uint64_t		finobt_num_inos;
+	uint64_t		finobt_num_free_inos;
+	bt_status_t		bno_btree_curs;
+	bt_status_t		bcnt_btree_curs;
+	bt_status_t		ino_btree_curs;
+	bt_status_t		fino_btree_curs;
+	bt_status_t		rmap_btree_curs;
+	bt_status_t		refcnt_btree_curs;
+	int			extra_blocks = 0;
+	uint			num_freeblocks;
+	xfs_extlen_t		freeblks1;
 #ifdef DEBUG
-	xfs_extlen_t	freeblks2;
+	xfs_extlen_t		freeblks2;
 #endif
-	xfs_agblock_t	num_extents;
-	struct agi_stat	agi_stat = {0,};
+	xfs_agblock_t		num_extents;
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -2516,8 +2713,8 @@ inject_lost_blocks(
 		if (error)
 			goto out_cancel;
 
-		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
-					    XFS_AG_RESV_NONE);
+		error = -libxfs_free_extent(tp, *fsb, 1,
+				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
 		if (error)
 			goto out_cancel;
 

