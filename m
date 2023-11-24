Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5B83C482
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/rWo9qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F40C433C8;
	Fri, 24 Nov 2023 23:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870115;
	bh=ffdW+eTYu7ksuX/UplavKU63Hz8Wvtljtw5MgFkxjm0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D/rWo9qNz/ncdtA3bzuXnLWe1plJgzb1nDQOQ7Q3blw0C0uAnFSM3jujCSLNnb35A
	 Sb6lEpDwsyKmOnR5XWSu2d3qlHUCacehyHuif3dxanCNNZzjz8pYxs956Jth/MmIy6
	 JGHAqmIkEObL7OQQRfpBva/J/nmD/VdueDvAHTFHFIxBhi+HUIQlFd4RID+SMAy7WS
	 Vl/gWBG+K3G9otALwzK1z6DYjtVuUMnU/2BlXj3bAGntdZnkhq0eHFBIOi/Dipatc3
	 QJtCCegvmc84F5jq4bhUZPU1+bmjXvCBmK5esyQZ6hAtQEcsXfAZSkmKFR9AfHxCQe
	 /1VlzPUa3yAqw==
Date: Fri, 24 Nov 2023 15:55:15 -0800
Subject: [PATCH 4/6] xfs: repair the inode core and forks of a metadata inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928407.2771542.9456327157299550315.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
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

Add a helper function to repair the core and forks of a metadata inode,
so that we can get move onto the task of repairing higher level metadata
that lives in an inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap_repair.c |   17 ++++-
 fs/xfs/scrub/repair.c      |  151 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 +
 3 files changed, 166 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 2c593eebb1fc4..e55f3e52f36fc 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -78,6 +78,9 @@ struct xrep_bmap {
 
 	/* Are there shared extents? */
 	bool			shared_extents;
+
+	/* Do we allow unwritten extents? */
+	bool			allow_unwritten;
 };
 
 /* Is this space extent shared?  Flag the inode if it is. */
@@ -272,6 +275,10 @@ xrep_bmap_walk_rmap(
 	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
 		return 0;
 
+	/* Reject unwritten extents if we don't allow those. */
+	if ((rec->rm_flags & XFS_RMAP_UNWRITTEN) && !rb->allow_unwritten)
+		return -EFSCORRUPTED;
+
 	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
 			rec->rm_startblock);
 
@@ -762,10 +769,11 @@ xrep_bmap_check_inputs(
 }
 
 /* Repair an inode fork. */
-STATIC int
+int
 xrep_bmap(
 	struct xfs_scrub	*sc,
-	int			whichfork)
+	int			whichfork,
+	bool			allow_unwritten)
 {
 	struct xrep_bmap	*rb;
 	char			*descr;
@@ -784,6 +792,7 @@ xrep_bmap(
 		return -ENOMEM;
 	rb->sc = sc;
 	rb->whichfork = whichfork;
+	rb->allow_unwritten = allow_unwritten;
 
 	/*
 	 * No need to waste time scanning for shared extents if the inode is
@@ -834,7 +843,7 @@ int
 xrep_bmap_data(
 	struct xfs_scrub	*sc)
 {
-	return xrep_bmap(sc, XFS_DATA_FORK);
+	return xrep_bmap(sc, XFS_DATA_FORK, true);
 }
 
 /* Repair an inode's attr fork. */
@@ -842,5 +851,5 @@ int
 xrep_bmap_attr(
 	struct xfs_scrub	*sc)
 {
-	return xrep_bmap(sc, XFS_ATTR_FORK);
+	return xrep_bmap(sc, XFS_ATTR_FORK, false);
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 0f8dc25ef998b..cd13ba9b4f345 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -29,6 +29,7 @@
 #include "xfs_defer.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_reflink.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -959,3 +960,153 @@ xrep_will_attempt(
 
 	return false;
 }
+
+/* Try to fix some part of a metadata inode by calling another scrubber. */
+STATIC int
+xrep_metadata_inode_subtype(
+	struct xfs_scrub	*sc,
+	unsigned int		scrub_type)
+{
+	__u32			smtype = sc->sm->sm_type;
+	__u32			smflags = sc->sm->sm_flags;
+	int			error;
+
+	/*
+	 * Let's see if the inode needs repair.  We're going to open-code calls
+	 * to the scrub and repair functions so that we can hang on to the
+	 * resources that we already acquired instead of using the standard
+	 * setup/teardown routines.
+	 */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	sc->sm->sm_type = scrub_type;
+
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xchk_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xchk_bmap_data(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		error = xchk_bmap_attr(sc);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+	}
+	if (error)
+		goto out;
+
+	if (!xrep_will_attempt(sc))
+		goto out;
+
+	/*
+	 * Repair some part of the inode.  This will potentially join the inode
+	 * to the transaction.
+	 */
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xrep_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xrep_bmap(sc, XFS_DATA_FORK, false);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		error = xrep_bmap(sc, XFS_ATTR_FORK, false);
+		break;
+	}
+	if (error)
+		goto out;
+
+	/*
+	 * Finish all deferred intent items and then roll the transaction so
+	 * that the inode will not be joined to the transaction when we exit
+	 * the function.
+	 */
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		goto out;
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		goto out;
+
+	/*
+	 * Clear the corruption flags and re-check the metadata that we just
+	 * repaired.
+	 */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xchk_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xchk_bmap_data(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		error = xchk_bmap_attr(sc);
+		break;
+	}
+	if (error)
+		goto out;
+
+	/* If corruption persists, the repair has failed. */
+	if (xchk_needs_repair(sc->sm)) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+out:
+	sc->sm->sm_type = smtype;
+	sc->sm->sm_flags = smflags;
+	return error;
+}
+
+/*
+ * Repair the ondisk forks of a metadata inode.  The caller must ensure that
+ * sc->ip points to the metadata inode and the ILOCK is held on that inode.
+ * The inode must not be joined to the transaction before the call, and will
+ * not be afterwards.
+ */
+int
+xrep_metadata_inode_forks(
+	struct xfs_scrub	*sc)
+{
+	bool			dirty = false;
+	int			error;
+
+	/* Repair the inode record and the data fork. */
+	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_INODE);
+	if (error)
+		return error;
+
+	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTD);
+	if (error)
+		return error;
+
+	/* Make sure the attr fork looks ok before we delete it. */
+	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+	if (error)
+		return error;
+
+	/* Clear the reflink flag since metadata never shares. */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		dirty = true;
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		error = xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If we modified the inode, roll the transaction but don't rejoin the
+	 * inode to the new transaction because xrep_bmap_data can do that.
+	 */
+	if (dirty) {
+		error = xfs_trans_roll(&sc->tp);
+		if (error)
+			return error;
+		dirty = false;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index be3585b8f4364..b7ddd35e753eb 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -82,6 +82,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
+int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
+int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);

