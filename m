Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E44C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 04:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75C6C21897
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 04:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mQug+67Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfH3EU5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 00:20:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfH3EU4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 00:20:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U4IieV116096;
        Fri, 30 Aug 2019 04:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XgQ8HrtHc2ZXqjzfzyGz2sEb6Uhn9nujzFW+wNk0sZ8=;
 b=mQug+67YJnmWclX4Ih2S+nP1x5lQfTP5j7oUpx2QARcE14nLnQB8ax1rk1MqmusUuudY
 auGfYCc+CujNTGcld10s3+KWuoMQylWHpivxqVuPNxXkHstfWvB6R0XwtDaVzUkgzb7R
 GIaM+UvT/w+5A4ygzuFiPW4YGffw2qY51D8Kfpbr+HA8yNUM3MB2cs9si0YXQC28qdE2
 DqxLr5rq6g0TtzNHzBeVY59oklNMXn6ATPWzOqggwiil6OzDNhnNoTQj8CIC90OnjN3X
 5mThmkQx2m6Hus9yUlPz3EgWL61jgGNRwxqxUhkhoWRBxeMdWNLREECSO2JFFro83eza Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2upvjjr12b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 04:20:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U4If6w072846;
        Fri, 30 Aug 2019 04:20:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2upkrfs5cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 04:20:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7U4KqOg026390;
        Fri, 30 Aug 2019 04:20:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 21:20:51 -0700
Subject: [PATCH 4/9] libfrog: introduce xfs_fd to wrap an fd to a file on an
 xfs filesystem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 29 Aug 2019 21:20:47 -0700
Message-ID: <156713884740.386621.17037456340127194067.stgit@magnolia>
In-Reply-To: <156713882070.386621.8501281965010809034.stgit@magnolia>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300043
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce a new "xfs_fd" context structure where we can store a file
descriptor and all the runtime fs context (geometry, which ioctls work,
etc.) that goes with it.  We're going to create wrappers for the
bulkstat and inumbers ioctls in subsequent patches; and when we
introduce the v5 bulkstat/inumbers ioctls we'll need all that context to
downgrade gracefully on old kernels.  Start the transition by adopting
xfs_fd natively in scrub.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |   20 ++++++++++++++++++++
 libfrog/fsgeom.c   |   32 ++++++++++++++++++++++++++++++++
 scrub/fscounters.c |   22 ++++++++++++----------
 scrub/inodes.c     |   10 +++++-----
 scrub/phase1.c     |   39 +++++++++++++++++++--------------------
 scrub/phase2.c     |    2 +-
 scrub/phase3.c     |    4 ++--
 scrub/phase4.c     |    8 ++++----
 scrub/phase5.c     |    2 +-
 scrub/phase6.c     |    6 +++---
 scrub/phase7.c     |    2 +-
 scrub/repair.c     |    4 ++--
 scrub/scrub.c      |   12 ++++++------
 scrub/spacemap.c   |   12 ++++++------
 scrub/vfs.c        |    2 +-
 scrub/xfs_scrub.h  |    7 ++++---
 16 files changed, 119 insertions(+), 65 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index f3541193..766ee5d5 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -19,4 +19,24 @@
 struct xfs_fsop_geom;
 int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
 
+/*
+ * Structure for recording whatever observations we want about the level of
+ * xfs runtime support for this fd.  Right now we only store the fd and fs
+ * geometry.
+ */
+struct xfs_fd {
+	/* ioctl file descriptor */
+	int			fd;
+
+	/* filesystem geometry */
+	struct xfs_fsop_geom	fsgeom;
+};
+
+/* Static initializers */
+#define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
+#define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
+
+int xfd_prepare_geometry(struct xfs_fd *xfd);
+int xfd_close(struct xfs_fd *xfd);
+
 #endif	/* __XFROG_H__ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 69d24774..694ccbd0 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -93,3 +93,35 @@ xfrog_geometry(
 
 	return errno;
 }
+
+/*
+ * Prepare xfs_fd structure for future ioctl operations by computing the xfs
+ * geometry for @xfd->fd.  Returns zero or a positive error code.
+ */
+int
+xfd_prepare_geometry(
+	struct xfs_fd		*xfd)
+{
+	return xfrog_geometry(xfd->fd, &xfd->fsgeom);
+}
+
+/*
+ * Release any resources associated with this xfs_fd structure.  Returns zero
+ * or a positive error code.
+ */
+int
+xfd_close(
+	struct xfs_fd		*xfd)
+{
+	int			ret = 0;
+
+	if (xfd->fd < 0)
+		return 0;
+
+	ret = close(xfd->fd);
+	xfd->fd = -1;
+	if (ret < 0)
+		return errno;
+
+	return 0;
+}
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 9e93e2a6..f18d0e19 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -57,10 +57,10 @@ xfs_count_inodes_range(
 	igrpreq.ocount  = &igrplen;
 
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	while (!error && igrplen && inogrp.xi_startino < last_ino) {
 		nr += inogrp.xi_alloccount;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 	if (error) {
@@ -113,7 +113,7 @@ xfs_count_all_inodes(
 	int			ret;
 
 	ci = calloc(1, sizeof(struct xfs_count_inodes) +
-			(ctx->geo.agcount * sizeof(uint64_t)));
+			(ctx->mnt.fsgeom.agcount * sizeof(uint64_t)));
 	if (!ci)
 		return false;
 	ci->moveon = true;
@@ -125,7 +125,7 @@ xfs_count_all_inodes(
 		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
 		goto out_free;
 	}
-	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
 		if (ret) {
 			moveon = false;
@@ -136,7 +136,7 @@ _("Could not queue AG %u icount work."), agno);
 	}
 	workqueue_destroy(&wq);
 
-	for (agno = 0; agno < ctx->geo.agcount; agno++)
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
 		*count += ci->counters[agno];
 	moveon = ci->moveon;
 
@@ -162,14 +162,14 @@ xfs_scan_estimate_blocks(
 	int				error;
 
 	/* Grab the fstatvfs counters, since it has to report accurately. */
-	error = fstatvfs(ctx->mnt_fd, &sfs);
+	error = fstatvfs(ctx->mnt.fd, &sfs);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
 	}
 
 	/* Fetch the filesystem counters. */
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSCOUNTS, &fc);
+	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
@@ -179,14 +179,16 @@ xfs_scan_estimate_blocks(
 	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
 	 * blocks back to the free data counts.
 	 */
-	error = ioctl(ctx->mnt_fd, XFS_IOC_GET_RESBLKS, &rb);
+	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
 	if (error)
 		str_errno(ctx, ctx->mntpoint);
 	sfs.f_bfree += rb.resblks_avail;
 
-	*d_blocks = sfs.f_blocks + (ctx->geo.logstart ? ctx->geo.logblocks : 0);
+	*d_blocks = sfs.f_blocks;
+	if (ctx->mnt.fsgeom.logstart > 0)
+		*d_blocks += ctx->mnt.fsgeom.logblocks;
 	*d_bfree = sfs.f_bfree;
-	*r_blocks = ctx->geo.rtblocks;
+	*r_blocks = ctx->mnt.fsgeom.rtblocks;
 	*r_bfree = fc.freertx;
 	*f_files = sfs.f_files;
 	*f_free = sfs.f_ffree;
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 442a5978..08f3d847 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -72,7 +72,7 @@ xfs_iterate_inodes_range_check(
 		/* Load the one inode. */
 		oneino = inogrp->xi_startino + i;
 		onereq.ubuffer = bs;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT_SINGLE,
+		error = ioctl(ctx->mnt.fd, XFS_IOC_FSBULKSTAT_SINGLE,
 				&onereq);
 		if (error || bs->bs_ino != inogrp->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bstat));
@@ -134,7 +134,7 @@ xfs_iterate_inodes_range(
 
 	/* Find the inode chunk & alloc mask */
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	while (!error && igrplen) {
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
@@ -145,7 +145,7 @@ xfs_iterate_inodes_range(
 		 */
 		if (inogrp.xi_alloccount == 0)
 			goto igrp_retry;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+		error = ioctl(ctx->mnt.fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 		if (error)
 			str_info(ctx, descr, "%s", strerror_r(errno,
 						buf, DESCR_BUFSZ));
@@ -190,7 +190,7 @@ _("Changed too many times during scan; giving up."));
 
 		stale_count = 0;
 igrp_retry:
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 err:
@@ -260,7 +260,7 @@ xfs_scan_all_inodes(
 		return false;
 	}
 
-	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_scan_ag_inodes, agno, &si);
 		if (ret) {
 			si.moveon = false;
diff --git a/scrub/phase1.c b/scrub/phase1.c
index bdd23d26..6d8293b2 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -39,7 +39,7 @@ xfs_shutdown_fs(
 
 	flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
 	str_info(ctx, ctx->mntpoint, _("Shutting down filesystem!"));
-	if (ioctl(ctx->mnt_fd, XFS_IOC_GOINGDOWN, &flag))
+	if (ioctl(ctx->mnt.fd, XFS_IOC_GOINGDOWN, &flag))
 		str_errno(ctx, ctx->mntpoint);
 }
 
@@ -60,11 +60,9 @@ xfs_cleanup_fs(
 	if (ctx->datadev)
 		disk_close(ctx->datadev);
 	fshandle_destroy();
-	if (ctx->mnt_fd >= 0) {
-		error = close(ctx->mnt_fd);
-		if (error)
-			str_errno(ctx, _("closing mountpoint fd"));
-	}
+	error = xfd_close(&ctx->mnt);
+	if (error)
+		str_liberror(ctx, error, _("closing mountpoint fd"));
 	fs_table_destroy();
 
 	return true;
@@ -86,8 +84,8 @@ xfs_setup_fs(
 	 * CAP_SYS_ADMIN, which we probably need to do anything fancy
 	 * with the (XFS driver) kernel.
 	 */
-	ctx->mnt_fd = open(ctx->mntpoint, O_RDONLY | O_NOATIME | O_DIRECTORY);
-	if (ctx->mnt_fd < 0) {
+	ctx->mnt.fd = open(ctx->mntpoint, O_RDONLY | O_NOATIME | O_DIRECTORY);
+	if (ctx->mnt.fd < 0) {
 		if (errno == EPERM)
 			str_info(ctx, ctx->mntpoint,
 _("Must be root to run scrub."));
@@ -96,23 +94,23 @@ _("Must be root to run scrub."));
 		return false;
 	}
 
-	error = fstat(ctx->mnt_fd, &ctx->mnt_sb);
+	error = fstat(ctx->mnt.fd, &ctx->mnt_sb);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
 	}
-	error = fstatvfs(ctx->mnt_fd, &ctx->mnt_sv);
+	error = fstatvfs(ctx->mnt.fd, &ctx->mnt_sv);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
 	}
-	error = fstatfs(ctx->mnt_fd, &ctx->mnt_sf);
+	error = fstatfs(ctx->mnt.fd, &ctx->mnt_sf);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
 	}
 
-	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
+	if (!platform_test_xfs_fd(ctx->mnt.fd)) {
 		str_info(ctx, ctx->mntpoint,
 _("Does not appear to be an XFS filesystem!"));
 		return false;
@@ -123,27 +121,28 @@ _("Does not appear to be an XFS filesystem!"));
 	 * This seems to reduce the incidence of stale file handle
 	 * errors when we open things by handle.
 	 */
-	error = syncfs(ctx->mnt_fd);
+	error = syncfs(ctx->mnt.fd);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
 	}
 
 	/* Retrieve XFS geometry. */
-	error = xfrog_geometry(ctx->mnt_fd, &ctx->geo);
+	error = xfd_prepare_geometry(&ctx->mnt);
 	if (error) {
 		str_liberror(ctx, error, _("Retrieving XFS geometry"));
 		return false;
 	}
 
-	if (!xfs_action_lists_alloc(ctx->geo.agcount, &ctx->action_lists)) {
+	if (!xfs_action_lists_alloc(ctx->mnt.fsgeom.agcount,
+				&ctx->action_lists)) {
 		str_error(ctx, ctx->mntpoint, _("Not enough memory."));
 		return false;
 	}
 
-	ctx->agblklog = log2_roundup(ctx->geo.agblocks);
-	ctx->blocklog = highbit32(ctx->geo.blocksize);
-	ctx->inodelog = highbit32(ctx->geo.inodesize);
+	ctx->agblklog = log2_roundup(ctx->mnt.fsgeom.agblocks);
+	ctx->blocklog = highbit32(ctx->mnt.fsgeom.blocksize);
+	ctx->inodelog = highbit32(ctx->mnt.fsgeom.inodesize);
 	ctx->inopblog = ctx->blocklog - ctx->inodelog;
 
 	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
@@ -171,12 +170,12 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 	}
 
 	/* Did we find the log and rt devices, if they're present? */
-	if (ctx->geo.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
+	if (ctx->mnt.fsgeom.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
 		str_info(ctx, ctx->mntpoint,
 _("Unable to find log device path."));
 		return false;
 	}
-	if (ctx->geo.rtblocks && ctx->fsinfo.fs_rt == NULL) {
+	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL) {
 		str_info(ctx, ctx->mntpoint,
 _("Unable to find realtime device path."));
 		return false;
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 653f666c..a80da7fd 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -141,7 +141,7 @@ xfs_scan_metadata(
 	if (!moveon)
 		goto out;
 
-	for (agno = 0; moveon && agno < ctx->geo.agcount; agno++) {
+	for (agno = 0; moveon && agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
 		if (ret) {
 			moveon = false;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 4963d675..a42d8213 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -33,7 +33,7 @@ xfs_scrub_fd(
 	struct xfs_bstat	*bs,
 	struct xfs_action_list	*alist)
 {
-	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd, alist);
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt.fd, alist);
 }
 
 struct scrub_inode_ctx {
@@ -115,7 +115,7 @@ xfs_scrub_inode(
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
 		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
-				bstat->bs_gen, ctx->mnt_fd, &alist);
+				bstat->bs_gen, ctx->mnt.fd, &alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
 		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 79248326..49f00723 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -40,7 +40,7 @@ xfs_repair_ag(
 
 	/* Repair anything broken until we fail to make progress. */
 	do {
-		moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist, flags);
+		moveon = xfs_action_list_process(ctx, ctx->mnt.fd, alist, flags);
 		if (!moveon) {
 			*pmoveon = false;
 			return;
@@ -56,7 +56,7 @@ xfs_repair_ag(
 
 	/* Try once more, but this time complain if we can't fix things. */
 	flags |= ALP_COMPLAIN_IF_UNFIXED;
-	moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist, flags);
+	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, alist, flags);
 	if (!moveon)
 		*pmoveon = false;
 }
@@ -77,7 +77,7 @@ xfs_process_action_items(
 		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
 		return false;
 	}
-	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
 		if (xfs_action_list_length(&ctx->action_lists[agno]) > 0) {
 			ret = workqueue_add(&wq, xfs_repair_ag, agno, &moveon);
 			if (ret) {
@@ -121,7 +121,7 @@ xfs_estimate_repair_work(
 	xfs_agnumber_t		agno;
 	size_t			need_fixing = 0;
 
-	for (agno = 0; agno < ctx->geo.agcount; agno++)
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
 		need_fixing += xfs_action_list_length(&ctx->action_lists[agno]);
 	need_fixing++;
 	*items = need_fixing;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 1743119d..748885d4 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -306,7 +306,7 @@ xfs_scrub_fs_label(
 		return false;
 
 	/* Retrieve label; quietly bail if we don't support that. */
-	error = ioctl(ctx->mnt_fd, FS_IOC_GETFSLABEL, &label);
+	error = ioctl(ctx->mnt.fd, FS_IOC_GETFSLABEL, &label);
 	if (error) {
 		if (errno != EOPNOTSUPP && errno != ENOTTY) {
 			moveon = false;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 66e6451c..e5a0b3c1 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -468,7 +468,7 @@ xfs_scan_blocks(
 	}
 
 	vs.rvp_data = read_verify_pool_init(ctx, ctx->datadev,
-			ctx->geo.blocksize, xfs_check_rmap_ioerr,
+			ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
 			scrub_nproc(ctx));
 	if (!vs.rvp_data) {
 		str_info(ctx, ctx->mntpoint,
@@ -477,7 +477,7 @@ _("Could not create data device media verifier."));
 	}
 	if (ctx->logdev) {
 		vs.rvp_log = read_verify_pool_init(ctx, ctx->logdev,
-				ctx->geo.blocksize, xfs_check_rmap_ioerr,
+				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
 				scrub_nproc(ctx));
 		if (!vs.rvp_log) {
 			str_info(ctx, ctx->mntpoint,
@@ -487,7 +487,7 @@ _("Could not create data device media verifier."));
 	}
 	if (ctx->rtdev) {
 		vs.rvp_realtime = read_verify_pool_init(ctx, ctx->rtdev,
-				ctx->geo.blocksize, xfs_check_rmap_ioerr,
+				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
 				scrub_nproc(ctx));
 		if (!vs.rvp_realtime) {
 			str_info(ctx, ctx->mntpoint,
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 0c3202e4..13959ca8 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -111,7 +111,7 @@ xfs_scan_summary(
 	int			error;
 
 	/* Flush everything out to disk before we start counting. */
-	error = syncfs(ctx->mnt_fd);
+	error = syncfs(ctx->mnt.fd);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
diff --git a/scrub/repair.c b/scrub/repair.c
index 4ed3c09a..45450d8c 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -262,7 +262,7 @@ xfs_action_list_defer(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	ASSERT(agno < ctx->geo.agcount);
+	ASSERT(agno < ctx->mnt.fsgeom.agcount);
 
 	xfs_action_list_splice(&ctx->action_lists[agno], alist);
 }
@@ -276,7 +276,7 @@ xfs_action_list_process_or_defer(
 {
 	bool				moveon;
 
-	moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist,
+	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, alist,
 			ALP_REPAIR_ONLY | ALP_NOPROGRESS);
 	if (!moveon)
 		return moveon;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0f0c9639..136ed529 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -363,7 +363,7 @@ xfs_scrub_metadata(
 		background_sleep();
 
 		/* Check the item. */
-		fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta, false);
+		fix = xfs_check_metadata(ctx, ctx->mnt.fd, &meta, false);
 		progress_add(1);
 		switch (fix) {
 		case CHECK_ABORT:
@@ -399,7 +399,7 @@ xfs_scrub_primary_super(
 	enum check_outcome		fix;
 
 	/* Check the item. */
-	fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta, false);
+	fix = xfs_check_metadata(ctx, ctx->mnt.fd, &meta, false);
 	switch (fix) {
 	case CHECK_ABORT:
 		return false;
@@ -460,7 +460,7 @@ xfs_scrub_estimate_ag_work(
 		switch (sc->type) {
 		case ST_AGHEADER:
 		case ST_PERAG:
-			estimate += ctx->geo.agcount;
+			estimate += ctx->mnt.fsgeom.agcount;
 			break;
 		case ST_FS:
 			estimate++;
@@ -605,9 +605,9 @@ __xfs_scrub_test(
 	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
 		return false;
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
-		inject.fd = ctx->mnt_fd;
+		inject.fd = ctx->mnt.fd;
 		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_ERROR_INJECTION, &inject);
+		error = ioctl(ctx->mnt.fd, XFS_IOC_ERROR_INJECTION, &inject);
 		if (error == 0)
 			injected = true;
 	}
@@ -615,7 +615,7 @@ __xfs_scrub_test(
 	meta.sm_type = type;
 	if (repair)
 		meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_SCRUB_METADATA, &meta);
+	error = ioctl(ctx->mnt.fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (!error)
 		return true;
 	switch (errno) {
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index d547a041..c3621a3a 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -56,7 +56,7 @@ xfs_iterate_fsmap(
 	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
 	head->fmh_count = FSMAP_NR;
 
-	while ((error = ioctl(ctx->mnt_fd, FS_IOC_GETFSMAP, head)) == 0) {
+	while ((error = ioctl(ctx->mnt.fd, FS_IOC_GETFSMAP, head)) == 0) {
 		for (i = 0, p = head->fmh_recs;
 		     i < head->fmh_entries;
 		     i++, p++) {
@@ -107,8 +107,8 @@ xfs_scan_ag_blocks(
 	off64_t			bperag;
 	bool			moveon;
 
-	bperag = (off64_t)ctx->geo.agblocks *
-		 (off64_t)ctx->geo.blocksize;
+	bperag = (off64_t)ctx->mnt.fsgeom.agblocks *
+		 (off64_t)ctx->mnt.fsgeom.blocksize;
 
 	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
 				major(ctx->fsinfo.fs_datadev),
@@ -205,7 +205,7 @@ xfs_scan_all_spacemaps(
 	}
 	if (ctx->fsinfo.fs_rt) {
 		ret = workqueue_add(&wq, xfs_scan_rt_blocks,
-				ctx->geo.agcount + 1, &sbx);
+				ctx->mnt.fsgeom.agcount + 1, &sbx);
 		if (ret) {
 			sbx.moveon = false;
 			str_info(ctx, ctx->mntpoint,
@@ -215,7 +215,7 @@ _("Could not queue rtdev fsmap work."));
 	}
 	if (ctx->fsinfo.fs_log) {
 		ret = workqueue_add(&wq, xfs_scan_log_blocks,
-				ctx->geo.agcount + 2, &sbx);
+				ctx->mnt.fsgeom.agcount + 2, &sbx);
 		if (ret) {
 			sbx.moveon = false;
 			str_info(ctx, ctx->mntpoint,
@@ -223,7 +223,7 @@ _("Could not queue logdev fsmap work."));
 			goto out;
 		}
 	}
-	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_scan_ag_blocks, agno, &sbx);
 		if (ret) {
 			sbx.moveon = false;
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 8bcc4e79..7b0b5bcd 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -232,7 +232,7 @@ fstrim(
 	int			error;
 
 	range.len = ULLONG_MAX;
-	error = ioctl(ctx->mnt_fd, FITRIM, &range);
+	error = ioctl(ctx->mnt.fd, FITRIM, &range);
 	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
 		perror(_("fstrim"));
 }
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index a459e4b5..28eae6fe 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -6,6 +6,8 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
+#include <xfrog.h>
+
 extern char *progname;
 
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
@@ -53,14 +55,13 @@ struct scrub_ctx {
 	/* How does the user want us to react to errors? */
 	enum error_action	error_action;
 
-	/* fd to filesystem mount point */
-	int			mnt_fd;
+	/* xfrog context for the mount point */
+	struct xfs_fd		mnt;
 
 	/* Number of threads for metadata scrubbing */
 	unsigned int		nr_io_threads;
 
 	/* XFS specific geometry */
-	struct xfs_fsop_geom	geo;
 	struct fs_path		fsinfo;
 	unsigned int		agblklog;
 	unsigned int		blocklog;

