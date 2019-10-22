Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAC9CA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CB420B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FZ5xyyri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfJVSu4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:50:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732753AbfJVSuz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:50:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiJeJ109548;
        Tue, 22 Oct 2019 18:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fAD8NkBKOPPrIUasrBr0d4S+iE6BftRMjDu+PCtTaiM=;
 b=FZ5xyyriDE+RezziXj4MI6Zcs5xoRs3DrLcljdRrulma+5MnD7kWHbkiqVZAWRQJUBFj
 i631l2DJSvkBGRy8pjTuupy6TdO1H1mVj1QyoidvF4bfOSIowirsjCptk3J+y+6VbsD1
 HY8F70vb8B3E1DiCQ+nWWdPwxLcWpad3aro9sGAxyltcYfaUpX8ZTDEXSGc89cBRoUVM
 WgbwS6pZJ9Gsgq9xafj5jKRSlIMkEmcdOsqjV44hTqD5xZP+PO2Li1XUUDA/rynF0mVr
 E6PXqJ4Hx8bcpLir746zOw6w9nvfBoLSklQ4r4EOlhy9r0WzutxTK4oTV4Plaloze03y fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtgv92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:50:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhlTi148116;
        Tue, 22 Oct 2019 18:50:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vsp40137b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:50:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIoplN004534;
        Tue, 22 Oct 2019 18:50:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:50:51 -0700
Subject: [PATCH 04/18] xfs_scrub: remove moveon from vfs directory tree
 iteration
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:50:46 -0700
Message-ID: <157177024676.1461658.4214905324305884109.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
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

Replace the moveon returns in the vfs directory tree walking functions
with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   28 +++++++++++++++++-----------
 scrub/vfs.c    |   52 ++++++++++++++++++++++++++++++----------------------
 scrub/vfs.h    |   14 +++++++-------
 3 files changed, 54 insertions(+), 40 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index c4511b08..3da82e7c 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -311,21 +311,24 @@ _("Disappeared during read error reporting."));
 }
 
 /* Scan a directory for matches in the read verify error list. */
-static bool
+static int
 xfs_report_verify_dir(
 	struct scrub_ctx	*ctx,
 	const char		*path,
 	int			dir_fd,
 	void			*arg)
 {
-	return xfs_report_verify_fd(ctx, path, dir_fd, arg);
+	bool			moveon;
+
+	moveon = xfs_report_verify_fd(ctx, path, dir_fd, arg);
+	return moveon ? 0 : -1;
 }
 
 /*
  * Scan the inode associated with a directory entry for matches with
  * the read verify error list.
  */
-static bool
+static int
 xfs_report_verify_dirent(
 	struct scrub_ctx	*ctx,
 	const char		*path,
@@ -340,11 +343,11 @@ xfs_report_verify_dirent(
 
 	/* Ignore things we can't open. */
 	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
-		return true;
+		return 0;
 
 	/* Ignore . and .. */
 	if (!strcmp(".", dirent->d_name) || !strcmp("..", dirent->d_name))
-		return true;
+		return 0;
 
 	/*
 	 * If we were given a dirent, open the associated file under
@@ -353,8 +356,12 @@ xfs_report_verify_dirent(
 	 */
 	fd = openat(dir_fd, dirent->d_name,
 			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
-	if (fd < 0)
-		return true;
+	if (fd < 0) {
+		if (errno == ENOENT)
+			return 0;
+		str_errno(ctx, path);
+		return errno;
+	}
 
 	/* Go find the badness. */
 	moveon = xfs_report_verify_fd(ctx, path, fd, arg);
@@ -365,7 +372,7 @@ xfs_report_verify_dirent(
 	error = close(fd);
 	if (error)
 		str_errno(ctx, path);
-	return moveon;
+	return moveon ? 0 : -1;
 }
 
 /* Use a fsmap to report metadata lost to a media error. */
@@ -480,7 +487,6 @@ report_all_media_errors(
 	struct scrub_ctx		*ctx,
 	struct media_verify_state	*vs)
 {
-	bool				moveon;
 	int				ret;
 
 	ret = report_disk_ioerrs(ctx, ctx->datadev, vs);
@@ -496,9 +502,9 @@ report_all_media_errors(
 	}
 
 	/* Scan the directory tree to get file paths. */
-	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
+	ret = scan_fs_tree(ctx, xfs_report_verify_dir,
 			xfs_report_verify_dirent, vs);
-	if (!moveon)
+	if (ret)
 		return false;
 
 	/* Scan for unlinked files. */
diff --git a/scrub/vfs.c b/scrub/vfs.c
index d7c40239..c807c9b9 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -30,7 +30,7 @@ struct scan_fs_tree {
 	pthread_mutex_t		lock;
 	pthread_cond_t		wakeup;
 	struct stat		root_sb;
-	bool			moveon;
+	bool			aborted;
 	scan_fs_tree_dir_fn	dir_fn;
 	scan_fs_tree_dirent_fn	dirent_fn;
 	void			*arg;
@@ -138,8 +138,9 @@ scan_fs_dir(
 	}
 
 	/* Caller-specific directory checks. */
-	if (!sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg)) {
-		sft->moveon = false;
+	error = sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg);
+	if (error) {
+		sft->aborted = true;
 		error = close(dir_fd);
 		if (error)
 			str_errno(ctx, sftd->path);
@@ -150,11 +151,14 @@ scan_fs_dir(
 	dir = fdopendir(dir_fd);
 	if (!dir) {
 		str_errno(ctx, sftd->path);
+		sft->aborted = true;
 		close(dir_fd);
 		goto out;
 	}
 	rewinddir(dir);
-	for (dirent = readdir(dir); dirent != NULL; dirent = readdir(dir)) {
+	for (dirent = readdir(dir);
+	     !sft->aborted && dirent != NULL;
+	     dirent = readdir(dir)) {
 		snprintf(newpath, PATH_MAX, "%s/%s", sftd->path,
 				dirent->d_name);
 
@@ -171,14 +175,15 @@ scan_fs_dir(
 			continue;
 
 		/* Caller-specific directory entry function. */
-		if (!sft->dirent_fn(ctx, newpath, dir_fd, dirent, &sb,
-				sft->arg)) {
-			sft->moveon = false;
+		error = sft->dirent_fn(ctx, newpath, dir_fd, dirent, &sb,
+				sft->arg);
+		if (error) {
+			sft->aborted = true;
 			break;
 		}
 
 		if (xfs_scrub_excessive_errors(ctx)) {
-			sft->moveon = false;
+			sft->aborted = true;
 			break;
 		}
 
@@ -189,7 +194,7 @@ scan_fs_dir(
 			if (error) {
 				str_liberror(ctx, error,
 _("queueing subdirectory scan"));
-				sft->moveon = false;
+				sft->aborted = true;
 				break;
 			}
 		}
@@ -206,8 +211,11 @@ _("queueing subdirectory scan"));
 	free(sftd);
 }
 
-/* Scan the entire filesystem. */
-bool
+/*
+ * Scan the entire filesystem.  This function returns 0 on success; if there
+ * are errors, this function will log them and returns nonzero.
+ */
+int
 scan_fs_tree(
 	struct scrub_ctx	*ctx,
 	scan_fs_tree_dir_fn	dir_fn,
@@ -215,20 +223,18 @@ scan_fs_tree(
 	void			*arg)
 {
 	struct workqueue	wq;
-	struct scan_fs_tree	sft;
-	bool			moveon = false;
+	struct scan_fs_tree	sft = {
+		.root_sb	= ctx->mnt_sb,
+		.dir_fn		= dir_fn,
+		.dirent_fn	= dirent_fn,
+		.arg		= arg,
+	};
 	int			ret;
 
-	sft.moveon = true;
-	sft.nr_dirs = 0;
-	sft.root_sb = ctx->mnt_sb;
-	sft.dir_fn = dir_fn;
-	sft.dirent_fn = dirent_fn;
-	sft.arg = arg;
 	ret = pthread_mutex_init(&sft.lock, NULL);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating directory scan lock"));
-		return false;
+		return ret;
 	}
 	ret = pthread_cond_init(&sft.wakeup, NULL);
 	if (ret) {
@@ -268,14 +274,16 @@ scan_fs_tree(
 		goto out_wq;
 	}
 
-	moveon = sft.moveon;
+	if (!ret && sft.aborted)
+		ret = -1;
+
 out_wq:
 	workqueue_destroy(&wq);
 out_cond:
 	pthread_cond_destroy(&sft.wakeup);
 out_mutex:
 	pthread_mutex_destroy(&sft.lock);
-	return moveon;
+	return ret;
 }
 
 #ifndef FITRIM
diff --git a/scrub/vfs.h b/scrub/vfs.h
index af23674a..dc1099cf 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -8,20 +8,20 @@
 
 /*
  * Visit a subdirectory prior to iterating entries in that subdirectory.
- * Return true to continue iteration or false to stop iterating and return to
- * the caller.
+ * Return 0 to continue iteration or a positive error code to stop iterating
+ * and return to the caller.
  */
-typedef bool (*scan_fs_tree_dir_fn)(struct scrub_ctx *, const char *,
+typedef int (*scan_fs_tree_dir_fn)(struct scrub_ctx *, const char *,
 		int, void *);
 
 /*
- * Visit each directory entry in a directory.  Return true to continue
- * iteration or false to stop iterating and return to the caller.
+ * Visit each directory entry in a directory.  Return 0 to continue iteration
+ * or a positive error code to stop iterating and return to the caller.
  */
-typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
+typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 		int, struct dirent *, struct stat *, void *);
 
-bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
+int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
 void fstrim(struct scrub_ctx *ctx);

