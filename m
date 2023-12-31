Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB913C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ie0SESzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5362FC433C8;
	Sun, 31 Dec 2023 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060842;
	bh=s58YCXnXaAZfyDaCElKjOD1jqgJzyUShY38omCgri2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ie0SESzyVWRKEt2dQZiFr+mFqqh1VcMvDWqlFlw6WQsu/djY4DdawVvQM8dTTqr6x
	 GVpcTdV5ETvzrt+hU0SnEnvItmpXuTCnPZp0HdppLugBUKalvbQhQtQK3ePwV0ymeG
	 DWbsiiSX+VuvvwErN/883fxSPWkE2Qx+al1nJG3m9aqGqETfrD91LqwbfImU6YKBa8
	 06jmpOSXFjKiT5sB/mCqHVJak1As0f8+507dkvOa5T4NcUix/Zafq2+R8934d6s4W7
	 S2IpokPMLm1sM/i0wASDTK0gCiXT9LSiFylISaTjYvzZjJWrfOHQR+1u9M9JmZVLbo
	 6yklItoteaiHA==
Date: Sun, 31 Dec 2023 14:14:01 -0800
Subject: [PATCH 2/4] xfs: remember sick inodes that get inactivated
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992428.1794340.11675530389388113218.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
References: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
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

If an unhealthy inode gets inactivated, remember this fact in the
per-fs health summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h        |    1 +
 libxfs/xfs_health.h    |    8 ++++++--
 libxfs/xfs_inode_buf.c |    2 +-
 spaceman/health.c      |    4 ++++
 4 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 515cd27d3b3..b5c8da7e6aa 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -294,6 +294,7 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
+#define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 26a2661571b..df07c5877ba 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -76,6 +76,7 @@ struct xfs_da_args;
 #define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+#define XFS_SICK_AG_INODES	(1 << 10) /* inactivated bad inodes */
 
 /* Observable health issues for inode metadata. */
 #define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
@@ -92,6 +93,9 @@ struct xfs_da_args;
 #define XFS_SICK_INO_DIR_ZAPPED		(1 << 10) /* directory erased */
 #define XFS_SICK_INO_SYMLINK_ZAPPED	(1 << 11) /* symlink erased */
 
+/* Don't propagate sick status to ag health summary during inactivation */
+#define XFS_SICK_INO_FORGET	(1 << 12)
+
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
@@ -132,12 +136,12 @@ struct xfs_da_args;
 #define XFS_SICK_FS_SECONDARY	(0)
 #define XFS_SICK_RT_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
-#define XFS_SICK_INO_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
 #define XFS_SICK_RT_INDIRECT	(0)
-#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 83d93698116..82cf64db938 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -136,7 +136,7 @@ xfs_imap_to_bp(
 			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
-				XFS_SICK_AG_INOBT);
+				XFS_SICK_AG_INODES);
 	return error;
 }
 
diff --git a/spaceman/health.c b/spaceman/health.c
index 88b12c0b0ea..12fb67bab28 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -127,6 +127,10 @@ static const struct flag_map ag_flags[] = {
 		.descr = "reference count btree",
 		.has_fn = has_reflink,
 	},
+	{
+		.mask = XFS_AG_GEOM_SICK_INODES,
+		.descr = "overall inode state",
+	},
 	{0},
 };
 

