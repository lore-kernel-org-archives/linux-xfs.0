Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3D8C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8093217F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITJXdx4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbfKFVBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:01:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfKFVBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 16:01:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KxDR3175908;
        Wed, 6 Nov 2019 21:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=z9B2L4zWHnXA49cTONyzQnT1zi413+7nN8uWnwXWhmE=;
 b=ITJXdx4rBMoVBDE2xHNNLW4GFagSJPOshO9b8+NF1yoM0t33o2xlIzKOzbDjWV4kkGbv
 i9LksLWiUWVlfGNXZa6QO9/LaFsGWJHVx/BXn8orSjVyCANYu+ForbqSa3mhpJkHAZOU
 /T3U3WX76MwxkWWcn31Rx9L6bmlZsQMRvxsnLF+t0xBj76KiyP77k8b3Rfb1etlMkH9C
 OLSVjz9Fyd9MrlcEC4/dU92cjsVKoLhG/cYgfemyODzFFITqbH5oyBINQN54zBM8d03k
 w5xpc2Dr1/sRqJRNriI0qkdVIfVsPNr+X7rceuPF/OywdACpiycM3AVyrbzywV8PjtXW Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w11pgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:01:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KwB3Y136952;
        Wed, 6 Nov 2019 21:01:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w41w80kyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:01:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6L1Ut9001762;
        Wed, 6 Nov 2019 21:01:30 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 13:01:29 -0800
Date:   Wed, 6 Nov 2019 13:01:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/18] xfs_scrub: remove moveon from filemap iteration
Message-ID: <20191106210129.GP4153244@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
 <157177022734.1461658.2788133461833707223.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157177022734.1461658.2788133461833707223.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the moveon and descr clutter from filemap iteration in favor of
returning errors directly and passing error domain descriptions around
through the existing void *arg.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: rebase without full-disk media scan
---
 scrub/filemap.c |   73 +++++++++++++++++---------------------------------
 scrub/filemap.h |   16 +++++------
 scrub/phase6.c  |   80 +++++++++++++++++++++++++++++--------------------------
 3 files changed, 74 insertions(+), 95 deletions(-)

diff --git a/scrub/filemap.c b/scrub/filemap.c
index f92e9620..bad2e9e1 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -23,47 +23,31 @@
 
 #define BMAP_NR		2048
 
-/* Iterate all the extent block mappings between the key and fork end. */
-bool
-xfs_iterate_filemaps(
+/*
+ * Iterate all the extent block mappings between the key and fork end.
+ * Returns 0 or a positive error number.
+ */
+int
+scrub_iterate_filemaps(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	int			fd,
 	int			whichfork,
-	struct xfs_bmap		*key,
-	xfs_bmap_iter_fn	fn,
+	struct file_bmap	*key,
+	scrub_bmap_iter_fn	fn,
 	void			*arg)
 {
 	struct fsxattr		fsx;
 	struct getbmapx		*map;
 	struct getbmapx		*p;
-	struct xfs_bmap		bmap;
-	char			bmap_descr[DESCR_BUFSZ];
-	bool			moveon = true;
+	struct file_bmap	bmap;
 	xfs_off_t		new_off;
 	int			getxattr_type;
 	int			i;
-	int			error;
-
-	switch (whichfork) {
-	case XFS_ATTR_FORK:
-		snprintf(bmap_descr, DESCR_BUFSZ, _("%s attr"), descr);
-		break;
-	case XFS_COW_FORK:
-		snprintf(bmap_descr, DESCR_BUFSZ, _("%s CoW"), descr);
-		break;
-	case XFS_DATA_FORK:
-		snprintf(bmap_descr, DESCR_BUFSZ, _("%s data"), descr);
-		break;
-	default:
-		abort();
-	}
+	int			ret;
 
 	map = calloc(BMAP_NR, sizeof(struct getbmapx));
-	if (!map) {
-		str_errno(ctx, bmap_descr);
-		return false;
-	}
+	if (!map)
+		return errno;
 
 	map->bmv_offset = BTOBB(key->bm_offset);
 	map->bmv_block = BTOBB(key->bm_physical);
@@ -89,34 +73,28 @@ xfs_iterate_filemaps(
 		abort();
 	}
 
-	error = ioctl(fd, getxattr_type, &fsx);
-	if (error < 0) {
-		str_errno(ctx, bmap_descr);
-		moveon = false;
+	ret = ioctl(fd, getxattr_type, &fsx);
+	if (ret < 0) {
+		ret = errno;
 		goto out;
 	}
 
-	if (fsx.fsx_nextents == 0) {
-		moveon = true;
+	if (fsx.fsx_nextents == 0)
 		goto out;
-	}
 
 	map->bmv_count = min(fsx.fsx_nextents + 1, BMAP_NR);
 
-	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
+	while ((ret = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
 		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
 			bmap.bm_offset = BBTOB(p->bmv_offset);
 			bmap.bm_physical = BBTOB(p->bmv_block);
 			bmap.bm_length = BBTOB(p->bmv_length);
 			bmap.bm_flags = p->bmv_oflags;
-			moveon = fn(ctx, bmap_descr, fd, whichfork, &fsx,
-					&bmap, arg);
-			if (!moveon)
+			ret = fn(ctx, fd, whichfork, &fsx, &bmap, arg);
+			if (ret)
 				goto out;
-			if (xfs_scrub_excessive_errors(ctx)) {
-				moveon = false;
+			if (xfs_scrub_excessive_errors(ctx))
 				goto out;
-			}
 		}
 
 		if (map->bmv_entries == 0)
@@ -129,17 +107,16 @@ xfs_iterate_filemaps(
 		map->bmv_length -= new_off - map->bmv_offset;
 		map->bmv_offset = new_off;
 	}
+	if (ret < 0)
+		ret = errno;
 
 	/*
 	 * Pre-reflink filesystems don't know about CoW forks, so don't
 	 * be too surprised if it fails.
 	 */
-	if (whichfork == XFS_COW_FORK && error && errno == EINVAL)
-		error = 0;
-
-	if (error)
-		str_errno(ctx, bmap_descr);
+	if (whichfork == XFS_COW_FORK && ret == EINVAL)
+		ret = 0;
 out:
 	free(map);
-	return moveon;
+	return ret;
 }
diff --git a/scrub/filemap.h b/scrub/filemap.h
index 219be575..133e860b 100644
--- a/scrub/filemap.h
+++ b/scrub/filemap.h
@@ -7,7 +7,7 @@
 #define XFS_SCRUB_FILEMAP_H_
 
 /* inode fork block mapping */
-struct xfs_bmap {
+struct file_bmap {
 	uint64_t	bm_offset;	/* file offset of segment in bytes */
 	uint64_t	bm_physical;	/* physical starting byte  */
 	uint64_t	bm_length;	/* length of segment, bytes */
@@ -15,15 +15,13 @@ struct xfs_bmap {
 };
 
 /*
- * Visit each inode fork mapping.  Return true to continue iteration or false
- * to stop iterating and return to the caller.
+ * Visit each inode fork mapping.  Return 0 to continue iteration or a positive
+ * error code to stop iterating and return to the caller.
  */
-typedef bool (*xfs_bmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
-		int fd, int whichfork, struct fsxattr *fsx,
-		struct xfs_bmap *bmap, void *arg);
+typedef int (*scrub_bmap_iter_fn)(struct scrub_ctx *ctx, int fd, int whichfork,
+		struct fsxattr *fsx, struct file_bmap *bmap, void *arg);
 
-bool xfs_iterate_filemaps(struct scrub_ctx *ctx, const char *descr, int fd,
-		int whichfork, struct xfs_bmap *key, xfs_bmap_iter_fn fn,
-		void *arg);
+int scrub_iterate_filemaps(struct scrub_ctx *ctx, int fd, int whichfork,
+		struct file_bmap *key, scrub_bmap_iter_fn fn, void *arg);
 
 #endif /* XFS_SCRUB_FILEMAP_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index aae6b7d8..f57ce339 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -133,9 +133,10 @@ xfs_decode_special_owner(
 /* Routines to translate bad physical extents into file paths and offsets. */
 
 struct badfile_report {
-	struct scrub_ctx	*ctx;
-	const char		*descr;
-	struct xfs_bmap		*bmap;
+	struct scrub_ctx		*ctx;
+	const char			*descr;
+	struct media_verify_state	*vs;
+	struct file_bmap		*bmap;
 };
 
 /* Report on bad extents found during a media scan. */
@@ -168,75 +169,66 @@ _("media error at data offset %llu length %llu."),
 }
 
 /* Report if this extent overlaps a bad region. */
-static bool
+static int
 report_data_loss(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
 	int				fd,
 	int				whichfork,
 	struct fsxattr			*fsx,
-	struct xfs_bmap			*bmap,
+	struct file_bmap		*bmap,
 	void				*arg)
 {
-	struct badfile_report		br = {
-		.ctx			= ctx,
-		.descr			= descr,
-		.bmap			= bmap,
-	};
-	struct media_verify_state	*vs = arg;
+	struct badfile_report		*br = arg;
+	struct media_verify_state	*vs = br->vs;
 	struct bitmap			*bmp;
-	int				ret;
+
+	br->bmap = bmap;
 
 	/* Only report errors for real extents. */
 	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
-		return true;
+		return 0;
 
 	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
 		bmp = vs->r_bad;
 	else
 		bmp = vs->d_bad;
 
-	ret = bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
-			report_badfile, &br);
-	if (ret) {
-		str_liberror(ctx, ret, descr);
-		return false;
-	}
-	return true;
+	return bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
+			report_badfile, br);
 }
 
 /* Report if the extended attribute data overlaps a bad region. */
-static bool
+static int
 report_attr_loss(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
 	int				fd,
 	int				whichfork,
 	struct fsxattr			*fsx,
-	struct xfs_bmap			*bmap,
+	struct file_bmap		*bmap,
 	void				*arg)
 {
-	struct media_verify_state	*vs = arg;
+	struct badfile_report		*br = arg;
+	struct media_verify_state	*vs = br->vs;
 	struct bitmap			*bmp = vs->d_bad;
 
 	/* Complain about attr fork extents that don't look right. */
 	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC)) {
-		str_info(ctx, descr,
+		str_info(ctx, br->descr,
 _("found unexpected unwritten/delalloc attr fork extent."));
-		return true;
+		return 0;
 	}
 
 	if (fsx->fsx_xflags & FS_XFLAG_REALTIME) {
-		str_info(ctx, descr,
+		str_info(ctx, br->descr,
 _("found unexpected realtime attr fork extent."));
-		return true;
+		return 0;
 	}
 
 	if (bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
-		str_corrupt(ctx, descr,
+		str_corrupt(ctx, br->descr,
 _("media error in extended attribute data."));
 
-	return true;
+	return 0;
 }
 
 /* Iterate the extent mappings of a file to report errors. */
@@ -247,18 +239,30 @@ xfs_report_verify_fd(
 	int				fd,
 	void				*arg)
 {
-	struct xfs_bmap			key = {0};
-	bool				moveon;
+	struct badfile_report		br = {
+		.ctx			= ctx,
+		.vs			= arg,
+		.descr			= descr,
+	};
+	struct file_bmap		key = {0};
+	int				ret;
 
 	/* data fork */
-	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_DATA_FORK, &key,
-			report_data_loss, arg);
-	if (!moveon)
+	ret = scrub_iterate_filemaps(ctx, fd, XFS_DATA_FORK, &key,
+			report_data_loss, &br);
+	if (ret) {
+		str_liberror(ctx, ret, descr);
 		return false;
+	}
 
 	/* attr fork */
-	return xfs_iterate_filemaps(ctx, descr, fd, XFS_ATTR_FORK, &key,
-			report_attr_loss, arg);
+	ret = scrub_iterate_filemaps(ctx, fd, XFS_ATTR_FORK, &key,
+			report_attr_loss, &br);
+	if (ret) {
+		str_liberror(ctx, ret, descr);
+		return false;
+	}
+	return true;
 }
 
 /* Report read verify errors in unlinked (but still open) files. */
