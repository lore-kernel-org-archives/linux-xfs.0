Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C87C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F369020829
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BhRnFAIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgETBxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:53:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgETBxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:53:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1rQct042077;
        Wed, 20 May 2020 01:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RVJaMcJG+VrEXp+iiB5n5DDQSzY2rJnKY17lqO0rTH4=;
 b=BhRnFAIOX3bpmQq1D1A1ZSPptFGCWbGEw9qOwIsoI/AZaztc8/u8XO+DWgfxECFp+dGk
 f83VDC1syv/348hhVeSGEijE1f07Z3fpgripvlxNAMFJ5K9LjLiJPsBieI33cDGQXnzK
 VLHLPChs4WwDaIsKQbSWzfEyZCU7dcZ80PspNUBemPUMUWLI2qp1IQ++izxZSvUdN5Ke
 bnf0qEUYGsw66wyUaqlrKho/RFJpXIZQF8LXMIa9qkEhByL0cbijXjfuzf1fTT7u6b7r
 cz8zx9tqwexoIVDej7aIAZ63NxTZZYHFY/jCQiZxZCgNL1rGwv3dRf339NiD867vcTIR nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127kr8jue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:53:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1mPF5084272;
        Wed, 20 May 2020 01:51:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 314gm648gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:51:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1phEb006574;
        Wed, 20 May 2020 01:51:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:51:43 -0700
Subject: [PATCH 9/9] xfs_repair: track blocks lost during btree construction
 via extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 19 May 2020 18:51:40 -0700
Message-ID: <158993950078.983175.14943057067035503330.stgit@magnolia>
In-Reply-To: <158993944270.983175.4120094597556662259.stgit@magnolia>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=2
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=2 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use extent records (not just raw fsbs) to track blocks that were lost
during btree construction.  This makes it somewhat more efficient.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   61 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 26 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 72c6908a..22007275 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -45,6 +45,12 @@ struct bt_rebuild {
 	};
 };
 
+struct lost_fsb {
+	xfs_fsblock_t		fsbno;
+	xfs_extlen_t		len;
+};
+
+
 /*
  * extra metadata for the agi
  */
@@ -314,21 +320,24 @@ static void
 finish_rebuild(
 	struct xfs_mount	*mp,
 	struct bt_rebuild	*btr,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct xrep_newbt_resv	*resv, *n;
 
 	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
-		while (resv->used < resv->len) {
-			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
-			int		error;
+		struct lost_fsb	lost;
+		int		error;
 
-			error = slab_add(lost_fsb, &fsb);
-			if (error)
-				do_error(
+		if (resv->used == resv->len)
+			continue;
+
+		lost.fsbno = resv->fsbno + resv->used;
+		lost.len = resv->len - resv->used;
+		error = slab_add(lost_fsbs, &lost);
+		if (error)
+			do_error(
 _("Insufficient memory saving lost blocks.\n"));
-			resv->used++;
-		}
+		resv->used = resv->len;
 	}
 
 	xrep_newbt_destroy(&btr->newbt, 0);
@@ -1036,7 +1045,7 @@ build_agf_agfl(
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_rebuild	*btr_rmap,
 	struct bt_rebuild	*btr_refc,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
@@ -1253,7 +1262,7 @@ static void
 phase5_func(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct repair_ctx	sc = { .mp = mp, };
 	struct agi_stat		agi_stat = {0,};
@@ -1372,7 +1381,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&btr_rmap, &btr_refc, lost_fsb);
+			&btr_rmap, &btr_refc, lost_fsbs);
 
 	/*
 	 * build inode allocation trees.
@@ -1387,15 +1396,15 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	/*
 	 * tear down cursors
 	 */
-	finish_rebuild(mp, &btr_bno, lost_fsb);
-	finish_rebuild(mp, &btr_cnt, lost_fsb);
-	finish_rebuild(mp, &btr_ino, lost_fsb);
+	finish_rebuild(mp, &btr_bno, lost_fsbs);
+	finish_rebuild(mp, &btr_cnt, lost_fsbs);
+	finish_rebuild(mp, &btr_ino, lost_fsbs);
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		finish_rebuild(mp, &btr_fino, lost_fsb);
+		finish_rebuild(mp, &btr_fino, lost_fsbs);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		finish_rebuild(mp, &btr_rmap, lost_fsb);
+		finish_rebuild(mp, &btr_rmap, lost_fsbs);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		finish_rebuild(mp, &btr_refc, lost_fsb);
+		finish_rebuild(mp, &btr_refc, lost_fsbs);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so the extent nodes
@@ -1414,19 +1423,19 @@ inject_lost_blocks(
 {
 	struct xfs_trans	*tp = NULL;
 	struct xfs_slab_cursor	*cur = NULL;
-	xfs_fsblock_t		*fsb;
+	struct lost_fsb		*lost;
 	int			error;
 
 	error = init_slab_cursor(lost_fsbs, NULL, &cur);
 	if (error)
 		return error;
 
-	while ((fsb = pop_slab_cursor(cur)) != NULL) {
+	while ((lost = pop_slab_cursor(cur)) != NULL) {
 		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
 		if (error)
 			goto out_cancel;
 
-		error = -libxfs_free_extent(tp, *fsb, 1,
+		error = -libxfs_free_extent(tp, lost->fsbno, lost->len,
 				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
 		if (error)
 			goto out_cancel;
@@ -1447,7 +1456,7 @@ inject_lost_blocks(
 void
 phase5(xfs_mount_t *mp)
 {
-	struct xfs_slab		*lost_fsb;
+	struct xfs_slab		*lost_fsbs;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -1490,12 +1499,12 @@ phase5(xfs_mount_t *mp)
 	if (sb_fdblocks_ag == NULL)
 		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
 
-	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
+	error = init_slab(&lost_fsbs, sizeof(struct lost_fsb));
 	if (error)
 		do_error(_("cannot alloc lost block slab\n"));
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-		phase5_func(mp, agno, lost_fsb);
+		phase5_func(mp, agno, lost_fsbs);
 
 	print_final_rpt();
 
@@ -1538,10 +1547,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
 	 * Put blocks that were unnecessarily reserved for btree
 	 * reconstruction back into the filesystem free space data.
 	 */
-	error = inject_lost_blocks(mp, lost_fsb);
+	error = inject_lost_blocks(mp, lost_fsbs);
 	if (error)
 		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
-	free_slab(&lost_fsb);
+	free_slab(&lost_fsbs);
 
 	bad_ino_btree = 0;
 

