Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120BFC00306
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A25A206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VFMNq8bF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404421AbfIFDen (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:34:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392134AbfIFDen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:34:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YfuS110279;
        Fri, 6 Sep 2019 03:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=t/xoy+e+BlDcuXsCV3x8SN3FNV7jnPSIQkXURxbGowM=;
 b=VFMNq8bF0puxBFrCSGRjXREM8pp3hXfzfNLK+zeKXSpyM2OvQqmY0EA3eWxQRcahTQQ8
 yHU7VjRDEgt0zRem1ptEzUG6KkenIvapXffmoL1ZEnmK8wDRVtfkJrbI1RFqnuHSfpg8
 0vEfgflHNa+s2W/0hJ52huLKqG6u0pzfrvLsHoMGvwHrf2Tj2W3RINg/aOmtcHVK/2Ab
 xQDC3xaJfS5oJIFHNSyj46ERRLwnbjQZfFuuHBW/hovYsoj/naVGpVLdT9Qlkq2Ojno2
 gbiQvsH0LRGLehX9uGZTcwZyI1TjbJa3Grxa+HHSKnCnl8v/TxNR/ieVk1HjkYGKbZOq DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uuf4n035f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YXtw104082;
        Fri, 6 Sep 2019 03:34:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7p2p9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863XT23013835;
        Fri, 6 Sep 2019 03:33:29 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:33:28 -0700
Subject: [PATCH 1/5] xfs_scrub: remove unnecessary fd parameter from file
 scrubbers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:33:28 -0700
Message-ID: <156774080821.2643094.5031489896405041648.stgit@magnolia>
In-Reply-To: <156774080205.2643094.9791648860536208060.stgit@magnolia>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_scrub's scrub ioctl wrapper functions always take a scrub_ctx and an
fd, but we always set the fd to ctx->mnt.fd.  Remove the redundant
parameter.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase3.c |   10 +++++-----
 scrub/scrub.c  |   34 ++++++++++++----------------------
 scrub/scrub.h  |   16 ++++++++--------
 3 files changed, 25 insertions(+), 35 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 5eff7907..81c64cd1 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -28,12 +28,12 @@
 static bool
 xfs_scrub_fd(
 	struct scrub_ctx	*ctx,
-	bool			(*fn)(struct scrub_ctx *, uint64_t,
-				      uint32_t, int, struct xfs_action_list *),
+	bool			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
+				      uint32_t gen, struct xfs_action_list *a),
 	struct xfs_bstat	*bs,
 	struct xfs_action_list	*alist)
 {
-	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt.fd, alist);
+	return fn(ctx, bs->bs_ino, bs->bs_gen, alist);
 }
 
 struct scrub_inode_ctx {
@@ -114,8 +114,8 @@ xfs_scrub_inode(
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
-		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
-				bstat->bs_gen, ctx->mnt.fd, &alist);
+		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
+				&alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
 		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index ac67f8ec..62edc361 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -176,7 +176,6 @@ xfs_scrub_warn_incomplete_scrub(
 static enum check_outcome
 xfs_check_metadata(
 	struct scrub_ctx		*ctx,
-	int				fd,
 	struct xfs_scrub_metadata	*meta,
 	bool				is_inode)
 {
@@ -191,7 +190,7 @@ xfs_check_metadata(
 
 	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
 retry:
-	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, meta);
+	error = ioctl(ctx->mnt.fd, XFS_IOC_SCRUB_METADATA, meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	if (error) {
@@ -363,7 +362,7 @@ xfs_scrub_metadata(
 		background_sleep();
 
 		/* Check the item. */
-		fix = xfs_check_metadata(ctx, ctx->mnt.fd, &meta, false);
+		fix = xfs_check_metadata(ctx, &meta, false);
 		progress_add(1);
 		switch (fix) {
 		case CHECK_ABORT:
@@ -399,7 +398,7 @@ xfs_scrub_primary_super(
 	enum check_outcome		fix;
 
 	/* Check the item. */
-	fix = xfs_check_metadata(ctx, ctx->mnt.fd, &meta, false);
+	fix = xfs_check_metadata(ctx, &meta, false);
 	switch (fix) {
 	case CHECK_ABORT:
 		return false;
@@ -478,7 +477,6 @@ __xfs_scrub_file(
 	struct scrub_ctx		*ctx,
 	uint64_t			ino,
 	uint32_t			gen,
-	int				fd,
 	unsigned int			type,
 	struct xfs_action_list		*alist)
 {
@@ -493,7 +491,7 @@ __xfs_scrub_file(
 	meta.sm_gen = gen;
 
 	/* Scrub the piece of metadata. */
-	fix = xfs_check_metadata(ctx, fd, &meta, true);
+	fix = xfs_check_metadata(ctx, &meta, true);
 	if (fix == CHECK_ABORT)
 		return false;
 	if (fix == CHECK_DONE)
@@ -507,10 +505,9 @@ xfs_scrub_inode_fields(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_INODE, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
 }
 
 bool
@@ -518,10 +515,9 @@ xfs_scrub_data_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTD, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
 }
 
 bool
@@ -529,10 +525,9 @@ xfs_scrub_attr_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTA, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
 }
 
 bool
@@ -540,10 +535,9 @@ xfs_scrub_cow_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTC, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
 }
 
 bool
@@ -551,10 +545,9 @@ xfs_scrub_dir(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_DIR, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
 }
 
 bool
@@ -562,10 +555,9 @@ xfs_scrub_attr(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_XATTR, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
 }
 
 bool
@@ -573,10 +565,9 @@ xfs_scrub_symlink(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_SYMLINK, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
 }
 
 bool
@@ -584,10 +575,9 @@ xfs_scrub_parent(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd,
 	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT, alist);
+	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
 }
 
 /* Test the availability of a kernel scrub command. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index e6e3f16f..7e28b522 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -36,21 +36,21 @@ bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
 bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd, struct xfs_action_list *alist);
+		struct xfs_action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */
 struct action_item {

