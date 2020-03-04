Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A272C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5345220CC7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BAevQNF5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbgCDDcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 22:32:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgCDDcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 22:32:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243OH7Q077293;
        Wed, 4 Mar 2020 03:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Nv05Ps6W1/36yuKH+8RkN65LvOAgLQ+llCQ8GfsSIQU=;
 b=BAevQNF5T7CyC2Sx7aoIeXCr0xOyjF/QUmu8we9S8y0odLr6sO0iAOgRlF0tt0Fds4k4
 UKvGyZ/UgYKD/+GpI5Z/m39sFbVGrOpdCgQPFuvqaU8YV+GnvtHd9gUaqHN66uA4C81o
 6gsAxJi32fJT99qffvPsSwPzembJuIM81EeTIkHDQkuAep9pw+vJV8aZL1n6aG80AvFt
 GILbcf5IKL/lWaXZdSogeJ6WmoF0vltDZE6szZSONKCQl6Ir1zojXgH96R/YeBlJUa+N
 +95y7iwWQEVu3uaZvDgdEyaJxjIb6ISk8tdnFk7HUjZ+fbu0gmlrp0YuhwqdexbPlnPU pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yffwqukvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:32:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243GciI106430;
        Wed, 4 Mar 2020 03:30:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yg1enk0e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:30:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0243U44S000524;
        Wed, 4 Mar 2020 03:30:04 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 19:30:04 -0800
Subject: [PATCH 9/9] xfs_repair: track blocks lost during btree construction
 via extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 03 Mar 2020 19:30:03 -0800
Message-ID: <158329260320.2424103.6307844608711552371.stgit@magnolia>
In-Reply-To: <158329254501.2424103.11001979654106437662.stgit@magnolia>
References: <158329254501.2424103.11001979654106437662.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040022
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
index 15358597..4470f63a 100644
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
@@ -1044,7 +1052,7 @@ build_agf_agfl(
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_rebuild	*btr_rmap,
 	struct bt_rebuild	*btr_refcount,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
@@ -1253,7 +1261,7 @@ static void
 phase5_func(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	struct xfs_slab		*lost_fsb)
+	struct xfs_slab		*lost_fsbs)
 {
 	struct repair_ctx	sc = { .mp = mp, };
 	struct agi_stat		agi_stat = {0,};
@@ -1388,7 +1396,7 @@ phase5_func(
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&btr_rmap, &btr_refcount, lost_fsb);
+			&btr_rmap, &btr_refcount, lost_fsbs);
 
 	/*
 	 * build inode allocation trees.
@@ -1403,15 +1411,15 @@ phase5_func(
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
@@ -1431,19 +1439,19 @@ inject_lost_blocks(
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
@@ -1464,7 +1472,7 @@ inject_lost_blocks(
 void
 phase5(xfs_mount_t *mp)
 {
-	struct xfs_slab		*lost_fsb;
+	struct xfs_slab		*lost_fsbs;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -1507,12 +1515,12 @@ phase5(xfs_mount_t *mp)
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
 
@@ -1555,10 +1563,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
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
 

