Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B276BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzXJef5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAADC433C7;
	Sun, 31 Dec 2023 21:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058855;
	bh=n6UvvuOetrKBPwcwfJsqSFBFdGH0XEhrJVW6Zd18n5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qzXJef5Lpv19xWHY0r+GUgBSI+4hr3BHV00w3GVFvx3pb5VCQV5ZBJkE5h1OchdqP
	 kUSK81zLD9x9muAnsjZq+xBFEw7dpqTwHuRoz6c7M/tDHD6CZoWAudK7lFJ4s45D4h
	 xCCM9ABeTzfyyg5fxVEIF4eWGJuXNwDIxxP9UL9V0IWp3d++rDLgfnD5k1l9iy7F1F
	 McwjZi3PfNLzHb/aUIdLzgXi5aBOJK8chmrtI3dQp7AC6cRHADpBvSOkMRhDeP+hjJ
	 Z2UiDzdPitvjbXhLWyosf4h/bNyiBBd9wtfpwoPK1zRg4zZz2GNlqDpl8Zqw5zWjIg
	 e8DCj7uO1r5sg==
Date: Sun, 31 Dec 2023 13:40:55 -0800
Subject: [PATCH 35/39] xfs: support repairing metadata btrees rooted in
 metadir inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850463.1764998.8425659997382974924.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Adapt the repair code so that we can stage a new btree in the data fork
area of a metadir inode and reap the old blocks.  We already have nearly
all of the infrastructure; the only parts that were missing were the
metadata inode reservation handling.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/newbt.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h |    1 +
 fs/xfs/scrub/reap.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h  |    2 ++
 4 files changed, 87 insertions(+)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 8375c8b9752a7..66a780f4e0176 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -19,6 +19,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_defer.h"
+#include "xfs_imeta.h"
+#include "xfs_quota.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -120,6 +122,44 @@ xrep_newbt_init_inode(
 	return 0;
 }
 
+/*
+ * Initialize accounting resources for staging a new metadata inode btree.
+ * If the inode has an imeta space reservation, the caller must adjust the
+ * imeta reservation at btree commit.
+ */
+int
+xrep_newbt_init_metadir_inode(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_ifork		*ifp;
+
+	ASSERT(xfs_is_metadir_inode(sc->ip));
+	ASSERT(XFS_IS_DQDETACHED(sc->mp, sc->ip));
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+
+	ifp = kmem_cache_zalloc(xfs_ifork_cache, XCHK_GFP_FLAGS);
+	if (!ifp)
+		return -ENOMEM;
+
+	/*
+	 * Allocate new metadir btree blocks with XFS_AG_RESV_NONE because the
+	 * inode metadata space reservations can only account allocated space
+	 * to the i_nblocks.  We do not want to change the inode core fields
+	 * until we're ready to commit the new tree, so we allocate the blocks
+	 * as if they were regular file blocks.  This exposes us to a higher
+	 * risk of the repair being cancelled due to ENOSPC.
+	 */
+	xrep_newbt_init_ag(xnr, sc, &oinfo,
+			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
+			XFS_AG_RESV_NONE);
+	xnr->ifake.if_fork = ifp;
+	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, XFS_DATA_FORK);
+	return 0;
+}
+
 /*
  * Initialize accounting resources for staging a new btree.  Callers are
  * expected to add their own reservations (and clean them up) manually.
@@ -225,6 +265,7 @@ xrep_newbt_alloc_ag_blocks(
 	int			error = 0;
 
 	ASSERT(sc->sa.pag != NULL);
+	ASSERT(xnr->resv != XFS_AG_RESV_IMETA);
 
 	while (nr_blocks > 0) {
 		struct xfs_alloc_arg	args = {
@@ -299,6 +340,8 @@ xrep_newbt_alloc_file_blocks(
 	struct xfs_mount	*mp = sc->mp;
 	int			error = 0;
 
+	ASSERT(xnr->resv != XFS_AG_RESV_IMETA);
+
 	while (nr_blocks > 0) {
 		struct xfs_alloc_arg	args = {
 			.tp		= sc->tp,
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index 3d804d31af24a..5ce785599287b 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -63,6 +63,7 @@ void xrep_newbt_init_ag(struct xrep_newbt *xnr, struct xfs_scrub *sc,
 		enum xfs_ag_resv_type resv);
 int xrep_newbt_init_inode(struct xrep_newbt *xnr, struct xfs_scrub *sc,
 		int whichfork, const struct xfs_owner_info *oinfo);
+int xrep_newbt_init_metadir_inode(struct xrep_newbt *xnr, struct xfs_scrub *sc);
 int xrep_newbt_alloc_blocks(struct xrep_newbt *xnr, uint64_t nr_blocks);
 int xrep_newbt_add_extent(struct xrep_newbt *xnr, struct xfs_perag *pag,
 		xfs_agblock_t agbno, xfs_extlen_t len);
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 37eb61906be18..b8c48e36d2a8d 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -33,6 +33,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_defer.h"
+#include "xfs_imeta.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -391,6 +392,8 @@ xreap_agextent_iter(
 	xfs_fsblock_t		fsbno;
 	int			error = 0;
 
+	ASSERT(rs->resv != XFS_AG_RESV_IMETA);
+
 	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno, agbno);
 
 	/*
@@ -676,6 +679,44 @@ xrep_reap_fsblocks(
 	return 0;
 }
 
+/*
+ * Dispose of every block of an old metadata btree that used to be rooted in a
+ * metadata directory file.
+ */
+int
+xrep_reap_metadir_fsblocks(
+	struct xfs_scrub		*sc,
+	struct xfsb_bitmap		*bitmap)
+{
+	/*
+	 * Reap old metadir btree blocks with XFS_AG_RESV_NONE because the old
+	 * blocks are no longer mapped by the inode, and inode metadata space
+	 * reservations can only account freed space to the i_nblocks.
+	 */
+	struct xfs_owner_info		oinfo;
+	struct xreap_state		rs = {
+		.sc			= sc,
+		.oinfo			= &oinfo,
+		.resv			= XFS_AG_RESV_NONE,
+	};
+	int				error;
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(sc->ip != NULL);
+	ASSERT(xfs_is_metadir_inode(sc->ip));
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+
+	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
+	if (error)
+		return error;
+
+	if (xreap_dirty(&rs))
+		return xrep_defer_finish(sc);
+
+	return 0;
+}
+
 /*
  * Metadata files are not supposed to share blocks with anything else.
  * If blocks are shared, we remove the reverse mapping (thus reducing the
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 3f2f1775e29db..70e5e6bbb8d38 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -14,6 +14,8 @@ int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
 int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo);
 int xrep_reap_ifork(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork);
+int xrep_reap_metadir_fsblocks(struct xfs_scrub *sc,
+		struct xfsb_bitmap *bitmap);
 
 /* Buffer cache scan context. */
 struct xrep_bufscan {

