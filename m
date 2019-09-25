Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C206C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D6A205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GV8bBqsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfIYVj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbfIYVj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdQbM058345;
        Wed, 25 Sep 2019 21:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/fvVQgpt/NtgOpS8gMHg2nCSHecs1ugrd7ZaqpnFscY=;
 b=GV8bBqsXMFFhk7QkAv7Sg5Hyix4uifW9hwo/fW4hVDXEhdG4LQiMbaZ4pUzdEykJ/tNV
 3OsgdZOsKrTG9xKZublB8LGH2xYkSDJ2+Veu4GSif1LdPRwl69agaMIjqoCosnZd62Ih
 Pl5p3eFq/ApzqkXX6sf3+r3hnVBhIi7UDbpmH53SXGdwmqYdySi5y+MVfDarcwAd7g0h
 dVIxp3s5e6KDjF4TlQ2DhzLZxHxUp/TBZwqy3xq5sO5GhYnnQWgwvdwpd//7uVdycYdu
 EMk/N0yqgseVF4Ds9U0VCp/aayLR5GbK9W+Ci8ZLJTbDZB13n4AIDE4CNHFumbNTyYy6 +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdJP0107680;
        Wed, 25 Sep 2019 21:39:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qakycp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLcVg1016658;
        Wed, 25 Sep 2019 21:38:31 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:38:30 -0700
Subject: [PATCH 04/18] xfs_scrub: remove moveon from vfs directory tree
 iteration
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:38:29 -0700
Message-ID: <156944750944.301514.5858412897281643737.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
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

Replace the moveon returns in the vfs directory tree walking functions
with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   28 +++++++++++++++++-----------
 scrub/vfs.c    |   52 ++++++++++++++++++++++++++++++----------------------
 scrub/vfs.h    |    6 +++---
 3 files changed, 50 insertions(+), 36 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 55b5a611..dd6e29af 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -294,21 +294,24 @@ _("Disappeared during read error reporting."));
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
@@ -323,11 +326,11 @@ xfs_report_verify_dirent(
 
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
@@ -336,8 +339,12 @@ xfs_report_verify_dirent(
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
@@ -348,7 +355,7 @@ xfs_report_verify_dirent(
 	error = close(fd);
 	if (error)
 		str_errno(ctx, path);
-	return moveon;
+	return moveon ? 0 : -1;
 }
 
 /* Report an IO error resulting from read-verify based off getfsmap. */
@@ -508,7 +515,6 @@ xfs_report_verify_errors(
 	struct scrub_ctx		*ctx,
 	struct media_verify_state	*vs)
 {
-	bool				moveon;
 	int				ret;
 
 	ret = walk_ioerrs(ctx, ctx->datadev, vs);
@@ -524,9 +530,9 @@ xfs_report_verify_errors(
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
index caef8969..7c518b28 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -6,12 +6,12 @@
 #ifndef XFS_SCRUB_VFS_H_
 #define XFS_SCRUB_VFS_H_
 
-typedef bool (*scan_fs_tree_dir_fn)(struct scrub_ctx *, const char *,
+typedef int (*scan_fs_tree_dir_fn)(struct scrub_ctx *, const char *,
 		int, void *);
-typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
+typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 		int, struct dirent *, struct stat *, void *);
 
-bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
+int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
 void fstrim(struct scrub_ctx *ctx);

