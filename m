Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D01C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiLaAWy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:22:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9406EBE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:22:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3149361D17
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A83C433EF;
        Sat, 31 Dec 2022 00:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446171;
        bh=uNBKf3WtKVvIQH0MI+EDlX4qipMaW1qWtMtZZmtwIN8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UuFH7mvM25NUm71XhMuV5bJVO45m/TBue5iIOdRqjAiJB0Hx0QN9+1Ug4PC7TBOx4
         2rrrPJYuTpJyNWH0U4ssatW48uMHhcK55IkfqWxQVynZx5sugCupqodDGEUDYH5Hr8
         GZ9hEEI/YdBOHwkESSNIwwcsQq93nrJsXA2Ccx+1vV4DvCKVw/UKfSjnxE/I5TKl7p
         8klst5UL6j+MeC8OzF8a2GDQybd1FHu/Ci2XkK7aWxEGhJzC73LAz9a5+ksrae0C2D
         GhlKxIvp3Ssx0V/DqoG3Y82ZIiK+99NrDM67TA/CizGrH9zNqulSFA0JySKh+BX7CF
         sQamwAvpUpztg==
Subject: [PATCH 16/19] xfs_fsr: port to new swapext library function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:01 -0800
Message-ID: <167243868148.713817.14987115560616505118.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port fsr to use the new libfrog library functions to handle swapext.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c           |   80 ++++++++++++++++++++++++-----------------------
 libfrog/file_exchange.c |   17 ++++++++++
 libfrog/file_exchange.h |    2 +
 3 files changed, 59 insertions(+), 40 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8e916faee94..bbc7d5fcabb 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -13,6 +13,8 @@
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
+#include "libfrog/fiexchange.h"
+#include "libfrog/file_exchange.h"
 
 #include <fcntl.h>
 #include <errno.h>
@@ -122,12 +124,6 @@ open_handle(
 	return 0;
 }
 
-static int
-xfs_swapext(int fd, xfs_swapext_t *sx)
-{
-    return ioctl(fd, XFS_IOC_SWAPEXT, sx);
-}
-
 static int
 xfs_fscounts(int fd, xfs_fsop_counts_t *counts)
 {
@@ -1150,14 +1146,13 @@ packfile(
 	struct xfs_bulkstat	*statp,
 	struct fsxattr		*fsxp)
 {
+	struct file_xchg_range	fxr;
 	int			tfd = -1;
-	int			srval;
 	int			retval = -1;	/* Failure is the default */
 	int			nextents, extent, cur_nextents, new_nextents;
 	unsigned		blksz_dio;
 	unsigned		dio_min;
 	struct dioattr		dio;
-	static xfs_swapext_t	sx;
 	struct xfs_flock64	space;
 	off64_t			cnt, pos;
 	void			*fbuf = NULL;
@@ -1194,6 +1189,20 @@ packfile(
 	}
 	unlink(tname);
 
+	/*
+	 * Set up everything in the swap request except for the destination
+	 * freshness check, which we'll do separately since we already have
+	 * a bulkstat.
+	 */
+	error = xfrog_file_exchange_prep(file_fd,
+			FILE_XCHG_RANGE_NONATOMIC | FILE_XCHG_RANGE_FULL_FILES,
+			0, tfd, 0, statp->bs_size, &fxr);
+	if (error) {
+		fsrprintf(_("error %d setting up swapext request\n"), error);
+		goto out;
+	}
+	xfrog_file_exchange_require_file2_fresh(&fxr, statp);
+
 	/* Setup extended attributes */
 	if (fsr_setup_attr_fork(file_fd->fd, tfd, statp) != 0) {
 		fsrprintf(_("failed to set ATTR fork on tmp: %s:\n"), tname);
@@ -1404,19 +1413,6 @@ packfile(
 		goto out;
 	}
 
-	error = -xfrog_bulkstat_v5_to_v1(file_fd, &sx.sx_stat, statp);
-	if (error) {
-		fsrprintf(_("bstat conversion error on %s: %s\n"),
-				fname, strerror(error));
-		goto out;
-	}
-
-	sx.sx_version  = XFS_SX_VERSION;
-	sx.sx_fdtarget = file_fd->fd;
-	sx.sx_fdtmp    = tfd;
-	sx.sx_offset   = 0;
-	sx.sx_length   = statp->bs_size;
-
 	/* switch to the owner's id, to keep quota in line */
         if (fchown(tfd, statp->bs_uid, statp->bs_gid) < 0) {
                 if (vflag)
@@ -1426,25 +1422,29 @@ packfile(
         }
 
 	/* Swap the extents */
-	srval = xfs_swapext(file_fd->fd, &sx);
-	if (srval < 0) {
-		if (errno == ENOTSUP) {
-			if (vflag || dflag)
-			   fsrprintf(_("%s: file type not supported\n"), fname);
-		} else if (errno == EFAULT) {
-			/* The file has changed since we started the copy */
-			if (vflag || dflag)
-			   fsrprintf(_("%s: file modified defrag aborted\n"),
-				     fname);
-		} else if (errno == EBUSY) {
-			/* Timestamp has changed or mmap'ed file */
-			if (vflag || dflag)
-			   fsrprintf(_("%s: file busy\n"), fname);
-		} else {
-			fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
-				  fname, strerror(errno));
-		}
-		goto out;
+	error = xfrog_file_exchange(file_fd, &fxr);
+	switch (error) {
+		case 0:
+			break;
+	case ENOTSUP:
+		if (vflag || dflag)
+			fsrprintf(_("%s: file type not supported\n"), fname);
+		break;
+	case EFAULT:
+	case EDOM:
+		/* The file has changed since we started the copy */
+		if (vflag || dflag)
+			fsrprintf(_("%s: file modified defrag aborted\n"),
+					fname);
+		break;
+	case EBUSY:
+		/* Timestamp has changed or mmap'ed file */
+		if (vflag || dflag)
+			fsrprintf(_("%s: file busy\n"), fname);
+		break;
+	default:
+		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
+			  fname, strerror(error));
 	}
 
 	/* Report progress */
diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
index 00277f8f0fc..84795d71db2 100644
--- a/libfrog/file_exchange.c
+++ b/libfrog/file_exchange.c
@@ -55,6 +55,23 @@ xfrog_file_exchange_prep_freshness(
 	return 0;
 }
 
+/*
+ * Enable checking that the target (or destination) file has not been modified
+ * since a particular point in time.
+ */
+void
+xfrog_file_exchange_require_file2_fresh(
+	struct file_xchg_range	*req,
+	struct xfs_bulkstat	*bulkstat)
+{
+	req->flags |= FILE_XCHG_RANGE_FILE2_FRESH;
+	req->file2_ino = bulkstat->bs_ino;
+	req->file2_mtime = bulkstat->bs_mtime;
+	req->file2_ctime = bulkstat->bs_ctime;
+	req->file2_mtime_nsec = bulkstat->bs_mtime_nsec;
+	req->file2_ctime_nsec = bulkstat->bs_ctime_nsec;
+}
+
 /* Prepare an extent swap request. */
 int
 xfrog_file_exchange_prep(
diff --git a/libfrog/file_exchange.h b/libfrog/file_exchange.h
index a77d67514e8..618c2e5aa99 100644
--- a/libfrog/file_exchange.h
+++ b/libfrog/file_exchange.h
@@ -6,6 +6,8 @@
 #ifndef __LIBFROG_FILE_EXCHANGE_H__
 #define __LIBFROG_FILE_EXCHANGE_H__
 
+void xfrog_file_exchange_require_file2_fresh(struct file_xchg_range *req,
+		struct xfs_bulkstat *bulkstat);
 int xfrog_file_exchange_prep(struct xfs_fd *file2, uint64_t flags,
 		int64_t file2_offset, int file1_fd, int64_t file1_offset,
 		int64_t length, struct file_xchg_range *req);

