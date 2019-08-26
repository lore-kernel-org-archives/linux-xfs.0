Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFB2C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBCBF21881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sDsWW1Hi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfHZVbY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfHZVbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFVKn162597;
        Mon, 26 Aug 2019 21:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pgrCmq58otpGd+7MOsmlsJJykbpRO7it8vejwWHVim4=;
 b=sDsWW1HiHoIREzyjcukASvEfM1Vm9mOWX/owM5EhPeT2mI3k7+PFyhpOshIGRt2Ghw5+
 yjhabyiy7koYpzNln4Ga9WYJrfGG0D6AehcIBHURCKqGJz3HC7j6uJCubMU2mEvUoES6
 VFFlYmeNZyfZKnoXqW1+m4s3rMSPgyCSYQmWOnz89mo+75eheFd0id8BhP0s2fFgXyDj
 G1TkujOuAFJjwSzkXzv2K3BssqiZUE/4YkLySGNH7RAGZwBjZA3JmbFM7PoVxlDWbU5K
 iNNVVUlZPOg2Ah/Rk/FsA4tvKKCsfp6h05exfQzJ408qTMlds0SMTYUtkmcoq72w/iPX 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t82bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIs5J184963;
        Mon, 26 Aug 2019 21:31:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvymt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVJSj030032;
        Mon, 26 Aug 2019 21:31:20 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:19 -0700
Subject: [PATCH 02/11] xfs_scrub: improve reporting of file data media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:18 -0700
Message-ID: <156685507865.2843133.13819584101266401531.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
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

When we report media errors, we should tell the administrator the file
offset and length of the bad region, not just the offset of the entire
file extent record that overlaps a bad region.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/bitmap.h |    2 ++
 libfrog/bitmap.c |   39 +++++++++++++++++++++++++++++++++++++++
 scrub/phase6.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 88 insertions(+), 5 deletions(-)


diff --git a/include/bitmap.h b/include/bitmap.h
index 13154975..4dfb2412 100644
--- a/include/bitmap.h
+++ b/include/bitmap.h
@@ -16,6 +16,8 @@ void bitmap_free(struct bitmap **bmap);
 int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
 int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
 		void *arg);
+int bitmap_iterate_range(struct bitmap *bmap, uint64_t start, uint64_t length,
+		int (*fn)(uint64_t, uint64_t, void *), void *arg);
 bool bitmap_test(struct bitmap *bmap, uint64_t start,
 		uint64_t len);
 bool bitmap_empty(struct bitmap *bmap);
diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 82ac8210..cc5d99f1 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -342,6 +342,45 @@ bitmap_iterate(
 }
 #endif
 
+/* Iterate the set regions of part of this bitmap. */
+int
+bitmap_iterate_range(
+	struct bitmap		*bmap,
+	uint64_t		start,
+	uint64_t		length,
+	int			(*fn)(uint64_t, uint64_t, void *),
+	void			*arg)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+	struct avl64node	*pos;
+	struct avl64node	*n;
+	struct avl64node	*l;
+	struct bitmap_node	*ext;
+	int			ret;
+
+	ret = pthread_mutex_lock(&bmap->bt_lock);
+	if (ret)
+		return ret;
+
+	avl64_findranges(bmap->bt_tree, start, start + length, &firstn,
+			&lastn);
+
+	if (firstn == NULL && lastn == NULL)
+		goto out;
+
+	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
+		ext = container_of(pos, struct bitmap_node, btn_node);
+		ret = fn(ext->btn_start, ext->btn_length, arg);
+		if (ret)
+			break;
+	}
+
+out:
+	pthread_mutex_unlock(&bmap->bt_lock);
+	return ret;
+}
+
 /* Do any bitmap extents overlap the given one?  (locked) */
 static bool
 __bitmap_test(
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 60355bb8..e78c8463 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -111,6 +111,41 @@ xfs_decode_special_owner(
 
 /* Routines to translate bad physical extents into file paths and offsets. */
 
+struct badfile_report {
+	struct scrub_ctx	*ctx;
+	const char		*descr;
+	struct xfs_bmap		*bmap;
+};
+
+/* Report on bad extents found during a media scan. */
+static int
+report_badfile(
+	uint64_t		start,
+	uint64_t		length,
+	void			*arg)
+{
+	struct badfile_report	*br = arg;
+	unsigned long long	bad_offset;
+	unsigned long long	bad_length;
+
+	/* Clamp the bad region to the file mapping. */
+	if (start < br->bmap->bm_physical) {
+		length -= br->bmap->bm_physical - start;
+		start = br->bmap->bm_physical;
+	}
+	length = min(length, br->bmap->bm_length);
+
+	/* Figure out how far into the bmap is the bad mapping and report it. */
+	bad_offset = start - br->bmap->bm_physical;
+	bad_length = min(start + length,
+			 br->bmap->bm_physical + br->bmap->bm_length) - start;
+
+	str_error(br->ctx, br->descr,
+_("media error at data offset %llu length %llu."),
+			br->bmap->bm_offset + bad_offset, bad_length);
+	return 0;
+}
+
 /* Report if this extent overlaps a bad region. */
 static bool
 report_data_loss(
@@ -122,8 +157,14 @@ report_data_loss(
 	struct xfs_bmap			*bmap,
 	void				*arg)
 {
+	struct badfile_report		br = {
+		.ctx			= ctx,
+		.descr			= descr,
+		.bmap			= bmap,
+	};
 	struct media_verify_state	*vs = arg;
 	struct bitmap			*bmp;
+	int				ret;
 
 	/* Only report errors for real extents. */
 	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
@@ -134,11 +175,12 @@ report_data_loss(
 	else
 		bmp = vs->d_bad;
 
-	if (!bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
-		return true;
-
-	str_error(ctx, descr,
-_("offset %llu failed read verification."), bmap->bm_offset);
+	ret = bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
+			report_badfile, &br);
+	if (ret) {
+		str_liberror(ctx, ret, descr);
+		return false;
+	}
 	return true;
 }
 

