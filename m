Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72CEC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFBD21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+xODc/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfIYVbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:31:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfIYVbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:31:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTFuP050675;
        Wed, 25 Sep 2019 21:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XAJvi0aBZWpmYSpembD+fJ9I10fL2oiWFabIHjSdePo=;
 b=V+xODc/457zbFycFhcz2REd1TiZ7y/ioMPhUElc9n+4Z9l6VmGwuZjyie5+we7n6xaUM
 vRNLMFoTW2MXMp4bvbrK7lEqWUHuFEH15vN0X1KL2g+wUu+xZOEgLGlsvO3cxEix/jFc
 td/XvD8dumlB/ff0OZkoSTYF4waD7dr5kRoQqrvXdODfWjONKnmJUVYftnx7h8fmcaZl
 ABIutwW9d69VO0XnHCM4zHLQ1xCh/gSXJECBvuJ0l1FUZ+yVDjIvVkuKO7cWteurMdtP
 HHDlGKJVvylHmtFAMl/od4uN1RIkdJsIL8bNzmxsGdPy0piH8wf6Y2X6GrSQ2PEJr/em yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7efa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTEue085297;
        Wed, 25 Sep 2019 21:31:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakkxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLVC2k013049;
        Wed, 25 Sep 2019 21:31:12 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:12 -0700
Subject: [PATCH 1/5] xfs_scrub: remove unnecessary fd parameter from file
 scrubbers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:31:11 -0700
Message-ID: <156944707127.296129.4719167869012786091.stgit@magnolia>
In-Reply-To: <156944706528.296129.7604742756772046951.stgit@magnolia>
References: <156944706528.296129.7604742756772046951.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_scrub's scrub ioctl wrapper functions always take a scrub_ctx and an
fd, but we always set the fd to ctx->mnt.fd.  Remove the redundant
parameter.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

