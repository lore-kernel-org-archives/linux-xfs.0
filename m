Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACF012E4E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296050; cv=none; b=m9fcJc5DSCS/3siCVOttBw1vSy/uRtCcpfDUxZH5U068+Bf+20/R6RYK1pe9DyXl6G1OAt0xxWBEE2DoXUOszNW7/FS80Tn9zKv9sgsTImbYkNOih1VjKtAfYXlJ48CFXgodp+0kiJtbmOle/PuPayWe4og+K8Y2R4bYmSVFqik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296050; c=relaxed/simple;
	bh=DXBnD167SEzfx0Wqw9dMw5x32XLD1b88NZYLlUEoKCA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fam/GPFGKlRo7/k0D/+fSiM/Gxi8ztunAUVT7e8sBmKX4skjo6xfxYC4QARb3r+UmX8u1tqegYAAB+fijVz1nwph8/AmcAD8eD+cNzvLilvpDqhUnrrfNJLPGtqP1NLvyDUGG3HX8EELh23EgZYxPFuawM+Q2jccM9svsUlrx7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GV6MDdIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GV6MDdIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82846C433F1;
	Wed, 13 Mar 2024 02:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296049;
	bh=DXBnD167SEzfx0Wqw9dMw5x32XLD1b88NZYLlUEoKCA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GV6MDdIeNVaSsdD7Si+lAvID7iuv5GFaoZ/BfXvuXfn0iD5XV4TNa/LS6g/VegS2S
	 BW8JRa6opQlSW8/V9QX8S+9xcTMieeescG76X+GPzNLZlhTp+Qo+rIwA1amrj56soD
	 9uQnD3XyDtdsheyWl/tMSQwAd39ykF4I4TyX46HS6moqhWQ53c14yVJaQm7hh9RLPh
	 6c/I7Vc/G2BJX2YidmT2Yp8OOPAVi2bQPHX8wlfnb54o1Zj408655by2QxUxJyOAPj
	 gVjmw4orzcmPC6dec72mfmVJVQsVcr5wWcyXqi6JE1MwQB8h7no4NbJLS3qkgVPuml
	 enhPHSr5PTQ4g==
Date: Tue, 12 Mar 2024 19:14:09 -0700
Subject: [PATCH 1/3] xfs_repair: push inode buf and dinode pointers all the
 way to inode fork processing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029434340.2065697.11904740279941887091.stgit@frogsfrogsfrogs>
In-Reply-To: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
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
index 171756818a6a..195361334519 100644
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
index 164f51d4c4fc..a18af3ff7772 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1893,17 +1893,19 @@ _("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblock
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
@@ -2005,20 +2007,22 @@ process_inode_data_fork(
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
 
@@ -2077,7 +2081,7 @@ process_inode_attr_fork(
 		 * XXX - put the inode onto the "move it" list and
 		 *	log the the attribute scrubbing
 		 */
-		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
+		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
 
 		if (!no_modify)  {
 			do_warn(_(", clearing attr fork\n"));
@@ -2274,21 +2278,22 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
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
@@ -2301,6 +2306,7 @@ process_dinode_int(xfs_mount_t *mp,
 	const int		is_free = 0;
 	const int		is_used = 1;
 	blkmap_t		*dblkmap = NULL;
+	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
 
@@ -2324,6 +2330,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * If uncertain is set, verify_mode MUST be set.
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
+	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
@@ -2863,18 +2870,21 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
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
@@ -2992,8 +3002,8 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 
 int
 process_dinode(
-	xfs_mount_t		*mp,
-	struct xfs_dinode	*dino,
+	struct xfs_mount	*mp,
+	struct xfs_dinode	**dinop,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	int			was_free,
@@ -3003,7 +3013,8 @@ process_dinode(
 	int			check_dups,
 	int			extra_attr_check,
 	int			*isa_dir,
-	xfs_ino_t		*parent)
+	xfs_ino_t		*parent,
+	struct xfs_buf		**ino_bpp)
 {
 	const int		verify_mode = 0;
 	const int		uncertain = 0;
@@ -3011,9 +3022,10 @@ process_dinode(
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
@@ -3038,9 +3050,9 @@ verify_dinode(
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
@@ -3064,7 +3076,7 @@ verify_uncertain_dinode(
 	const int		ino_discovery = 0;
 	const int		uncertain = 1;
 
-	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
+	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
 				verify_mode, uncertain, ino_discovery,
-				check_dups, 0, &isa_dir, &parent);
+				check_dups, 0, &isa_dir, &parent, NULL);
 }
diff --git a/repair/dinode.h b/repair/dinode.h
index 333d96d26a2f..92df83da6210 100644
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

