Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BDEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiLaAAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbiLaAAT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E7D1E3CE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5679EB81DE0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012A4C433D2;
        Sat, 31 Dec 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444816;
        bh=uHOqYWFRUjBokQLEm2gqz5BDsGUuNqtRPqDos9+Zqas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NY/pcsw578Tcub5zyXzQWmyf3mHmxUQBee8IsfV3pfIw1GVWFk9MU0thHeo/lHk2Q
         SOnO673Jfm+YVLeet6mRUrykq9udxsDQdpeFrI9Hd4PEYt5nQv9nKOCZ9QjfDzluDf
         GEYt+iopytpri4TVGnNgwMA5jljF2v2O6ecKeojiQbNmwYXLtYqrpyw9VYw4KCiFy/
         /gyWBMDsITyNy7jKEUGst6yawdVtqkA7cllzKA28s1IucYX5/30jl0Viv2M3aHzWjA
         hUkBv8PuIHSEV6KJrsEJF6rw8060ZlCqDR/y5B+dh2F4aW+hxzO6Qk/M6qFurCQqyB
         GlC94l3fqYfJA==
Subject: [PATCH 2/5] xfs: use atomic extent swapping to fix user file fork
 data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:13 -0800
Message-ID: <167243845298.700496.13995255804054630084.stgit@magnolia>
In-Reply-To: <167243845264.700496.9115810454468711427.stgit@magnolia>
References: <167243845264.700496.9115810454468711427.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Build on the code that was recently added to the temporary repair file
code so that we can atomically switch the contents of any file fork,
even if the fork is in local format.  The upcoming functions to repair
xattrs, directories, and symlinks will need that capability.

Repair can lock out access to these user files by holding IOLOCK_EXCL on
these user files.  Therefore, it is safe to drop the ILOCK of both the
file being repaired and the tempfile being used for staging, and cancel
the scrub transaction.  We do this so that we can reuse the resource
estimation and transaction allocation functions used by a regular file
exchange operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_swapext.c |    2 
 fs/xfs/libxfs/xfs_swapext.h |    1 
 fs/xfs/scrub/tempfile.c     |  176 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h     |    2 
 fs/xfs/scrub/tempswap.h     |    2 
 5 files changed, 182 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 12d548aa90cf..42df372d1a89 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -709,7 +709,7 @@ xfs_swapext_rmapbt_blocks(
 }
 
 /* Estimate the bmbt and rmapbt overhead required to exchange extents. */
-static int
+int
 xfs_swapext_estimate_overhead(
 	struct xfs_swapext_req	*req)
 {
diff --git a/fs/xfs/libxfs/xfs_swapext.h b/fs/xfs/libxfs/xfs_swapext.h
index 155add23d8e2..13824310f2a2 100644
--- a/fs/xfs/libxfs/xfs_swapext.h
+++ b/fs/xfs/libxfs/xfs_swapext.h
@@ -145,6 +145,7 @@ unsigned int xfs_swapext_reflink_prep(const struct xfs_swapext_req *req);
 void xfs_swapext_reflink_finish(struct xfs_trans *tp,
 		const struct xfs_swapext_req *req, unsigned int reflink_state);
 
+int xfs_swapext_estimate_overhead(struct xfs_swapext_req *req);
 int xfs_swapext_estimate(struct xfs_swapext_req *req);
 
 extern struct kmem_cache	*xfs_swapext_intent_cache;
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 7214d2370bc9..c9a089b169f2 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -219,6 +219,19 @@ xrep_tempfile_iunlock(
 	sc->temp_ilock_flags &= ~XFS_ILOCK_EXCL;
 }
 
+/*
+ * Begin the process of making changes to both the file being scrubbed and
+ * the temporary file by taking ILOCK_EXCL on both.
+ */
+void
+xrep_tempfile_ilock_both(
+	struct xfs_scrub	*sc)
+{
+	xfs_lock_two_inodes(sc->ip, XFS_ILOCK_EXCL, sc->tempip, XFS_ILOCK_EXCL);
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+}
+
 /* Release the temporary file. */
 void
 xrep_tempfile_rele(
@@ -500,6 +513,78 @@ xrep_tempswap_prep_request(
 	return 0;
 }
 
+/*
+ * Fill out the swapext resource estimation structures in preparation for
+ * swapping the contents of a metadata file that we've rebuilt in the temp
+ * file.  Caller must hold IOLOCK_EXCL but not ILOCK_EXCL on both files.
+ */
+STATIC int
+xrep_tempswap_estimate(
+	struct xfs_scrub	*sc,
+	struct xrep_tempswap	*tx)
+{
+	struct xfs_swapext_req	*req = &tx->req;
+	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*tifp;
+	int			state = 0;
+
+	/*
+	 * Deal with either fork being in local format.  The swapext code only
+	 * knows how to exchange block mappings for regular files, so we only
+	 * have to know about local format for xattrs and directories.
+	 */
+	ifp = xfs_ifork_ptr(sc->ip, req->whichfork);
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
+		state |= 1;
+
+	tifp = xfs_ifork_ptr(sc->tempip, req->whichfork);
+	if (tifp->if_format == XFS_DINODE_FMT_LOCAL)
+		state |= 2;
+
+	switch (state) {
+	case 0:
+		/* Both files have mapped extents; use the regular estimate. */
+		return xfs_xchg_range_estimate(req);
+	case 1:
+		/*
+		 * The file being repaired is in local format, but the temp
+		 * file has mapped extents.  To perform the swap, the file
+		 * being repaired will be reinitialized to have an empty extent
+		 * map, so the number of exchanges is the temporary file's
+		 * extent count.
+		 */
+		req->ip1_bcount = sc->tempip->i_nblocks;
+		req->nr_exchanges = tifp->if_nextents;
+		break;
+	case 2:
+		/*
+		 * The temporary file is in local format, but the file being
+		 * repaired has mapped extents.  To perform the swap, the temp
+		 * file will be converted to have a single block, so the number
+		 * of exchanges is (worst case) the extent count of the file
+		 * being repaired plus one more.
+		 */
+		req->ip1_bcount = 1;
+		req->ip2_bcount = sc->ip->i_nblocks;
+		req->nr_exchanges = ifp->if_nextents;
+		break;
+	case 3:
+		/*
+		 * Both forks are in local format.  To perform the swap, the
+		 * file being repaired will be reinitialized to have an empty
+		 * extent map and the temp file will be converted to have a
+		 * single block.  Only one exchange is required.  Presumably,
+		 * the caller could not exchange the two inode fork areas
+		 * directly.
+		 */
+		req->ip1_bcount = 1;
+		req->nr_exchanges = 1;
+		break;
+	}
+
+	return xfs_swapext_estimate_overhead(req);
+}
+
 /*
  * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
  * this if quota enforcement is disabled or if both inodes' dquots are the
@@ -586,6 +671,49 @@ xrep_tempswap_trans_reserve(
 	return xrep_tempswap_reserve_quota(sc, tx);
 }
 
+/*
+ * Allocate a transaction, ILOCK the temporary file and the file being
+ * repaired, and join them to the transaction in preparation to swap fork
+ * contents as part of a repair operation.
+ */
+int
+xrep_tempswap_trans_alloc(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempswap	*tx)
+{
+	unsigned int		flags = 0;
+	int			error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xrep_tempswap_prep_request(sc, whichfork, tx);
+	if (error)
+		return error;
+
+	error = xrep_tempswap_estimate(sc, tx);
+	if (error)
+		return error;
+
+	if (xfs_has_lazysbcount(sc->mp))
+		flags |= XFS_TRANS_RES_FDBLKS;
+
+	error = xrep_tempswap_grab_log_assist(sc);
+	if (error)
+		return error;
+
+	error = xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
+			tx->req.resblks, 0, flags, &sc->tp);
+	if (error)
+		return error;
+
+	sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_xchg_range_ilock(sc->tp, sc->ip, sc->tempip);
+
+	return xrep_tempswap_reserve_quota(sc, tx);
+}
+
 /* Swap forks between the file being repaired and the temporary file. */
 int
 xrep_tempswap_contents(
@@ -617,3 +745,51 @@ xrep_tempswap_contents(
 
 	return 0;
 }
+
+/*
+ * Write local format data from one of the temporary file's forks into the same
+ * fork of file being repaired, and swap the file sizes, if appropriate.
+ * Caller must ensure that the file being repaired has enough fork space to
+ * hold all the bytes.
+ */
+void
+xrep_tempfile_copyout_local(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xfs_ifork	*temp_ifp;
+	struct xfs_ifork	*ifp;
+	unsigned int		ilog_flags = XFS_ILOG_CORE;
+
+	temp_ifp = xfs_ifork_ptr(sc->tempip, whichfork);
+	ifp = xfs_ifork_ptr(sc->ip, whichfork);
+
+	ASSERT(temp_ifp != NULL);
+	ASSERT(ifp != NULL);
+	ASSERT(temp_ifp->if_format == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		ASSERT(sc->tempip->i_disk_size <= xfs_inode_data_fork_size(sc->ip));
+		break;
+	case XFS_ATTR_FORK:
+		ASSERT(sc->tempip->i_forkoff >= sc->ip->i_forkoff);
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_idestroy_fork(ifp);
+	xfs_init_local_fork(sc->ip, whichfork, temp_ifp->if_u1.if_data,
+			temp_ifp->if_bytes);
+
+	if (whichfork == XFS_DATA_FORK) {
+		i_size_write(VFS_I(sc->ip), i_size_read(VFS_I(sc->tempip)));
+		sc->ip->i_disk_size = sc->tempip->i_disk_size;
+	}
+
+	ilog_flags |= xfs_ilog_fdata(whichfork);
+	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index 282637f36f3d..402957f7f2b3 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -16,6 +16,7 @@ void xrep_tempfile_iounlock(struct xfs_scrub *sc);
 void xrep_tempfile_ilock(struct xfs_scrub *sc);
 bool xrep_tempfile_ilock_nowait(struct xfs_scrub *sc);
 void xrep_tempfile_iunlock(struct xfs_scrub *sc);
+void xrep_tempfile_ilock_both(struct xfs_scrub *sc);
 
 int xrep_tempfile_prealloc(struct xfs_scrub *sc, xfs_fileoff_t off,
 		xfs_filblks_t len);
@@ -31,6 +32,7 @@ int xrep_tempfile_copyin(struct xfs_scrub *sc, xfs_fileoff_t off,
 int xrep_tempfile_set_isize(struct xfs_scrub *sc, unsigned long long isize);
 
 int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
+void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
 #else
 static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 {
diff --git a/fs/xfs/scrub/tempswap.h b/fs/xfs/scrub/tempswap.h
index 62e88cc6d91a..bef8d2d2134d 100644
--- a/fs/xfs/scrub/tempswap.h
+++ b/fs/xfs/scrub/tempswap.h
@@ -14,6 +14,8 @@ struct xrep_tempswap {
 int xrep_tempswap_grab_log_assist(struct xfs_scrub *sc);
 int xrep_tempswap_trans_reserve(struct xfs_scrub *sc, int whichfork,
 		struct xrep_tempswap *ti);
+int xrep_tempswap_trans_alloc(struct xfs_scrub *sc, int whichfork,
+		struct xrep_tempswap *ti);
 
 int xrep_tempswap_contents(struct xfs_scrub *sc, struct xrep_tempswap *ti);
 #endif /* CONFIG_XFS_ONLINE_REPAIR */

