Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE912C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCFE21872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N+oaSsbq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfHZV3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLF2vi162106;
        Mon, 26 Aug 2019 21:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aRKcuZKWJbseS3ccJApkH8+U7BGshPuCCbBnI0QcBG4=;
 b=N+oaSsbqrrmN8xcyW+R0pLzWELsP0aa2Z5MurpHSW8fDCfFvUglcZ8Wb1CtWEDHkspym
 AR8026H5j2mozbavsekSqkbF2v7uI2hrfiMifApbGF0cmp9eX1unKK+EVa5V2CSc4Qfz
 5ewkWkKNZx/3Offi49D4rj9SdyEDqVnkbKWY2BDM29KupFDGa8I9yor+otvoGAX4q/Le
 572r8qnYG0SQSL4if0r9l1DB7xoQsA3O4wTGrm9x8FFd5KsIuLkambxZW8/jKXI98zQ+
 niTaQbUqrjkdsrhcw/DLNpn7cUuCv7JgWT9osTbV8U6Nvq6hfE/SMru3xEhFF1ODu8a6 GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2umq5t822n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcj1169601;
        Mon, 26 Aug 2019 21:29:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2umhu7wyh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:04 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLT3cd028542;
        Mon, 26 Aug 2019 21:29:03 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:02 -0700
Subject: [PATCH 07/13] libfrog: fix bitmap error communication problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:01 -0700
Message-ID: <156685494177.2841546.14924730951051368538.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert all the libfrog code and callers away from the libc-style
indirect errno returns to directly returning error codes to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/bitmap.h |    2 +-
 libfrog/bitmap.c |   13 +++++++------
 repair/rmap.c    |    4 ++--
 scrub/phase6.c   |   20 +++++++++++---------
 4 files changed, 21 insertions(+), 18 deletions(-)


diff --git a/include/bitmap.h b/include/bitmap.h
index 99a2fb23..13154975 100644
--- a/include/bitmap.h
+++ b/include/bitmap.h
@@ -11,7 +11,7 @@ struct bitmap {
 	struct avl64tree_desc	*bt_tree;
 };
 
-int bitmap_init(struct bitmap **bmap);
+int bitmap_alloc(struct bitmap **bmap);
 void bitmap_free(struct bitmap **bmap);
 int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
 int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 4dafc4c9..be95965f 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -23,7 +23,8 @@
  */
 
 #define avl_for_each_range_safe(pos, n, l, first, last) \
-	for (pos = (first), n = pos->avl_nextino, l = (last)->avl_nextino; pos != (l); \
+	for (pos = (first), n = pos->avl_nextino, l = (last)->avl_nextino; \
+			pos != (l); \
 			pos = n, n = pos ? pos->avl_nextino : NULL)
 
 #define avl_for_each_safe(tree, pos, n) \
@@ -67,18 +68,18 @@ static struct avl64ops bitmap_ops = {
 
 /* Initialize a bitmap. */
 int
-bitmap_init(
+bitmap_alloc(
 	struct bitmap		**bmapp)
 {
 	struct bitmap		*bmap;
 
 	bmap = calloc(1, sizeof(struct bitmap));
 	if (!bmap)
-		return -ENOMEM;
+		return errno;
 	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
 	if (!bmap->bt_tree) {
 		free(bmap);
-		return -ENOMEM;
+		return errno;
 	}
 
 	pthread_mutex_init(&bmap->bt_lock, NULL);
@@ -139,12 +140,12 @@ __bitmap_insert(
 
 	ext = bitmap_node_init(start, length);
 	if (!ext)
-		return -ENOMEM;
+		return errno;
 
 	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
 	if (node == NULL) {
 		free(ext);
-		return -EEXIST;
+		return EEXIST;
 	}
 
 	return 0;
diff --git a/repair/rmap.c b/repair/rmap.c
index 24251e9f..165c70c4 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -490,13 +490,13 @@ rmap_store_ag_btree_rec(
 	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
 	if (error)
 		goto err;
-	error = -bitmap_init(&own_ag_bitmap);
+	error = bitmap_alloc(&own_ag_bitmap);
 	if (error)
 		goto err_slab;
 	while ((rm_rec = pop_slab_cursor(rm_cur)) != NULL) {
 		if (rm_rec->rm_owner != XFS_RMAP_OWN_AG)
 			continue;
-		error = -bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
+		error = bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
 					rm_rec->rm_blockcount);
 		if (error) {
 			/*
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 3f80bca5..35dda1f9 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -341,6 +341,7 @@ xfs_check_rmap_ioerr(
 	struct media_verify_state	*vs = arg;
 	struct bitmap			*tree;
 	dev_t				dev;
+	int				ret;
 
 	dev = xfs_disk_to_dev(ctx, disk);
 
@@ -355,9 +356,9 @@ xfs_check_rmap_ioerr(
 	else
 		tree = NULL;
 	if (tree) {
-		errno = -bitmap_set(tree, start, length);
-		if (errno)
-			str_errno(ctx, ctx->mntpoint);
+		ret = bitmap_set(tree, start, length);
+		if (ret)
+			str_liberror(ctx, ret, _("setting bad block bitmap"));
 	}
 
 	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
@@ -454,16 +455,17 @@ xfs_scan_blocks(
 {
 	struct media_verify_state	vs = { NULL };
 	bool				moveon = false;
+	int				ret;
 
-	errno = -bitmap_init(&vs.d_bad);
-	if (errno) {
-		str_errno(ctx, ctx->mntpoint);
+	ret = bitmap_alloc(&vs.d_bad);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating datadev badblock bitmap"));
 		goto out;
 	}
 
-	errno = -bitmap_init(&vs.r_bad);
-	if (errno) {
-		str_errno(ctx, ctx->mntpoint);
+	ret = bitmap_alloc(&vs.r_bad);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating realtime badblock bitmap"));
 		goto out_dbad;
 	}
 

