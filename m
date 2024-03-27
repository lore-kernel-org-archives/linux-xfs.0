Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0161C6A8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504417; cv=none; b=ZczEpBc/eHvvAWbiDppAjXoo7qbbrEt2Ob0AK/fmO+Amd/WEm/2IxKU76cWw6kSQFZUmxqHgRiVWIk8Q31lODtCCiIsQZ8Jx/ZkLDKWADb1mHgaqeC7WCL1maqfLth/N7DMAsQKWDykjNSmQq/bk4ueMVNJ0ozuGQpby75NE0TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504417; c=relaxed/simple;
	bh=mJUUTvSJ7OC7/4A+oy7cwlnLqrWEeON0bMSb1rF8w8A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FN4XI9TX0BzN6z1327Oir8DWmgrgGWO/pxDvyCagRFN0TdbA/5VDN5EZq7aAM79QD0AbtvYzZOWClwcmw0P8OWpf9yvRPMUOSR+G9tpBpbyg1xIJ4V03pgSHMHWUkE+/2szzlunmGB+jrYCA1mJrLK51uLMVfJrdYM2D9ibO9MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZuMBSOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZuMBSOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80042C433F1;
	Wed, 27 Mar 2024 01:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504417;
	bh=mJUUTvSJ7OC7/4A+oy7cwlnLqrWEeON0bMSb1rF8w8A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mZuMBSOu+NawznGY9nScxN7PrHssjbswKQPZHVD4XVtjwQ6VeEvXj72AzsC/u9wmy
	 TWS9NSEeiUnbRS3C/pxow11jmyeMrS+THGt+RqQh7UbzxQfrr9ukBgYHoAWzmfpNEG
	 ofcNnpVbTTUOMXZFF/E25oBDgsWBoPU8RSEMRxGGTj92Ugne8+UoQVsviZkKA7xwOE
	 c9neraGTaR5DamMzl/EfcnqLqVZBav7uZTKtJ5in3xEVTP3mg49AdGDkqRJ3cPldte
	 nwk+1A0hkTCWs+h3B8o8zheMLHcUCPjH3q587MzIo8jjaaAvl9xPkeDH+I01bEzk5q
	 DKG/01P63F6QA==
Date: Tue, 26 Mar 2024 18:53:36 -0700
Subject: [PATCH 03/15] xfs: create a log incompat flag for atomic file mapping
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380715.3216674.13307875397061790548.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
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

Create a log incompat flag so that we only attempt to process file
mapping exchange log items if the filesystem supports it, and a geometry
flag to advertise support if it's present or could be present.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
 fs/xfs/libxfs/xfs_fs.h     |    3 +++
 fs/xfs/libxfs/xfs_sb.c     |    3 +++
 fs/xfs/xfs_exchrange.c     |   31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_exchrange.h     |    2 ++
 5 files changed, 52 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2b2f9050fbfbb..753adde56a2d0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -391,6 +391,12 @@ xfs_sb_has_incompat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+
+/*
+ * Log contains file mapping exchange log intent items which are not otherwise
+ * protected by an INCOMPAT/RO_COMPAT feature flag.
+ */
+#define XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS (1 << 1)
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
 	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
@@ -423,6 +429,13 @@ static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
 		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
 }
 
+static inline bool xfs_sb_version_haslogexchmaps(struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) &&
+		(sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS);
+}
+
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8a1e30cf4dc88..ea07fb7b89722 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -240,6 +240,9 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 
+/* file range exchange available to userspace */
+#define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE	(1 << 24)
+
 /*
  * Minimum and maximum sizes need for growth checks.
  *
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d991eec054368..c2d86faeee61b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_exchrange.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1258,6 +1259,8 @@ xfs_fs_geometry(
 	}
 	if (xfs_has_large_extent_counts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+	if (xfs_exchrange_possible(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index a575e26ae1a58..620cf1eb7464b 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -15,6 +15,37 @@
 #include "xfs_exchrange.h"
 #include <linux/fsnotify.h>
 
+/*
+ * If the filesystem has relatively new features enabled, we're willing to
+ * upgrade the filesystem to have the EXCHMAPS log incompat feature.
+ * Technically we could do this with any V5 filesystem, but let's not deal
+ * with really old kernels.
+ */
+static inline bool
+xfs_exchrange_upgradeable(
+	struct xfs_mount	*mp)
+{
+	return xfs_has_bigtime(mp) || xfs_has_large_extent_counts(mp);
+}
+
+/*
+ * Decide if we should advertise to userspace the potential for using file
+ * range exchanges on this filesystem.  This does not say anything about the
+ * actual readiness to start such an operation.
+ */
+bool
+xfs_exchrange_possible(
+	struct xfs_mount	*mp)
+{
+	/* Always possible when mapping exchange log intent items are enabled */
+	if (xfs_sb_version_haslogexchmaps(&mp->m_sb))
+		return true;
+
+	/* Can we upgrade the fs to have the log intent item? */
+	return xfs_exchrange_upgradeable(mp) &&
+	       xfs_can_add_incompat_log_features(mp, false);
+}
+
 /*
  * Generic code for exchanging ranges of two files via XFS_IOC_EXCHANGE_RANGE.
  * This part deals with struct file objects and byte ranges and does not deal
diff --git a/fs/xfs/xfs_exchrange.h b/fs/xfs/xfs_exchrange.h
index 923c386cb9756..a6e35942d9442 100644
--- a/fs/xfs/xfs_exchrange.h
+++ b/fs/xfs/xfs_exchrange.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_EXCHRANGE_H__
 #define __XFS_EXCHRANGE_H__
 
+bool xfs_exchrange_possible(struct xfs_mount *mp);
+
 /* Update the mtime/cmtime of file1 and file2 */
 #define __XFS_EXCHANGE_RANGE_UPD_CMTIME1	(1ULL << 63)
 #define __XFS_EXCHANGE_RANGE_UPD_CMTIME2	(1ULL << 62)

