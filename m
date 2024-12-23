Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A61BE871
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990281; cv=none; b=CFffaVmHlMcZQTG+qfq+ZUfZMrHZd6CGS8QJm6UkDY0j04btYoJMJyNH56shWj8B+rKfQ4B9V5IU6aAtAc7JXOwD6CU4LMBNqVewWVm23Lg0lwRKvFKSNxcKodaS4Fy90GeEjYIcFUWu/6x59brjFRFXNk4KyKcJLoC8F9txocI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990281; c=relaxed/simple;
	bh=IZVoXHys9PUnBqz+s+/BaZfkcuuasJ7akohU6Ej+BpM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFnl9z+DqGYYgqUkkCNLQcyiA1DRSbtUqaZaO041yp5gPyGsyBVuSDiOn5/TI6PDjdcr7i1FaMTGf+SeQG88w8jvYdddd0xS9i81tdWD4w4vWnMm4S5oXvvDG7BK3zjdr3DM2fkg0I/P3Vn3Oad/wz0LJcMlkoV4xaNspK0i3aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAJC81pT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAJC81pT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4857DC4CED3;
	Mon, 23 Dec 2024 21:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990281;
	bh=IZVoXHys9PUnBqz+s+/BaZfkcuuasJ7akohU6Ej+BpM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cAJC81pTDim8mkRxxctNqqOK3QiUFkcCB5HX5ZH7K+iEsxDHqDQMWjy/lal3wFSan
	 XJfIkHMDLKiA22B3aWLLZy5ndkHOaqiHKj2siq+GXJy+B6phGptSxnGrt5wx0m8aok
	 SLITHXPVBHuvuZwywhzGAchXmKTfSo/BixDjJ8P3Jde/6GpjZBkRJ+HTqleaT+GgVr
	 ZnwuodXf0BNsNt9aG/c3DfE7Mxi/Via38DxG1DnOB/EoZc/6xu5MGfMNNNgE4p1n46
	 NjVB+zhWqMpxS7mMzXmaGLC0iK2nrhFl2NdtbJNDhYnCJBSkHq90BtazrhxLWc5pK2
	 pJa/tIduJunSQ==
Date: Mon, 23 Dec 2024 13:44:40 -0800
Subject: [PATCH 29/36] xfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940386.2293042.7331978230425131716.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7297fd0bebbd70efd12f72632a0f3ac49a8f59fe

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_buf.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.h |    3 ++
 libxfs/xfs_metafile.h  |   11 ++++++++
 3 files changed, 84 insertions(+)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 981113f6acd37a..98482cb4948284 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -17,6 +17,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
 #include "xfs_health.h"
+#include "xfs_metafile.h"
 
 
 /*
@@ -486,6 +487,69 @@ xfs_dinode_verify_nrext64(
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
+	/* Mandatory inode flags must be set */
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
@@ -670,6 +734,12 @@ xfs_dinode_verify(
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
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 585ed5a110af4e..8d43d2641c7328 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
diff --git a/libxfs/xfs_metafile.h b/libxfs/xfs_metafile.h
index 60fe1890611277..c66b0c51b461a8 100644
--- a/libxfs/xfs_metafile.h
+++ b/libxfs/xfs_metafile.h
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
+/* All metadata directories must have these flags set. */
+#define XFS_METADIR_DIFLAGS	(XFS_METAFILE_DIFLAGS | \
+				 XFS_DIFLAG_NOSYMLINKS)
+
 /* Code specific to kernel/userspace; must be provided externally. */
 
 int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,

