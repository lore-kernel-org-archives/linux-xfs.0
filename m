Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E6619259D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990921; cv=none; b=DU+RocG/laTMBcJaYXqCczg8ZZJl729MdQe97b889+6+4RYreLSu5i6LwMf6ijLvF0pBLVVDXaEI04HspT5d/PACcKNdZKSnBE5xZCwDjvY+xqjkXqYpqxcLF4M66BuK4bRQ/0TB67K+v+cF0UKF+vt9BQhu/B1dQ1kNE1fcYko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990921; c=relaxed/simple;
	bh=fIUmEQA4v/MOi9El7L4la8p/35aXPsLbTV4Zp1Km530=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ko14KMkdB3CH6kaPb5syZ4fy8shIMMyf3z6b5NKuHdjflxNyRjHjVouYk6FthQ4oteg2k0WdIS3PziYjgNuRFf15IFvgAMHMWj5aYVU03FyHRysIm43J7WVid/ovLF1xFJ2t8zvZ5HN9Q7BEi4lq0w+/hmAvKdC5iMT9XmR4xAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7XjYLOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7XjYLOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935DBC4CED3;
	Mon, 23 Dec 2024 21:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990921;
	bh=fIUmEQA4v/MOi9El7L4la8p/35aXPsLbTV4Zp1Km530=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S7XjYLOHNrI/zAERZ7kJwudveM8KHmm6XPdOg7heszbwa16TSi4w5bHWM0HrG9gRB
	 kFmbsW0LA8RytsqJw3H59GtDF9lHc98dMGdGWmZt4fFaRfWZjrNfNEdyfvdHo3KYKF
	 4OqHBDGj7duUrl9wrLV5oI6MwOLMfqMKY94UREKf9LDSwdTWyLdLbmERX21bWUN2Do
	 Ntxxept/ltVbPmQNye/1OV5qQEuEUPKKbhUDh8S5Smzd1+Qvy/VvRZWEvK7n8M4jmH
	 bhdNpIbU4j7rlbaXbIBAUdwO1g+GyHQb/jR4C3nU+ukhju83nUPpYzUAvUSydUac8p
	 lUtoeoqEZd4iA==
Date: Mon, 23 Dec 2024 13:55:21 -0800
Subject: [PATCH 34/41] xfs_repair: mark space used by metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941489.2294268.3788483920934017496.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Track space used by metadata files as a separate incore extent type.
This ensures that we can warn about cross-linked metadata files, even
though we are going to rebuild the entire metadata directory tree in the
end.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dino_chunks.c |   31 +++++++++++++
 repair/dinode.c      |  122 ++++++++++++++++++++++++++++++++++++++------------
 repair/dinode.h      |    6 ++
 repair/incore.h      |   31 ++++++++-----
 repair/phase4.c      |    2 +
 repair/scan.c        |   30 +++++++++++-
 6 files changed, 175 insertions(+), 47 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 0d9b3a01bc298d..0cbc498101ec72 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -141,6 +141,16 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		_("uncertain inode block %d/%d already known\n"),
 				agno, agbno);
 			break;
+		case XR_E_METADATA:
+			/*
+			 * Files in the metadata directory tree are always
+			 * reconstructed, so it's ok to let go if this block
+			 * is also a valid inode cluster.
+			 */
+			do_warn(
+		_("inode block %d/%d claimed by metadata file\n"),
+				agno, agbno);
+			fallthrough;
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
@@ -430,6 +440,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
 			pthread_mutex_unlock(&ag_locks[agno].lock);
 			return 0;
+		case XR_E_METADATA:
 		case XR_E_INO:
 			do_error(
 	_("uncertain inode block overlap, agbno = %d, ino = %" PRIu64 "\n"),
@@ -474,6 +485,16 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		_("uncertain inode block %" PRIu64 " already known\n"),
 				XFS_AGB_TO_FSB(mp, agno, cur_agbno));
 			break;
+		case XR_E_METADATA:
+			/*
+			 * Files in the metadata directory tree are always
+			 * reconstructed, so it's ok to let go if this block
+			 * is also a valid inode cluster.
+			 */
+			do_warn(
+		_("inode block %d/%d claimed by metadata file\n"),
+				agno, agbno);
+			fallthrough;
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
@@ -559,6 +580,16 @@ process_inode_agbno_state(
 	switch (state) {
 	case XR_E_INO:	/* already marked */
 		break;
+	case XR_E_METADATA:
+		/*
+		 * Files in the metadata directory tree are always
+		 * reconstructed, so it's ok to let go if this block is also a
+		 * valid inode cluster.
+		 */
+		do_warn(
+	_("inode block %d/%d claimed by metadata file\n"),
+			agno, agbno);
+		fallthrough;
 	case XR_E_UNKNOWN:
 	case XR_E_FREE:
 	case XR_E_FREE1:
diff --git a/repair/dinode.c b/repair/dinode.c
index 4ca45ad4aab1fa..8148cdbc4f10ad 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -220,6 +220,7 @@ static int
 process_rt_rec_state(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
+	bool			zap_metadata,
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fsblock_t		b = irec->br_startblock;
@@ -256,7 +257,13 @@ _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d
 		switch (state)  {
 		case XR_E_FREE:
 		case XR_E_UNKNOWN:
-			set_rtbmap(ext, XR_E_INUSE);
+			set_rtbmap(ext, zap_metadata ? XR_E_METADATA :
+						       XR_E_INUSE);
+			break;
+		case XR_E_METADATA:
+			do_error(
+_("data fork in rt inode %" PRIu64 " found metadata file block %" PRIu64 " in rt bmap\n"),
+				ino, ext);
 			break;
 		case XR_E_BAD_STATE:
 			do_error(
@@ -293,7 +300,8 @@ process_rt_rec(
 	struct xfs_bmbt_irec	*irec,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	int			check_dups)
+	int			check_dups,
+	bool			zap_metadata)
 {
 	xfs_fsblock_t		lastb;
 	int			bad;
@@ -333,7 +341,7 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 	if (check_dups)
 		bad = process_rt_rec_dups(mp, ino, irec);
 	else
-		bad = process_rt_rec_state(mp, ino, irec);
+		bad = process_rt_rec_state(mp, ino, zap_metadata, irec);
 	if (bad)
 		return bad;
 
@@ -364,7 +372,8 @@ process_bmbt_reclist_int(
 	xfs_fileoff_t		*first_key,
 	xfs_fileoff_t		*last_key,
 	int			check_dups,
-	int			whichfork)
+	int			whichfork,
+	bool			zap_metadata)
 {
 	xfs_bmbt_irec_t		irec;
 	xfs_filblks_t		cp = 0;		/* prev count */
@@ -443,7 +452,8 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 
 		if (type == XR_INO_RTDATA && whichfork == XFS_DATA_FORK) {
 			pthread_mutex_lock(&rt_lock.lock);
-			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups);
+			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups,
+					zap_metadata);
 			pthread_mutex_unlock(&rt_lock.lock);
 			if (error2)
 				return error2;
@@ -558,6 +568,11 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 			case XR_E_INUSE_FS1:
 				do_warn(_("rmap claims metadata use!\n"));
 				fallthrough;
+			case XR_E_METADATA:
+				do_warn(
+_("%s fork in inode %" PRIu64 " claims metadata file block %" PRIu64 "\n"),
+					forkname, ino, b);
+				break;
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
@@ -614,15 +629,28 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 		for (; agbno < ebno; agbno += blen) {
 			state = get_bmap_ext(agno, agbno, ebno, &blen);
 			switch (state)  {
+			case XR_E_METADATA:
+				/*
+				 * The entire metadata directory tree is rebuilt
+				 * every time, so we can let regular files take
+				 * ownership of this block.
+				 */
+				if (zap_metadata)
+					break;
+				fallthrough;
 			case XR_E_FREE:
 			case XR_E_FREE1:
 			case XR_E_INUSE1:
 			case XR_E_UNKNOWN:
-				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
+				set_bmap_ext(agno, agbno, blen, zap_metadata ?
+						XR_E_METADATA : XR_E_INUSE);
 				break;
+
 			case XR_E_INUSE:
 			case XR_E_MULT:
-				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
+				if (!zap_metadata)
+					set_bmap_ext(agno, agbno, blen,
+							XR_E_MULT);
 				break;
 			default:
 				break;
@@ -661,10 +689,12 @@ process_bmbt_reclist(
 	blkmap_t		**blkmapp,
 	xfs_fileoff_t		*first_key,
 	xfs_fileoff_t		*last_key,
-	int			whichfork)
+	int			whichfork,
+	bool			zap_metadata)
 {
 	return process_bmbt_reclist_int(mp, rp, numrecs, type, ino, tot,
-				blkmapp, first_key, last_key, 0, whichfork);
+				blkmapp, first_key, last_key, 0, whichfork,
+				zap_metadata);
 }
 
 /*
@@ -679,13 +709,15 @@ scan_bmbt_reclist(
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	int			whichfork)
+	int			whichfork,
+	bool			zap_metadata)
 {
 	xfs_fileoff_t		first_key = 0;
 	xfs_fileoff_t		last_key = 0;
 
 	return process_bmbt_reclist_int(mp, rp, numrecs, type, ino, tot,
-				NULL, &first_key, &last_key, 1, whichfork);
+				NULL, &first_key, &last_key, 1, whichfork,
+				zap_metadata);
 }
 
 /*
@@ -760,7 +792,8 @@ process_btinode(
 	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
-	int			check_dups)
+	int			check_dups,
+	bool			zap_metadata)
 {
 	xfs_bmdr_block_t	*dib;
 	xfs_fileoff_t		last_key;
@@ -839,8 +872,8 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic, NULL,
-				&xfs_bmbt_buf_ops))
+				&cursor, 1, check_dups, magic,
+				(void *)zap_metadata, &xfs_bmbt_buf_ops))
 			return(1);
 		/*
 		 * fix key (offset) mismatches between the keys in root
@@ -935,7 +968,8 @@ process_exinode(
 	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
-	int			check_dups)
+	int			check_dups,
+	bool			zap_metadata)
 {
 	xfs_ino_t		lino;
 	xfs_bmbt_rec_t		*rp;
@@ -969,10 +1003,10 @@ process_exinode(
 	if (check_dups == 0)
 		ret = process_bmbt_reclist(mp, rp, &numrecs, type, lino,
 					tot, blkmapp, &first_key, &last_key,
-					whichfork);
+					whichfork, zap_metadata);
 	else
 		ret = scan_bmbt_reclist(mp, rp, &numrecs, type, lino, tot,
-					whichfork);
+					whichfork, zap_metadata);
 
 	*nex = numrecs;
 	return ret;
@@ -1901,7 +1935,8 @@ process_inode_data_fork(
 	xfs_extnum_t		*nextents,
 	blkmap_t		**dblkmap,
 	int			check_dups,
-	struct xfs_buf		**ino_bpp)
+	struct xfs_buf		**ino_bpp,
+	bool			zap_metadata)
 {
 	struct xfs_dinode	*dino = *dinop;
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1948,14 +1983,14 @@ process_inode_data_fork(
 			try_rebuild = 1;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
-			check_dups);
+			check_dups, zap_metadata);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (!rmapbt_suspect && try_rebuild == -1)
 			try_rebuild = 1;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
-			check_dups);
+			check_dups, zap_metadata);
 		break;
 	case XFS_DINODE_FMT_DEV:
 		err = 0;
@@ -2008,12 +2043,12 @@ _("would have tried to rebuild inode %"PRIu64" data fork\n"),
 		case XFS_DINODE_FMT_EXTENTS:
 			err = process_exinode(mp, agno, ino, dino, type,
 				dirty, totblocks, nextents, dblkmap,
-				XFS_DATA_FORK, 0);
+				XFS_DATA_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_BTREE:
 			err = process_btinode(mp, agno, ino, dino, type,
 				dirty, totblocks, nextents, dblkmap,
-				XFS_DATA_FORK, 0);
+				XFS_DATA_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_DEV:
 			err = 0;
@@ -2048,7 +2083,8 @@ process_inode_attr_fork(
 	int			check_dups,
 	int			extra_attr_check,
 	int			*retval,
-	struct xfs_buf		**ino_bpp)
+	struct xfs_buf		**ino_bpp,
+	bool			zap_metadata)
 {
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	struct xfs_dinode	*dino = *dinop;
@@ -2096,7 +2132,7 @@ process_inode_attr_fork(
 		*anextents = 0;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
 				atotblocks, anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				XFS_ATTR_FORK, check_dups, zap_metadata);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (!rmapbt_suspect && try_rebuild == -1)
@@ -2105,7 +2141,7 @@ process_inode_attr_fork(
 		*anextents = 0;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
 				atotblocks, anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				XFS_ATTR_FORK, check_dups, zap_metadata);
 		break;
 	default:
 		do_warn(_("illegal attribute format %d, ino %" PRIu64 "\n"),
@@ -2169,12 +2205,12 @@ _("would have tried to rebuild inode %"PRIu64" attr fork or cleared it\n"),
 		case XFS_DINODE_FMT_EXTENTS:
 			err = process_exinode(mp, agno, ino, dino,
 				type, dirty, atotblocks, anextents,
-				&ablkmap, XFS_ATTR_FORK, 0);
+				&ablkmap, XFS_ATTR_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_BTREE:
 			err = process_btinode(mp, agno, ino, dino,
 				type, dirty, atotblocks, anextents,
-				&ablkmap, XFS_ATTR_FORK, 0);
+				&ablkmap, XFS_ATTR_FORK, 0, zap_metadata);
 			break;
 		default:
 			do_error(_("illegal attribute fmt %d, ino %" PRIu64 "\n"),
@@ -2393,6 +2429,7 @@ process_dinode_int(
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
 	bool			is_meta = false;
+	bool			zap_metadata = false;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2982,6 +3019,33 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		off = get_inode_offset(mp, lino, irec);
 		set_inode_is_meta(irec, off);
 		is_meta = true;
+
+		/*
+		 * We always rebuild the metadata directory tree during phase
+		 * 6, so we use this flag to get all the directory blocks
+		 * marked as free, and any other metadata files whose contents
+		 * we don't want to save.
+		 *
+		 * Currently, there are no metadata files that use xattrs, so
+		 * we always drop the xattr blocks of metadata files.  Parent
+		 * pointers will be rebuilt during phase 6.
+		 */
+		switch (type) {
+		case XR_INO_RTBITMAP:
+		case XR_INO_RTSUM:
+		case XR_INO_UQUOTA:
+		case XR_INO_GQUOTA:
+		case XR_INO_PQUOTA:
+			/*
+			 * This inode was recognized as being filesystem
+			 * metadata, so preserve the inode and its contents for
+			 * later checking and repair.
+			 */
+			break;
+		default:
+			zap_metadata = true;
+			break;
+		}
 	}
 
 	/*
@@ -2989,7 +3053,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	if (process_inode_data_fork(mp, agno, ino, dinop, type, dirty,
 			&totblocks, &nextents, &dblkmap, check_dups,
-			ino_bpp) != 0)
+			ino_bpp, zap_metadata) != 0)
 		goto bad_out;
 	dino = *dinop;
 
@@ -2999,7 +3063,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	if (process_inode_attr_fork(mp, agno, ino, dinop, type, dirty,
 			&atotblocks, &anextents, check_dups, extra_attr_check,
-			&retval, ino_bpp))
+			&retval, ino_bpp, is_meta))
 		goto bad_out;
 	dino = *dinop;
 
diff --git a/repair/dinode.h b/repair/dinode.h
index 92df83da621053..ed2ec4ca2386ff 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -27,7 +27,8 @@ process_bmbt_reclist(xfs_mount_t	*mp,
 		struct blkmap		**blkmapp,
 		uint64_t		*first_key,
 		uint64_t		*last_key,
-		int			whichfork);
+		int			whichfork,
+		bool			zap_metadata);
 
 int
 scan_bmbt_reclist(
@@ -37,7 +38,8 @@ scan_bmbt_reclist(
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	int			whichfork);
+	int			whichfork,
+	bool			zap_metadata);
 
 void
 update_rootino(xfs_mount_t *mp);
diff --git a/repair/incore.h b/repair/incore.h
index 568a8c7cb75b7c..07716fc4c01a05 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -85,18 +85,25 @@ typedef struct rt_extent_tree_node  {
 #define XR_E_UNKNOWN	0	/* unknown state */
 #define XR_E_FREE1	1	/* free block (marked by one fs space tree) */
 #define XR_E_FREE	2	/* free block (marked by both fs space trees) */
-#define XR_E_INUSE	3	/* extent used by file/dir data or metadata */
-#define XR_E_INUSE_FS	4	/* extent used by fs ag header or log */
-#define XR_E_MULT	5	/* extent is multiply referenced */
-#define XR_E_INO	6	/* extent used by inodes (inode blocks) */
-#define XR_E_FS_MAP	7	/* extent used by fs space/inode maps */
-#define XR_E_INUSE1	8	/* used block (marked by rmap btree) */
-#define XR_E_INUSE_FS1	9	/* used by fs ag header or log (rmap btree) */
-#define XR_E_INO1	10	/* used by inodes (marked by rmap btree) */
-#define XR_E_FS_MAP1	11	/* used by fs space/inode maps (rmap btree) */
-#define XR_E_REFC	12	/* used by fs ag reference count btree */
-#define XR_E_COW	13	/* leftover cow extent */
-#define XR_E_BAD_STATE	14
+/*
+ * Space used by metadata files.  The entire metadata directory tree will be
+ * rebuilt from scratch during phase 6, so this value must be less than
+ * XR_E_INUSE so that the space will go back to the free space btrees during
+ * phase 5.
+ */
+#define XR_E_METADATA	3
+#define XR_E_INUSE	4	/* extent used by file/dir data or metadata */
+#define XR_E_INUSE_FS	5	/* extent used by fs ag header or log */
+#define XR_E_MULT	6	/* extent is multiply referenced */
+#define XR_E_INO	7	/* extent used by inodes (inode blocks) */
+#define XR_E_FS_MAP	8	/* extent used by fs space/inode maps */
+#define XR_E_INUSE1	9	/* used block (marked by rmap btree) */
+#define XR_E_INUSE_FS1	10	/* used by fs ag header or log (rmap btree) */
+#define XR_E_INO1	11	/* used by inodes (marked by rmap btree) */
+#define XR_E_FS_MAP1	12	/* used by fs space/inode maps (rmap btree) */
+#define XR_E_REFC	13	/* used by fs ag reference count btree */
+#define XR_E_COW	14	/* leftover cow extent */
+#define XR_E_BAD_STATE	15
 
 /* separate state bit, OR'ed into high (4th) bit of ex_state field */
 
diff --git a/repair/phase4.c b/repair/phase4.c
index 7efef86245fbe7..40db36f1f93020 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -303,6 +303,7 @@ phase4(xfs_mount_t *mp)
 				_("unknown block state, ag %d, blocks %u-%u\n"),
 					i, j, j + blen - 1);
 				fallthrough;
+			case XR_E_METADATA:
 			case XR_E_UNKNOWN:
 			case XR_E_FREE:
 			case XR_E_INUSE:
@@ -335,6 +336,7 @@ phase4(xfs_mount_t *mp)
 	_("unknown rt extent state, extent %" PRIu64 "\n"),
 				rtx);
 			fallthrough;
+		case XR_E_METADATA:
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
diff --git a/repair/scan.c b/repair/scan.c
index f6d46a2861b312..0fec7c222ff156 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -227,6 +227,7 @@ scan_bmapbt(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
+	bool			zap_metadata = priv != NULL;
 
 	/*
 	 * unlike the ag freeblock btrees, if anything looks wrong
@@ -352,7 +353,20 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_bmap(agno, agbno, XR_E_INUSE);
+			set_bmap(agno, agbno, zap_metadata ? XR_E_METADATA :
+							     XR_E_INUSE);
+			break;
+		case XR_E_METADATA:
+			/*
+			 * bmbt block already claimed by a metadata file.  We
+			 * always reconstruct the entire metadata tree, so if
+			 * this is a regular file we mark it owned by the file.
+			 */
+			do_warn(
+_("inode 0x%" PRIx64 "bmap block 0x%" PRIx64 " claimed by metadata file\n"),
+				ino, bno);
+			if (!zap_metadata)
+				set_bmap(agno, agbno, XR_E_INUSE);
 			break;
 		case XR_E_FS_MAP:
 		case XR_E_INUSE:
@@ -364,7 +378,8 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 			 * we made it here, the block probably
 			 * contains btree data.
 			 */
-			set_bmap(agno, agbno, XR_E_MULT);
+			if (!zap_metadata)
+				set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
 _("inode 0x%" PRIx64 "bmap block 0x%" PRIx64 " claimed, state is %d\n"),
 				ino, bno, state);
@@ -429,7 +444,8 @@ _("inode %" PRIu64 " bad # of bmap records (%" PRIu64 ", min - %u, max - %u)\n")
 		if (check_dups == 0)  {
 			err = process_bmbt_reclist(mp, rp, &numrecs, type, ino,
 						   tot, blkmapp, &first_key,
-						   &last_key, whichfork);
+						   &last_key, whichfork,
+						   zap_metadata);
 			if (err)
 				return 1;
 
@@ -459,7 +475,7 @@ _("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" P
 			return 0;
 		} else {
 			return scan_bmbt_reclist(mp, rp, &numrecs, type, ino,
-						 tot, whichfork);
+					tot, whichfork, zap_metadata);
 		}
 	}
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
@@ -849,6 +865,12 @@ process_rmap_rec(
 			break;
 		}
 		break;
+	case XR_E_METADATA:
+		do_warn(
+_("Metadata file block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+			agno, b, b + blen - 1,
+			name, state, owner);
+		break;
 	case XR_E_INUSE_FS:
 		if (owner == XFS_RMAP_OWN_FS ||
 		    owner == XFS_RMAP_OWN_LOG)

