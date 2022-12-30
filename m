Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B949AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiLaAJJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbiLaAJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:09:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDECF1CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BF6B81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BF6C433D2;
        Sat, 31 Dec 2022 00:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445345;
        bh=L9KcCI6bh4kns0frselq0d4+1Ik9MB4AxmzK36uLuLk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SL2EAplqZr2wKyd9itVw+ijm1bIQhaLa/8RNQssrcvGbH2RgyWFVuBFM+McFDdtAK
         NXU1h1625zE/KLFEaL2/M0x8ewvj6nyAn77UmsQSHsSRkP9mxiroCs17X0+ofErKNU
         K2fHn6vw9p8rHNw8clRp6EXXxknQ5FoCzIth9707At+OYSutuEBU1FhaludVBzIh7K
         k12yxBz368vryLUucuXnWhvH7jbUOT63Gr5tEphiGV/iu/aF+xCryM8lXRUsnEZ/AV
         e+Saoajkg1fDXxTylvaAx5NohYfVj09eERz3OhBtNqIOl6TGHduCzYEDa91++98Ks3
         +PvTgkwCyRbkA==
Subject: [PATCH 1/2] xfs_repair: push inode buf and dinode pointers all the
 way to inode fork processing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865205.709165.3039237323414368997.stgit@magnolia>
In-Reply-To: <167243865191.709165.12894699968646341429.stgit@magnolia>
References: <167243865191.709165.12894699968646341429.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the process_dinode* family of functions assume that they have
the buffer backing the inodes locked, and therefore the dinode pointer
won't ever change.  However, the bmbt rebuilding code in the next patch
will violate that assumption, so we must pass pointers to the inobp and
the dinode pointer (that is to say, double pointers) all the way through
to process_inode_{data,attr}_fork so that we can regrab the buffer after
the rebuilding step finishes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    5 ++-
 repair/dinode.c      |   88 ++++++++++++++++++++++++++++----------------------
 repair/dinode.h      |    7 ++--
 3 files changed, 57 insertions(+), 43 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 0e09132b0b1..5c7799b1888 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -851,10 +851,11 @@ process_inode_chunk(
 		ino_dirty = 0;
 		parent = 0;
 
-		status = process_dinode(mp, dino, agno, agino,
+		status = process_dinode(mp, &dino, agno, agino,
 				is_inode_free(ino_rec, irec_offset),
 				&ino_dirty, &is_used,ino_discovery, check_dups,
-				extra_attr_check, &isa_dir, &parent);
+				extra_attr_check, &isa_dir, &parent,
+				&bplist[bp_index]);
 
 		ASSERT(is_used != 3);
 		if (ino_dirty) {
diff --git a/repair/dinode.c b/repair/dinode.c
index e534a01b500..cea3c1ee5fe 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1889,17 +1889,19 @@ _("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblock
  */
 static int
 process_inode_data_fork(
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
-	struct xfs_dinode	*dino,
+	struct xfs_dinode	**dinop,
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*totblocks,
 	xfs_extnum_t		*nextents,
 	blkmap_t		**dblkmap,
-	int			check_dups)
+	int			check_dups,
+	struct xfs_buf		**ino_bpp)
 {
+	struct xfs_dinode	*dino = *dinop;
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int			err = 0;
 	xfs_extnum_t		nex, max_nex;
@@ -2001,20 +2003,22 @@ process_inode_data_fork(
  */
 static int
 process_inode_attr_fork(
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
-	struct xfs_dinode	*dino,
+	struct xfs_dinode	**dinop,
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*atotblocks,
 	xfs_extnum_t		*anextents,
 	int			check_dups,
 	int			extra_attr_check,
-	int			*retval)
+	int			*retval,
+	struct xfs_buf		**ino_bpp)
 {
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	blkmap_t		*ablkmap = NULL;
+	struct xfs_dinode	*dino = *dinop;
+	struct blkmap		*ablkmap = NULL;
 	int			repair = 0;
 	int			err;
 
@@ -2073,7 +2077,7 @@ process_inode_attr_fork(
 		 * XXX - put the inode onto the "move it" list and
 		 *	log the the attribute scrubbing
 		 */
-		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
+		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
 
 		if (!no_modify)  {
 			do_warn(_(", clearing attr fork\n"));
@@ -2272,21 +2276,22 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
  * for detailed, info, look at process_dinode() comments.
  */
 static int
-process_dinode_int(xfs_mount_t *mp,
-		struct xfs_dinode *dino,
-		xfs_agnumber_t agno,
-		xfs_agino_t ino,
-		int was_free,		/* 1 if inode is currently free */
-		int *dirty,		/* out == > 0 if inode is now dirty */
-		int *used,		/* out == 1 if inode is in use */
-		int verify_mode,	/* 1 == verify but don't modify inode */
-		int uncertain,		/* 1 == inode is uncertain */
-		int ino_discovery,	/* 1 == check dirs for unknown inodes */
-		int check_dups,		/* 1 == check if inode claims
-					 * duplicate blocks		*/
-		int extra_attr_check, /* 1 == do attribute format and value checks */
-		int *isa_dir,		/* out == 1 if inode is a directory */
-		xfs_ino_t *parent)	/* out -- parent if ino is a dir */
+process_dinode_int(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	**dinop,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		ino,
+	int			was_free,	/* 1 if inode is currently free */
+	int			*dirty,		/* out == > 0 if inode is now dirty */
+	int			*used,		/* out == 1 if inode is in use */
+	int			verify_mode,	/* 1 == verify but don't modify inode */
+	int			uncertain,	/* 1 == inode is uncertain */
+	int			ino_discovery,	/* 1 == check dirs for unknown inodes */
+	int			check_dups,	/* 1 == check if inode claims duplicate blocks */
+	int			extra_attr_check, /* 1 == do attribute format and value checks */
+	int			*isa_dir,	/* out == 1 if inode is a directory */
+	xfs_ino_t		*parent,	/* out -- parent if ino is a dir */
+	struct xfs_buf		**ino_bpp)
 {
 	xfs_rfsblock_t		totblocks = 0;
 	xfs_rfsblock_t		atotblocks = 0;
@@ -2299,6 +2304,7 @@ process_dinode_int(xfs_mount_t *mp,
 	const int		is_free = 0;
 	const int		is_used = 1;
 	blkmap_t		*dblkmap = NULL;
+	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
 
@@ -2322,6 +2328,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * If uncertain is set, verify_mode MUST be set.
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
+	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
@@ -2861,18 +2868,21 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	/*
 	 * check data fork -- if it's bad, clear the inode
 	 */
-	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
-			&totblocks, &nextents, &dblkmap, check_dups) != 0)
+	if (process_inode_data_fork(mp, agno, ino, dinop, type, dirty,
+			&totblocks, &nextents, &dblkmap, check_dups,
+			ino_bpp) != 0)
 		goto bad_out;
+	dino = *dinop;
 
 	/*
 	 * check attribute fork if necessary.  attributes are
 	 * always stored in the regular filesystem.
 	 */
-	if (process_inode_attr_fork(mp, agno, ino, dino, type, dirty,
+	if (process_inode_attr_fork(mp, agno, ino, dinop, type, dirty,
 			&atotblocks, &anextents, check_dups, extra_attr_check,
-			&retval))
+			&retval, ino_bpp))
 		goto bad_out;
+	dino = *dinop;
 
 	/*
 	 * enforce totblocks is 0 for misc types
@@ -2990,8 +3000,8 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 
 int
 process_dinode(
-	xfs_mount_t		*mp,
-	struct xfs_dinode	*dino,
+	struct xfs_mount	*mp,
+	struct xfs_dinode	**dinop,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	int			was_free,
@@ -3001,7 +3011,8 @@ process_dinode(
 	int			check_dups,
 	int			extra_attr_check,
 	int			*isa_dir,
-	xfs_ino_t		*parent)
+	xfs_ino_t		*parent,
+	struct xfs_buf		**ino_bpp)
 {
 	const int		verify_mode = 0;
 	const int		uncertain = 0;
@@ -3009,9 +3020,10 @@ process_dinode(
 #ifdef XR_INODE_TRACE
 	fprintf(stderr, _("processing inode %d/%d\n"), agno, ino);
 #endif
-	return process_dinode_int(mp, dino, agno, ino, was_free, dirty, used,
-				verify_mode, uncertain, ino_discovery,
-				check_dups, extra_attr_check, isa_dir, parent);
+	return process_dinode_int(mp, dinop, agno, ino, was_free, dirty, used,
+			verify_mode, uncertain, ino_discovery,
+			check_dups, extra_attr_check, isa_dir, parent,
+			ino_bpp);
 }
 
 /*
@@ -3036,9 +3048,9 @@ verify_dinode(
 	const int		ino_discovery = 0;
 	const int		uncertain = 0;
 
-	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
-				verify_mode, uncertain, ino_discovery,
-				check_dups, 0, &isa_dir, &parent);
+	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
+			verify_mode, uncertain, ino_discovery,
+			check_dups, 0, &isa_dir, &parent, NULL);
 }
 
 /*
@@ -3062,7 +3074,7 @@ verify_uncertain_dinode(
 	const int		ino_discovery = 0;
 	const int		uncertain = 1;
 
-	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
+	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
 				verify_mode, uncertain, ino_discovery,
-				check_dups, 0, &isa_dir, &parent);
+				check_dups, 0, &isa_dir, &parent, NULL);
 }
diff --git a/repair/dinode.h b/repair/dinode.h
index 333d96d26a2..92df83da621 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -43,8 +43,8 @@ void
 update_rootino(xfs_mount_t *mp);
 
 int
-process_dinode(xfs_mount_t *mp,
-		struct xfs_dinode *dino,
+process_dinode(struct xfs_mount *mp,
+		struct xfs_dinode **dinop,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino,
 		int was_free,
@@ -54,7 +54,8 @@ process_dinode(xfs_mount_t *mp,
 		int check_dups,
 		int extra_attr_check,
 		int *isa_dir,
-		xfs_ino_t *parent);
+		xfs_ino_t *parent,
+		struct xfs_buf **ino_bpp);
 
 int
 verify_dinode(xfs_mount_t *mp,

