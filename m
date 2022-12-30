Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCB5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbiLaBPf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiLaBPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:15:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE0618E30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE86561D74
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DADC433D2;
        Sat, 31 Dec 2022 01:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449332;
        bh=yRS2VsvOX2QfYTQXiGKktYeYGnMCt7/h9/5YIcmetKQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Alzvstshj2HPb5K2d+NpJJCLEqbLLx/wXN7XEroBFT4K8HTp/0L1CiKVaPUVCiIm9
         tLhdvk1WBQhuhetVzKI2rYxJTuvBE5T8So3jVkGqBDuRdT/1wvCRXp5hKcoChmBYOP
         bCg8fUG2XvR/YRXyW7AG4ZL59M4vRcXWve7antN4Gnn6eWExT8fBd02bJpDYz2J+F2
         2XY6oI1Nk7mgbS1aQ8d0Ix5MVFkRIj+bOBZotuPtk4+YOqj7XUwizy7vKww4N/wZfW
         o/gXTI4j2krYfn6wqphqeAkdB9NrZ9B5Untk/7nwK3V/hGyO85PId3dYzYGftFGXYL
         kJQpr8qtvAtBg==
Subject: [PATCH 20/23] xfs: scrub metadata directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:27 -0800
Message-ID: <167243864741.708110.16141637739025575601.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach online scrub about the metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c           |    9 +++++++++
 fs/xfs/scrub/dir_repair.c    |    6 ++++++
 fs/xfs/scrub/parent.c        |   18 ++++++++++++++++++
 fs/xfs/scrub/parent_repair.c |   37 +++++++++++++++++++++++++++++++------
 4 files changed, 64 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 218cf43cdf93..30636501fb9f 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -59,6 +59,15 @@ xchk_dir_check_ftype(
 
 	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
+	/*
+	 * Metadata and regular inodes cannot cross trees.  This property
+	 * cannot change without a full inode free and realloc cycle, so it's
+	 * safe to check this without holding locks.
+	 */
+	if (xfs_is_metadata_inode(ip) ^ xfs_is_metadata_inode(sc->ip))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
 }
 
 /*
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 7530819e1435..14f34b9d4448 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -204,6 +204,12 @@ xrep_dir_salvage_entry(
 	if (error)
 		return 0;
 
+	/* Don't mix metadata and regular directory trees. */
+	if (xfs_is_metadata_inode(ip) ^ xfs_is_metadata_inode(rd->sc->ip)) {
+		xchk_irele(sc, ip);
+		return 0;
+	}
+
 	entry.ftype = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
 	xchk_irele(sc, ip);
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 92866f1757be..5af765a8182c 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -197,6 +197,16 @@ xchk_parent_validate(
 		goto out_rele;
 	}
 
+	/*
+	 * Metadata and regular inodes cannot cross trees.  This property
+	 * cannot change without a full inode free and realloc cycle, so it's
+	 * safe to check this without holding locks.
+	 */
+	if (xfs_is_metadata_inode(dp) ^ xfs_is_metadata_inode(sc->ip)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out_rele;
+	}
+
 	/*
 	 * We prefer to keep the inode locked while we lock and search its
 	 * alleged parent for a forward reference.  If we can grab the iolock
@@ -302,5 +312,13 @@ xchk_parent(
 		return 0;
 	}
 
+	/* Is this the metadata root dir?  Then '..' must point to itself. */
+	if (sc->ip == mp->m_metadirip) {
+		if (sc->ip->i_ino != mp->m_sb.sb_metadirino ||
+		    sc->ip->i_ino != parent_ino)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
 	return xchk_parent_validate(sc, parent_ino);
 }
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index ffef5de0fbe2..bba1cd1c7c8b 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -135,6 +135,10 @@ xrep_findparent_walk_directory(
 	if (xrep_is_tempfile(dp))
 		return 0;
 
+	/* Don't mix metadata and regular directory trees. */
+	if (xfs_is_metadata_inode(dp) ^ xfs_is_metadata_inode(sc->ip))
+		return 0;
+
 	/* Try to lock dp; if we can, we're ready to scan! */
 	if (!xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
 		xfs_ino_t	orig_parent, new_parent;
@@ -227,15 +231,30 @@ xrep_parent_confirm(
 	};
 	int			error;
 
-	/*
-	 * The root directory always points to itself.  Unlinked dirs can point
-	 * anywhere, so we point them at the root dir too.
-	 */
-	if (sc->ip == sc->mp->m_rootip || VFS_I(sc->ip)->i_nlink == 0) {
+	/* The root directory always points to itself. */
+	if (sc->ip == sc->mp->m_rootip) {
 		*parent_ino = sc->mp->m_sb.sb_rootino;
 		return 0;
 	}
 
+	/* The metadata root directory always points to itself. */
+	if (sc->ip == sc->mp->m_metadirip) {
+		*parent_ino = sc->mp->m_sb.sb_metadirino;
+		return 0;
+	}
+
+	/*
+	 * Unlinked dirs can point anywhere, so we point them at the root dir
+	 * of whichever tree is appropriate.
+	 */
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		if (xfs_is_metadata_inode(sc->ip))
+			*parent_ino = sc->mp->m_sb.sb_metadirino;
+		else
+			*parent_ino = sc->mp->m_sb.sb_rootino;
+		return 0;
+	}
+
 	/* Reject garbage parent inode numbers and self-referential parents. */
 	if (*parent_ino == NULLFSINO)
 	       return 0;
@@ -389,8 +408,14 @@ xrep_parent_self_reference(
 	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
 		return sc->mp->m_sb.sb_rootino;
 
-	if (VFS_I(sc->ip)->i_nlink == 0)
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_metadirino)
+		return sc->mp->m_sb.sb_metadirino;
+
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		if (xfs_is_metadata_inode(sc->ip))
+			return sc->mp->m_sb.sb_metadirino;
 		return sc->mp->m_sb.sb_rootino;
+	}
 
 	return NULLFSINO;
 }

