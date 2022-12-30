Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8724DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiLaBp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiLaBp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:45:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85682F026
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F5E261CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6E9C433EF;
        Sat, 31 Dec 2022 01:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451126;
        bh=VW3w3XlqxmsGE6Jo0BTYi+GqqupgCz5mejzpRDW2X2c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sx2pXIB0baRqSTLRlVqzv1gp1O4vL3Fw1VTcNJqGNN8UHz8icNdAs4szLLln5Quav
         u49kjTQhEKX2qnEnVCuJ0g5ycZ75xeYUFxDfh3KTE+qJWX6Kydfy6H+FjNw1fMAp7y
         cpx28ILA1hi6GJwDMb8U7PMPuCR977Xf2YDJfulaDbAAT4vGLcgnmxHd5UY3nypvLj
         F5FRIuwJ4ny10rRlZxeWqiy1yP1Q2lZJUErwX6CSvZmcKX2kNKid0UNtfZavaA1LTw
         FZnrB7BW2iwy4fRbb83yYYgArLlrHQC4TYYgIXYJAz9T0FbWqn03YrXRpzhRHsepxe
         VGZ0NrPMj6x+g==
Subject: [PATCH 33/38] xfs: repair inodes that have realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:20 -0800
Message-ID: <167243870074.715303.5398086761063722797.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Plumb into the inode core repair code the ability to search for extents
on realtime devices.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   68 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a8d19d1e76e3..8566282827f8 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -37,6 +37,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -610,18 +612,77 @@ xrep_dinode_count_ag_rmaps(
 	return error;
 }
 
+/* Count extents and blocks for an inode given an rt rmap. */
+STATIC int
+xrep_dinode_walk_rtrmap(
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
+	if (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))
+		return -EFSCORRUPTED;
+
+	ri->rt_blocks += rec->rm_blockcount;
+	ri->rt_extents++;
+	return 0;
+}
+
+/* Count extents and blocks for an inode from all realtime rmap data. */
+STATIC int
+xrep_dinode_count_rtgroup_rmaps(
+	struct xrep_inode	*ri,
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	if (!xfs_has_realtime(sc->mp) ||
+	    xrep_is_rtmeta_ino(sc, rtg, sc->sm->sm_ino))
+		return 0;
+
+	error = xrep_rtgroup_init(sc, rtg, &sc->sr, XFS_RTGLOCK_RMAP);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_dinode_walk_rtrmap,
+			ri);
+	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_free(sc, &sc->sr);
+	return error;
+}
+
 /* Count extents and blocks for a given inode from all rmap data. */
 STATIC int
 xrep_dinode_count_rmaps(
 	struct xrep_inode	*ri)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
-	if (!xfs_has_rmapbt(ri->sc->mp) || xfs_has_realtime(ri->sc->mp))
+	if (!xfs_has_rmapbt(ri->sc->mp))
 		return -EOPNOTSUPP;
 
+	for_each_rtgroup(ri->sc->mp, rgno, rtg) {
+		error = xrep_dinode_count_rtgroup_rmaps(ri, rtg);
+		if (error) {
+			xfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
 	for_each_perag(ri->sc->mp, agno, pag) {
 		error = xrep_dinode_count_ag_rmaps(ri, pag);
 		if (error) {
@@ -917,6 +978,7 @@ xrep_dinode_ensure_forkoff(
 	uint16_t		mode)
 {
 	struct xfs_bmdr_block	*bmdr;
+	struct xfs_rtrmap_root	*rmdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
 	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
@@ -1023,6 +1085,10 @@ xrep_dinode_ensure_forkoff(
 		bmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 		dfork_min = xfs_bmap_broot_space(sc->mp, bmdr);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		rmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+		dfork_min = xfs_rtrmap_broot_space(sc->mp, rmdr);
+		break;
 	default:
 		dfork_min = 0;
 		break;

