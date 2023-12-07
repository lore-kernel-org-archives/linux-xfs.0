Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C591841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gf03gdq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036B1C433C8;
	Thu,  7 Dec 2023 02:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916981;
	bh=zbzkdKQN0ZEwrZgY+MXbb+RdVnm+DnAr8c7Gl7ci2xY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gf03gdq4w6iLLzW9700lyBXNew5K7QGYZL0Jg6s9r62duvaAj2o2XNliW1J3umUoQ
	 IcyrE5IVIJD7++q8T95bj7oZUqUCLepWuRvpTe89teDhDPNQgiZ91CIUP2dgkBxUZv
	 0Ql7tA1omT/IZnrF9mlPBqjLnzEmGIRPLd6Xd+8g+ge6PVgc0/AsHKr1C+BI6t19eg
	 wdw4YHxJlGVo4FYzmpaFhq670ND4xKtqmeWWPRnYlr9TY4hRS9V96fn4oE7vppQ29k
	 zvoyxC03tBIlt+YtaflQUtMpbBlE2vSJAv1VwkKAllHX1b4iobh6WYrWOHYNjFI3Xr
	 iXJNhzgtbZdGg==
Date: Wed, 06 Dec 2023 18:43:00 -0800
Subject: [PATCH 5/9] xfs: zap broken inode forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191666188.1182270.114932269965181078.stgit@frogsfrogsfrogs>
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

Determine if inode fork damage is responsible for the inode being unable
to pass the ifork verifiers in xfs_iget and zap the fork contents if
this is true.  Once this is done the fork will be empty but we'll be
able to construct an in-core inode, and a subsequent call to the inode
fork repair ioctl will search the rmapbt to rebuild the records that
were in the fork.

Note: The next patch will add some new state flags to prevent non-scrub
access to zapped file contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c      |   13 -
 fs/xfs/libxfs/xfs_attr_leaf.h      |    3 
 fs/xfs/libxfs/xfs_bmap.c           |   22 +
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    3 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   13 -
 fs/xfs/libxfs/xfs_inode_fork.c     |   33 +-
 fs/xfs/libxfs/xfs_shared.h         |    2 
 fs/xfs/libxfs/xfs_symlink_remote.c |    8 
 fs/xfs/scrub/inode_repair.c        |  709 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h               |   42 ++
 11 files changed, 804 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2580ae47209a6..57c4e6ff4524e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1040,23 +1040,16 @@ xfs_attr_shortform_allfit(
 	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
-/* Verify the consistency of an inline attribute fork. */
+/* Verify the consistency of a raw inline attribute fork. */
 xfs_failaddr_t
 xfs_attr_shortform_verify(
-	struct xfs_inode		*ip)
+	struct xfs_attr_shortform	*sfp,
+	size_t				size)
 {
-	struct xfs_attr_shortform	*sfp;
 	struct xfs_attr_sf_entry	*sfep;
 	struct xfs_attr_sf_entry	*next_sfep;
 	char				*endp;
-	struct xfs_ifork		*ifp;
 	int				i;
-	int64_t				size;
-
-	ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
-	ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
-	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
 
 	/*
 	 * Give up if the attribute is way too short.
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 368f4d9fa1d59..ce6743463c868 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -56,7 +56,8 @@ int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     unsigned int *basep);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
-xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
+xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_shortform *sfp,
+		size_t size);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 68be1dd4f0f26..9968a3a6e6d8d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6179,19 +6179,18 @@ xfs_bmap_finish_one(
 	return error;
 }
 
-/* Check that an inode's extent does not have invalid flags or bad ranges. */
+/* Check that an extent does not have invalid flags or bad ranges. */
 xfs_failaddr_t
-xfs_bmap_validate_extent(
-	struct xfs_inode	*ip,
+xfs_bmap_validate_extent_raw(
+	struct xfs_mount	*mp,
+	bool			rtfile,
 	int			whichfork,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-
 	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
 		return __this_address;
 
-	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
+	if (rtfile && whichfork == XFS_DATA_FORK) {
 		if (!xfs_verify_rtbext(mp, irec->br_startblock,
 					   irec->br_blockcount))
 			return __this_address;
@@ -6221,3 +6220,14 @@ xfs_bmap_intent_destroy_cache(void)
 	kmem_cache_destroy(xfs_bmap_intent_cache);
 	xfs_bmap_intent_cache = NULL;
 }
+
+/* Check that an inode's extent does not have invalid flags or bad ranges. */
+xfs_failaddr_t
+xfs_bmap_validate_extent(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*irec)
+{
+	return xfs_bmap_validate_extent_raw(ip->i_mount,
+			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e33470e39728d..8518324db2855 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -263,6 +263,8 @@ static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 	}
 }
 
+xfs_failaddr_t xfs_bmap_validate_extent_raw(struct xfs_mount *mp, bool rtfile,
+		int whichfork, struct xfs_bmbt_irec *irec);
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
 int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 7404a9ff1a929..1db2e60ba827f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -175,7 +175,8 @@ extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
-extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
+xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *sfp, int64_t size);
 int xfs_dir2_sf_entsize(struct xfs_mount *mp,
 		struct xfs_dir2_sf_hdr *hdr, int len);
 void xfs_dir2_sf_put_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d387..870ef1d1ebe4a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -707,11 +707,10 @@ xfs_dir2_sf_check(
 /* Verify the consistency of an inline directory. */
 xfs_failaddr_t
 xfs_dir2_sf_verify(
-	struct xfs_inode		*ip)
+	struct xfs_mount		*mp,
+	struct xfs_dir2_sf_hdr		*sfp,
+	int64_t				size)
 {
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-	struct xfs_dir2_sf_hdr		*sfp;
 	struct xfs_dir2_sf_entry	*sfep;
 	struct xfs_dir2_sf_entry	*next_sfep;
 	char				*endp;
@@ -719,15 +718,9 @@ xfs_dir2_sf_verify(
 	int				i;
 	int				i8count;
 	int				offset;
-	int64_t				size;
 	int				error;
 	uint8_t				filetype;
 
-	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-
-	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
-
 	/*
 	 * Give up if the directory is way too short.
 	 */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 5a2e7ddfa76d6..dad8ea832c208 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -702,12 +702,22 @@ xfs_ifork_verify_local_data(
 	xfs_failaddr_t		fa = NULL;
 
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
-	case S_IFDIR:
-		fa = xfs_dir2_sf_verify(ip);
+	case S_IFDIR: {
+		struct xfs_mount	*mp = ip->i_mount;
+		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+		struct xfs_dir2_sf_hdr	*sfp;
+
+		sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
+		fa = xfs_dir2_sf_verify(mp, sfp, ifp->if_bytes);
 		break;
-	case S_IFLNK:
-		fa = xfs_symlink_shortform_verify(ip);
+	}
+	case S_IFLNK: {
+		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+		fa = xfs_symlink_shortform_verify(ifp->if_u1.if_data,
+				ifp->if_bytes);
 		break;
+	}
 	default:
 		break;
 	}
@@ -729,11 +739,20 @@ xfs_ifork_verify_local_attr(
 	struct xfs_ifork	*ifp = &ip->i_af;
 	xfs_failaddr_t		fa;
 
-	if (!xfs_inode_has_attr_fork(ip))
+	if (!xfs_inode_has_attr_fork(ip)) {
 		fa = __this_address;
-	else
-		fa = xfs_attr_shortform_verify(ip);
+	} else {
+		struct xfs_attr_shortform	*sfp;
+		struct xfs_ifork		*ifp;
+		int64_t				size;
 
+		ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+		ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
+		sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+		size = ifp->if_bytes;
+
+		fa = xfs_attr_shortform_verify(sfp, size);
+	}
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
 				ifp->if_u1.if_data, ifp->if_bytes, fa);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c4381388c0c1a..4220d3584c1b0 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -139,7 +139,7 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
+xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index bdc777b9ec4a6..3c96d1d617fb0 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -202,15 +202,11 @@ xfs_symlink_local_to_remote(
  */
 xfs_failaddr_t
 xfs_symlink_shortform_verify(
-	struct xfs_inode	*ip)
+	void			*sfp,
+	int64_t			size)
 {
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-	char			*sfp = (char *)ifp->if_u1.if_data;
-	int			size = ifp->if_bytes;
 	char			*endp = sfp + size;
 
-	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-
 	/*
 	 * Zero length symlinks should never occur in memory as they are
 	 * never allowed to exist on disk.
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 491f3def7964b..b6d3552365270 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -22,8 +22,11 @@
 #include "xfs_ialloc.h"
 #include "xfs_da_format.h"
 #include "xfs_reflink.h"
+#include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
@@ -31,6 +34,8 @@
 #include "xfs_quota.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_log_priv.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -70,6 +75,16 @@
  *
  * - Invalid user, group, or project IDs (aka -1U) will be reset to zero.
  *   Setuid and setgid bits are cleared.
+ *
+ * - Data and attr forks are reset to extents format with zero extents if the
+ *   fork data is inconsistent.  It is necessary to run the bmapbtd or bmapbta
+ *   repair functions to recover the space mapping.
+ *
+ * - ACLs will not be recovered if the attr fork is zapped or the extended
+ *   attribute structure itself requires salvaging.
+ *
+ * - If the attr fork is zapped, the user and group ids are reset to root and
+ *   the setuid and setgid bits are removed.
  */
 
 /*
@@ -82,6 +97,31 @@ struct xrep_inode {
 	struct xfs_imap		imap;
 
 	struct xfs_scrub	*sc;
+
+	/* Blocks in use on the data device by data extents or bmbt blocks. */
+	xfs_rfsblock_t		data_blocks;
+
+	/* Blocks in use on the rt device. */
+	xfs_rfsblock_t		rt_blocks;
+
+	/* Blocks in use by the attr fork. */
+	xfs_rfsblock_t		attr_blocks;
+
+	/* Number of data device extents for the data fork. */
+	xfs_extnum_t		data_extents;
+
+	/*
+	 * Number of realtime device extents for the data fork.  If
+	 * data_extents and rt_extents indicate that the data fork has extents
+	 * on both devices, we'll just back away slowly.
+	 */
+	xfs_extnum_t		rt_extents;
+
+	/* Number of (data device) extents for the attr fork. */
+	xfs_aextnum_t		attr_extents;
+
+	/* Must we remove all access from this file? */
+	bool			zap_acls;
 };
 
 /*
@@ -186,9 +226,10 @@ xrep_dinode_header(
 /* Turn di_mode into /something/ recognizable. */
 STATIC void
 xrep_dinode_mode(
-	struct xfs_scrub	*sc,
+	struct xrep_inode	*ri,
 	struct xfs_dinode	*dip)
 {
+	struct xfs_scrub	*sc = ri->sc;
 	uint16_t		mode = be16_to_cpu(dip->di_mode);
 
 	trace_xrep_dinode_mode(sc, dip);
@@ -201,13 +242,15 @@ xrep_dinode_mode(
 	dip->di_mode = cpu_to_be16(mode);
 	dip->di_uid = 0;
 	dip->di_gid = 0;
+	ri->zap_acls = true;
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */
 STATIC void
 xrep_dinode_flags(
 	struct xfs_scrub	*sc,
-	struct xfs_dinode	*dip)
+	struct xfs_dinode	*dip,
+	bool			isrt)
 {
 	struct xfs_mount	*mp = sc->mp;
 	uint64_t		flags2 = be64_to_cpu(dip->di_flags2);
@@ -216,6 +259,11 @@ xrep_dinode_flags(
 
 	trace_xrep_dinode_flags(sc, dip);
 
+	if (isrt)
+		flags |= XFS_DIFLAG_REALTIME;
+	else
+		flags &= ~XFS_DIFLAG_REALTIME;
+
 	/*
 	 * For regular files on a reflink filesystem, set the REFLINK flag to
 	 * protect shared extents.  A later stage will actually check those
@@ -368,6 +416,653 @@ xrep_dinode_extsize_hints(
 	}
 }
 
+/* Count extents and blocks for an inode given an rmap. */
+STATIC int
+xrep_dinode_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_inode		*ri = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	/* We only care about this inode. */
+	if (rec->rm_owner != ri->sc->sm->sm_ino)
+		return 0;
+
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK) {
+		ri->attr_blocks += rec->rm_blockcount;
+		if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+			ri->attr_extents++;
+
+		return 0;
+	}
+
+	ri->data_blocks += rec->rm_blockcount;
+	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+		ri->data_extents++;
+
+	return 0;
+}
+
+/* Count extents and blocks for an inode from all AG rmap data. */
+STATIC int
+xrep_dinode_count_ag_rmaps(
+	struct xrep_inode	*ri,
+	struct xfs_perag	*pag)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agf;
+	int			error;
+
+	error = xfs_alloc_read_agf(pag, ri->sc->tp, 0, &agf);
+	if (error)
+		return error;
+
+	cur = xfs_rmapbt_init_cursor(ri->sc->mp, ri->sc->tp, agf, pag);
+	error = xfs_rmap_query_all(cur, xrep_dinode_walk_rmap, ri);
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(ri->sc->tp, agf);
+	return error;
+}
+
+/* Count extents and blocks for a given inode from all rmap data. */
+STATIC int
+xrep_dinode_count_rmaps(
+	struct xrep_inode	*ri)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	if (!xfs_has_rmapbt(ri->sc->mp) || xfs_has_realtime(ri->sc->mp))
+		return -EOPNOTSUPP;
+
+	for_each_perag(ri->sc->mp, agno, pag) {
+		error = xrep_dinode_count_ag_rmaps(ri, pag);
+		if (error) {
+			xfs_perag_rele(pag);
+			return error;
+		}
+	}
+
+	/* Can't have extents on both the rt and the data device. */
+	if (ri->data_extents && ri->rt_extents)
+		return -EFSCORRUPTED;
+
+	trace_xrep_dinode_count_rmaps(ri->sc,
+			ri->data_blocks, ri->rt_blocks, ri->attr_blocks,
+			ri->data_extents, ri->rt_extents, ri->attr_extents);
+	return 0;
+}
+
+/* Return true if this extents-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_extents_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size,
+	int			whichfork)
+{
+	struct xfs_bmbt_irec	new;
+	struct xfs_bmbt_rec	*dp;
+	xfs_extnum_t		nex;
+	bool			isrt;
+	unsigned int		i;
+
+	nex = xfs_dfork_nextents(dip, whichfork);
+	if (nex > dfork_size / sizeof(struct xfs_bmbt_rec))
+		return true;
+
+	dp = XFS_DFORK_PTR(dip, whichfork);
+
+	isrt = dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+	for (i = 0; i < nex; i++, dp++) {
+		xfs_failaddr_t	fa;
+
+		xfs_bmbt_disk_get_all(dp, &new);
+		fa = xfs_bmap_validate_extent_raw(sc->mp, isrt, whichfork,
+				&new);
+		if (fa)
+			return true;
+	}
+
+	return false;
+}
+
+/* Return true if this btree-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_bmbt_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size,
+	int			whichfork)
+{
+	struct xfs_bmdr_block	*dfp;
+	xfs_extnum_t		nex;
+	unsigned int		i;
+	unsigned int		dmxr;
+	unsigned int		nrecs;
+	unsigned int		level;
+
+	nex = xfs_dfork_nextents(dip, whichfork);
+	if (nex <= dfork_size / sizeof(struct xfs_bmbt_rec))
+		return true;
+
+	if (dfork_size < sizeof(struct xfs_bmdr_block))
+		return true;
+
+	dfp = XFS_DFORK_PTR(dip, whichfork);
+	nrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (nrecs == 0 || XFS_BMDR_SPACE_CALC(nrecs) > dfork_size)
+		return true;
+	if (level == 0 || level >= XFS_BM_MAXLEVELS(sc->mp, whichfork))
+		return true;
+
+	dmxr = xfs_bmdr_maxrecs(dfork_size, 0);
+	for (i = 1; i <= nrecs; i++) {
+		struct xfs_bmbt_key	*fkp;
+		xfs_bmbt_ptr_t		*fpp;
+		xfs_fileoff_t		fileoff;
+		xfs_fsblock_t		fsbno;
+
+		fkp = XFS_BMDR_KEY_ADDR(dfp, i);
+		fileoff = be64_to_cpu(fkp->br_startoff);
+		if (!xfs_verify_fileoff(sc->mp, fileoff))
+			return true;
+
+		fpp = XFS_BMDR_PTR_ADDR(dfp, i, dmxr);
+		fsbno = be64_to_cpu(*fpp);
+		if (!xfs_verify_fsbno(sc->mp, fsbno))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check the data fork for things that will fail the ifork verifiers or the
+ * ifork formatters.
+ */
+STATIC bool
+xrep_dinode_check_dfork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	uint16_t		mode)
+{
+	void			*dfork_ptr;
+	int64_t			data_size;
+	unsigned int		fmt;
+	unsigned int		dfork_size;
+
+	/*
+	 * Verifier functions take signed int64_t, so check for bogus negative
+	 * values first.
+	 */
+	data_size = be64_to_cpu(dip->di_size);
+	if (data_size < 0)
+		return true;
+
+	fmt = XFS_DFORK_FORMAT(dip, XFS_DATA_FORK);
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		if (fmt != XFS_DINODE_FMT_DEV)
+			return true;
+		break;
+	case S_IFREG:
+		if (fmt == XFS_DINODE_FMT_LOCAL)
+			return true;
+		fallthrough;
+	case S_IFLNK:
+	case S_IFDIR:
+		switch (fmt) {
+		case XFS_DINODE_FMT_LOCAL:
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			break;
+		default:
+			return true;
+		}
+		break;
+	default:
+		return true;
+	}
+
+	dfork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_DATA_FORK);
+	dfork_ptr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+
+	switch (fmt) {
+	case XFS_DINODE_FMT_DEV:
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		/* dir/symlink structure cannot be larger than the fork */
+		if (data_size > dfork_size)
+			return true;
+		/* directory structure must pass verification. */
+		if (S_ISDIR(mode) &&
+		    xfs_dir2_sf_verify(sc->mp, dfork_ptr, data_size) != NULL)
+			return true;
+		/* symlink structure must pass verification. */
+		if (S_ISLNK(mode) &&
+		    xfs_symlink_shortform_verify(dfork_ptr, data_size) != NULL)
+			return true;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (xrep_dinode_bad_extents_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (xrep_dinode_bad_bmbt_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
+	default:
+		return true;
+	}
+
+	return false;
+}
+
+static void
+xrep_dinode_set_data_nextents(
+	struct xfs_dinode	*dip,
+	xfs_extnum_t		nextents)
+{
+	if (xfs_dinode_has_large_extent_counts(dip))
+		dip->di_big_nextents = cpu_to_be64(nextents);
+	else
+		dip->di_nextents = cpu_to_be32(nextents);
+}
+
+static void
+xrep_dinode_set_attr_nextents(
+	struct xfs_dinode	*dip,
+	xfs_extnum_t		nextents)
+{
+	if (xfs_dinode_has_large_extent_counts(dip))
+		dip->di_big_anextents = cpu_to_be32(nextents);
+	else
+		dip->di_anextents = cpu_to_be16(nextents);
+}
+
+/* Reset the data fork to something sane. */
+STATIC void
+xrep_dinode_zap_dfork(
+	struct xrep_inode	*ri,
+	struct xfs_dinode	*dip,
+	uint16_t		mode)
+{
+	struct xfs_scrub	*sc = ri->sc;
+
+	trace_xrep_dinode_zap_dfork(sc, dip);
+
+	xrep_dinode_set_data_nextents(dip, 0);
+	ri->data_blocks = 0;
+	ri->rt_blocks = 0;
+
+	/* Special files always get reset to DEV */
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		dip->di_format = XFS_DINODE_FMT_DEV;
+		dip->di_size = 0;
+		return;
+	}
+
+	/*
+	 * If we have data extents, reset to an empty map and hope the user
+	 * will run the bmapbtd checker next.
+	 */
+	if (ri->data_extents || ri->rt_extents || S_ISREG(mode)) {
+		dip->di_format = XFS_DINODE_FMT_EXTENTS;
+		return;
+	}
+
+	/* Otherwise, reset the local format to the minimum. */
+	switch (mode & S_IFMT) {
+	case S_IFLNK:
+		xrep_dinode_zap_symlink(sc, dip);
+		break;
+	case S_IFDIR:
+		xrep_dinode_zap_dir(sc, dip);
+		break;
+	}
+}
+
+/*
+ * Check the attr fork for things that will fail the ifork verifiers or the
+ * ifork formatters.
+ */
+STATIC bool
+xrep_dinode_check_afork(
+	struct xfs_scrub		*sc,
+	struct xfs_dinode		*dip)
+{
+	struct xfs_attr_shortform	*afork_ptr;
+	size_t				attr_size;
+	unsigned int			afork_size;
+
+	if (XFS_DFORK_BOFF(dip) == 0)
+		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
+		       xfs_dfork_attr_extents(dip) != 0;
+
+	afork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
+	afork_ptr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);
+
+	switch (XFS_DFORK_FORMAT(dip, XFS_ATTR_FORK)) {
+	case XFS_DINODE_FMT_LOCAL:
+		/* Fork has to be large enough to extract the xattr size. */
+		if (afork_size < sizeof(struct xfs_attr_sf_hdr))
+			return true;
+
+		/* xattr structure cannot be larger than the fork */
+		attr_size = be16_to_cpu(afork_ptr->hdr.totsize);
+		if (attr_size > afork_size)
+			return true;
+
+		/* xattr structure must pass verification. */
+		return xfs_attr_shortform_verify(afork_ptr, attr_size) != NULL;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (xrep_dinode_bad_extents_fork(sc, dip, afork_size,
+					XFS_ATTR_FORK))
+			return true;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (xrep_dinode_bad_bmbt_fork(sc, dip, afork_size,
+					XFS_ATTR_FORK))
+			return true;
+		break;
+	default:
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Reset the attr fork to empty.  Since the attr fork could have contained
+ * ACLs, make the file readable only by root.
+ */
+STATIC void
+xrep_dinode_zap_afork(
+	struct xrep_inode	*ri,
+	struct xfs_dinode	*dip,
+	uint16_t		mode)
+{
+	struct xfs_scrub	*sc = ri->sc;
+
+	trace_xrep_dinode_zap_afork(sc, dip);
+
+	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
+	xrep_dinode_set_attr_nextents(dip, 0);
+	ri->attr_blocks = 0;
+
+	/*
+	 * If the data fork is in btree format, removing the attr fork entirely
+	 * might cause verifier failures if the next level down in the bmbt
+	 * could now fit in the data fork area.
+	 */
+	if (dip->di_format != XFS_DINODE_FMT_BTREE)
+		dip->di_forkoff = 0;
+	dip->di_mode = cpu_to_be16(mode & ~0777);
+	dip->di_uid = 0;
+	dip->di_gid = 0;
+}
+
+/* Make sure the fork offset is a sensible value. */
+STATIC void
+xrep_dinode_ensure_forkoff(
+	struct xrep_inode	*ri,
+	struct xfs_dinode	*dip,
+	uint16_t		mode)
+{
+	struct xfs_bmdr_block	*bmdr;
+	struct xfs_scrub	*sc = ri->sc;
+	xfs_extnum_t		attr_extents, data_extents;
+	size_t			bmdr_minsz = XFS_BMDR_SPACE_CALC(1);
+	unsigned int		lit_sz = XFS_LITINO(sc->mp);
+	unsigned int		afork_min, dfork_min;
+
+	trace_xrep_dinode_ensure_forkoff(sc, dip);
+
+	/*
+	 * Before calling this function, xrep_dinode_core ensured that both
+	 * forks actually fit inside their respective literal areas.  If this
+	 * was not the case, the fork was reset to FMT_EXTENTS with zero
+	 * records.  If the rmapbt scan found attr or data fork blocks, this
+	 * will be noted in the dinode_stats, and we must leave enough room
+	 * for the bmap repair code to reconstruct the mapping structure.
+	 *
+	 * First, compute the minimum space required for the attr fork.
+	 */
+	switch (dip->di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+		/*
+		 * If we still have a shortform xattr structure at all, that
+		 * means the attr fork area was exactly large enough to fit
+		 * the sf structure.
+		 */
+		afork_min = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		attr_extents = xfs_dfork_attr_extents(dip);
+		if (attr_extents) {
+			/*
+			 * We must maintain sufficient space to hold the entire
+			 * extent map array in the data fork.  Note that we
+			 * previously zapped the fork if it had no chance of
+			 * fitting in the inode.
+			 */
+			afork_min = sizeof(struct xfs_bmbt_rec) * attr_extents;
+		} else if (ri->attr_extents > 0) {
+			/*
+			 * The attr fork thinks it has zero extents, but we
+			 * found some xattr extents.  We need to leave enough
+			 * empty space here so that the incore attr fork will
+			 * get created (and hence trigger the attr fork bmap
+			 * repairer).
+			 */
+			afork_min = bmdr_minsz;
+		} else {
+			/* No extents on disk or found in rmapbt. */
+			afork_min = 0;
+		}
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		/* Must have space for btree header and key/pointers. */
+		bmdr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);
+		afork_min = XFS_BMAP_BROOT_SPACE(sc->mp, bmdr);
+		break;
+	default:
+		/* We should never see any other formats. */
+		afork_min = 0;
+		break;
+	}
+
+	/* Compute the minimum space required for the data fork. */
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_DEV:
+		dfork_min = sizeof(__be32);
+		break;
+	case XFS_DINODE_FMT_UUID:
+		dfork_min = sizeof(uuid_t);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		/*
+		 * If we still have a shortform data fork at all, that means
+		 * the data fork area was large enough to fit whatever was in
+		 * there.
+		 */
+		dfork_min = be64_to_cpu(dip->di_size);
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		data_extents = xfs_dfork_data_extents(dip);
+		if (data_extents) {
+			/*
+			 * We must maintain sufficient space to hold the entire
+			 * extent map array in the data fork.  Note that we
+			 * previously zapped the fork if it had no chance of
+			 * fitting in the inode.
+			 */
+			dfork_min = sizeof(struct xfs_bmbt_rec) * data_extents;
+		} else if (ri->data_extents > 0 || ri->rt_extents > 0) {
+			/*
+			 * The data fork thinks it has zero extents, but we
+			 * found some data extents.  We need to leave enough
+			 * empty space here so that the data fork bmap repair
+			 * will recover the mappings.
+			 */
+			dfork_min = bmdr_minsz;
+		} else {
+			/* No extents on disk or found in rmapbt. */
+			dfork_min = 0;
+		}
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		/* Must have space for btree header and key/pointers. */
+		bmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+		dfork_min = XFS_BMAP_BROOT_SPACE(sc->mp, bmdr);
+		break;
+	default:
+		dfork_min = 0;
+		break;
+	}
+
+	/*
+	 * Round all values up to the nearest 8 bytes, because that is the
+	 * precision of di_forkoff.
+	 */
+	afork_min = roundup(afork_min, 8);
+	dfork_min = roundup(dfork_min, 8);
+	bmdr_minsz = roundup(bmdr_minsz, 8);
+
+	ASSERT(dfork_min <= lit_sz);
+	ASSERT(afork_min <= lit_sz);
+
+	/*
+	 * If the data fork was zapped and we don't have enough space for the
+	 * recovery fork, move the attr fork up.
+	 */
+	if (dip->di_format == XFS_DINODE_FMT_EXTENTS &&
+	    xfs_dfork_data_extents(dip) == 0 &&
+	    (ri->data_extents > 0 || ri->rt_extents > 0) &&
+	    bmdr_minsz > XFS_DFORK_DSIZE(dip, sc->mp)) {
+		if (bmdr_minsz + afork_min > lit_sz) {
+			/*
+			 * The attr for and the stub fork we need to recover
+			 * the data fork won't both fit.  Zap the attr fork.
+			 */
+			xrep_dinode_zap_afork(ri, dip, mode);
+			afork_min = bmdr_minsz;
+		} else {
+			void	*before, *after;
+
+			/* Otherwise, just slide the attr fork up. */
+			before = XFS_DFORK_APTR(dip);
+			dip->di_forkoff = bmdr_minsz >> 3;
+			after = XFS_DFORK_APTR(dip);
+			memmove(after, before, XFS_DFORK_ASIZE(dip, sc->mp));
+		}
+	}
+
+	/*
+	 * If the attr fork was zapped and we don't have enough space for the
+	 * recovery fork, move the attr fork down.
+	 */
+	if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	    xfs_dfork_attr_extents(dip) == 0 &&
+	    ri->attr_extents > 0 &&
+	    bmdr_minsz > XFS_DFORK_ASIZE(dip, sc->mp)) {
+		if (dip->di_format == XFS_DINODE_FMT_BTREE) {
+			/*
+			 * If the data fork is in btree format then we can't
+			 * adjust forkoff because that runs the risk of
+			 * violating the extents/btree format transition rules.
+			 */
+		} else if (bmdr_minsz + dfork_min > lit_sz) {
+			/*
+			 * If we can't move the attr fork, too bad, we lose the
+			 * attr fork and leak its blocks.
+			 */
+			xrep_dinode_zap_afork(ri, dip, mode);
+		} else {
+			/*
+			 * Otherwise, just slide the attr fork down.  The attr
+			 * fork is empty, so we don't have any old contents to
+			 * move here.
+			 */
+			dip->di_forkoff = (lit_sz - bmdr_minsz) >> 3;
+		}
+	}
+}
+
+/*
+ * Zap the data/attr forks if we spot anything that isn't going to pass the
+ * ifork verifiers or the ifork formatters, because we need to get the inode
+ * into good enough shape that the higher level repair functions can run.
+ */
+STATIC void
+xrep_dinode_zap_forks(
+	struct xrep_inode	*ri,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	xfs_extnum_t		data_extents;
+	xfs_extnum_t		attr_extents;
+	xfs_filblks_t		nblocks;
+	uint16_t		mode;
+	bool			zap_datafork = false;
+	bool			zap_attrfork = ri->zap_acls;
+
+	trace_xrep_dinode_zap_forks(sc, dip);
+
+	mode = be16_to_cpu(dip->di_mode);
+
+	data_extents = xfs_dfork_data_extents(dip);
+	attr_extents = xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
+	/* Inode counters don't make sense? */
+	if (data_extents > nblocks)
+		zap_datafork = true;
+	if (attr_extents > nblocks)
+		zap_attrfork = true;
+	if (data_extents + attr_extents > nblocks)
+		zap_datafork = zap_attrfork = true;
+
+	if (!zap_datafork)
+		zap_datafork = xrep_dinode_check_dfork(sc, dip, mode);
+	if (!zap_attrfork)
+		zap_attrfork = xrep_dinode_check_afork(sc, dip);
+
+	/* Zap whatever's bad. */
+	if (zap_attrfork)
+		xrep_dinode_zap_afork(ri, dip, mode);
+	if (zap_datafork)
+		xrep_dinode_zap_dfork(ri, dip, mode);
+	xrep_dinode_ensure_forkoff(ri, dip, mode);
+
+	/*
+	 * Zero di_nblocks if we don't have any extents at all to satisfy the
+	 * buffer verifier.
+	 */
+	data_extents = xfs_dfork_data_extents(dip);
+	attr_extents = xfs_dfork_attr_extents(dip);
+	if (data_extents + attr_extents == 0)
+		dip->di_nblocks = 0;
+}
+
 /* Inode didn't pass dinode verifiers, so fix the raw buffer and retry iget. */
 STATIC int
 xrep_dinode_core(
@@ -380,6 +1075,11 @@ xrep_dinode_core(
 	int			error;
 	int			iget_error;
 
+	/* Figure out what this inode had mapped in both forks. */
+	error = xrep_dinode_count_rmaps(ri);
+	if (error)
+		return error;
+
 	/* Read the inode cluster buffer. */
 	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
 			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
@@ -394,10 +1094,11 @@ xrep_dinode_core(
 	/* Fix everything the verifier will complain about. */
 	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
 	xrep_dinode_header(sc, dip);
-	xrep_dinode_mode(sc, dip);
-	xrep_dinode_flags(sc, dip);
+	xrep_dinode_mode(ri, dip);
+	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(sc, dip);
 	xrep_dinode_extsize_hints(sc, dip);
+	xrep_dinode_zap_forks(ri, dip);
 
 	/* Write out the inode. */
 	trace_xrep_dinode_fixed(sc, dip);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6041c716242aa..120faa4dce2d0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1469,6 +1469,10 @@ DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_extsize_hints);
 DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_symlink);
 DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_dir);
 DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_fixed);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_forks);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_dfork);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_afork);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_ensure_forkoff);
 
 DECLARE_EVENT_CLASS(xrep_inode_class,
 	TP_PROTO(struct xfs_scrub *sc),
@@ -1522,6 +1526,44 @@ DEFINE_REPAIR_INODE_EVENT(xrep_inode_sfdir_size);
 DEFINE_REPAIR_INODE_EVENT(xrep_inode_dir_size);
 DEFINE_REPAIR_INODE_EVENT(xrep_inode_fixed);
 
+TRACE_EVENT(xrep_dinode_count_rmaps,
+	TP_PROTO(struct xfs_scrub *sc, xfs_rfsblock_t data_blocks,
+		xfs_rfsblock_t rt_blocks, xfs_rfsblock_t attr_blocks,
+		xfs_extnum_t data_extents, xfs_extnum_t rt_extents,
+		xfs_aextnum_t attr_extents),
+	TP_ARGS(sc, data_blocks, rt_blocks, attr_blocks, data_extents,
+		rt_extents, attr_extents),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_rfsblock_t, data_blocks)
+		__field(xfs_rfsblock_t, rt_blocks)
+		__field(xfs_rfsblock_t, attr_blocks)
+		__field(xfs_extnum_t, data_extents)
+		__field(xfs_extnum_t, rt_extents)
+		__field(xfs_aextnum_t, attr_extents)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->data_blocks = data_blocks;
+		__entry->rt_blocks = rt_blocks;
+		__entry->attr_blocks = attr_blocks;
+		__entry->data_extents = data_extents;
+		__entry->rt_extents = rt_extents;
+		__entry->attr_extents = attr_extents;
+	),
+	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %llu rtextents %llu aextents %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->data_blocks,
+		  __entry->rt_blocks,
+		  __entry->attr_blocks,
+		  __entry->data_extents,
+		  __entry->rt_extents,
+		  __entry->attr_extents)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

