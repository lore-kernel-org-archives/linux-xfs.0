Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4951EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiL3XcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiL3XcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:32:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FA9164AF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12731B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A2CC433EF;
        Fri, 30 Dec 2022 23:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443135;
        bh=XKY2OuTN/SSoHe+f8lbIq6CuL64pMRFtFJhc5FNC7Gs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sElGeOJiY2OSYRfoa3DzLbxXylbTuhi1YD6DZ3rk2uL9hGSxrBXj8W79kAGumw4rV
         +sauOj9zNHffnlEcnW7UngQQthZECvqoRTMA5gyYjUfVAlY//19o3gThI9vPtRegdK
         S46yOBoyWkeijHQ+hnG2ZzqUrLoojFZz2XgegLS1oicqmBmVf/r7p7aRyi3MYcJdeD
         n7y1R5Z5dFWsoE2RLh61RUD8+AZkGCLYI7X6I26fri0Dm4gxhuH6QhBA9YiMs7WCsJ
         6UV0qEC1+9/vqkb6/ixQyDiJo5GpIEjpLXW4xHqB/lL64J/K58K9CrFUTnUlujURDB
         jiIENNev4FbCw==
Subject: [PATCH 1/4] xfs: repair the inode core and forks of a metadata inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838007.695277.14042285203439915158.stgit@magnolia>
In-Reply-To: <167243837989.695277.12249962882609806700.stgit@magnolia>
References: <167243837989.695277.12249962882609806700.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index b9425f1a87d7..4638f3652b54 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -74,6 +74,9 @@ struct xrep_bmap {
 
 	/* Which fork are we fixing? */
 	int			whichfork;
+
+	/* Do we allow unwritten extents? */
+	bool			allow_unwritten;
 };
 
 /* Remember this reverse-mapping as a series of bmap records. */
@@ -213,6 +216,10 @@ xrep_bmap_walk_rmap(
 	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
 		return 0;
 
+	/* Reject unwritten extents if we don't allow those. */
+	if ((rec->rm_flags & XFS_RMAP_UNWRITTEN) && !rb->allow_unwritten)
+		return -EFSCORRUPTED;
+
 	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
 			rec->rm_startblock);
 
@@ -705,10 +712,11 @@ xrep_bmap_check_inputs(
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
 	unsigned int		max_bmbt_recs;
@@ -726,6 +734,7 @@ xrep_bmap(
 		return -ENOMEM;
 	rb->sc = sc;
 	rb->whichfork = whichfork;
+	rb->allow_unwritten = allow_unwritten;
 
 	/* Set up enough storage to handle the max records for this fork. */
 	large_extcount = xfs_has_large_extent_counts(sc->mp);
@@ -764,7 +773,7 @@ int
 xrep_bmap_data(
 	struct xfs_scrub	*sc)
 {
-	return xrep_bmap(sc, XFS_DATA_FORK);
+	return xrep_bmap(sc, XFS_DATA_FORK, true);
 }
 
 /* Repair an inode's attr fork. */
@@ -772,5 +781,5 @@ int
 xrep_bmap_attr(
 	struct xfs_scrub	*sc)
 {
-	return xrep_bmap(sc, XFS_ATTR_FORK);
+	return xrep_bmap(sc, XFS_ATTR_FORK, false);
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3f3554d82eeb..2de438ddb8ac 100644
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
@@ -947,3 +948,153 @@ xrep_will_attempt(
 
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
index 8f525d7c63c7..69cb6b38bc55 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -72,6 +72,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
+int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
+int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);

