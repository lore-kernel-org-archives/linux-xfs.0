Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31E219488
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191352; cv=none; b=biqHoxtGp2ycAjPytPFLIj9XIVLATsf5JWzoTUds+6QrZ2N8rhr5b7+sk6yH0nL+y5h2t3AjFS1dqejx179Y/KXzL5E2mw578Zbwi3prkJsq4IGarH8zX2Wsn98vdTMyhJ3aWlJXxlaT7yj1DyNjABj2hDlyTuG9I99IkOzIH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191352; c=relaxed/simple;
	bh=+i2gtaZlhPRu6eH+WD3AS8HOgE3e/GG4E95wmb1PPns=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDsYDT7pDGuB9pe3hOrjv0fvAf9oQ8001DQW3EZwWVRWmuyLqDSCzikYa14n5B40gw5FJdrBlOz4YnNFBU3gEhFDCcRUelTJgP8QQ2FMoPMmjSNqlcm1iHmKW/Ji4wssJP3C7vmV+Pc4xU5uOFYxO3eTqVai2mAw9zYEtfFCrRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDd0/8eV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDd0/8eV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CDEC4CECD;
	Thu, 17 Oct 2024 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191352;
	bh=+i2gtaZlhPRu6eH+WD3AS8HOgE3e/GG4E95wmb1PPns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vDd0/8eVGVQye5j8KlIixha77BIoAV9SAsUaKr+iT/8eqi3F7utf1ZanVHUDpdAvU
	 buo7c8PoqQQrJGI5Tvx50yJh5l934Ri4CY9kfNu/DAaMgdCuMqDid6s9+Qmf79xWiv
	 qINKqZqZNRRWpGbS0z+cNdUsZtWFYk635jxnXq6nUGPkJluv717Gjskp/oBmnMeFCQ
	 OxZZuYo/0h55RBDR0yZbN8kbn5lDZzqs8MdRVBznr8zyvAAlcJwyxz3f5aozHmHkM7
	 H8zkZ+9FBVTm6tt1pcdUpbbXoGwbEMbTQMjZkKVc6+3EFVdNbkij7l81CJe7HBBd3s
	 vGNJi2tAp8RWQ==
Date: Thu, 17 Oct 2024 11:55:52 -0700
Subject: [PATCH 07/29] xfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069568.3451313.16618351746744803410.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Load the metadata directory root inode into memory at mount time and
release it at unmount time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c |   31 +++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h |    1 +
 2 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 25bbcc3f4ee08b..2dd2606fc7e3e4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -620,6 +621,22 @@ xfs_mount_setup_inode_geom(
 	xfs_ialloc_setup_geometry(mp);
 }
 
+/* Mount the metadata directory tree root. */
+STATIC int
+xfs_mount_setup_metadir(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	/* Load the metadata directory root inode into memory. */
+	error = xfs_metafile_iget(mp, mp->m_sb.sb_metadirino, XFS_METAFILE_DIR,
+			&mp->m_metadirip);
+	if (error)
+		xfs_warn(mp, "Failed to load metadir root directory, error %d",
+				error);
+	return error;
+}
+
 /* Compute maximum possible height for per-AG btree types for this fs. */
 static inline void
 xfs_agbtree_compute_maxlevels(
@@ -866,6 +883,12 @@ xfs_mountfs(
 		mp->m_features |= XFS_FEAT_ATTR2;
 	}
 
+	if (xfs_has_metadir(mp)) {
+		error = xfs_mount_setup_metadir(mp);
+		if (error)
+			goto out_free_metadir;
+	}
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
@@ -876,7 +899,7 @@ xfs_mountfs(
 		xfs_warn(mp,
 			"Failed to read root inode 0x%llx, error %d",
 			sbp->sb_rootino, -error);
-		goto out_log_dealloc;
+		goto out_free_metadir;
 	}
 
 	ASSERT(rip != NULL);
@@ -1018,6 +1041,9 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+ out_free_metadir:
+	if (mp->m_metadirip)
+		xfs_irele(mp->m_metadirip);
 
 	/*
 	 * Inactivate all inodes that might still be in memory after a log
@@ -1039,7 +1065,6 @@ xfs_mountfs(
 	 * quota inodes.
 	 */
 	xfs_unmount_flush_inodes(mp);
- out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
 	shrinker_free(mp->m_inodegc_shrinker);
@@ -1091,6 +1116,8 @@ xfs_unmountfs(
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
+	if (mp->m_metadirip)
+		xfs_irele(mp->m_metadirip);
 
 	xfs_unmount_flush_inodes(mp);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 09a7fe1f81420e..1da0e10a9e2e6b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,6 +127,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	struct xfs_buftarg	*m_ddev_targp;	/* data device */
 	struct xfs_buftarg	*m_logdev_targp;/* log device */

