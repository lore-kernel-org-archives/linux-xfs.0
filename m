Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7254E170A16
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838026; cv=none; b=bgUVs4V5k/XKYRK1shY4UVfDp9IRYZgD/TBrrOrO2tiDi0HH7TrQun5SBKFMThzyVE9MXcalHnRPQf9l+QlDo7vnKfgHvlgiuuL5VfgvS1JvMTazUdtK15h388juBf0eGOkscsskV99UPvOCAaJwnqMwK0wjCE14e55It7VA/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838026; c=relaxed/simple;
	bh=vS77g9y2vwqQciMlX71HgjaBSrkw3Kt6j/3hcuLOVV8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GUu8BUObJn2sAhP8vlR6YxoZY/GUug6dArvwwOmf7pqiCLAEiG7S0OPpyyzqdyOIMipvX81kSVm74AfE2yHirm00Zvs3bb4XMxyT5Z1vUwLecNQyE/jDnLW1cfjBvUl56BJ6xAB3h748Y7aXH1BLKN8fN4kuBKhWB4BNPyqIrmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwACuzKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwACuzKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04173C4CEC3;
	Fri, 25 Oct 2024 06:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838026;
	bh=vS77g9y2vwqQciMlX71HgjaBSrkw3Kt6j/3hcuLOVV8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qwACuzKfOsDcBIjMSJbcqbUiO35SQlzEwWazP+v4GLF7P0beSglT6I2ObbsE0vVa1
	 jkzh+SfXdW3wrdzKJpewURRkp468AshE2HxStAsPi2XJNNdgkYx8KJti4rkfQDbfwq
	 i3lbc2NscOs7KieY7xU8y8/n1u7rLu1XWT9Cjaw5qJsBS4VYWJ3tgFv2gOc4uCmh56
	 L1nHQlGu8xg9esY1rgDMNRwder79pKzV8pT0tdnUlgZFZyl7t2XNi0CZOgbjvOFULB
	 CRdLr+XDhPZMRadc9xSZs9fuJovm6ieQNznnfjMy6MI/eFQ+GYAxJUHOyJ6bHBg38D
	 vm+SP1tbC7VvQ==
Date: Thu, 24 Oct 2024 23:33:45 -0700
Subject: [PATCH 5/7] xfs_fsr: port to new file exchange library function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773405.3040944.316630518119574344.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port fsr to use the new libfrog library functions to handle exchanging
mappings between the target and donor files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c |   74 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 34 insertions(+), 40 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 22e134adfd73ab..8845ff172fcb2e 100644
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
@@ -1189,14 +1184,13 @@ packfile(
 	struct xfs_bulkstat	*statp,
 	struct fsxattr		*fsxp)
 {
+	struct xfs_commit_range	xdf;
 	int			tfd = -1;
-	int			srval;
 	int			retval = -1;	/* Failure is the default */
 	int			nextents, extent, cur_nextents, new_nextents;
 	unsigned		blksz_dio;
 	unsigned		dio_min;
 	struct dioattr		dio;
-	static xfs_swapext_t	sx;
 	struct xfs_flock64	space;
 	off_t			cnt, pos;
 	void			*fbuf = NULL;
@@ -1239,6 +1233,16 @@ packfile(
 		goto out;
 	}
 
+	/*
+	 * Snapshot file_fd before we start copying data but after tweaking
+	 * forkoff.
+	 */
+	error = xfrog_defragrange_prep(&xdf, file_fd->fd, statp, tfd);
+	if (error) {
+		fsrprintf(_("failed to prep for defrag: %s\n"), strerror(error));
+		goto out;
+	}
+
 	/* Setup extended inode flags, project identifier, etc */
 	if (fsxp->fsx_xflags || fsxp->fsx_projid) {
 		if (ioctl(tfd, FS_IOC_FSSETXATTR, fsxp) < 0) {
@@ -1446,19 +1450,6 @@ packfile(
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
@@ -1468,25 +1459,28 @@ packfile(
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
+	error = xfrog_defragrange(file_fd->fd, &xdf);
+	switch (error) {
+		case 0:
+			break;
+	case ENOTSUP:
+		if (vflag || dflag)
+			fsrprintf(_("%s: file type not supported\n"), fname);
+		break;
+	case EFAULT:
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

