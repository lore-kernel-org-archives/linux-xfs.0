Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03131841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="teD8ZCoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8C3C433C8;
	Thu,  7 Dec 2023 02:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916996;
	bh=CRTSoGOgCX3vvCQWOHtkeukw6rV/a3S+AC34MLkairI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=teD8ZCoNqLOK5lu7IHKRCh/6hwL2ghV3iklhWU+82aj3S40vb+ZEBnHfNEIVaCKHU
	 d47Vr/bjBqH7vSX8sC4oHhq3TtI5xr9eilBz6kMDhvXhhtJDmUKE1EDj5UMloaIoLp
	 kl29ow9uXCeX0fgCPsuZKOnZJzudxUDo8oYLjQWPbMUipx+o10pZY1KBVqJbKW4dCd
	 hDXuH7OBaM3wyroTbEwJeyzMXydN0jkfJxrR7QvSesvQxY23IlG7l1ptQ9w31OEteL
	 3Py0j/1n/UhgWOF/OzSrYgBIGbM96Jn0eIh2VmMU+fIiC5A0G+itgHCVxH6/7GAgtT
	 dm//FVHiSa9Rw==
Date: Wed, 06 Dec 2023 18:43:16 -0800
Subject: [PATCH 6/9] xfs: set inode sick state flags when we zap either ondisk
 fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191666205.1182270.10061610128319408467.stgit@frogsfrogsfrogs>
In-Reply-To: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
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

Christoph asked for stronger protections against online repair zapping a
fork to get the inode to load vs. other threads trying to access the
partially repaired file.  Do this by adding a special "[DA]FORK_ZAPPED"
inode health flag whenever repair zaps a fork, and sprinkling checks for
that flag into the various file operations for things that don't like
handling an unexpected zero-extents fork.

In practice xfs_scrub will scrub and fix the forks almost immediately
after zapping them, so the window is very small.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h  |    6 +++++-
 fs/xfs/scrub/bmap.c         |   30 ++++++++++++++++++++++++++++--
 fs/xfs/scrub/health.c       |   14 ++++++++++++++
 fs/xfs/scrub/health.h       |    1 +
 fs/xfs/scrub/inode_repair.c |   10 ++++++++++
 fs/xfs/xfs_dir2_readdir.c   |    3 +++
 fs/xfs/xfs_inode.c          |   25 +++++++++++++++++++++++++
 fs/xfs/xfs_inode.h          |    2 ++
 fs/xfs/xfs_symlink.c        |    2 ++
 fs/xfs/xfs_xattr.c          |    6 ++++++
 10 files changed, 96 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 99e796256c5d1..aad7c19225d4b 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -67,6 +67,8 @@ struct xfs_fsop_geom;
 #define XFS_SICK_INO_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_SICK_INO_DFORK_ZAPPED (1 << 8)  /* data fork totally destroyed */
+#define XFS_SICK_INO_AFORK_ZAPPED (1 << 9)  /* attr fork totally destroyed */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -95,7 +97,9 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_DIR | \
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
-				 XFS_SICK_INO_PARENT)
+				 XFS_SICK_INO_PARENT | \
+				 XFS_SICK_INO_DFORK_ZAPPED | \
+				 XFS_SICK_INO_AFORK_ZAPPED)
 
 /* These functions must be provided by the xfs implementation. */
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f74bd2a97c7f7..0ff1f631a9594 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -19,9 +19,11 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/health.h"
 #include "xfs_ag.h"
 
 /* Set us up with an inode's bmap. */
@@ -863,8 +865,16 @@ xchk_bmap(
 	case XFS_ATTR_FORK:
 		if (!xfs_has_attr(mp) && !xfs_has_attr2(mp))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		if (xfs_inode_has_sickness(sc->ip, XFS_SICK_INO_AFORK_ZAPPED)) {
+			xchk_fblock_set_corrupt(sc, whichfork, 0);
+			return 0;
+		}
 		break;
 	default:
+		if (xfs_inode_has_sickness(sc->ip, XFS_SICK_INO_DFORK_ZAPPED)) {
+			xchk_fblock_set_corrupt(sc, whichfork, 0);
+			return 0;
+		}
 		ASSERT(whichfork == XFS_DATA_FORK);
 		break;
 	}
@@ -943,7 +953,15 @@ int
 xchk_bmap_data(
 	struct xfs_scrub	*sc)
 {
-	return xchk_bmap(sc, XFS_DATA_FORK);
+	int			error;
+
+	error = xchk_bmap(sc, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	/* If the data fork is clean, it is clearly not zapped. */
+	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_DFORK_ZAPPED);
+	return 0;
 }
 
 /* Scrub an inode's attr fork. */
@@ -951,7 +969,15 @@ int
 xchk_bmap_attr(
 	struct xfs_scrub	*sc)
 {
-	return xchk_bmap(sc, XFS_ATTR_FORK);
+	int			error;
+
+	error = xchk_bmap(sc, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	/* If the attr fork is clean, it is clearly not zapped. */
+	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_AFORK_ZAPPED);
+	return 0;
 }
 
 /* Scrub an inode's CoW fork. */
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 5e2b09ed6e29a..1a481be641cdd 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -117,6 +117,20 @@ xchk_health_mask_for_scrub_type(
 	return type_to_health_flag[scrub_type].sick_mask;
 }
 
+/*
+ * If the scrub state is clean, add @mask to the scrub sick mask to clear
+ * additional sick flags from the metadata object's sick state.
+ */
+void
+xchk_mark_healthy_if_clean(
+	struct xfs_scrub	*sc,
+	unsigned int		mask)
+{
+	if (!(sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				  XFS_SCRUB_OFLAG_XCORRUPT)))
+		sc->sick_mask |= mask;
+}
+
 /*
  * Update filesystem health assessments based on what we found and did.
  *
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index 66a273f8585bc..ebb8d8438ce58 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -10,5 +10,6 @@ unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc);
 bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
+void xchk_mark_healthy_if_clean(struct xfs_scrub *sc, unsigned int mask);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index b6d3552365270..ee7a933452a03 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -36,6 +36,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -120,6 +121,9 @@ struct xrep_inode {
 	/* Number of (data device) extents for the attr fork. */
 	xfs_aextnum_t		attr_extents;
 
+	/* Sick state to set after zapping parts of the inode. */
+	unsigned int		ino_sick_mask;
+
 	/* Must we remove all access from this file? */
 	bool			zap_acls;
 };
@@ -705,6 +709,8 @@ xrep_dinode_zap_dfork(
 
 	trace_xrep_dinode_zap_dfork(sc, dip);
 
+	ri->ino_sick_mask |= XFS_SICK_INO_DFORK_ZAPPED;
+
 	xrep_dinode_set_data_nextents(dip, 0);
 	ri->data_blocks = 0;
 	ri->rt_blocks = 0;
@@ -804,6 +810,8 @@ xrep_dinode_zap_afork(
 
 	trace_xrep_dinode_zap_afork(sc, dip);
 
+	ri->ino_sick_mask |= XFS_SICK_INO_AFORK_ZAPPED;
+
 	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	xrep_dinode_set_attr_nextents(dip, 0);
 	ri->attr_blocks = 0;
@@ -1140,6 +1148,8 @@ xrep_dinode_core(
 		return error;
 
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	if (ri->ino_sick_mask)
+		xfs_inode_mark_sick(sc->ip, ri->ino_sick_mask);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9f3ceb4615156..57f42c2af0a31 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Directory file type support functions
@@ -519,6 +520,8 @@ xfs_readdir(
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
+	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
+		return -EIO;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	ASSERT(xfs_isilocked(dp, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c0f1c89786c2a..6dcf529d2e2ca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -661,6 +662,8 @@ xfs_lookup(
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
+	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
+		return -EIO;
 
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
 	if (error)
@@ -978,6 +981,8 @@ xfs_create(
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
+	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
+		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
 
@@ -1217,6 +1222,8 @@ xfs_link(
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
+	if (xfs_ifork_zapped(tdp, XFS_DATA_FORK))
+		return -EIO;
 
 	error = xfs_qm_dqattach(sip);
 	if (error)
@@ -2506,6 +2513,8 @@ xfs_remove(
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
+	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
+		return -EIO;
 
 	error = xfs_qm_dqattach(dp);
 	if (error)
@@ -3758,3 +3767,19 @@ xfs_inode_reload_unlinked(
 
 	return error;
 }
+
+/* Has this inode fork been zapped by repair? */
+bool
+xfs_ifork_zapped(
+	const struct xfs_inode	*ip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return ip->i_sick & XFS_SICK_INO_DFORK_ZAPPED;
+	case XFS_ATTR_FORK:
+		return ip->i_sick & XFS_SICK_INO_AFORK_ZAPPED;
+	default:
+		return false;
+	}
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3beb470f18920..97f63bacd4c2b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -622,4 +622,6 @@ xfs_inode_unlinked_incomplete(
 int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
+bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f9..d2bf9d1985a08 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -108,6 +108,8 @@ xfs_readlink(
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
+	if (xfs_ifork_zapped(ip, XFS_DATA_FORK))
+		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 987843f84d03f..364104e1b38ae 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -136,6 +136,9 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	};
 	int			error;
 
+	if (xfs_ifork_zapped(XFS_I(inode), XFS_ATTR_FORK))
+		return -EIO;
+
 	error = xfs_attr_get(&args);
 	if (error)
 		return error;
@@ -294,6 +297,9 @@ xfs_vn_listxattr(
 	struct inode	*inode = d_inode(dentry);
 	int		error;
 
+	if (xfs_ifork_zapped(XFS_I(inode), XFS_ATTR_FORK))
+		return -EIO;
+
 	/*
 	 * First read the regular on-disk attributes.
 	 */

