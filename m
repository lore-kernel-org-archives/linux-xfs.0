Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235E01DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845108; cv=none; b=q8Dc5ebUaHtXbk0Ee0sXmBcRC6+lWknRGLXFY08kT92u0+sEFl+aNDcC7dmkTC6Su/uyARu6qwnah5/XTwOIxPBiNMRS4UJOBLd90fKWPzIGsmTQ4wgaCLci0zD/9r+Sw2IPxIzSUWAo1RcEl9ar/nhKPTYjJt0yITHijqKU9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845108; c=relaxed/simple;
	bh=jjf/1TIPTAmt1avp1fMRq7hCUGfl7lS9hSkigYlR0CY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BW+47HDGBOiM2B+RBE9ofPpF/bAueWFhO6ni+gNbLn31Xkq/hwW+FY2gea/qmWWSpr32aB6325bvfE/aW6kJVIYzre6BCNZpZ+fpB+c6xhAXBjYCIm/A9v1YlKi2Mlb7pjEDVUOItl6hXi1N8aM2PrFiz4OhDW3YSP3QfKBWV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWQf2Hoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWQf2Hoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FE1C4CED1;
	Tue,  5 Nov 2024 22:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845108;
	bh=jjf/1TIPTAmt1avp1fMRq7hCUGfl7lS9hSkigYlR0CY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MWQf2HoiwoutxKHGRw3V1Sy3Q1tb//1fw0AEREqnAebpSRfUB6e1HENJ6EOiz2kyv
	 dzemrHvC3NSO+QGnYlyyJO7lhxHqIttT48jHTIl1vZtwfGflYeCQCKmrnkx/IyKrHs
	 GFsubZhupZWXJWDwMaEa1pS3lXds5YfAcDSn46jQ8s75NFP9WUZbmnrx09JdjWU1HV
	 OvU2O5SFr19fCYsxohwM7uHSTU8QMbspJ006KOHDIp3iExmFcsE4MN6qte1efVwAGf
	 cRqs3Gvtnys+e5BWcBvOvBofFGuiwCBT1r9B/igaAZlI/f2saIjdawXVxoTYuTEyO7
	 qAQ1EkZAeo+WQ==
Date: Tue, 05 Nov 2024 14:18:27 -0800
Subject: [PATCH 07/28] xfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396140.1870066.2494746728560562508.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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
index 6aaacfc0487e90..71ed04ddd737de 100644
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

