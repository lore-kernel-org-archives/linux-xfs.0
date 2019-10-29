Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5943ECA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217C12086D
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B5MqY7qz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfJ2Xpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:45:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfJ2Xpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:45:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNe6pd017566;
        Tue, 29 Oct 2019 23:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VphdNTKBBp5D0DNg1olb47I+Py/A3VSlohTBYz8/hmk=;
 b=B5MqY7qz6W4JEQJFNUgrQbyIrR6ahV0P1Eu0l3XprPEV+s0Gf1CI5mZ9rYMbnalCQdSK
 TxaZhibSWDsFoR3ivgC1z5eun85R3mZLiX8egW4/FA6VkEE2zn0+3WzyZEhzmiTqRyLo
 z22KVe2wJRHpoeyvHRbHMI5kIZ305Tw1wNSl5A/1e1Sx2Fq9Zv+XQQ1zD3Emt7HplSIU
 JSa8hqAMYFepp54VSqlQLCFkxo6GL+e/E2fi1Hlezu6TeNfaLAmpXOs9E7+sPfnpQ3Uz
 wOhR6J1lpckiti35eg2HLzT/EXigWGXxlHQ5NLs8W41LEi9+p+yKXozZE2Iemc7Cjm1Q 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vxwhfgbyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:45:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNiRIn066733;
        Tue, 29 Oct 2019 23:45:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vxwj8veyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:45:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNjk6e018186;
        Tue, 29 Oct 2019 23:45:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:45:46 -0700
Subject: [PATCH 3/9] xfs_repair: create a new class of btree rebuild cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:45:45 -0700
Message-ID: <157239274502.1277435.17152946386021835217.stgit@magnolia>
In-Reply-To: <157239272641.1277435.17698788915454836309.stgit@magnolia>
References: <157239272641.1277435.17698788915454836309.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290208
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
 repair/phase5.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 210 insertions(+), 21 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 4108e22b..ec236d4c 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -18,6 +18,7 @@
 #include "progress.h"
 #include "slab.h"
 #include "rmap.h"
+#include "bload.h"
 
 /*
  * we maintain the current slice (path from root to leaf)
@@ -65,6 +66,14 @@ typedef struct bt_status  {
 	uint64_t		owner;		/* owner */
 } bt_status_t;
 
+struct bt_rebuild {
+	struct xrep_newbt	newbt;
+	struct xfs_btree_bload	bload;
+	union {
+		struct xfs_slab_cursor	*slab_cursor;
+	};
+};
+
 /*
  * extra metadata for the agi
  */
@@ -306,6 +315,157 @@ _("error - not enough free space in filesystem\n"));
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
+/* Reserve blocks for the new btree. */
+static void
+setup_rebuild(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr,
+	uint32_t		nr_blocks)
+{
+	struct extent_tree_node	*ext_ptr;
+	struct extent_tree_node	*bno_ext_ptr;
+	uint32_t		blocks_allocated = 0;
+	int			error;
+
+	/*
+	 * grab the smallest extent and use it up, then get the
+	 * next smallest.  This mimics the init_*_cursor code.
+	 */
+	ext_ptr =  findfirst_bcnt_extent(agno);
+
+	/*
+	 * set up the free block array
+	 */
+	while (blocks_allocated < nr_blocks)  {
+		uint64_t	len;
+		xfs_agblock_t	new_start;
+		xfs_extlen_t	new_len;
+
+		if (!ext_ptr)
+			do_error(
+_("error - not enough free space in filesystem\n"));
+
+		/* Use up the extent we've got. */
+		len = min(ext_ptr->ex_blockcount,
+				btr->bload.nr_blocks - blocks_allocated);
+		error = xrep_newbt_add_reservation(&btr->newbt,
+				XFS_AGB_TO_FSB(mp, agno,
+					       ext_ptr->ex_startblock),
+				len, NULL);
+		if (error)
+			do_error(_("could not set up btree reservation: %s\n"),
+				strerror(-error));
+		blocks_allocated += len;
+
+		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
+				btr->newbt.oinfo.oi_owner);
+		if (error)
+			do_error(_("could not set up btree rmaps: %s\n"),
+				strerror(-error));
+
+		/* Figure out if we're putting anything back. */
+		new_start = ext_ptr->ex_startblock + len;
+		new_len = ext_ptr->ex_blockcount - len;
+
+		/* Delete the used-up extent from both extent trees. */
+#ifdef XR_BLD_FREE_TRACE
+		fprintf(stderr, "releasing extent: %u [%u %u]\n",
+			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
+#endif
+		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
+		ASSERT(bno_ext_ptr != NULL);
+		get_bno_extent(agno, bno_ext_ptr);
+		release_extent_tree_node(bno_ext_ptr);
+
+		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
+				ext_ptr->ex_blockcount);
+		ASSERT(ext_ptr != NULL);
+		release_extent_tree_node(ext_ptr);
+
+		/*
+		 * If we only used part of this last extent, then we need only
+		 * to reinsert the extent in the extent trees and we're done.
+		 */
+		if (new_len > 0) {
+			add_bno_extent(agno, new_start, new_len);
+			add_bcnt_extent(agno, new_start, new_len);
+			break;
+		}
+
+		/* Otherwise, find the next biggest extent. */
+		ext_ptr = findfirst_bcnt_extent(agno);
+	}
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "blocks_allocated = %d\n",
+		blocks_allocated);
+#endif
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+static int
+rebuild_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct bt_rebuild	*btr = priv;
+
+	return xrep_newbt_alloc_block(cur, &btr->newbt, ptr);
+}
+
 static void
 write_cursor(bt_status_t *curs)
 {
@@ -334,6 +494,34 @@ finish_cursor(bt_status_t *curs)
 	free(curs->btree_blocks);
 }
 
+static void
+finish_rebuild(
+	struct xfs_mount	*mp,
+	struct bt_rebuild	*btr)
+{
+	struct xrep_newbt_resv	*resv, *n;
+
+	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
+		xfs_agnumber_t	agno;
+		xfs_agblock_t	bno;
+		xfs_extlen_t	len;
+
+		if (resv->used >= resv->len)
+			continue;
+
+		/* XXX: Shouldn't this go on the AGFL? */
+		/* Put back everything we didn't use. */
+		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
+		agno = XFS_FSB_TO_AGNO(mp, resv->fsbno + resv->used);
+		len = resv->len - resv->used;
+
+		add_bno_extent(agno, bno, len);
+		add_bcnt_extent(agno, bno, len);
+	}
+
+	xrep_newbt_destroy(&btr->newbt, 0);
+}
+
 /*
  * We need to leave some free records in the tree for the corner case of
  * setting up the AGFL. This may require allocation of blocks, and as
@@ -2211,28 +2399,29 @@ keep_fsinos(xfs_mount_t *mp)
 
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
@@ -2454,8 +2643,8 @@ inject_lost_blocks(
 		if (error)
 			goto out_cancel;
 
-		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
-					    XFS_AG_RESV_NONE);
+		error = -libxfs_free_extent(tp, *fsb, 1,
+				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
 		if (error)
 			goto out_cancel;
 

