Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA14C8183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEWJ51z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF4C433C7;
	Wed, 13 Dec 2023 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508074;
	bh=oZiFWvqyntFe+tMRTqHGPAWdjTcIOVvBi+V8/6WkjDs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XEWJ51z0DiuOwaPhr0lwSOUFkTITcZyFOIm/t1qQgc6DewkXibSKSjlzoJxkcbaoU
	 /b9GmEICUZBmd7Bvq2YdlScJiehfYhfwVP45lBKEaBxdZ+PGEd5Gc6xfAHnGYvVVI3
	 vCJa9/6KCvTvCnpRzJYZVqI1DZIlwiIuCBgyjjeqn5VTLRxjJyncrQmJptDy3Id+cT
	 /QenKWe6VX+QqOPjvfvHUytNBeVdm4QMOtN5ASLIKyJaEVNpsdqS1hZckN8U/GkWCs
	 yMdbiK4sd2rcxwX3ZTAyTyPSPTTN51UtzdWth7chyaJgsmUTKHeRz8B9Bg3s+QFOHi
	 ibcfRhyGYiUfQ==
Date: Wed, 13 Dec 2023 14:54:34 -0800
Subject: [PATCH 5/9] xfs: set inode sick state flags when we zap either ondisk
 fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783546.1399182.5752005394880036340.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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

In a few patches, we'll add some online repair code that tries to
massage the ondisk inode record just enough to get it to pass the inode
verifiers so that we can continue with more file repairs.  Part of that
massaging can include zapping the ondisk forks to clear errors.  After
that point, the bmap fork repair functions will rebuild the zapped
forks.

Christoph asked for stronger protections against online repair zapping a
fork to get the inode to load vs. other threads trying to access the
partially repaired file.  Do this by adding a special "[DA]FORK_ZAPPED"
inode health flag whenever repair zaps a fork, and sprinkling checks for
that flag into the various file operations for things that don't like
handling an unexpected zero-extents fork.

In practice xfs_scrub will scrub and fix the forks almost immediately
after zapping them, so the window is very small.  However, if a crash or
unmount should occur, we can still detect these zapped inode forks by
looking for a zero-extents fork when data was expected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_health.h |   10 ++++++++++
 fs/xfs/scrub/bmap.c        |   39 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/common.c      |    2 ++
 fs/xfs/scrub/dir.c         |   16 +++++++++++++---
 fs/xfs/scrub/health.c      |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h      |    2 ++
 fs/xfs/scrub/symlink.c     |   20 +++++++++++++++-----
 fs/xfs/xfs_dir2_readdir.c  |    3 +++
 fs/xfs/xfs_health.c        |    8 ++++++--
 fs/xfs/xfs_inode.c         |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h         |    2 ++
 fs/xfs/xfs_symlink.c       |    3 +++
 fs/xfs/xfs_xattr.c         |    6 ++++++
 13 files changed, 166 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 99e796256c5d..6296993ff8f3 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -68,6 +68,11 @@ struct xfs_fsop_geom;
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
 
+#define XFS_SICK_INO_BMBTD_ZAPPED	(1 << 8)  /* data fork erased */
+#define XFS_SICK_INO_BMBTA_ZAPPED	(1 << 9)  /* attr fork erased */
+#define XFS_SICK_INO_DIR_ZAPPED		(1 << 10) /* directory erased */
+#define XFS_SICK_INO_SYMLINK_ZAPPED	(1 << 11) /* symlink erased */
+
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
@@ -97,6 +102,11 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
+#define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
+				 XFS_SICK_INO_BMBTA_ZAPPED | \
+				 XFS_SICK_INO_DIR_ZAPPED | \
+				 XFS_SICK_INO_SYMLINK_ZAPPED)
+
 /* These functions must be provided by the xfs implementation. */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f74bd2a97c7f..1487aaf3d95f 100644
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
@@ -943,7 +945,20 @@ int
 xchk_bmap_data(
 	struct xfs_scrub	*sc)
 {
-	return xchk_bmap(sc, XFS_DATA_FORK);
+	int			error;
+
+	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTD_ZAPPED)) {
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
+	}
+
+	error = xchk_bmap(sc, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	/* If the data fork is clean, it is clearly not zapped. */
+	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTD_ZAPPED);
+	return 0;
 }
 
 /* Scrub an inode's attr fork. */
@@ -951,7 +966,27 @@ int
 xchk_bmap_attr(
 	struct xfs_scrub	*sc)
 {
-	return xchk_bmap(sc, XFS_ATTR_FORK);
+	int			error;
+
+	/*
+	 * If the attr fork has been zapped, it's possible that forkoff was
+	 * reset to zero and hence sc->ip->i_afp is NULL.  We don't want the
+	 * NULL ifp check in xchk_bmap to conclude that the attr fork is ok,
+	 * so short circuit that logic by setting the corruption flag and
+	 * returning immediately.
+	 */
+	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTA_ZAPPED)) {
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
+	}
+
+	error = xchk_bmap(sc, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	/* If the attr fork is clean, it is clearly not zapped. */
+	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTA_ZAPPED);
+	return 0;
 }
 
 /* Scrub an inode's CoW fork. */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index bff0a374fb1b..f0207e71e5dc 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1160,6 +1160,7 @@ xchk_metadata_inode_subtype(
 	unsigned int		scrub_type)
 {
 	__u32			smtype = sc->sm->sm_type;
+	unsigned int		sick_mask = sc->sick_mask;
 	int			error;
 
 	sc->sm->sm_type = scrub_type;
@@ -1177,6 +1178,7 @@ xchk_metadata_inode_subtype(
 		break;
 	}
 
+	sc->sick_mask = sick_mask;
 	sc->sm->sm_type = smtype;
 	return error;
 }
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 0b491784b759..b366fab699ac 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -15,10 +15,12 @@
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/readdir.h"
+#include "scrub/health.h"
 
 /* Set us up to scrub directories. */
 int
@@ -760,6 +762,11 @@ xchk_directory(
 	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
 		return -ENOENT;
 
+	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_DIR_ZAPPED)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
 	/* Plausible size? */
 	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
@@ -784,7 +791,10 @@ xchk_directory(
 
 	/* Look up every name in this directory by hash. */
 	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, NULL);
-	if (error == -ECANCELED)
-		error = 0;
-	return error;
+	if (error && error != -ECANCELED)
+		return error;
+
+	/* If the dir is clean, it is clearly not zapped. */
+	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_DIR_ZAPPED);
+	return 0;
 }
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 5e2b09ed6e29..df716da11226 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -117,6 +117,38 @@ xchk_health_mask_for_scrub_type(
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
+/*
+ * If we're scrubbing a piece of file metadata for the first time, does it look
+ * like it has been zapped?  Skip the check if we just repaired the metadata
+ * and are revalidating it.
+ */
+bool
+xchk_file_looks_zapped(
+	struct xfs_scrub	*sc,
+	unsigned int		mask)
+{
+	ASSERT((mask & ~XFS_SICK_INO_ZAPPED) == 0);
+
+	if (sc->flags & XREP_ALREADY_FIXED)
+		return false;
+
+	return xfs_inode_has_sickness(sc->ip, mask);
+}
+
 /*
  * Update filesystem health assessments based on what we found and did.
  *
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index 66a273f8585b..a731b2467399 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -10,5 +10,7 @@ unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc);
 bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
+void xchk_mark_healthy_if_clean(struct xfs_scrub *sc, unsigned int mask);
+bool xchk_file_looks_zapped(struct xfs_scrub *sc, unsigned int mask);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 38708fb9a5d7..60643d791d4a 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -12,8 +12,10 @@
 #include "xfs_log_format.h"
 #include "xfs_inode.h"
 #include "xfs_symlink.h"
+#include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/health.h"
 
 /* Set us up to scrub a symbolic link. */
 int
@@ -41,13 +43,19 @@ xchk_symlink(
 
 	if (!S_ISLNK(VFS_I(ip)->i_mode))
 		return -ENOENT;
+
+	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_SYMLINK_ZAPPED)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
 	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 	len = ip->i_disk_size;
 
 	/* Plausible size? */
 	if (len > XFS_SYMLINK_MAXLEN || len <= 0) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out;
+		return 0;
 	}
 
 	/* Inline symlink? */
@@ -55,15 +63,17 @@ xchk_symlink(
 		if (len > xfs_inode_data_fork_size(ip) ||
 		    len > strnlen(ifp->if_u1.if_data, xfs_inode_data_fork_size(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out;
+		return 0;
 	}
 
 	/* Remote symlink; must read the contents. */
 	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		goto out;
+		return error;
 	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-out:
-	return error;
+
+	/* If a remote symlink is clean, it is clearly not zapped. */
+	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_SYMLINK_ZAPPED);
+	return 0;
 }
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9f3ceb461515..57f42c2af0a3 100644
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
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 72a075bb2c10..9a57afee9338 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -222,7 +222,7 @@ xfs_inode_mark_sick(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	ASSERT(!(mask & ~(XFS_SICK_INO_PRIMARY | XFS_SICK_INO_ZAPPED)));
 	trace_xfs_inode_mark_sick(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
@@ -246,7 +246,7 @@ xfs_inode_mark_healthy(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	ASSERT(!(mask & ~(XFS_SICK_INO_PRIMARY | XFS_SICK_INO_ZAPPED)));
 	trace_xfs_inode_mark_healthy(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
@@ -369,6 +369,10 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_XATTR,	XFS_BS_SICK_XATTR },
 	{ XFS_SICK_INO_SYMLINK,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_PARENT,	XFS_BS_SICK_PARENT },
+	{ XFS_SICK_INO_BMBTD_ZAPPED,	XFS_BS_SICK_BMBTD },
+	{ XFS_SICK_INO_BMBTA_ZAPPED,	XFS_BS_SICK_BMBTA },
+	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
+	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c0f1c89786c2..ea6b277485a4 100644
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
@@ -3758,3 +3767,29 @@ xfs_inode_reload_unlinked(
 
 	return error;
 }
+
+/* Has this inode fork been zapped by repair? */
+bool
+xfs_ifork_zapped(
+	const struct xfs_inode	*ip,
+	int			whichfork)
+{
+	unsigned int		datamask = 0;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		switch (ip->i_vnode.i_mode & S_IFMT) {
+		case S_IFDIR:
+			datamask = XFS_SICK_INO_DIR_ZAPPED;
+			break;
+		case S_IFLNK:
+			datamask = XFS_SICK_INO_SYMLINK_ZAPPED;
+			break;
+		}
+		return ip->i_sick & (XFS_SICK_INO_BMBTD_ZAPPED | datamask);
+	case XFS_ATTR_FORK:
+		return ip->i_sick & XFS_SICK_INO_BMBTA_ZAPPED;
+	default:
+		return false;
+	}
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3beb470f1892..97f63bacd4c2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -622,4 +622,6 @@ xfs_inode_unlinked_incomplete(
 int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
+bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f..7c713727f7fd 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -108,6 +109,8 @@ xfs_readlink(
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
+	if (xfs_ifork_zapped(ip, XFS_DATA_FORK))
+		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 987843f84d03..364104e1b38a 100644
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

