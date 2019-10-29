Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666E7CA9EC4
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3701B20862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qMbP0vUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfJ2Xq3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:46:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfJ2Xq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:46:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNe6UH045257;
        Tue, 29 Oct 2019 23:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HOK3jJpVpnnCmVQFhqLhS3PqnEov2zHnQeFXcnU+y+4=;
 b=qMbP0vUvCd4DjmBa3HcqUcXbi3T90cIwW0SEMHVTOy9L6tW760gVnVLA+/aY6zZ1x2GZ
 Wexk/QXbQ4+KxXVw8vQzPqYHek428DR5O9YeZ1hAekxb+sviYpb6cCRRusIBSHwbSRps
 +rpeJceSJNrQuyCbP3X7NfXSaGw/eVFwVxTZ+JZh4nkciUmZYtWmR/JKAh26HZly0COP
 xXFxBx15x+c1pmdFhG6g0Ds94imyXJ/it0PDrFLq5VYeJf4ENaJfrjftzU3SqA7eHHq0
 UDQ/g1yn4FpROthyD5R8h7ck/1gOsJkg9DIIECp7OCvM2iWu4o6RHLR8OcyJ+E9s1j59 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vxwhfgc3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:46:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNhkli015708;
        Tue, 29 Oct 2019 23:46:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vxwj84rtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:46:25 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNkOGQ018415;
        Tue, 29 Oct 2019 23:46:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:46:24 -0700
Subject: [PATCH 9/9] xfs_repair: track blocks lost during btree construction
 via extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:46:23 -0700
Message-ID: <157239278377.1277435.318232659414339051.stgit@magnolia>
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

Use extent records (not just raw fsbs) to track blocks that were lost
during btree construction.  This makes it somewhat more efficient.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   60 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 26 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 94fc17d8..1519a372 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -20,6 +20,11 @@
 #include "rmap.h"
 #include "bload.h"
 
+struct lost_fsb {
+	xfs_fsblock_t		fsbno;
+	xfs_extlen_t		len;
+};
+
 struct bt_rebuild {
 	struct xrep_newbt	newbt;
 	struct xfs_btree_bload	bload;
@@ -301,21 +306,24 @@ static void
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
@@ -1039,7 +1047,7 @@ build_agf_agfl(
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_rebuild	*btr_rmap,
 	struct bt_rebuild	*btr_refcount,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
@@ -1238,7 +1246,7 @@ static void
 phase5_func(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct repair_ctx	sc = { .mp = mp, };
 	struct agi_stat		agi_stat = {0,};
@@ -1373,7 +1381,7 @@ phase5_func(
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&btr_rmap, &btr_refcount, lost_fsb);
+			&btr_rmap, &btr_refcount, lost_fsbs);
 
 	/*
 	 * build inode allocation trees.
@@ -1388,15 +1396,15 @@ phase5_func(
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
-		finish_rebuild(mp, &btr_refcount, lost_fsb);
+		finish_rebuild(mp, &btr_refcount, lost_fsbs);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so
@@ -1416,19 +1424,19 @@ inject_lost_blocks(
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
@@ -1449,7 +1457,7 @@ inject_lost_blocks(
 void
 phase5(xfs_mount_t *mp)
 {
-	struct xfs_slab		*lost_fsb;
+	struct xfs_slab		*lost_fsbs;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -1492,12 +1500,12 @@ phase5(xfs_mount_t *mp)
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
 
@@ -1540,10 +1548,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
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
 

