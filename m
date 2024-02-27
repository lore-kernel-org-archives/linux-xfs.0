Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB03037159
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000499; cv=none; b=C0hitdcFLWYcC/wkHnWf4dNDH0Q5u/Ju93nwMI5mbGXlddbMztuv2B8/nuW7ofS1H8AXaQM2HsetgJqpV38cquR9nZnS2iY1hv2tPzQ5HJSpMgTnjxFvVyltiE1iGMXRLyYXekyFAnGufWmBEegp3luLTOwRiG7FRyCm65smeeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000499; c=relaxed/simple;
	bh=cnMne7vS8X2q/t97Pmjo9jNYm+OKB3K3u8DgKCcOr1I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D96coeSETDPCE0Gtl0WAMCO5ByNu6aCmR04Om6dUzuJYT6UwJjQR4PEfZhpZiOzsJRP4a7vzVVj5X7tAybEfF09fMeJrT/AIGSX2+XTCQ9/8KPe4TEzRNoJThCZekS3osNO2k5oX3Ot4K9G1e2QJsCxUZgzQxdNS17O1GDhJzOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WISscVyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WISscVyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5F3C433F1;
	Tue, 27 Feb 2024 02:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000499;
	bh=cnMne7vS8X2q/t97Pmjo9jNYm+OKB3K3u8DgKCcOr1I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WISscVyk3c5CA6MI/wcXuvZqzessjHr372cJ2PEv89Y1i1xQvSn/nKKDQSFTuC9rZ
	 1HLBdU9YHgA7pJbrmImdvkMyCxtUBUkWyCuds6ncVOZXUXNWGf/wzaFDp6WYDBahgF
	 9tH0QwtTGpn2bhIbw7g1H2UBC5p0uIf4/NpugaHfW7dHdMWdLtdAZNwXeXXW3LRrTt
	 IhSVIVWblgJbHMY5/e79IAvsoljrEtFB5hbItafBTDs1YK37UjikT2Ja3oykrqElh7
	 vN0FQ3a5JfpkhKPlCrAHXX45nHUQABcqR8abn1UsY8bcQv2B7DZkcLbFxiwuNLw4X4
	 bJEaptAW6wIXQ==
Date: Mon, 26 Feb 2024 18:21:38 -0800
Subject: [PATCH 03/14] xfs: create a log incompat flag for atomic file mapping
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011689.938268.15360453692750885891.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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
index fe2bd607ac11f..ede313f8371e5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -240,6 +240,9 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 
+/* file range exchange available to userspace */
+#define XFS_FSOP_GEOM_FLAGS_EXCHRANGE	(1 << 24)
+
 /*
  * Minimum and maximum sizes need for growth checks.
  *
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d991eec054368..2d8a0546ab4ba 100644
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
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHRANGE;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index d5889db89daeb..6ee181e9229a8 100644
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
index 593a85a644bce..a008b42736716 100644
--- a/fs/xfs/xfs_exchrange.h
+++ b/fs/xfs/xfs_exchrange.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_EXCHRANGE_H__
 #define __XFS_EXCHRANGE_H__
 
+bool xfs_exchrange_possible(struct xfs_mount *mp);
+
 /* Update the mtime/cmtime of file1 and file2 */
 #define __XFS_EXCHRANGE_UPD_CMTIME1	(1ULL << 63)
 #define __XFS_EXCHRANGE_UPD_CMTIME2	(1ULL << 62)

