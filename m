Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55005C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F19A205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PChQ5lbu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfIYVkS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:40:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfIYVkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:40:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOJ5013229;
        Wed, 25 Sep 2019 21:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3KKIBlOJweEOUGhw1GkyivuD1QGzH1LAgCAd2ORx/G4=;
 b=PChQ5lbuJ+XE/iyPEpcvKHu3oGNWOauDrfV6xDcsrpAT4kN8kZgTnvDzFBJzDXUHlSwc
 z4NTr3Ohi8tysHJwhIpcRArDtPdX3V7167VqZp6hhL3ctayEZKckdYhba8mfUBF8MjSL
 pm59/NLAM4ENzHWhNzXIT5uO3HxxUPjwC63ImhnpaZo33W6dBtsi/6y1OXq5R2NqSfoR
 yHHWlfQWcKfeW24VQVX9iav9h7eZyGb01OgzEKC/HOkdEfFDMwwpzYPXZzI7lKRKGXb4
 QLkyMS9Sv1QyUBDCUlgD5Pe/PNQReazUQzx6ZS7fYK3dDlJ2o3eSs+otkz0UW3h6ksHq Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq7jcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOdc033675;
        Wed, 25 Sep 2019 21:40:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnyux7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLeFs3017718;
        Wed, 25 Sep 2019 21:40:15 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:40:15 -0700
Subject: [PATCH 2/7] libfrog: convert bitmap.c to negative error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:40:14 -0700
Message-ID: <156944761397.302827.17622064656927525540.stgit@magnolia>
In-Reply-To: <156944760161.302827.4342305147521200999.stgit@magnolia>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |   29 ++++++++++++++++-------------
 repair/rmap.c    |    4 ++--
 scrub/phase6.c   |   12 ++++++------
 3 files changed, 24 insertions(+), 21 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 5daa1081..3b4c603c 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -76,14 +76,14 @@ bitmap_alloc(
 
 	bmap = calloc(1, sizeof(struct bitmap));
 	if (!bmap)
-		return errno;
+		return -errno;
 	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
 	if (!bmap->bt_tree) {
-		ret = errno;
+		ret = -errno;
 		goto out;
 	}
 
-	ret = pthread_mutex_init(&bmap->bt_lock, NULL);
+	ret = -pthread_mutex_init(&bmap->bt_lock, NULL);
 	if (ret)
 		goto out_tree;
 
@@ -149,12 +149,12 @@ __bitmap_insert(
 
 	ext = bitmap_node_init(start, length);
 	if (!ext)
-		return errno;
+		return -errno;
 
 	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
 	if (node == NULL) {
 		free(ext);
-		return EEXIST;
+		return -EEXIST;
 	}
 
 	return 0;
@@ -235,7 +235,7 @@ bitmap_set(
 
 #if 0	/* Unused, provided for completeness. */
 /* Clear a region of bits. */
-bool
+int
 bitmap_clear(
 	struct bitmap		*bmap,
 	uint64_t		start,
@@ -259,7 +259,7 @@ bitmap_clear(
 	/* Nothing, we're done. */
 	if (firstn == NULL && lastn == NULL) {
 		pthread_mutex_unlock(&bmap->bt_lock);
-		return true;
+		return 0;
 	}
 
 	assert(firstn != NULL && lastn != NULL);
@@ -297,20 +297,23 @@ bitmap_clear(
 					new_start;
 
 			ext = bitmap_node_init(new_start, new_length);
-			if (!ext)
-				return false;
+			if (!ext) {
+				ret = -errno;
+				goto out;
+			}
 
 			node = avl64_insert(bmap->bt_tree, &ext->btn_node);
 			if (node == NULL) {
-				errno = EEXIST;
-				return false;
+				ret = -EEXIST;
+				goto out;
 			}
 			break;
 		}
 	}
 
+out:
 	pthread_mutex_unlock(&bmap->bt_lock);
-	return true;
+	return ret;
 }
 #endif
 
@@ -323,7 +326,7 @@ bitmap_iterate(
 {
 	struct avl64node	*node;
 	struct bitmap_node	*ext;
-	int			ret;
+	int			ret = 0;
 
 	pthread_mutex_lock(&bmap->bt_lock);
 	avl_for_each(bmap->bt_tree, node) {
diff --git a/repair/rmap.c b/repair/rmap.c
index c6ed25a9..c4c99131 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -490,13 +490,13 @@ rmap_store_ag_btree_rec(
 	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
 	if (error)
 		goto err;
-	error = bitmap_alloc(&own_ag_bitmap);
+	error = -bitmap_alloc(&own_ag_bitmap);
 	if (error)
 		goto err_slab;
 	while ((rm_rec = pop_slab_cursor(rm_cur)) != NULL) {
 		if (rm_rec->rm_owner != XFS_RMAP_OWN_AG)
 			continue;
-		error = bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
+		error = -bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
 					rm_rec->rm_blockcount);
 		if (error) {
 			/*
diff --git a/scrub/phase6.c b/scrub/phase6.c
index f0977d6a..bbe0d7d4 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -174,7 +174,7 @@ report_data_loss(
 	else
 		bmp = vs->d_bad;
 
-	return bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
+	return -bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
 			report_badfile, br);
 }
 
@@ -444,7 +444,7 @@ remember_ioerr(
 	if (!tree)
 		return;
 
-	ret = bitmap_set(tree, start, length);
+	ret = -bitmap_set(tree, start, length);
 	if (ret)
 		str_liberror(ctx, ret, _("setting bad block bitmap"));
 }
@@ -476,7 +476,7 @@ walk_ioerr(
 	(keys + 1)->fmr_owner = ULLONG_MAX;
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
-	return scrub_iterate_fsmap(wioerr->ctx, keys, ioerr_fsmap_report,
+	return -scrub_iterate_fsmap(wioerr->ctx, keys, ioerr_fsmap_report,
 			&start);
 }
 
@@ -498,7 +498,7 @@ walk_ioerrs(
 	tree = bitmap_for_disk(ctx, disk, vs);
 	if (!tree)
 		return 0;
-	return bitmap_iterate(tree, walk_ioerr, &wioerr);
+	return -bitmap_iterate(tree, walk_ioerr, &wioerr);
 }
 
 /* Given bad extent lists for the data & rtdev, find bad files. */
@@ -666,13 +666,13 @@ phase6_func(
 	struct media_verify_state	vs = { NULL };
 	int				ret, ret2, ret3;
 
-	ret = bitmap_alloc(&vs.d_bad);
+	ret = -bitmap_alloc(&vs.d_bad);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev badblock bitmap"));
 		return ret;
 	}
 
-	ret = bitmap_alloc(&vs.r_bad);
+	ret = -bitmap_alloc(&vs.r_bad);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating realtime badblock bitmap"));
 		goto out_dbad;

