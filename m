Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99083C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkUzvij3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B02C433C8;
	Sun, 31 Dec 2023 23:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064985;
	bh=u7MMqWsn3m6kQ/tEnxLuQTBZo/LE9BjZ3LYfUR5GwkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TkUzvij3L380aLRJNfo80EByTZ4DhJ/Ss+XXqif3xcwx5k2p8E9onqLfOvL5QvQqF
	 u82NMuA57CN6K3ls8fpf5cSk/i/qrN09nUCm+EMkd1s67PGickul/B/i35R+LYY0ny
	 O5wbLzaLdTegOi10lIi5wd6XNO5rcAwQZWMelHLOj+gv0A7FrHVEKM8sck1J0kIW5/
	 ZfP95gcyup93QGV3Q+G5Yl+TwVvCUjZJabKemGS5AhBGx3OM4V8jguLoZr9kZb2mjE
	 fin83G6JYE7pU0OjY/1Wn90nUEgLODdcP039+uQhE6U0CdYsHHLSJsmOspP3Y7Qcb1
	 oHLUBo1sqaA5Q==
Date: Sun, 31 Dec 2023 15:23:04 -0800
Subject: [PATCH 03/28] xfs: hoist project id get/set functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009218.1808635.16794246427785332675.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_inode_util.c  |   11 +++++++++++
 libxfs/xfs_inode_util.h  |    2 ++
 3 files changed, 15 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 49372a44029..3455c014832 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -150,6 +150,7 @@
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_get_projid			libxfs_get_projid
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
@@ -252,6 +253,7 @@
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
 #define xfs_sb_to_disk			libxfs_sb_to_disk
 #define xfs_sb_version_to_features	libxfs_sb_version_to_features
+#define xfs_set_projid			libxfs_set_projid
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
 #define xfs_symlink_write_target	libxfs_symlink_write_target
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 868a77cafa6..89fb58807a1 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -122,3 +122,14 @@ xfs_ip2xflags(
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
+
+#define XFS_PROJID_DEFAULT	0
+
+prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
+
+	return XFS_PROJID_DEFAULT;
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 6ad1898a0f7..f7e4d5a8235 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -11,4 +11,6 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
 uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
+prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
+
 #endif /* __XFS_INODE_UTIL_H__ */

