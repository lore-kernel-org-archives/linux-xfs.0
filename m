Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAFCECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5215D21848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MqDkLTb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbfJIQtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:49:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfJIQtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:49:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjcpp026561
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+rzyB1XeWKZ+oIrEscfVb4d+r+rbkOOhaN5Gw82OsTg=;
 b=MqDkLTb7DVP/XNiD+IF/fSyVlttTP1pR0lqFC8v4lzLhfsfXzEuyvEO9jtMNdwZb3qmi
 BpDhUCkJMvMniShuiV+luFE7oZBaL+p92e1slmTOM5SLCUpga3ainczKpGBXaTtuIi8I
 4fI9Sc53kzMU+KbWVE0/+UqAW0v0LTb7wVSEdl4gHk3iL3y2XonW+XDBmantPaJL2qAR
 odHgeqjEBJfLoyIQzCSwiklfUJnpbkQ0a4mcwoHAaPG1+GNYsiaq6sjxMQWNxpYNBmY4
 YQmn/eyPMtCUTHWuRhcdY0ukEcrOiPz47tvlpkd4+SlqDANYLxVopf2fzFAthmKNATWH ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vektrnrq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZ67144600
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vh8k145wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:08 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99Gn7S8023788
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:49:06 -0700
Subject: [PATCH 1/4] xfs: rename xfs_bitmap to xbitmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:49:02 -0700
Message-ID: <157063974228.2913318.15618537137940666793.stgit@magnolia>
In-Reply-To: <157063973592.2913318.8246472567175058111.stgit@magnolia>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Shorten the name of xfs_bitmap to xbitmap since the scrub bitmap has
nothing to do with the libxfs bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |   42 ++++++++++++-----------
 fs/xfs/scrub/bitmap.c          |   72 ++++++++++++++++++++--------------------
 fs/xfs/scrub/bitmap.h          |   22 ++++++------
 fs/xfs/scrub/repair.c          |    8 ++--
 fs/xfs/scrub/repair.h          |    4 +-
 5 files changed, 74 insertions(+), 74 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 8fcd43040c96..9fbb6035f4e2 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -429,10 +429,10 @@ xrep_agf(
 
 struct xrep_agfl {
 	/* Bitmap of other OWN_AG metadata blocks. */
-	struct xfs_bitmap	agmetablocks;
+	struct xbitmap		agmetablocks;
 
 	/* Bitmap of free space. */
-	struct xfs_bitmap	*freesp;
+	struct xbitmap		*freesp;
 
 	struct xfs_scrub	*sc;
 };
@@ -455,12 +455,12 @@ xrep_agfl_walk_rmap(
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
 		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
 				rec->rm_startblock);
-		error = xfs_bitmap_set(ra->freesp, fsb, rec->rm_blockcount);
+		error = xbitmap_set(ra->freesp, fsb, rec->rm_blockcount);
 		if (error)
 			return error;
 	}
 
-	return xfs_bitmap_set_btcur_path(&ra->agmetablocks, cur);
+	return xbitmap_set_btcur_path(&ra->agmetablocks, cur);
 }
 
 /*
@@ -476,19 +476,19 @@ STATIC int
 xrep_agfl_collect_blocks(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agf_bp,
-	struct xfs_bitmap	*agfl_extents,
+	struct xbitmap		*agfl_extents,
 	xfs_agblock_t		*flcount)
 {
 	struct xrep_agfl	ra;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_btree_cur	*cur;
-	struct xfs_bitmap_range	*br;
-	struct xfs_bitmap_range	*n;
+	struct xbitmap_range	*br;
+	struct xbitmap_range	*n;
 	int			error;
 
 	ra.sc = sc;
 	ra.freesp = agfl_extents;
-	xfs_bitmap_init(&ra.agmetablocks);
+	xbitmap_init(&ra.agmetablocks);
 
 	/* Find all space used by the free space btrees & rmapbt. */
 	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
@@ -500,7 +500,7 @@ xrep_agfl_collect_blocks(
 	/* Find all blocks currently being used by the bnobt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
 			XFS_BTNUM_BNO);
-	error = xfs_bitmap_set_btblocks(&ra.agmetablocks, cur);
+	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
 	if (error)
 		goto err;
 	xfs_btree_del_cursor(cur, error);
@@ -508,7 +508,7 @@ xrep_agfl_collect_blocks(
 	/* Find all blocks currently being used by the cntbt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
 			XFS_BTNUM_CNT);
-	error = xfs_bitmap_set_btblocks(&ra.agmetablocks, cur);
+	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
 	if (error)
 		goto err;
 
@@ -518,8 +518,8 @@ xrep_agfl_collect_blocks(
 	 * Drop the freesp meta blocks that are in use by btrees.
 	 * The remaining blocks /should/ be AGFL blocks.
 	 */
-	error = xfs_bitmap_disunion(agfl_extents, &ra.agmetablocks);
-	xfs_bitmap_destroy(&ra.agmetablocks);
+	error = xbitmap_disunion(agfl_extents, &ra.agmetablocks);
+	xbitmap_destroy(&ra.agmetablocks);
 	if (error)
 		return error;
 
@@ -528,7 +528,7 @@ xrep_agfl_collect_blocks(
 	 * the AGFL we'll free them later.
 	 */
 	*flcount = 0;
-	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
+	for_each_xbitmap_extent(br, n, agfl_extents) {
 		*flcount += br->len;
 		if (*flcount > xfs_agfl_size(mp))
 			break;
@@ -538,7 +538,7 @@ xrep_agfl_collect_blocks(
 	return 0;
 
 err:
-	xfs_bitmap_destroy(&ra.agmetablocks);
+	xbitmap_destroy(&ra.agmetablocks);
 	xfs_btree_del_cursor(cur, error);
 	return error;
 }
@@ -573,13 +573,13 @@ STATIC void
 xrep_agfl_init_header(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agfl_bp,
-	struct xfs_bitmap	*agfl_extents,
+	struct xbitmap		*agfl_extents,
 	xfs_agblock_t		flcount)
 {
 	struct xfs_mount	*mp = sc->mp;
 	__be32			*agfl_bno;
-	struct xfs_bitmap_range	*br;
-	struct xfs_bitmap_range	*n;
+	struct xbitmap_range	*br;
+	struct xbitmap_range	*n;
 	struct xfs_agfl		*agfl;
 	xfs_agblock_t		agbno;
 	unsigned int		fl_off;
@@ -603,7 +603,7 @@ xrep_agfl_init_header(
 	 */
 	fl_off = 0;
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
-	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
+	for_each_xbitmap_extent(br, n, agfl_extents) {
 		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
 
 		trace_xrep_agfl_insert(mp, sc->sa.agno, agbno, br->len);
@@ -637,7 +637,7 @@ int
 xrep_agfl(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_bitmap	agfl_extents;
+	struct xbitmap		agfl_extents;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*agf_bp;
 	struct xfs_buf		*agfl_bp;
@@ -649,7 +649,7 @@ xrep_agfl(
 		return -EOPNOTSUPP;
 
 	xchk_perag_get(sc->mp, &sc->sa);
-	xfs_bitmap_init(&agfl_extents);
+	xbitmap_init(&agfl_extents);
 
 	/*
 	 * Read the AGF so that we can query the rmapbt.  We hope that there's
@@ -701,7 +701,7 @@ xrep_agfl(
 	error = xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
 err:
-	xfs_bitmap_destroy(&agfl_extents);
+	xbitmap_destroy(&agfl_extents);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 3d47d111be5a..5b07b46c89c9 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -18,14 +18,14 @@
  * This is the logical equivalent of bitmap |= mask(start, len).
  */
 int
-xfs_bitmap_set(
-	struct xfs_bitmap	*bitmap,
+xbitmap_set(
+	struct xbitmap		*bitmap,
 	uint64_t		start,
 	uint64_t		len)
 {
-	struct xfs_bitmap_range	*bmr;
+	struct xbitmap_range	*bmr;
 
-	bmr = kmem_alloc(sizeof(struct xfs_bitmap_range), KM_MAYFAIL);
+	bmr = kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
 	if (!bmr)
 		return -ENOMEM;
 
@@ -39,13 +39,13 @@ xfs_bitmap_set(
 
 /* Free everything related to this bitmap. */
 void
-xfs_bitmap_destroy(
-	struct xfs_bitmap	*bitmap)
+xbitmap_destroy(
+	struct xbitmap		*bitmap)
 {
-	struct xfs_bitmap_range	*bmr;
-	struct xfs_bitmap_range	*n;
+	struct xbitmap_range	*bmr;
+	struct xbitmap_range	*n;
 
-	for_each_xfs_bitmap_extent(bmr, n, bitmap) {
+	for_each_xbitmap_extent(bmr, n, bitmap) {
 		list_del(&bmr->list);
 		kmem_free(bmr);
 	}
@@ -53,24 +53,24 @@ xfs_bitmap_destroy(
 
 /* Set up a per-AG block bitmap. */
 void
-xfs_bitmap_init(
-	struct xfs_bitmap	*bitmap)
+xbitmap_init(
+	struct xbitmap		*bitmap)
 {
 	INIT_LIST_HEAD(&bitmap->list);
 }
 
 /* Compare two btree extents. */
 static int
-xfs_bitmap_range_cmp(
+xbitmap_range_cmp(
 	void			*priv,
 	struct list_head	*a,
 	struct list_head	*b)
 {
-	struct xfs_bitmap_range	*ap;
-	struct xfs_bitmap_range	*bp;
+	struct xbitmap_range	*ap;
+	struct xbitmap_range	*bp;
 
-	ap = container_of(a, struct xfs_bitmap_range, list);
-	bp = container_of(b, struct xfs_bitmap_range, list);
+	ap = container_of(a, struct xbitmap_range, list);
+	bp = container_of(b, struct xbitmap_range, list);
 
 	if (ap->start > bp->start)
 		return 1;
@@ -96,14 +96,14 @@ xfs_bitmap_range_cmp(
 #define LEFT_ALIGNED	(1 << 0)
 #define RIGHT_ALIGNED	(1 << 1)
 int
-xfs_bitmap_disunion(
-	struct xfs_bitmap	*bitmap,
-	struct xfs_bitmap	*sub)
+xbitmap_disunion(
+	struct xbitmap		*bitmap,
+	struct xbitmap		*sub)
 {
 	struct list_head	*lp;
-	struct xfs_bitmap_range	*br;
-	struct xfs_bitmap_range	*new_br;
-	struct xfs_bitmap_range	*sub_br;
+	struct xbitmap_range	*br;
+	struct xbitmap_range	*new_br;
+	struct xbitmap_range	*sub_br;
 	uint64_t		sub_start;
 	uint64_t		sub_len;
 	int			state;
@@ -113,8 +113,8 @@ xfs_bitmap_disunion(
 		return 0;
 	ASSERT(!list_empty(&sub->list));
 
-	list_sort(NULL, &bitmap->list, xfs_bitmap_range_cmp);
-	list_sort(NULL, &sub->list, xfs_bitmap_range_cmp);
+	list_sort(NULL, &bitmap->list, xbitmap_range_cmp);
+	list_sort(NULL, &sub->list, xbitmap_range_cmp);
 
 	/*
 	 * Now that we've sorted both lists, we iterate bitmap once, rolling
@@ -124,11 +124,11 @@ xfs_bitmap_disunion(
 	 * list traversal is similar to merge sort, but we're deleting
 	 * instead.  In this manner we avoid O(n^2) operations.
 	 */
-	sub_br = list_first_entry(&sub->list, struct xfs_bitmap_range,
+	sub_br = list_first_entry(&sub->list, struct xbitmap_range,
 			list);
 	lp = bitmap->list.next;
 	while (lp != &bitmap->list) {
-		br = list_entry(lp, struct xfs_bitmap_range, list);
+		br = list_entry(lp, struct xbitmap_range, list);
 
 		/*
 		 * Advance sub_br and/or br until we find a pair that
@@ -181,7 +181,7 @@ xfs_bitmap_disunion(
 			 * Deleting from the middle: add the new right extent
 			 * and then shrink the left extent.
 			 */
-			new_br = kmem_alloc(sizeof(struct xfs_bitmap_range),
+			new_br = kmem_alloc(sizeof(struct xbitmap_range),
 					KM_MAYFAIL);
 			if (!new_br) {
 				error = -ENOMEM;
@@ -247,8 +247,8 @@ xfs_bitmap_disunion(
  * blocks going from the leaf towards the root.
  */
 int
-xfs_bitmap_set_btcur_path(
-	struct xfs_bitmap	*bitmap,
+xbitmap_set_btcur_path(
+	struct xbitmap		*bitmap,
 	struct xfs_btree_cur	*cur)
 {
 	struct xfs_buf		*bp;
@@ -261,7 +261,7 @@ xfs_bitmap_set_btcur_path(
 		if (!bp)
 			continue;
 		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
-		error = xfs_bitmap_set(bitmap, fsb, 1);
+		error = xbitmap_set(bitmap, fsb, 1);
 		if (error)
 			return error;
 	}
@@ -271,12 +271,12 @@ xfs_bitmap_set_btcur_path(
 
 /* Collect a btree's block in the bitmap. */
 STATIC int
-xfs_bitmap_collect_btblock(
+xbitmap_collect_btblock(
 	struct xfs_btree_cur	*cur,
 	int			level,
 	void			*priv)
 {
-	struct xfs_bitmap	*bitmap = priv;
+	struct xbitmap		*bitmap = priv;
 	struct xfs_buf		*bp;
 	xfs_fsblock_t		fsbno;
 
@@ -285,14 +285,14 @@ xfs_bitmap_collect_btblock(
 		return 0;
 
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
-	return xfs_bitmap_set(bitmap, fsbno, 1);
+	return xbitmap_set(bitmap, fsbno, 1);
 }
 
 /* Walk the btree and mark the bitmap wherever a btree block is found. */
 int
-xfs_bitmap_set_btblocks(
-	struct xfs_bitmap	*bitmap,
+xbitmap_set_btblocks(
+	struct xbitmap		*bitmap,
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, bitmap);
+	return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock, bitmap);
 }
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index ae8ecbce6fa6..8db4017ac78e 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -6,31 +6,31 @@
 #ifndef __XFS_SCRUB_BITMAP_H__
 #define __XFS_SCRUB_BITMAP_H__
 
-struct xfs_bitmap_range {
+struct xbitmap_range {
 	struct list_head	list;
 	uint64_t		start;
 	uint64_t		len;
 };
 
-struct xfs_bitmap {
+struct xbitmap {
 	struct list_head	list;
 };
 
-void xfs_bitmap_init(struct xfs_bitmap *bitmap);
-void xfs_bitmap_destroy(struct xfs_bitmap *bitmap);
+void xbitmap_init(struct xbitmap *bitmap);
+void xbitmap_destroy(struct xbitmap *bitmap);
 
-#define for_each_xfs_bitmap_extent(bex, n, bitmap) \
+#define for_each_xbitmap_extent(bex, n, bitmap) \
 	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
 
-#define for_each_xfs_bitmap_block(b, bex, n, bitmap) \
+#define for_each_xbitmap_block(b, bex, n, bitmap) \
 	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list) \
-		for ((b) = bex->start; (b) < bex->start + bex->len; (b)++)
+		for ((b) = (bex)->start; (b) < (bex)->start + (bex)->len; (b)++)
 
-int xfs_bitmap_set(struct xfs_bitmap *bitmap, uint64_t start, uint64_t len);
-int xfs_bitmap_disunion(struct xfs_bitmap *bitmap, struct xfs_bitmap *sub);
-int xfs_bitmap_set_btcur_path(struct xfs_bitmap *bitmap,
+int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
+int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
+int xbitmap_set_btcur_path(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
-int xfs_bitmap_set_btblocks(struct xfs_bitmap *bitmap,
+int xbitmap_set_btblocks(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 8349694f985d..d41da4c44f10 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -600,19 +600,19 @@ xrep_reap_block(
 int
 xrep_reap_extents(
 	struct xfs_scrub		*sc,
-	struct xfs_bitmap		*bitmap,
+	struct xbitmap			*bitmap,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type)
 {
-	struct xfs_bitmap_range		*bmr;
-	struct xfs_bitmap_range		*n;
+	struct xbitmap_range		*bmr;
+	struct xbitmap_range		*n;
 	xfs_fsblock_t			fsbno;
 	unsigned int			deferred = 0;
 	int				error = 0;
 
 	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
 
-	for_each_xfs_bitmap_block(fsbno, bmr, n, bitmap) {
+	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
 		ASSERT(sc->ip != NULL ||
 		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.agno);
 		trace_xrep_dispose_btree_extent(sc->mp,
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index eab41928990f..479cfe38065e 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -28,10 +28,10 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
 
-struct xfs_bitmap;
+struct xbitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
-int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
+int xrep_reap_extents(struct xfs_scrub *sc, struct xbitmap *exlist,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 struct xrep_find_ag_btree {

