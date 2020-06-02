Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DB0C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA8120738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rk6Xjf4M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgFBE2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFBE2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524IbVJ131153;
        Tue, 2 Jun 2020 04:28:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Gipmv1Iy6N1oxtD6qgybx3zlWIWN3Y8LE/wzKZKCQcU=;
 b=rk6Xjf4M1neuN4CER+cTWpEOv6N940uYo89jynOYcR6qviAP8maW3MPI7EJiRSAyl+uC
 4I6iwelfzbZTzWCtYC7h8kWNf8Gkoq6YgyY1GmEdXOserWXkj/7qlsmLkqzoykrxl2ke
 RHwRrXAdSwOF8FqjiR9KEAmNmDmqFcyC03JNhizjtVdgBxjl5bBKnj2ZiW0ahrFK0zUO
 vHyYoUs/ViIB/6ZE52nZVbVwIEGqXFp6LZ8ej/ai/9S3kc/nDxV89j84H8OIMrUh5mrc
 Q06Uh3spERhrx8MmqHnJYQHKRG/XUqGZFXr/1r5ixFS09VKzJ2T5SlOxvcvUvbm/hrKA UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31d5qr20tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:28:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JESj091203;
        Tue, 2 Jun 2020 04:28:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dwgg35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:28:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524SBf0022127;
        Tue, 2 Jun 2020 04:28:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:28:11 -0700
Subject: [PATCH 12/12] xfs_repair: use bitmap to track blocks lost during
 btree construction
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:28:10 -0700
Message-ID: <159107209039.315004.11590903544086845302.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=2 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=2 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the incore bitmap structure to track blocks that were lost
during btree construction.  This makes it somewhat more efficient.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/agbtree.c |   21 ++++++++--------
 repair/agbtree.h |    2 +-
 repair/phase5.c  |   72 ++++++++++++++++++++++--------------------------------
 3 files changed, 41 insertions(+), 54 deletions(-)


diff --git a/repair/agbtree.c b/repair/agbtree.c
index d3639fe4..9f87253f 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -5,6 +5,7 @@
  */
 #include <libxfs.h>
 #include "err_protos.h"
+#include "libfrog/bitmap.h"
 #include "slab.h"
 #include "rmap.h"
 #include "incore.h"
@@ -131,21 +132,21 @@ void
 finish_rebuild(
 	struct xfs_mount	*mp,
 	struct bt_rebuild	*btr,
-	struct xfs_slab		*lost_fsb)
+	struct bitmap		*lost_blocks)
 {
 	struct bulkload_resv	*resv, *n;
+	int			error;
 
 	for_each_bulkload_reservation(&btr->newbt, resv, n) {
-		while (resv->used < resv->len) {
-			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
-			int		error;
+		if (resv->used == resv->len)
+			continue;
 
-			error = slab_add(lost_fsb, &fsb);
-			if (error)
-				do_error(
-_("Insufficient memory saving lost blocks.\n"));
-			resv->used++;
-		}
+		error = bitmap_set(lost_blocks, resv->fsbno + resv->used,
+				   resv->len - resv->used);
+		if (error)
+			do_error(
+_("Insufficient memory saving lost blocks, err=%d.\n"), error);
+		resv->used = resv->len;
 	}
 
 	bulkload_destroy(&btr->newbt, 0);
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 6bbeb022..d8095d20 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -34,7 +34,7 @@ struct bt_rebuild {
 };
 
 void finish_rebuild(struct xfs_mount *mp, struct bt_rebuild *btr,
-		struct xfs_slab *lost_fsb);
+		struct bitmap *lost_blocks);
 void init_freespace_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
 		unsigned int free_space, unsigned int *nr_extents,
 		int *extra_blocks, struct bt_rebuild *btr_bno,
diff --git a/repair/phase5.c b/repair/phase5.c
index 439c1065..446f7ec0 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "libfrog/bitmap.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -211,7 +212,7 @@ build_agf_agfl(
 	struct bt_rebuild	*btr_cnt,
 	struct bt_rebuild	*btr_rmap,
 	struct bt_rebuild	*btr_refc,
-	struct xfs_slab		*lost_fsb)
+	struct bitmap		*lost_blocks)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
@@ -428,7 +429,7 @@ static void
 phase5_func(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	struct xfs_slab		*lost_fsb)
+	struct bitmap		*lost_blocks)
 {
 	struct repair_ctx	sc = { .mp = mp, };
 	struct bt_rebuild	btr_bno;
@@ -543,7 +544,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap, &btr_refc,
-			lost_fsb);
+			lost_blocks);
 
 	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
 
@@ -553,15 +554,15 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	/*
 	 * tear down cursors
 	 */
-	finish_rebuild(mp, &btr_bno, lost_fsb);
-	finish_rebuild(mp, &btr_cnt, lost_fsb);
-	finish_rebuild(mp, &btr_ino, lost_fsb);
+	finish_rebuild(mp, &btr_bno, lost_blocks);
+	finish_rebuild(mp, &btr_cnt, lost_blocks);
+	finish_rebuild(mp, &btr_ino, lost_blocks);
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		finish_rebuild(mp, &btr_fino, lost_fsb);
+		finish_rebuild(mp, &btr_fino, lost_blocks);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		finish_rebuild(mp, &btr_rmap, lost_fsb);
+		finish_rebuild(mp, &btr_rmap, lost_blocks);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		finish_rebuild(mp, &btr_refc, lost_fsb);
+		finish_rebuild(mp, &btr_refc, lost_blocks);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so the extent nodes
@@ -572,48 +573,33 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
 }
 
-/* Inject lost blocks back into the filesystem. */
+/* Inject this unused space back into the filesystem. */
 static int
-inject_lost_blocks(
-	struct xfs_mount	*mp,
-	struct xfs_slab		*lost_fsbs)
+inject_lost_extent(
+	uint64_t		start,
+	uint64_t		length,
+	void			*arg)
 {
-	struct xfs_trans	*tp = NULL;
-	struct xfs_slab_cursor	*cur = NULL;
-	xfs_fsblock_t		*fsb;
+	struct xfs_mount	*mp = arg;
+	struct xfs_trans	*tp;
 	int			error;
 
-	error = init_slab_cursor(lost_fsbs, NULL, &cur);
+	error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
 	if (error)
 		return error;
 
-	while ((fsb = pop_slab_cursor(cur)) != NULL) {
-		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
-		if (error)
-			goto out_cancel;
-
-		error = -libxfs_free_extent(tp, *fsb, 1,
-				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
-		if (error)
-			goto out_cancel;
-
-		error = -libxfs_trans_commit(tp);
-		if (error)
-			goto out_cancel;
-		tp = NULL;
-	}
+	error = -libxfs_free_extent(tp, start, length,
+			&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
+	if (error)
+		return error;
 
-out_cancel:
-	if (tp)
-		libxfs_trans_cancel(tp);
-	free_slab_cursor(&cur);
-	return error;
+	return -libxfs_trans_commit(tp);
 }
 
 void
 phase5(xfs_mount_t *mp)
 {
-	struct xfs_slab		*lost_fsb;
+	struct bitmap		*lost_blocks = NULL;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -656,12 +642,12 @@ phase5(xfs_mount_t *mp)
 	if (sb_fdblocks_ag == NULL)
 		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
 
-	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
+	error = bitmap_alloc(&lost_blocks);
 	if (error)
-		do_error(_("cannot alloc lost block slab\n"));
+		do_error(_("cannot alloc lost block bitmap\n"));
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-		phase5_func(mp, agno, lost_fsb);
+		phase5_func(mp, agno, lost_blocks);
 
 	print_final_rpt();
 
@@ -704,10 +690,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
 	 * Put blocks that were unnecessarily reserved for btree
 	 * reconstruction back into the filesystem free space data.
 	 */
-	error = inject_lost_blocks(mp, lost_fsb);
+	error = bitmap_iterate(lost_blocks, inject_lost_extent, mp);
 	if (error)
 		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
-	free_slab(&lost_fsb);
+	bitmap_free(&lost_blocks);
 
 	bad_ino_btree = 0;
 

