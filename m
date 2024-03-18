Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C3C58230
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798418; cv=none; b=n8e5tCWOj9K5eJKwTBtbPU4EGGM5NFNrmg8dYFv2OcL1Bc+SFwpqC3vYBqAmH2LFl7JUScmRiWBR3a3Iks6HznOsm3jy45W+jtedsNj3JkAHl7aX5CKARzZNoxixhKofnAeNEN5a/H0YY9JikFkAqrWwumLYjcgTzzcP1FKPIPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798418; c=relaxed/simple;
	bh=RvFX+K8I9vppY0dqknlmY4o2Q69HVBHm5lRDpBFo2tA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jofoTxLUu5+arhOAGFEiPNfeiuh9zrHZKS6mmXZFRmm2czzvriJxeAMo3AVHQ9fQGZIJZz73RvAC+BD3n8RflnIx/q7EVdJGrB0MV1uAvAAwj3UPVVC2KLBB3LA6AeTaDjFjDSqlc2iHAIvMTgcNuwAZ9fcEb5ECcVWUoJldvBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjhcPSJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjhcPSJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE32C433C7;
	Mon, 18 Mar 2024 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798417;
	bh=RvFX+K8I9vppY0dqknlmY4o2Q69HVBHm5lRDpBFo2tA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BjhcPSJkWOPv/dJD7NTdpDumgL6ch2/ltw6epPHPSj3lKCTNOCBWfQUEuzI4Xlrn6
	 JlxGdE4cnTOl8M97YW+InDQBmEbilLdotOrb89Gdj48y83Ma9XdHNsQ49leo4KguaZ
	 pV8uc3m4VdIIXS6UHBU2OXluUFTyesOAqqMOAy6mXj3l2HBRnzjqh4VBFE6mx3G749
	 tWBiFcMCPBn49a1ysdH4WXo0jGgCVWssP+MDVNrzEFdT/yEYGBg9b1aEqg1Rt3YkTC
	 DvjjbSWqfGMx2Git6L30ZaU3qtMIjwzi3EvHbMYC2wOa1R/lMHvi7lvB9lMi5mpYhR
	 Doy7jIRoefHxw==
Date: Mon, 18 Mar 2024 14:46:57 -0700
Subject: [PATCH 19/23] xfs: Add the parent pointer support to the superblock
 version 5.
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, allison.henderson@oracle.com,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802183.3806377.393240646221915919.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add the parent pointer superblock flag so that we can actually mount
filesystems with this feature enabled.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    4 +++-
 fs/xfs/libxfs/xfs_fs.h     |    2 ++
 fs/xfs/libxfs/xfs_sb.c     |    4 ++++
 fs/xfs/xfs_super.c         |    4 ++++
 4 files changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a823bba1f7d79..859062ab6c306 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8ab8de8a6e632..e54938d5b928b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -243,6 +243,8 @@ typedef struct xfs_fsop_resblks {
 /* file range exchange available to userspace */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE	(1 << 24)
 
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1U << 30) /* parent pointers */
+
 /*
  * Minimum and maximum sizes need for growth checks.
  *
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index c2d86faeee61b..22f5420adb3e5 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -176,6 +176,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1251,6 +1253,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 15b59c37e0ed1..ecf837f84ec0c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1741,6 +1741,10 @@ xfs_fs_fill_super(
 		goto out_filestream_unmount;
 	}
 
+	if (xfs_has_parent(mp))
+		xfs_warn(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

