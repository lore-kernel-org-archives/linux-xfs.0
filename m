Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F69C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkNx0HKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB810C433C8;
	Sun, 31 Dec 2023 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060638;
	bh=pJkQ4EBOjTt2FeYaolhIlsXJ8GwZKXwo3NFqTegQHEE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QkNx0HKurUxAz3hXRuOxQGtd2NB0FeDCVksT2EpKabsCqdMYjbf9t0t37RO2OLDVY
	 R2HNWy8NAofCYnfgv2fIZm3RoP45XErES6x9a9+dAq2UeWqEPXQkHVJgBGH4vkd0VG
	 l81Jg6XD2W2CsgDWjFAJ4PHFOAs5ORQq5LhCQkghgL4lLrxOBvsmQdjPJP2XTGmBYL
	 AelMNV6ZP/RNO+A8urSBNS/LSSkcwAROJuW4ufiylzF2EzKhG2xNV5qUl9laKMOTSn
	 vCKb/3j0dpTjEoO1usYANy2VCqTKEISouAsKBT+BrmCCu4JPcLLVb8WrBye9D+zRwz
	 uN8jXBFmqPXkw==
Date: Sun, 31 Dec 2023 14:10:38 -0800
Subject: [PATCH 1/3] xfs: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991587.1793944.15546271111816175118.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991573.1793944.10238192046951704393.stgit@frogsfrogsfrogs>
References: <170404991573.1793944.10238192046951704393.stgit@frogsfrogsfrogs>
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

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 spaceman/health.c   |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 07acbed9235..f10d0aa0e33 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 5626e53b3f0..2bfe2dc404a 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -42,6 +42,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
+#define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -79,7 +80,8 @@ struct xfs_fsop_geom;
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
-				 XFS_SICK_FS_QUOTACHECK)
+				 XFS_SICK_FS_QUOTACHECK | \
+				 XFS_SICK_FS_NLINKS)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/spaceman/health.c b/spaceman/health.c
index 3318f9d1a7f..88b12c0b0ea 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -76,6 +76,10 @@ static const struct flag_map fs_flags[] = {
 		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
 		.descr = "quota counts",
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_NLINKS,
+		.descr = "inode link counts",
+	},
 	{0},
 };
 

