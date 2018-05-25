Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:12:27 -0400
Subject: [PATCH 6/7] xfs_scrub: actually check for errors coming from close()
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:12:14 -0700
Message-ID: <152728633395.22515.8564988242826363746.stgit@magnolia>
In-Reply-To: <152728629694.22515.17699396814561914788.stgit@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report errors reported by close().

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c |    6 +++++-
 scrub/phase3.c |   27 +++++++++++++++++++++++++--
 scrub/phase5.c |    8 ++++++--
 scrub/phase6.c |   10 +++++++---
 scrub/vfs.c    |    4 +++-
 5 files changed, 46 insertions(+), 9 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index c2b9067a..87847259 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -60,6 +60,8 @@ bool
 xfs_cleanup_fs(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
 	if (ctx->rtdev)
@@ -69,7 +71,9 @@ xfs_cleanup_fs(
 	if (ctx->datadev)
 		disk_close(ctx->datadev);
 	fshandle_destroy();
-	close(ctx->mnt_fd);
+	error = close(ctx->mnt_fd);
+	if (error)
+		str_errno(ctx, _("closing mountpoint fd"));
 	fs_table_destroy();
 
 	return true;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 68c95e67..cbaa80ba 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -53,6 +53,25 @@ struct scrub_inode_ctx {
 	bool			moveon;
 };
 
+/* Report a filesystem error that the vfs fed us on close. */
+static void
+xfs_scrub_inode_vfs_error(
+	struct scrub_ctx	*ctx,
+	struct xfs_bstat	*bstat)
+{
+	char			descr[DESCR_BUFSZ];
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			old_errno = errno;
+
+	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
+			(uint64_t)bstat->bs_ino, agno, agino);
+	errno = old_errno;
+	str_errno(ctx, descr);
+}
+
 /* Verify the contents, xattrs, and extent maps of an inode. */
 static int
 xfs_scrub_inode(
@@ -65,6 +84,7 @@ xfs_scrub_inode(
 	struct ptcounter	*icount = ictx->icount;
 	bool			moveon = true;
 	int			fd = -1;
+	int			error;
 
 	background_sleep();
 
@@ -116,8 +136,11 @@ xfs_scrub_inode(
 out:
 	ptcounter_add(icount, 1);
 	progress_add(1);
-	if (fd >= 0)
-		close(fd);
+	if (fd >= 0) {
+		error = close(fd);
+		if (error)
+			xfs_scrub_inode_vfs_error(ctx, bstat);
+	}
 	if (!moveon)
 		ictx->moveon = false;
 	return ictx->moveon ? 0 : XFS_ITERATE_INODES_ABORT;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 01038f77..456f38e2 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -250,6 +250,7 @@ xfs_scrub_connections(
 	xfs_agnumber_t		agno;
 	xfs_agino_t		agino;
 	int			fd = -1;
+	int			error;
 
 	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
 	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
@@ -285,8 +286,11 @@ xfs_scrub_connections(
 
 out:
 	progress_add(1);
-	if (fd >= 0)
-		close(fd);
+	if (fd >= 0) {
+		error = close(fd);
+		if (error)
+			str_errno(ctx, descr);
+	}
 	if (!moveon)
 		*pmoveon = false;
 	return *pmoveon ? 0 : XFS_ITERATE_INODES_ABORT;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index b533cbbd..26540155 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -212,7 +212,9 @@ _("Disappeared during read error reporting."));
 
 	/* Go find the badness. */
 	moveon = xfs_report_verify_fd(ctx, descr, fd, arg);
-	close(fd);
+	error = close(fd);
+	if (error)
+		str_errno(ctx, descr);
 
 	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
 }
@@ -243,6 +245,7 @@ xfs_report_verify_dirent(
 {
 	bool			moveon;
 	int			fd;
+	int			error;
 
 	/* Ignore things we can't open. */
 	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
@@ -268,8 +271,9 @@ xfs_report_verify_dirent(
 		goto out;
 
 out:
-	close(fd);
-
+	error = close(fd);
+	if (error)
+		str_errno(ctx, path);
 	return moveon;
 }
 
diff --git a/scrub/vfs.c b/scrub/vfs.c
index cfb58782..77df2874 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -86,7 +86,9 @@ scan_fs_dir(
 	/* Caller-specific directory checks. */
 	if (!sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg)) {
 		sft->moveon = false;
-		close(dir_fd);
+		error = close(dir_fd);
+		if (error)
+			str_errno(ctx, sftd->path);
 		goto out;
 	}
 

