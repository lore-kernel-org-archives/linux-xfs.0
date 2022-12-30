Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93EEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbiLaCuF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:50:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E2B12AD7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C2661BF8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A02C433D2;
        Sat, 31 Dec 2022 02:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455001;
        bh=0JUSWXX50xI70GqUFCQ32RrJj9G7d9oxIPigdg1aW00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d1RRSAmd3gqikp9uwIRmFU06O4bpkPXcX+QSsKnZl4vZHMEN6WFmmOie1lCL4Ebfi
         Zdf7bn24ZuTtA81Tqy0EDgj0MNkjL1KhMkOxMJfXMloBTi2myR0iT3PjiCsfuDPvSc
         qvzi0Z/NfHusaWnFLi4ndqhVWwlNKqL+HoirLZw3Xvdfm7UY9Rgd3G2Sgp05BW/GBi
         nawRhDGMTbXnUY1Gb559DYr5dH5t9F7w5UZbYW5vKS/9gsy96JmLsekw01Q8A8h9M5
         4pWgNkhl9eOHGo87oZtnpDCOzP7lvaVfpsFT+T85LE7GNmkbl2ys2TY63ZsHLdbLIG
         7h17ow0EwwpqA==
Subject: [PATCH 29/41] xfs_repair: use realtime rmap btree data to check block
 types
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879978.732820.14503918837393040166.stgit@magnolia>
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

Use the realtime rmap btree to pre-populate the block type information
so that when repair iterates the primary metadata, we can confirm the
block type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |  163 +++++++++++++++++++++++
 repair/scan.c   |  390 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/scan.h   |   34 +++++
 3 files changed, 577 insertions(+), 10 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 36cb5cfcc70..93ef89272fd 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -777,6 +777,153 @@ get_agino_buf(
  * first, one utility routine for each type of inode
  */
 
+/*
+ * return 1 if inode should be cleared, 0 otherwise
+ */
+static int
+process_rtrmap(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		ino,
+	struct xfs_dinode	*dip,
+	int			type,
+	int			*dirty,
+	xfs_rfsblock_t		*tot,
+	uint64_t		*nex,
+	blkmap_t		**blkmapp,
+	int			check_dups)
+{
+	struct xfs_rmap_irec	oldkey;
+	struct xfs_rmap_irec	key;
+	struct rmap_priv	priv;
+	struct xfs_rtrmap_root	*dib;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_rmap_key	*kp;
+	struct xfs_rmap_rec	*rp;
+	char			*forkname = get_forkname(XFS_DATA_FORK);
+	xfs_ino_t		lino;
+	xfs_fsblock_t		bno;
+	size_t			droot_sz;
+	int			i;
+	int			level;
+	int			numrecs;
+	int			dmxr;
+	int			suspect = 0;
+	int			error;
+
+	/* We rebuild the rtrmapbt, so no need to process blocks again. */
+	if (check_dups) {
+		*tot = be64_to_cpu(dip->di_nblocks);
+		return 0;
+	}
+
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+
+	/* This rmap btree inode must be a metadata inode. */
+	if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADATA))) {
+		do_warn(
+_("rtrmap inode %" PRIu64 " not flagged as metadata\n"),
+			lino);
+		return 1;
+	}
+
+	memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
+	priv.high_key.rm_blockcount = 0;
+	priv.agcnts = NULL;
+	priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*tot = 0;
+	*nex = 0;
+
+	level = be16_to_cpu(dib->bb_level);
+	numrecs = be16_to_cpu(dib->bb_numrecs);
+
+	if (level > mp->m_rtrmap_maxlevels) {
+		do_warn(
+_("bad level %d in inode %" PRIu64 " rtrmap btree root block\n"),
+			level, lino);
+		return 1;
+	}
+
+	/*
+	 * use rtroot/dfork_dsize since the root block is in the data fork
+	 */
+	droot_sz = xfs_rtrmap_droot_space_calc(level, numrecs);
+	if (droot_sz > XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK)) {
+		do_warn(
+_("computed size of rtrmapbt root (%zu bytes) is greater than space in "
+	  "inode %" PRIu64 " %s fork\n"),
+				droot_sz, lino, forkname);
+		return 1;
+	}
+
+	if (level == 0) {
+		rp = xfs_rtrmap_droot_rec_addr(dib, 1);
+		error = process_rtrmap_reclist(mp, rp, numrecs,
+				&priv.last_rec, NULL, "rtrmapbt root");
+		if (error) {
+			rmap_avoid_check();
+			return 1;
+		}
+		return 0;
+	}
+
+	dmxr = libxfs_rtrmapbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK), false);
+	pp = xfs_rtrmap_droot_ptr_addr(dib, 1, dmxr);
+
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = xfs_rtrmap_droot_key_addr(dib, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
+		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in key %u of rtrmap root ino %" PRIu64 "\n"),
+				i, lino);
+			suspect++;
+			continue;
+		}
+		if (i == 0) {
+			oldkey = key;
+			continue;
+		}
+		if (rmap_diffkeys(&oldkey, &key) > 0) {
+			do_warn(
+_("out of order key %u in rtrmap root ino %" PRIu64 "\n"),
+				i, lino);
+			suspect++;
+			continue;
+		}
+		oldkey = key;
+	}
+
+	/* probe keys */
+	for (i = 0; i < numrecs; i++)  {
+		bno = get_unaligned_be64(&pp[i]);
+
+		if (!libxfs_verify_fsbno(mp, bno))  {
+			do_warn(
+_("bad rtrmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
+				bno, lino);
+			return 1;
+		}
+
+		if (scan_lbtree(bno, level, scan_rtrmapbt,
+				type, XFS_DATA_FORK, lino, tot, nex, blkmapp,
+				NULL, 0, 1, check_dups, XFS_RTRMAP_CRC_MAGIC,
+				&priv, &xfs_rtrmapbt_buf_ops))
+			return 1;
+	}
+
+	return suspect ? 1 : 0;
+}
+
 /*
  * return 1 if inode should be cleared, 0 otherwise
  */
@@ -1553,7 +1700,7 @@ static int
 check_dinode_mode_format(
 	struct xfs_dinode	*dinoc)
 {
-	if (dinoc->di_format >= XFS_DINODE_FMT_UUID)
+	if (dinoc->di_format == XFS_DINODE_FMT_UUID)
 		return -1;	/* FMT_UUID is not used */
 
 	switch (dinode_fmt(dinoc)) {
@@ -1568,8 +1715,13 @@ check_dinode_mode_format(
 			dinoc->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
 
 	case S_IFREG:
-		return (dinoc->di_format < XFS_DINODE_FMT_EXTENTS ||
-			dinoc->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
+		switch (dinoc->di_format) {
+		case XFS_DINODE_FMT_RMAP:
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			return 0;
+		}
+		return -1;
 
 	case S_IFLNK:
 		return (dinoc->di_format < XFS_DINODE_FMT_LOCAL ||
@@ -1983,6 +2135,10 @@ process_inode_data_fork(
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups, zap_metadata);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		err = process_rtrmap(mp, agno, ino, dino, type, dirty,
+				totblocks, nextents, dblkmap, check_dups);
+		break;
 	case XFS_DINODE_FMT_DEV:
 		err = 0;
 		break;
@@ -2042,6 +2198,7 @@ _("would have tried to rebuild inode %"PRIu64" data fork\n"),
 				XFS_DATA_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_DEV:
+		case XFS_DINODE_FMT_RMAP:
 			err = 0;
 			break;
 		default:
diff --git a/repair/scan.c b/repair/scan.c
index 4573c25a577..09ca037f47d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -957,13 +957,6 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 	}
 }
 
-struct rmap_priv {
-	struct aghdr_cnts	*agcnts;
-	struct xfs_rmap_irec	high_key;
-	struct xfs_rmap_irec	last_rec;
-	xfs_agblock_t		nr_blocks;
-};
-
 static bool
 rmap_in_order(
 	xfs_agblock_t	b,
@@ -1365,6 +1358,389 @@ _("out of order key %u in %s btree block (%u/%u)\n"),
 		rmap_avoid_check();
 }
 
+int
+process_rtrmap_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_rec	*rp,
+	int			numrecs,
+	struct xfs_rmap_irec	*last_rec,
+	struct xfs_rmap_irec	*high_key,
+	const char		*name)
+{
+	int			suspect = 0;
+	int			i;
+	struct xfs_rmap_irec	oldkey;
+	struct xfs_rmap_irec	key;
+
+	for (i = 0; i < numrecs; i++) {
+		xfs_rgblock_t		b, end;
+		xfs_extlen_t		len;
+		uint64_t		owner, offset;
+
+		b = be32_to_cpu(rp[i].rm_startblock);
+		len = be32_to_cpu(rp[i].rm_blockcount);
+		owner = be64_to_cpu(rp[i].rm_owner);
+		offset = be64_to_cpu(rp[i].rm_offset);
+
+		key.rm_flags = 0;
+		key.rm_startblock = b;
+		key.rm_blockcount = len;
+		key.rm_owner = owner;
+		if (libxfs_rmap_irec_offset_unpack(offset, &key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in record %u of %s\n"),
+				i, name);
+			suspect++;
+			continue;
+		}
+
+
+		end = key.rm_startblock + key.rm_blockcount;
+
+		/* Make sure startblock & len make sense. */
+		if (b >= mp->m_sb.sb_rgblocks) {
+			do_warn(
+_("invalid start block %llu in record %u of %s\n"),
+				(unsigned long long)b, i, name);
+			suspect++;
+			continue;
+		}
+		if (len == 0 || end - 1 >= mp->m_sb.sb_rgblocks) {
+			do_warn(
+_("invalid length %llu in record %u of %s\n"),
+				(unsigned long long)len, i, name);
+			suspect++;
+			continue;
+		}
+
+		/* We only store file data and superblocks in the rtrmap. */
+		if (XFS_RMAP_NON_INODE_OWNER(owner) &&
+		    owner != XFS_RMAP_OWN_FS) {
+			do_warn(
+_("invalid owner %lld in record %u of %s\n"),
+				(long long int)owner, i, name);
+			suspect++;
+			continue;
+		}
+
+		/* Look for impossible record field combinations. */
+		if (key.rm_flags & XFS_RMAP_KEY_FLAGS) {
+			do_warn(
+_("record %d cannot have attr fork/key flags in %s\n"),
+					i, name);
+			suspect++;
+			continue;
+		}
+
+		/* Check for out of order records. */
+		if (i == 0)
+			oldkey = key;
+		else {
+			if (rmap_diffkeys(&oldkey, &key) > 0)
+				do_warn(
+_("out-of-order record %d (%llu %"PRId64" %"PRIu64" %llu) in %s\n"),
+				i, (unsigned long long)b, owner, offset,
+				(unsigned long long)len, name);
+			else
+				oldkey = key;
+		}
+
+		/* Is this mergeable with the previous record? */
+		if (rmaps_are_mergeable(last_rec, &key)) {
+			do_warn(
+_("record %d in %s should be merged with previous record\n"),
+				i, name);
+			last_rec->rm_blockcount += key.rm_blockcount;
+		} else
+			*last_rec = key;
+
+		/* Check that we don't go past the high key. */
+		key.rm_startblock += key.rm_blockcount - 1;
+		key.rm_offset += key.rm_blockcount - 1;
+		key.rm_blockcount = 0;
+		if (high_key && rmap_diffkeys(&key, high_key) > 0) {
+			do_warn(
+_("record %d greater than high key of %s\n"),
+				i, name);
+			suspect++;
+		}
+	}
+
+	return suspect;
+}
+
+int
+scan_rtrmapbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	int			type,
+	int			whichfork,
+	xfs_fsblock_t		fsbno,
+	xfs_ino_t		ino,
+	xfs_rfsblock_t		*tot,
+	uint64_t		*nex,
+	blkmap_t		**blkmapp,
+	bmap_cursor_t		*bm_cursor,
+	int			suspect,
+	int			isroot,
+	int			check_dups,
+	int			*dirty,
+	uint64_t		magic,
+	void			*priv)
+{
+	const char		*name = "rtrmap";
+	char			rootname[256];
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_rmap_rec	*rp;
+	struct rmap_priv	*rmap_priv = priv;
+	int			hdr_errors = 0;
+	int			numrecs;
+	int			state;
+	struct xfs_rmap_key	*kp;
+	struct xfs_rmap_irec	oldkey;
+	struct xfs_rmap_irec	key;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	int			error;
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	/* If anything here is bad, just bail. */
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(
+_("bad magic # %#x in inode %" PRIu64 " %s block %" PRIu64 "\n"),
+			be32_to_cpu(block->bb_magic), ino, name, fsbno);
+		return 1;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		do_warn(
+_("expected level %d got %d in inode %" PRIu64 ", %s block %" PRIu64 "\n"),
+			level, be16_to_cpu(block->bb_level),
+			ino, name, fsbno);
+		return(1);
+	}
+
+	/* verify owner */
+	if (be64_to_cpu(block->bb_u.l.bb_owner) != ino) {
+		do_warn(
+_("expected owner inode %" PRIu64 ", got %llu, %s block %" PRIu64 "\n"),
+			ino,
+			(unsigned long long)be64_to_cpu(block->bb_u.l.bb_owner),
+			name, fsbno);
+		return 1;
+	}
+	/* verify block number */
+	if (be64_to_cpu(block->bb_u.l.bb_blkno) !=
+	    XFS_FSB_TO_DADDR(mp, fsbno)) {
+		do_warn(
+_("expected block %" PRIu64 ", got %llu, %s block %" PRIu64 "\n"),
+			XFS_FSB_TO_DADDR(mp, fsbno),
+			(unsigned long long)be64_to_cpu(block->bb_u.l.bb_blkno),
+			name, fsbno);
+		return 1;
+	}
+	/* verify uuid */
+	if (platform_uuid_compare(&block->bb_u.l.bb_uuid,
+				  &mp->m_sb.sb_meta_uuid) != 0) {
+		do_warn(
+_("wrong FS UUID, %s block %" PRIu64 "\n"),
+			name, fsbno);
+		return 1;
+	}
+
+	/*
+	 * Check for btree blocks multiply claimed.  We're going to regenerate
+	 * the rtrmap anyway, so mark the blocks as metadata so they get freed.
+	 */
+	state = get_bmap(agno, agbno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_INUSE1))  {
+		do_warn(
+_("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+				name, state, agno, agbno, suspect);
+		suspect++;
+		goto out;
+	}
+	set_bmap(agno, agbno, XR_E_METADATA);
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+
+	/*
+	 * All realtime rmap btree blocks are freed for a fully empty
+	 * filesystem, thus they are counted towards the free data
+	 * block counter.  The root lives in an inode and is thus not
+	 * counted.
+	 */
+	(*tot)++;
+
+	if (level == 0) {
+		if (numrecs > mp->m_rtrmap_mxr[0])  {
+			numrecs = mp->m_rtrmap_mxr[0];
+			hdr_errors++;
+		}
+		if (isroot == 0 && numrecs < mp->m_rtrmap_mnr[0])  {
+			numrecs = mp->m_rtrmap_mnr[0];
+			hdr_errors++;
+		}
+
+		if (hdr_errors) {
+			do_warn(
+_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_rtrmap_mnr[0], mp->m_rtrmap_mxr[0],
+				name, agno, agbno);
+			suspect++;
+		}
+
+		rp = xfs_rtrmap_rec_addr(block, 1);
+		snprintf(rootname, 256, "%s btree block %u/%u", name, agno, agbno);
+		error = process_rtrmap_reclist(mp, rp, numrecs,
+				&rmap_priv->last_rec, &rmap_priv->high_key,
+				rootname);
+		if (error)
+			suspect++;
+		goto out;
+	}
+
+	/*
+	 * interior record
+	 */
+	pp = xfs_rtrmap_ptr_addr(block, 1, mp->m_rtrmap_mxr[1]);
+
+	if (numrecs > mp->m_rtrmap_mxr[1])  {
+		numrecs = mp->m_rtrmap_mxr[1];
+		hdr_errors++;
+	}
+	if (isroot == 0 && numrecs < mp->m_rtrmap_mnr[1])  {
+		numrecs = mp->m_rtrmap_mnr[1];
+		hdr_errors++;
+	}
+
+	/*
+	 * don't pass bogus tree flag down further if this block
+	 * looked ok.  bail out if two levels in a row look bad.
+	 */
+	if (hdr_errors)  {
+		do_warn(
+_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs),
+			mp->m_rtrmap_mnr[1], mp->m_rtrmap_mxr[1],
+			name, agno, agbno);
+		if (suspect)
+			goto out;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
+	}
+
+	/* check the node's high keys */
+	for (i = 0; !isroot && i < numrecs; i++) {
+		kp = xfs_rtrmap_high_key_addr(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
+		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in key %u of %s btree block %u/%u\n"),
+				i, name, agno, agbno);
+			suspect++;
+			continue;
+		}
+		if (rmap_diffkeys(&key, &rmap_priv->high_key) > 0) {
+			do_warn(
+_("key %d greater than high key of block (%u/%u) in %s tree\n"),
+				i, agno, agbno, name);
+			suspect++;
+		}
+	}
+
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = xfs_rtrmap_key_addr(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
+		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in key %u of %s btree block %u/%u\n"),
+				i, name, agno, agbno);
+			suspect++;
+			continue;
+		}
+		if (i == 0) {
+			oldkey = key;
+			continue;
+		}
+		if (rmap_diffkeys(&oldkey, &key) > 0) {
+			do_warn(
+_("out of order key %u in %s btree block (%u/%u)\n"),
+				i, name, agno, agbno);
+			suspect++;
+		}
+		oldkey = key;
+	}
+
+	for (i = 0; i < numrecs; i++)  {
+		xfs_fsblock_t		pbno = be64_to_cpu(pp[i]);
+
+		/*
+		 * XXX - put sibling detection right here.
+		 * we know our sibling chain is good.  So as we go,
+		 * we check the entry before and after each entry.
+		 * If either of the entries references a different block,
+		 * check the sibling pointer.  If there's a sibling
+		 * pointer mismatch, try and extract as much data
+		 * as possible.
+		 */
+		kp = xfs_rtrmap_high_key_addr(block, i + 1);
+		rmap_priv->high_key.rm_flags = 0;
+		rmap_priv->high_key.rm_startblock =
+				be32_to_cpu(kp->rm_startblock);
+		rmap_priv->high_key.rm_owner =
+				be64_to_cpu(kp->rm_owner);
+		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&rmap_priv->high_key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in high key %u of %s btree block %u/%u\n"),
+				i, name, agno, agbno);
+			suspect++;
+			continue;
+		}
+
+		if (!libxfs_verify_fsbno(mp, pbno)) {
+			do_warn(
+_("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
+			       name, (unsigned long long)pbno, ino);
+			return 1;
+		}
+
+		error = scan_lbtree(pbno, level, scan_rtrmapbt,
+				type, whichfork, ino, tot, nex, blkmapp,
+				bm_cursor, suspect, 0, check_dups, magic,
+				rmap_priv, &xfs_rtrmapbt_buf_ops);
+		if (error) {
+			suspect++;
+			goto out;
+		}
+	}
+
+out:
+	if (hdr_errors || suspect) {
+		rmap_avoid_check();
+		return 1;
+	}
+	return 0;
+}
+
 struct refc_priv {
 	struct xfs_refcount_irec	last_rec;
 	xfs_agblock_t			nr_blocks;
diff --git a/repair/scan.h b/repair/scan.h
index aeaf9f1a7f4..a624c882734 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -66,4 +66,38 @@ scan_ags(
 	struct xfs_mount	*mp,
 	int			scan_threads);
 
+struct rmap_priv {
+	struct aghdr_cnts	*agcnts;
+	struct xfs_rmap_irec	high_key;
+	struct xfs_rmap_irec	last_rec;
+	xfs_agblock_t		nr_blocks;
+};
+
+int
+process_rtrmap_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_rec	*rp,
+	int			numrecs,
+	struct xfs_rmap_irec	*last_rec,
+	struct xfs_rmap_irec	*high_key,
+	const char		*name);
+
+int scan_rtrmapbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	int			type,
+	int			whichfork,
+	xfs_fsblock_t		bno,
+	xfs_ino_t		ino,
+	xfs_rfsblock_t		*tot,
+	uint64_t		*nex,
+	struct blkmap		**blkmapp,
+	bmap_cursor_t		*bm_cursor,
+	int			suspect,
+	int			isroot,
+	int			check_dups,
+	int			*dirty,
+	uint64_t		magic,
+	void			*priv);
+
 #endif /* _XR_SCAN_H */

