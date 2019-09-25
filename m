Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5F9C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8004121D82
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="caj1MZNR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfIYVed (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43068 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVed (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYO9g009867;
        Wed, 25 Sep 2019 21:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vTkD6KUcn379TJhBo2oB/mdzlgqlW1twLv63kEVw69Y=;
 b=caj1MZNRz+NPUKsfQeHcmlEhgORGhjc6K7PCOwPhiEWpYQ01riZuQmrL18VtuZlfSQxk
 cotA7wpDuSgwI3uzz/R5h3U6EpjGNZrQ6sgs6HrrV8bFZZCc7pXUXM6cP64/L2pA9n8T
 Gpc1okn3hO8td/CPiI4wY67OZZLhNtQ0bhAhDGl8z7QxyXlynwRVZYaVZdgXfXgA++yJ
 IfmCoPKXNL0Vxuh0jErym4VVrOmxxqhRSbqb8VE6ZqKaI/4C3h64/QycY4reGXf0psOS
 d7Zj7NyYb57LRnk80g11xj3p8DvFQ06AZgOTWOetEe/Y/FHA96EFtzhRKzjvq4EcUjlT 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYSaq078796;
        Wed, 25 Sep 2019 21:34:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v82tkreuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:28 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLY7Bf019805;
        Wed, 25 Sep 2019 21:34:07 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:07 -0700
Subject: [PATCH 07/13] libfrog: fix bitmap error communication problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:05 -0700
Message-ID: <156944724578.297677.11793519151262574472.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert all the libfrog code and callers away from the libc-style
indirect errno returns to directly returning error codes to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |   13 +++++++------
 libfrog/bitmap.h |    2 +-
 repair/rmap.c    |    4 ++--
 scrub/phase6.c   |   20 +++++++++++---------
 4 files changed, 21 insertions(+), 18 deletions(-)


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
diff --git a/libfrog/bitmap.h b/libfrog/bitmap.h
index 40119b9c..759386a8 100644
--- a/libfrog/bitmap.h
+++ b/libfrog/bitmap.h
@@ -11,7 +11,7 @@ struct bitmap {
 	struct avl64tree_desc	*bt_tree;
 };
 
-int bitmap_init(struct bitmap **bmap);
+int bitmap_alloc(struct bitmap **bmap);
 void bitmap_free(struct bitmap **bmap);
 int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
 int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
diff --git a/repair/rmap.c b/repair/rmap.c
index b907383e..c6ed25a9 100644
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
index aff04e76..d9285fee 100644
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
 

