Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E78933E7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607954; cv=none; b=couB5CeXky+l+p4InXyBebnbpGWGl3UBtU+wQ4UK6eWJzaZQwkEXeaM3nX/caS592fzupi+qTaORyUk4uVk9Z96KShlgPTiMtQDAJexCwRcWsWp2VuXOLtDFAuFT0vCkJyFhA5SSrFIEcvQPgShS3Qb4nhOy5YVAkfk5bStDF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607954; c=relaxed/simple;
	bh=pCQekLc7Auhxza0GYqw0CBMd0jUMjuz6H0lk3QjB32A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cxKS2Am+2tLd//W3TLPlpKrLWmk9svTAEBepko2vmfCXsZGIdcwRGW9v7K9kSFEy88IUxCBcPeNOQw01+TKvJEgceIcL/BSgAXGBrGx45PpUnE31vXrWlv17yM6on7Iei0vuTC/Tgs3OjCIgBbOLr1LUvbr+wtxlXnGWRxqE6sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJVfkmei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJVfkmei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12052C4CEC5;
	Fri, 11 Oct 2024 00:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607954;
	bh=pCQekLc7Auhxza0GYqw0CBMd0jUMjuz6H0lk3QjB32A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZJVfkmeiySiahWmSTDWMjqakeDX6R1NrdG+HNe5kS5CGc/xACJOJnHknQJtEPSrMC
	 7EJZuMk0WYXt3J6elrb7B+yMOYIZLRwkDMP0tD7pTrusr9h1TRvsSnCVISFA6RZZV6
	 TCwDct4t4qESvbXlySodna1yy2kpXnXpcupTKgnDIWdsB/Z9Dezh7wN1VOdfRaiSmw
	 Cn0F1qiejBborDXp/8z7TG8pzK1wctow6iTY2xD4GU4X04S6w50cjJtp813CTxUygO
	 WXsYF8np/ZYhUOMiBytMMbdm9h5yERJ2AUsAhYV+3TdCvr7bxLS8qb8Exue+2IkiLC
	 JbHTXFy+A0wJA==
Date: Thu, 10 Oct 2024 17:52:33 -0700
Subject: [PATCH 16/28] xfs: record health problems with the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642292.4176876.6236764985597752475.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h      |    1 +
 fs/xfs/libxfs/xfs_health.h  |    4 +++-
 fs/xfs/libxfs/xfs_metadir.c |   13 ++++++++++---
 fs/xfs/xfs_health.c         |    1 +
 fs/xfs/xfs_icache.c         |    1 +
 fs/xfs/xfs_inode.c          |    1 +
 6 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 499bea4ea8067f..b05e6fb1470351 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -198,6 +198,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
+#define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 9443b703d837a9..b8846d35a6adbd 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -62,6 +62,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
+#define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -105,7 +106,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
-				 XFS_SICK_FS_NLINKS)
+				 XFS_SICK_FS_NLINKS | \
+				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 0a61316b4f520f..bae7377c0f228c 100644
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
index ef1c48dc5a52a0..b149b9cf3402f1 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -380,6 +380,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
+	{ XFS_SICK_FS_METADIR,	XFS_FSOP_GEOM_SICK_METADIR },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 165ae3b0827b3f..f02feb33568474 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -877,6 +877,7 @@ xfs_trans_metafile_iget(
 whine:
 	xfs_err(mp, "metadata inode 0x%llx type %u is corrupt", ino,
 			metafile_type);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 752a4d39d5cc4f..b8dada5140c877 100644
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

