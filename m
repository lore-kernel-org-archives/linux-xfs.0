Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4F0A21
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371393; cv=none; b=NEpR2f1dUg8qHmhKx6skOn5GUAKuNPmCPq/CIhQ4T1rck1n/KX/Zp8FfT9BpYgixnpa8edwCyKGL3GnnIFGHknYKK+sgBDhnOX6pfq9gp7i6A3On7BXc7id4CxtAU4gSvgEt1bsgkBimeIfkqAXLC4K/VbHs6MD+IK7JUcZII9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371393; c=relaxed/simple;
	bh=Hf07StDQa1HiKs7MLHCugMhzDNXMUtBBZyxZ/ToV3Ww=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xnajkdc+/cyHLXLyaD1vJOpCp4VWey2yT92qa6N5dMfxo8s/pcEkAzasa0FV+0bbVOHMHZzJoto1aXIy/69lH1+PlBOBx9hg8SeW46UYwYSodsoqY7xAztR86GCocbNoatgYPGqMcBSBh38WVpQpl2dPNY2mUR9UkldpNKprRJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wvh5MB/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wvh5MB/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFCCC32782;
	Fri, 23 Aug 2024 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371392;
	bh=Hf07StDQa1HiKs7MLHCugMhzDNXMUtBBZyxZ/ToV3Ww=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wvh5MB/B4WLekkAsX5eYoXYYbGP4G+FbULKYTqbhHZIfUcGVV8dY6BhH1902p9KDm
	 81A9dB4fW9YANYSaPKiqe1vv++ZRahhrr/1hRenQC4DBOh8aZwiMusAT2Gnuem27Di
	 0K7qsPzTDeUF5kMFYy+p+5L/ntxCZp6YgC96Kt4XKosagpT3Bt9q3JBQTmivPrApzm
	 KTHkCUYqqltK9NUr7hcP15Md6Eyeu5QCDmIAEGomOedFvr8arbRCd5iq9YQ8Iek/sQ
	 DnGGQz9rapS7ypx7CS1iQJ3lxExXm26lkCNmFTInpQCxhVmRhwjNIhq/cPZJnqjg9J
	 fV9K2YrgvXAjw==
Date: Thu, 22 Aug 2024 17:03:12 -0700
Subject: [PATCH 04/26] xfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085241.57482.14718872314000238810.stgit@frogsfrogsfrogs>
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

Load the metadata directory root inode into memory at mount time and
release it at unmount time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |   31 +++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h |    1 +
 2 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 09eef1721ef4f..b0ea88acdb618 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -616,6 +617,22 @@ xfs_mount_setup_inode_geom(
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
@@ -862,6 +879,12 @@ xfs_mountfs(
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
@@ -872,7 +895,7 @@ xfs_mountfs(
 		xfs_warn(mp,
 			"Failed to read root inode 0x%llx, error %d",
 			sbp->sb_rootino, -error);
-		goto out_log_dealloc;
+		goto out_free_metadir;
 	}
 
 	ASSERT(rip != NULL);
@@ -1014,6 +1037,9 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+ out_free_metadir:
+	if (mp->m_metadirip)
+		xfs_irele(mp->m_metadirip);
 
 	/*
 	 * Inactivate all inodes that might still be in memory after a log
@@ -1035,7 +1061,6 @@ xfs_mountfs(
 	 * quota inodes.
 	 */
 	xfs_unmount_flush_inodes(mp);
- out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
 	shrinker_free(mp->m_inodegc_shrinker);
@@ -1087,6 +1112,8 @@ xfs_unmountfs(
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
+	if (mp->m_metadirip)
+		xfs_irele(mp->m_metadirip);
 
 	xfs_unmount_flush_inodes(mp);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d404ce122f238..6251ebced3062 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -93,6 +93,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	struct xfs_buftarg	*m_ddev_targp;	/* data device */
 	struct xfs_buftarg	*m_logdev_targp;/* log device */

