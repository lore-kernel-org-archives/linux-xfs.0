Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAA419E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371549; cv=none; b=uk2UzK7kVsd+A1AgL7mthxWjcNBDzYD4QkAd/cxsLb7Cazz5ga2f3035Uwbw6haxNXtnpIH9CNmOCGSX1X84iO55jjrTbCzcW8Vv50dbAC4EZ2oDjhHnxiQMOs/gUWpnLF4vDToNJwYmdQozp3DqPeNSZ+f4GX9kseCtEjNkX2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371549; c=relaxed/simple;
	bh=QNtjBnbem8poj8XPkW49LFQm+IcsJ/t276hTBxgmlS4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBxzm2Hc58SnDPTpRTNjse36G7n3Ucvk+nlDPHg1xwo5chcsyzDtzE3+ZfnfFTSXe01GvbFCGZzcGKFyyrGnIAo7Oz9I3mVnCZF01dfwdbdCUib6w7t9Id1ohFPAI1VPUM0L3M82TIArinQAXJnciC4glh2kZiKUKwee3iHeklI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DW1FlngA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DW1FlngA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC23C32782;
	Fri, 23 Aug 2024 00:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371548;
	bh=QNtjBnbem8poj8XPkW49LFQm+IcsJ/t276hTBxgmlS4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DW1FlngAKzLxa7kwTaFqV6iyyOZ5VwrYl1EyJRm8LAHkSYf5m78/NXavl+7dAWo5x
	 Oy1EnV/Q7CmV3jo1gPpeMLszOWYYqzq5REmoyqIc9gtisg5JOp6J1XYaIKaeADlr2k
	 8wKhbCLR3Au30iUvwq9XNTRRJsKmei5rQZ+ldpvMyxYp6oqKj7u+kfWaLq1iAVBccH
	 4VCixmo58UJ1hjU2dVAGmAm/NVhbquqUfD31JOjYNpu0mBMDm4re+CHZUFr0CUY89X
	 uTpEnj6/mZf510YFXHt3Axsmd/jFTsSonyIv7G/ukKutXTrUu6kHDkBS5DT6gFgtNA
	 TZSxjhxdM/4eA==
Date: Thu, 22 Aug 2024 17:05:48 -0700
Subject: [PATCH 14/26] xfs: record health problems with the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085417.57482.10297933158673089064.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Make a report to the health monitoring subsystem any time we encounter
something in the metadata directory tree that looks like corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h      |    1 +
 fs/xfs/libxfs/xfs_health.h  |    4 +++-
 fs/xfs/libxfs/xfs_metadir.c |   13 ++++++++++---
 fs/xfs/xfs_health.c         |    1 +
 fs/xfs/xfs_icache.c         |    1 +
 fs/xfs/xfs_inode.c          |    1 +
 6 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index cb7563d330d0f..6f5aebaf47ac8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -197,6 +197,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
+#define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index b0edb4288e592..0ded0cd93ce63 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -60,6 +60,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
+#define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -103,7 +104,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
-				 XFS_SICK_FS_NLINKS)
+				 XFS_SICK_FS_NLINKS | \
+				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 0a61316b4f520..bae7377c0f228 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_parent.h"
+#include "xfs_health.h"
 
 /*
  * Metadata Directory Tree
@@ -94,8 +95,10 @@ xfs_metadir_lookup(
 	};
 	int			error;
 
-	if (!S_ISDIR(VFS_I(dp)->i_mode))
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
@@ -103,10 +106,14 @@ xfs_metadir_lookup(
 	if (error)
 		return error;
 
-	if (!xfs_verify_ino(mp, args.inumber))
+	if (!xfs_verify_ino(mp, args.inumber)) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
-	if (xname->type != XFS_DIR3_FT_UNKNOWN && xname->type != args.filetype)
+	}
+	if (xname->type != XFS_DIR3_FT_UNKNOWN && xname->type != args.filetype) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	trace_xfs_metadir_lookup(dp, xname, args.inumber);
 	*ino = args.inumber;
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 10f116d093a22..d5367fd2d0615 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -376,6 +376,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
+	{ XFS_SICK_FS_METADIR,	XFS_FSOP_GEOM_SICK_METADIR },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c5ccfbbb98c5c..321efbf6656fa 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -858,6 +858,7 @@ xfs_trans_metafile_iget(
 whine:
 	xfs_err(mp, "metadata inode 0x%llx type %u is corrupt", ino,
 			metafile_type);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 35acb73665fdd..fff3037e67574 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -560,6 +560,7 @@ xfs_lookup(
 	 * a metadata file.
 	 */
 	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadir_inode(*ipp))) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		goto out_irele;
 	}

