Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006EABE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l542o3Uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37CEC433C7;
	Sun, 31 Dec 2023 22:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060466;
	bh=l20MgWRfO+rUSfy6sLcsh4ExpYTX+7/Xn+p+Xhsn1+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l542o3Uh12FtFUNVRiQFwqvcoObvhIHBYRar3qEblOIojUuNGJ6WuLQkk7y1avvvJ
	 Fr1JBPn5Nq4p1Io/KlGIiSc/7E7jeugyzZQDlmdVcY2Zl1prbVwWSY5hJ6nKqJimrM
	 pNPtxQ6kykfRjBOA2yuy0onVg2CoolpEemWA5WBLueFRPBjbrlb1trJIPDgXclADC3
	 1+4pK6ZzG1Z5MvqGP02deMbYcsmUWgKUPBYFCn/jFRvp8plK/dzi4mx1wGllzxaMsZ
	 EkzDbCP+rc8MCFzEMs5zMGJmSXncZh9XsciM7PcBpb+xF1r3C1uc1LJV/oKhcqGIky
	 NqVc4JGvUlweA==
Date: Sun, 31 Dec 2023 14:07:46 -0800
Subject: [PATCH 1/3] xfs_repair: push inode buf and dinode pointers all the
 way to inode fork processing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990815.1793572.8157608172149333053.stgit@frogsfrogsfrogs>
In-Reply-To: <170404990800.1793572.4237173751599480312.stgit@frogsfrogsfrogs>
References: <170404990800.1793572.4237173751599480312.stgit@frogsfrogsfrogs>
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
index 171756818a6..19536133451 100644
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
index c1cfadc8833..3f826b3482f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1892,17 +1892,19 @@ _("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblock
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
@@ -2004,20 +2006,22 @@ process_inode_data_fork(
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
 
@@ -2076,7 +2080,7 @@ process_inode_attr_fork(
 		 * XXX - put the inode onto the "move it" list and
 		 *	log the the attribute scrubbing
 		 */
-		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
+		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
 
 		if (!no_modify)  {
 			do_warn(_(", clearing attr fork\n"));
@@ -2273,21 +2277,22 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
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
@@ -2300,6 +2305,7 @@ process_dinode_int(xfs_mount_t *mp,
 	const int		is_free = 0;
 	const int		is_used = 1;
 	blkmap_t		*dblkmap = NULL;
+	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
 
@@ -2323,6 +2329,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * If uncertain is set, verify_mode MUST be set.
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
+	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
@@ -2862,18 +2869,21 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
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
@@ -2991,8 +3001,8 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 
 int
 process_dinode(
-	xfs_mount_t		*mp,
-	struct xfs_dinode	*dino,
+	struct xfs_mount	*mp,
+	struct xfs_dinode	**dinop,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	int			was_free,
@@ -3002,7 +3012,8 @@ process_dinode(
 	int			check_dups,
 	int			extra_attr_check,
 	int			*isa_dir,
-	xfs_ino_t		*parent)
+	xfs_ino_t		*parent,
+	struct xfs_buf		**ino_bpp)
 {
 	const int		verify_mode = 0;
 	const int		uncertain = 0;
@@ -3010,9 +3021,10 @@ process_dinode(
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
@@ -3037,9 +3049,9 @@ verify_dinode(
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
@@ -3063,7 +3075,7 @@ verify_uncertain_dinode(
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

