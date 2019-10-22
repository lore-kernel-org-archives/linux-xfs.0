Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241B6CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E077F20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ioQT0I18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbfJVSr2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44178 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiAnF109487;
        Tue, 22 Oct 2019 18:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xwwNIy7KKSsm21Uqwo2Te+gHfWT+BdBfVKbRI/jIv4Q=;
 b=ioQT0I18OiS4p0ZtM2wBAV8XgIcihIYbbLuPcAuiewjOUutijYmFBElnUAcUuQ3GsU+T
 R/lNH8PP5J61zeAAX7qw8VFX6iOPQvTiah9ivnr9/7FtdKehZfbHT/NAe8nB5jiT/cTf
 5ZWoqNVw1kZmQxfNvzgBsEuO7JN5XQwFDSho8ih7RdMWSJbj9JfD5RZjMAkQux6Xjzdp
 0d2DkZA+i4ZQj0pmCjJK3uSElG4u6Zd4ciLf1Ktb5fLGACo/cFL8kHVLIjmsCKWQpQod
 2DbWhVYzLm6wR2iRHfxP9w4eccpwGy51BKRPO1Z0TfkQ0pLI5E9URIJrcdGMahdNNUrT WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtgup7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhO01125252;
        Tue, 22 Oct 2019 18:47:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vsx239p57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:25 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIlOUo002600;
        Tue, 22 Oct 2019 18:47:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:47:24 +0000
Subject: [PATCH 3/9] xfs_scrub: improve reporting of file data media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:23 -0700
Message-ID: <157177004356.1459098.4142160848040771793.stgit@magnolia>
In-Reply-To: <157177002473.1459098.11320398367215468164.stgit@magnolia>
References: <157177002473.1459098.11320398367215468164.stgit@magnolia>
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

When we report media errors, we should tell the administrator the file
offset and length of the bad region, not just the offset of the entire
file extent record that overlaps a bad region.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |   37 +++++++++++++++++++++++++++++++++++++
 libfrog/bitmap.h |    2 ++
 scrub/phase6.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 86 insertions(+), 5 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index a75d085a..6a88ef48 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -339,6 +339,43 @@ bitmap_iterate(
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
+	int			ret = 0;
+
+	pthread_mutex_lock(&bmap->bt_lock);
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
diff --git a/libfrog/bitmap.h b/libfrog/bitmap.h
index 759386a8..043b77ee 100644
--- a/libfrog/bitmap.h
+++ b/libfrog/bitmap.h
@@ -16,6 +16,8 @@ void bitmap_free(struct bitmap **bmap);
 int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
 int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
 		void *arg);
+int bitmap_iterate_range(struct bitmap *bmap, uint64_t start, uint64_t length,
+		int (*fn)(uint64_t, uint64_t, void *), void *arg);
 bool bitmap_test(struct bitmap *bmap, uint64_t start,
 		uint64_t len);
 bool bitmap_empty(struct bitmap *bmap);
diff --git a/scrub/phase6.c b/scrub/phase6.c
index f2a78a60..5aeef1cb 100644
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
 

