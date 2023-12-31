Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4E0C8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HopOfADA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93F4C433C7;
	Sun, 31 Dec 2023 22:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061889;
	bh=dfpbXgnawP+eC94JS7M3yTs20cXzv3aaDRcKn3DO+9g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HopOfADAMnX8Z6KblX74XFVfNR/KXNl7YqAHbC6sfZtxANUs2TNSjS/6gM7Scev+I
	 ZpfR6NVX3Jj2bkjwZmDjxfrB3fWgihmdxTMPwjq5wjM01qYzAdebkDcc0DytmoLceF
	 nvhu1944QHbnq6Jes6v/esI5eHm/vJJISpeLsPPPLqBxd/jWNs8I2XBK3Y784JQhBo
	 ArvbYFfIM2XLBAkC9/RLSPZ/TftAZgr5wFspFlkg+bmuBOMEKzTF7/Ulant91DdAQh
	 WEFYjOu3xAiml01zNZFlpmkYl1YgFVtOsD9R3uWjEzkJ70NXvFHse+rfGHPmYDY8Z2
	 9ifTDxApJ4I4A==
Date: Sun, 31 Dec 2023 14:31:29 -0800
Subject: [PATCH 17/20] xfs_fsr: port to new swapext library function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996502.1796128.17245080944113896708.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port fsr to use the new libfrog library functions to handle swapext.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c           |   79 +++++++++++++++++++++++------------------------
 libfrog/file_exchange.c |   17 ++++++++++
 libfrog/file_exchange.h |    2 +
 3 files changed, 58 insertions(+), 40 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8e916faee94..37cacffa0fd 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -13,6 +13,7 @@
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
+#include "libfrog/file_exchange.h"
 
 #include <fcntl.h>
 #include <errno.h>
@@ -122,12 +123,6 @@ open_handle(
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
@@ -1150,14 +1145,13 @@ packfile(
 	struct xfs_bulkstat	*statp,
 	struct fsxattr		*fsxp)
 {
+	struct xfs_exch_range	fxr;
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
@@ -1194,6 +1188,20 @@ packfile(
 	}
 	unlink(tname);
 
+	/*
+	 * Set up everything in the swap request except for the destination
+	 * freshness check, which we'll do separately since we already have
+	 * a bulkstat.
+	 */
+	error = xfrog_file_exchange_prep(file_fd,
+			XFS_EXCH_RANGE_NONATOMIC | XFS_EXCH_RANGE_FULL_FILES,
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
@@ -1404,19 +1412,6 @@ packfile(
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
@@ -1426,25 +1421,29 @@ packfile(
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
index 4a66aa752fc..5a527489aa5 100644
--- a/libfrog/file_exchange.c
+++ b/libfrog/file_exchange.c
@@ -54,6 +54,23 @@ xfrog_file_exchange_prep_freshness(
 	return 0;
 }
 
+/*
+ * Enable checking that the target (or destination) file has not been modified
+ * since a particular point in time.
+ */
+void
+xfrog_file_exchange_require_file2_fresh(
+	struct xfs_exch_range	*req,
+	struct xfs_bulkstat	*bulkstat)
+{
+	req->flags |= XFS_EXCH_RANGE_FILE2_FRESH;
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
index 7b6ce11810b..63dedf46a2f 100644
--- a/libfrog/file_exchange.h
+++ b/libfrog/file_exchange.h
@@ -6,6 +6,8 @@
 #ifndef __LIBFROG_FILE_EXCHANGE_H__
 #define __LIBFROG_FILE_EXCHANGE_H__
 
+void xfrog_file_exchange_require_file2_fresh(struct xfs_exch_range *req,
+		struct xfs_bulkstat *bulkstat);
 int xfrog_file_exchange_prep(struct xfs_fd *file2, uint64_t flags,
 		int64_t file2_offset, int file1_fd, int64_t file1_offset,
 		int64_t length, struct xfs_exch_range *req);

