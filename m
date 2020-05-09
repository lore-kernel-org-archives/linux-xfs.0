Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BF5C47247
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3D42063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nxuSzjRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEIQct (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgEIQcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgAq072313;
        Sat, 9 May 2020 16:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EMiylHkb+UfdwgRp+LAkTDoazRCGOMBEhlccS1JxGr0=;
 b=nxuSzjRD80m+5XRz883dwjou9Yg8RsgvqsEsHBjEV0B7Ll8hObciH1Kr67q+6eyE570N
 OuFe7lgZhqZOcHi9gjukR/e9ck4D/vN3HVSmhiikQz4cyKe2uofqncoZyC/6EviAg9w7
 cTkK3444nQSOnSsA90m89hvRu6UYyznxqfvVxUelk+GB2KF8X/7nLoYv7tOmKWmREyPo
 AcWU0A1ey3VdTh4TDh1D0UdB5rGLasnFi6I7OYyBqXl6ITwz03c+0oV/xM9creF41KbL
 69ZF7Cjwue4yEOQsAMPKyIjHfC3eHzNJ9ZjIihH3lnDTw+bKNQl/lOIvO+yDzbRGL4bU xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30wkxqs6jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTufb112489;
        Sat, 9 May 2020 16:32:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30wx11cww3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:41 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GWeSo021143;
        Sat, 9 May 2020 16:32:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:32:40 -0700
Subject: [PATCH 9/9] xfs_repair: track blocks lost during btree construction
 via extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sat, 09 May 2020 09:32:40 -0700
Message-ID: <158904196027.984305.4802064994885970727.stgit@magnolia>
In-Reply-To: <158904190079.984305.707785748675261111.stgit@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=2 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
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
index 9b064a1b..f8693528 100644
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
@@ -310,21 +316,24 @@ static void
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
+
+		if (resv->used == resv->len)
+			continue;
 
-			error = slab_add(lost_fsb, &fsb);
-			if (error)
-				do_error(
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
@@ -1020,7 +1029,7 @@ build_agf_agfl(
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_rebuild	*btr_rmap,
 	struct bt_rebuild	*btr_refc,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
@@ -1239,7 +1248,7 @@ static void
 phase5_func(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct repair_ctx	sc = { .mp = mp, };
 	struct agi_stat		agi_stat = {0,};
@@ -1377,7 +1386,7 @@ phase5_func(
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&btr_rmap, &btr_refc, lost_fsb);
+			&btr_rmap, &btr_refc, lost_fsbs);
 
 	/*
 	 * build inode allocation trees.
@@ -1392,15 +1401,15 @@ phase5_func(
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
 	 * release the incore per-AG bno/bcnt trees so
@@ -1420,19 +1429,19 @@ inject_lost_blocks(
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
@@ -1453,7 +1462,7 @@ inject_lost_blocks(
 void
 phase5(xfs_mount_t *mp)
 {
-	struct xfs_slab		*lost_fsb;
+	struct xfs_slab		*lost_fsbs;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -1496,12 +1505,12 @@ phase5(xfs_mount_t *mp)
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
 
@@ -1544,10 +1553,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
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
 

