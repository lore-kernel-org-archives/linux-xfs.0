Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AECC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huSzE6/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2036C433C8;
	Sun, 31 Dec 2023 23:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065719;
	bh=XflgPEAVTZMN3uTiFG6K9VuwjZ8mAV3dvhHyYOt7B3c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=huSzE6/zzXq96TGqyVf3X3aFtvpQCNYikC8sUmQ5ohXHCzq4R/LuRJRGPl/rjZ8q8
	 kjnnOu3IWc1BF7pfdicVo8ze5eKuPan1zKFSH9bpM7XEcAGQpBi10HwSDmgSZx1gd0
	 mhqUK1Um31C3irCf9l0KxqQCNKZkgCO7t+6PE7fRd2DrltZxxHJt5PoIPdCsH4R132
	 DAKpVaGLadolJKhvmTmuI1bLE/BpkX+LY/HRA+PiZEVSYwEnRDf+bw6Ej8bzwOSoY4
	 PXM6VuJaTlPXKmjBIUoMq4DwkRELmmO7kOAky9yMNTsmBEPgDTkPJQEYiZduxRAdQa
	 vPrO9BfZpm7TQ==
Date: Sun, 31 Dec 2023 15:35:19 -0800
Subject: [PATCH 22/58] xfs: check metadata directory file path connectivity
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010241.1809361.1551820119699455070.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Create a new scrubber type that checks that well known metadata
directory paths are connected to the metadata inode that the incore
structures think is in use.  IOWs, check that "/quota/user" in the
metadata directory tree actually points to
mp->m_quotainfo->qi_uquotaip->i_ino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                     |   17 +++++++++++++++-
 libxfs/xfs_health.h                 |    4 +++-
 man/man2/ioctl_xfs_scrub_metadata.2 |   38 +++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 952e4fc93c4..a0efcbde5ae 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -198,6 +198,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 #define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
+#define XFS_FSOP_GEOM_SICK_METAPATH	(1 << 9)  /* metadir tree path */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -731,9 +732,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
+#define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	29
+#define XFS_SCRUB_TYPE_NR	30
 
 /*
  * This special type code only applies to the vectored scrub implementation.
@@ -788,6 +790,19 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+/*
+ * i: sm_ino values for XFS_SCRUB_TYPE_METAPATH to select a metadata file for
+ * path checking.
+ */
+#define XFS_SCRUB_METAPATH_RTBITMAP	0
+#define XFS_SCRUB_METAPATH_RTSUMMARY	1
+#define XFS_SCRUB_METAPATH_USRQUOTA	2
+#define XFS_SCRUB_METAPATH_GRPQUOTA	3
+#define XFS_SCRUB_METAPATH_PRJQUOTA	4
+
+/* Number of metapath sm_ino values */
+#define XFS_SCRUB_METAPATH_NR		5
+
 /*
  * ioctl limits
  */
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index d9b9968607f..1816c67351a 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -61,6 +61,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 #define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
+#define XFS_SICK_FS_METAPATH	(1 << 7)  /* metadata directory tree path */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -105,7 +106,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
 				 XFS_SICK_FS_NLINKS | \
-				 XFS_SICK_FS_METADIR)
+				 XFS_SICK_FS_METADIR | \
+				 XFS_SICK_FS_METAPATH)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 44aa139b297..b1db740560d 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -200,6 +200,44 @@ Scan all inodes in the filesystem to verify each file's link count.
 Mark everything healthy after a clean scrub run.
 This clears out all the indirect health problem markers that might remain
 in the system.
+
+.TP
+.B XFS_SCRUB_TYPE_METAPATH
+Check that a metadata directory path actually points to the active metadata
+inode.
+Metadata inodes are usually cached for the duration of the mount, so this
+scrubber ensures that the same inode will still be reachable after an unmount
+and mount cycle.
+Discrepancies can happen if the directory or parent pointer scrubbers rebuild
+a metadata directory but lose a link in the process.
+The
+.B sm_ino
+field should be passed one of the following special values to communicate which
+path to check:
+
+.RS 7
+.TP
+.B XFS_SCRUB_METAPATH_RTBITMAP
+Realtime bitmap file.
+.TP
+.B XFS_SCRUB_METAPATH_RTSUMMARY
+Realtime summary file.
+.TP
+.B XFS_SCRUB_METAPATH_USRQUOTA
+User quota file.
+.TP
+.B XFS_SCRUB_METAPATH_GRPQUOTA
+Group quota file.
+.TP
+.B XFS_SCRUB_METAPATH_PRJQUOTA
+Project quota file.
+.RE
+
+The values of
+.I sm_agno
+and
+.I sm_gen
+must be zero.
 .RE
 
 .PD 1

