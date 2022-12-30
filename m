Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974DAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbiLaCwK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiLaCwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:52:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C24511450
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:52:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8E2BB81E6F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C37AC433D2;
        Sat, 31 Dec 2022 02:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455125;
        bh=HVqxtQGcJQXbaOg6huTEAAEO56SWISXeY8j06RTQSxM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aVEIXFcB3T+jh4UdWESGEwrwh89BWaGYcJ4RLcSugxicay0+uR9ChvCBiLZErheEh
         oDo0+luNhZlyGKW+ekLo9q6vfwnXn2EaJ+4j8+XuV23AaJQOqb8qeXM/j2HZsLOtCY
         yn01/A9aMITD3iaqebIQH3iAmFlG3uDXLX92iqN03Xr0+4HcaIlEyDwWa+vjZ+sqnG
         OoqpTI98IZWBS4oufgbe+ge8fdPTHMJ99HY2Wb6kGnbWdgbs9f+f63+SKfmuQSYfMM
         YbWQ+jdhah+JLNBdxejA2fXpgDVEIgqNSKS9LpH5qTevn/2AHqfQrM8tbk/VvOyDBm
         arug04oyyuJvQ==
Subject: [PATCH 37/41] xfs_repair: rebuild the bmap btree for realtime files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880083.732820.16035907503055333430.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the realtime rmap btree information to rebuild an inode's data fork
when appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/bmap_repair.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 118 insertions(+), 4 deletions(-)


diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 5e41934b543..06ed86a0b4b 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -212,6 +212,113 @@ xrep_bmap_scan_ag(
 	return error;
 }
 
+/* Check for any obvious errors or conflicts in the file mapping. */
+STATIC int
+xrep_bmap_check_rtfork_rmap(
+	struct repair_ctx		*sc,
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec)
+{
+	/* xattr extents are never stored on realtime devices */
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
+		return EFSCORRUPTED;
+
+	/* bmbt blocks are never stored on realtime devices */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		return EFSCORRUPTED;
+
+	/* Data extents for non-rt files are never stored on the rt device. */
+	if (!XFS_IS_REALTIME_INODE(sc->ip))
+		return EFSCORRUPTED;
+
+	/* Check the file offsets and physical extents. */
+	if (!xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+		return EFSCORRUPTED;
+
+	/* Check that this fits in the rt volume. */
+	if (!xfs_verify_rgbext(cur->bc_ino.rtg, rec->rm_startblock,
+				rec->rm_blockcount))
+		return EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Record realtime extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_bmap		*rb = priv;
+	int				error = 0;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_bmap_check_rtfork_rmap(rb->sc, cur, rec);
+	if (error)
+		return error;
+
+	/*
+	 * Record all blocks allocated to this file even if the extent isn't
+	 * for the fork we're rebuilding so that we can reset di_nblocks later.
+	 */
+	rb->nblocks += rec->rm_blockcount;
+
+	/* If this rmap isn't for the fork we want, we're done. */
+	if (rb->whichfork == XFS_DATA_FORK &&
+	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rb->whichfork == XFS_ATTR_FORK &&
+	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	return xrep_bmap_from_rmap(rb, rec->rm_offset, rec->rm_startblock,
+			rec->rm_blockcount,
+			rec->rm_flags & XFS_RMAP_UNWRITTEN);
+}
+
+/*
+ * Scan the realtime reverse mappings to build the new extent map.  The rt rmap
+ * inodes must be loaded from disk explicitly here, since we have not yet
+ * validated the metadata directory tree but do not wish to throw away user
+ * data unnecessarily.
+ */
+STATIC int
+xrep_bmap_scan_rt(
+	struct xrep_bmap	*rb,
+	struct xfs_rtgroup	*rtg)
+{
+	struct repair_ctx	*sc = rb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_inode	*ip;
+	struct xfs_imeta_path	*path;
+	xfs_ino_t		ino;
+	int			error;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_lookup(mp, path, &ino);
+	libxfs_imeta_free_path(path);
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+	if (error)
+		return error;
+
+	cur = libxfs_rtrmapbt_init_cursor(mp, sc->tp, rtg, ip);
+	error = -libxfs_rmap_query_all(cur, xrep_bmap_walk_rtrmap, rb);
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_imeta_irele(ip);
+	return error;
+}
+
 /*
  * Collect block mappings for this fork of this inode and decide if we have
  * enough space to rebuild.  Caller is responsible for cleaning up the list if
@@ -222,9 +329,20 @@ xrep_bmap_find_mappings(
 	struct xrep_bmap	*rb)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
+	/* Iterate the rtrmaps for extents. */
+	for_each_rtgroup(rb->sc->mp, rgno, rtg) {
+		error = xrep_bmap_scan_rt(rb, rtg);
+		if (error) {
+			libxfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
 	/* Iterate the rmaps for extents. */
 	for_each_perag(rb->sc->mp, agno, pag) {
 		error = xrep_bmap_scan_ag(rb, pag);
@@ -564,10 +682,6 @@ xrep_bmap_check_inputs(
 		return EINVAL;
 	}
 
-	/* Don't know how to rebuild realtime data forks. */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return EOPNOTSUPP;
-
 	return 0;
 }
 

