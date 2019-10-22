Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F85CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A49D220B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n+cW0oAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbfJVSws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50302 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387746AbfJVSws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiW1Y109673;
        Tue, 22 Oct 2019 18:52:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kK3KlIzG6XhcEjzJoBm9bvC3Tl9hB5zzV79vdZNHE+Y=;
 b=n+cW0oAioQn4GdUihRyjxBu36G9gMOTf3zC+frgeOhwrO6P+yuqI2bZXktq5yPVwlb7O
 Fzvi39QsvDZgFi/hTUvgB6Hv3GWc2c9K7xgKwAhkwD3UR6xuMso4OOeqzptX6G6AWPJY
 +Ymv7iNrybFuCU1GtnTWF7Xr+Li9u2pzA9Dxze7omPJv0E8SklX14jTI9YYGWGeQxg5F
 0y8/8AuNxQnCh+in9DpwGoFsL19AeYHQaJekLumjI3e0PjAVctS/yte3mAC2Ozwa1Vka
 Wi1f2wDh+G6fRT9xnmP4roearTjBASdokcnDFEJce8dYaPNrDFlYg7xEmO/t13OOyWgk +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtgvm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhn8n148246;
        Tue, 22 Oct 2019 18:52:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vsp4019ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:42 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIqd8o028788;
        Tue, 22 Oct 2019 18:52:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:39 -0700
Subject: [PATCH 2/7] libfrog: convert bitmap.c to negative error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Tue, 22 Oct 2019 11:52:38 -0700
Message-ID: <157177035867.1462916.1273692110117857304.stgit@magnolia>
In-Reply-To: <157177034582.1462916.12588287391821422188.stgit@magnolia>
References: <157177034582.1462916.12588287391821422188.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/bitmap.c |   27 +++++++++++++++------------
 repair/rmap.c    |    4 ++--
 scrub/phase6.c   |   12 ++++++------
 3 files changed, 23 insertions(+), 20 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index c928d26f..5af5ab8d 100644
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
index 6dbadcee..6e959069 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -195,7 +195,7 @@ report_data_loss(
 	else
 		bmp = vs->d_bad;
 
-	return bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
+	return -bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
 			report_badfile, br);
 }
 
@@ -446,7 +446,7 @@ report_ioerr(
 	(keys + 1)->fmr_owner = ULLONG_MAX;
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
-	return scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
+	return -scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
 			&start);
 }
 
@@ -468,7 +468,7 @@ report_disk_ioerrs(
 	tree = bitmap_for_disk(ctx, disk, vs);
 	if (!tree)
 		return 0;
-	return bitmap_iterate(tree, report_ioerr, &dioerr);
+	return -bitmap_iterate(tree, report_ioerr, &dioerr);
 }
 
 /* Given bad extent lists for the data & rtdev, find bad files. */
@@ -598,7 +598,7 @@ remember_ioerr(
 		return;
 	}
 
-	ret = bitmap_set(tree, start, length);
+	ret = -bitmap_set(tree, start, length);
 	if (ret)
 		str_liberror(ctx, ret, _("setting bad block bitmap"));
 }
@@ -661,13 +661,13 @@ phase6_func(
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

