Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A923620
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371408; cv=none; b=DF/ROu4+DPGr3ckS+nnSE058wFzxHsUYaVCVZpoVxQ2NRlta1TufUwCYEFvPIxDyHzhiZCbiLANbCqx7HDJJk327ACsk8tD4LXHb9o/QMTuhO3cBwhnvynawHHizVpFs4uWvNfeZvpBXSG2Iu5iytk+6jSWwgohXWgA3TZoELJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371408; c=relaxed/simple;
	bh=UzDxU0LbVK0U6QSy1G66Htn+I88pmMZX2m2qaEMoo2o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6o3MM4ovZHBIaDOUzuYOt2sbp6wH9+HwsgQvgt8x3IaMTSVK4qmUfbo0kib55LKvjI8zL9PWSFNYbvSOYeDmz9E0XSd937kPpWuPHxfwEQT+ONiXj6DOgYkL5c7QGLJrfMephSjCtypw3M7WQX0xYAQRJaFI60QPE3nN+CSwvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhb0RSfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhb0RSfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AFAC32782;
	Fri, 23 Aug 2024 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371408;
	bh=UzDxU0LbVK0U6QSy1G66Htn+I88pmMZX2m2qaEMoo2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fhb0RSfVcmfUFx8bGmctolHgUnbRBJXOILVqWUVGSgNBGt/L3JJwiepi/pjgTTm1Q
	 hvIYZhFuxV3Nqel1f+TK/UuRstw8jKgfG/49INZCRzSMgQTzjnWBBz+YdFaS3McD85
	 XaRcTvAv9k0idh8WMY50wSC+eZ+PYBO+eI5wvdW6apOkCsZJ0vkflbJXx4vjjP30Sx
	 fhuuNduTKmw17/VB725v0dll7x6k1Dn4QgWLTRGVrsGwJ/9L9pnGebGzODFhwR2hpf
	 k9QoyPruV+wDpezUyZvI7v0U+w71ix4jyMGxPGKyL6Nl/Nt6l6SpA+6IleSJpIFmnu
	 5hc90o9cu072A==
Date: Thu, 22 Aug 2024 17:03:27 -0700
Subject: [PATCH 05/26] xfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085258.57482.14715560733408039930.stgit@frogsfrogsfrogs>
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

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   70 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.h |    3 ++
 fs/xfs/libxfs/xfs_metafile.h  |   11 ++++++
 fs/xfs/scrub/common.c         |   10 +++++-
 fs/xfs/scrub/inode.c          |   26 ++++++++++++++-
 fs/xfs/scrub/inode_repair.c   |   10 ++++++
 fs/xfs/xfs_icache.c           |    9 +++++
 fs/xfs/xfs_inode.c            |   11 ++++++
 8 files changed, 145 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index cdd6ed4279649..a74040ffdb5e2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -19,6 +19,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
 #include "xfs_health.h"
+#include "xfs_metafile.h"
 
 #include <linux/iversion.h>
 
@@ -488,6 +489,69 @@ xfs_dinode_verify_nrext64(
 	return NULL;
 }
 
+/*
+ * Validate all the picky requirements we have for a file that claims to be
+ * filesystem metadata.
+ */
+xfs_failaddr_t
+xfs_dinode_verify_metadir(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint64_t		flags2)
+{
+	if (!xfs_has_metadir(mp))
+		return __this_address;
+
+	/* V5 filesystem only */
+	if (dip->di_version < 3)
+		return __this_address;
+
+	if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+		return __this_address;
+
+	/* V3 inode fields that are always zero */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && dip->di_nrext64_pad)
+		return __this_address;
+	if (!(flags2 & XFS_DIFLAG2_NREXT64) && dip->di_flushiter)
+		return __this_address;
+
+	/* Metadata files can only be directories or regular files */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* They must have zero access permissions */
+	if (mode & 0777)
+		return __this_address;
+
+	/* DMAPI event and state masks are zero */
+	if (dip->di_dmevmask || dip->di_dmstate)
+		return __this_address;
+
+	/*
+	 * User and group IDs must be zero.  The project ID is used for
+	 * grouping inodes.  Metadata inodes are never accounted to quotas.
+	 */
+	if (dip->di_uid || dip->di_gid)
+		return __this_address;
+
+	/* Mandatory directory flags must be set */
+	if (S_ISDIR(mode)) {
+		if ((flags & XFS_METADIR_DIFLAGS) != XFS_METADIR_DIFLAGS)
+			return __this_address;
+	} else {
+		if ((flags & XFS_METAFILE_DIFLAGS) != XFS_METAFILE_DIFLAGS)
+			return __this_address;
+	}
+
+	/* dax flags2 must not be set */
+	if (flags2 & XFS_DIFLAG2_DAX)
+		return __this_address;
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -672,6 +736,12 @@ xfs_dinode_verify(
 	    !xfs_has_bigtime(mp))
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		fa = xfs_dinode_verify_metadir(mp, dip, mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 585ed5a110af4..8d43d2641c732 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index 60fe189061127..07ff20639bd54 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -6,6 +6,17 @@
 #ifndef __XFS_METAFILE_H__
 #define __XFS_METAFILE_H__
 
+/* All metadata files must have these flags set. */
+#define XFS_METAFILE_DIFLAGS	(XFS_DIFLAG_IMMUTABLE | \
+				 XFS_DIFLAG_SYNC | \
+				 XFS_DIFLAG_NOATIME | \
+				 XFS_DIFLAG_NODUMP | \
+				 XFS_DIFLAG_NODEFRAG)
+
+/* All metadata directory files must have these flags set. */
+#define XFS_METADIR_DIFLAGS	(XFS_METAFILE_DIFLAGS | \
+				 XFS_DIFLAG_NOSYMLINKS)
+
 /* Code specific to kernel/userspace; must be provided externally. */
 
 int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 22f5f1a9d3f09..f64271ccb786c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -947,9 +947,15 @@ xchk_iget_for_scrubbing(
 	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino)
 		return xchk_install_live_inode(sc, ip_in);
 
-	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+	/*
+	 * On pre-metadir filesystems, reject internal metadata files.  For
+	 * metadir filesystems, limited scrubbing of any file in the metadata
+	 * directory tree by handle is allowed, because that is the only way to
+	 * validate the lack of parent pointers in the sb-root metadata inodes.
+	 */
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	/* Reject obviously bad inode numbers. */
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index ec2c694c4083f..45222552a51cc 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -60,6 +60,22 @@ xchk_install_handle_iscrub(
 	if (error)
 		return error;
 
+	/*
+	 * Don't allow scrubbing by handle of any non-directory inode records
+	 * in the metadata directory tree.  We don't know if any of the scans
+	 * launched by this scrubber will end up indirectly trying to lock this
+	 * file.
+	 *
+	 * Scrubbers of inode-rooted metadata files (e.g. quota files) will
+	 * attach all the resources needed to scrub the inode and call
+	 * xchk_inode directly.  Userspace cannot call this directly.
+	 */
+	if (xfs_is_metadir_inode(ip) && !S_ISDIR(VFS_I(ip)->i_mode)) {
+		xchk_irele(sc, ip);
+		sc->ip = NULL;
+		return -ENOENT;
+	}
+
 	return xchk_prepare_iscrub(sc);
 }
 
@@ -94,9 +110,15 @@ xchk_setup_inode(
 		return xchk_prepare_iscrub(sc);
 	}
 
-	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+	/*
+	 * On pre-metadir filesystems, reject internal metadata files.  For
+	 * metadir filesystems, limited scrubbing of any file in the metadata
+	 * directory tree by handle is allowed, because that is the only way to
+	 * validate the lack of parent pointers in the sb-root metadata inodes.
+	 */
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	/* Reject obviously bad inode numbers. */
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 344fdffb19aba..060ebfb25c7a5 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -568,6 +568,16 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		xfs_failaddr_t	fa;
+
+		fa = xfs_dinode_verify_metadir(sc->mp, dip, mode, flags,
+				flags2);
+		if (fa)
+			flags2 &= ~XFS_DIFLAG2_METADATA;
+	}
+
 	dip->di_flags = cpu_to_be16(flags);
 	dip->di_flags2 = cpu_to_be64(flags2);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a3d4334d4151b..61bba47e565f4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -844,13 +844,20 @@ xfs_trans_metafile_iget(
 		mode = S_IFREG;
 	if (inode_wrong_type(VFS_I(ip), mode))
 		goto bad_rele;
+	if (xfs_has_metadir(mp)) {
+		if (!xfs_is_metadir_inode(ip))
+			goto bad_rele;
+		if (metafile_type != ip->i_metatype)
+			goto bad_rele;
+	}
 
 	*ipp = ip;
 	return 0;
 bad_rele:
 	xfs_irele(ip);
 whine:
-	xfs_err(mp, "metadata inode 0x%llx is corrupt", ino);
+	xfs_err(mp, "metadata inode 0x%llx type %u is corrupt", ino,
+			metafile_type);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e1c65507479cd..35acb73665fdd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -555,8 +555,19 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
+	/*
+	 * Fail if a directory entry in the regular directory tree points to
+	 * a metadata file.
+	 */
+	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadir_inode(*ipp))) {
+		error = -EFSCORRUPTED;
+		goto out_irele;
+	}
+
 	return 0;
 
+out_irele:
+	xfs_irele(*ipp);
 out_free_name:
 	if (ci_name)
 		kfree(ci_name->name);

