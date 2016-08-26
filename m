Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C0848481
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B80B8AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:16 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id SaMx39n1tyRxOXbs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:13 -0700 (PDT)
Subject: [PATCH 23/29] xfs_repair: use realtime rmap btree data to check
	block types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:07 -0700
Message-ID: <147216966788.7022.1787278022218422520.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Use the realtime rmap btree to pre-populate the block type information
so that when repair iterates the primary metadata, we can confirm the
block type.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |  170 +++++++++++++++++++++++-
 repair/dinode.h |    2 
 repair/scan.c   |  391 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/scan.h   |   33 +++++
 4 files changed, 583 insertions(+), 13 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 843c465..6718cd2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -423,6 +423,18 @@ verify_agbno(xfs_mount_t	*mp,
 	return verify_ag_bno(sbp, agno, agbno) == 0;
 }
 
+/*
+ * Verify realtime device block number.
+ * Returns 1 for good rtfsb or 0 if it's invalid.
+ */
+int
+verify_drtbno(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsb)
+{
+	return fsb < mp->m_sb.sb_rblocks;
+}
+
 static int
 process_rt_rec(
 	xfs_mount_t		*mp,
@@ -439,7 +451,7 @@ process_rt_rec(
 	/*
 	 * check numeric validity of the extent
 	 */
-	if (irec->br_startblock >= mp->m_sb.sb_rblocks) {
+	if (!verify_drtbno(mp, irec->br_startblock)) {
 		do_warn(
 _("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
 			ino,
@@ -447,7 +459,7 @@ _("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" P
 			irec->br_startoff);
 		return 1;
 	}
-	if (irec->br_startblock + irec->br_blockcount - 1 >= mp->m_sb.sb_rblocks) {
+	if (!verify_drtbno(mp, irec->br_startblock + irec->br_blockcount)) {
 		do_warn(
 _("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
 			ino,
@@ -917,6 +929,145 @@ get_agino_buf(
  * return 1 if inode should be cleared, 0 otherwise
  */
 static int
+process_rtrmap(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		ino,
+	struct xfs_dinode	*dip,
+	int			type,
+	int			*dirty,
+	xfs_rfsblock_t		*tot,
+	__uint64_t		*nex,
+	blkmap_t		**blkmapp,
+	int			check_dups)
+{
+	struct xfs_rtrmap_root	*dib;
+	xfs_ino_t		lino;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_rtrmap_key	*kp;
+	struct xfs_rtrmap_rec	*rp;
+	int			whichfork = XFS_DATA_FORK;
+	char			*forkname = get_forkname(whichfork);
+	int			i;
+	int			level;
+	int			numrecs;
+	xfs_fsblock_t		bno;
+	struct xfs_rmap_irec	oldkey;
+	struct xfs_rmap_irec	key;
+	struct rmap_priv	priv;
+	int			suspect = 0;
+	int			error;
+
+	/* We rebuild the rtrmapbt, so no need to process blocks again. */
+	if (check_dups) {
+		*tot = be64_to_cpu(dip->di_nblocks);
+		return 0;
+	}
+
+	memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
+	priv.high_key.rm_blockcount = 0;
+	priv.agcnts = NULL;
+	priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
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
+	if (XFS_RTRMAP_ROOT_SPACE_CALC(numrecs, level) >
+	    XFS_DFORK_SIZE(dip, mp, whichfork)) {
+		do_warn(
+_("indicated size of %s rtrmapbt root (%d bytes) greater than space in "
+	  "inode %" PRIu64 " %s fork\n"),
+			forkname, XFS_RTRMAP_ROOT_SPACE_CALC(numrecs, level),
+			lino, forkname);
+		return 1;
+	}
+
+	if (level == 0) {
+		rp = XFS_RTRMAP_ROOT_REC_ADDR(dib, 1);
+		error = process_rtrmap_reclist(mp, rp, numrecs,
+				&priv.last_rec, NULL, "rtrmapbt root");
+		if (error) {
+			rmap_avoid_check();
+			return 1;
+		}
+		return 0;
+	}
+
+	pp = XFS_RTRMAP_ROOT_PTR_ADDR(dib, 1,
+			libxfs_rtrmapbt_maxrecs(mp,
+				XFS_DFORK_SIZE(dip, mp, whichfork), 0));
+
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = XFS_RTRMAP_ROOT_KEY_ADDR(dib, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be64_to_cpu(kp->rm_startblock);
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
+		if (!verify_dfsbno(mp, bno))  {
+			do_warn(
+_("bad rtrmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
+				bno, lino);
+			return 1;
+		}
+
+		if (scan_lbtree(bno, level, scan_rtrmapbt,
+				type, whichfork, lino, tot, nex, blkmapp,
+				NULL, 1, check_dups, XFS_RTRMAP_CRC_MAGIC,
+				&priv,
+				&xfs_rtrmapbt_buf_ops))
+			return 1;
+	}
+
+	return suspect ? 1 : 0;
+}
+
+/*
+ * return 1 if inode should be cleared, 0 otherwise
+ */
+static int
 process_btinode(
 	xfs_mount_t		*mp,
 	xfs_agnumber_t		agno,
@@ -1545,9 +1696,13 @@ change_dinode_fmt(
 
 static int
 check_dinode_mode_format(
-	xfs_dinode_t *dinoc)
+	struct xfs_mount	*mp,
+	xfs_ino_t		lino,
+	struct xfs_dinode	*dinoc)
 {
-	if (dinoc->di_format >= XFS_DINODE_FMT_UUID)
+	if (lino == mp->m_sb.sb_rrmapino)
+		return dinoc->di_format != XFS_DINODE_FMT_RMAP;
+	else if (dinoc->di_format >= XFS_DINODE_FMT_UUID)
 		return -1;	/* FMT_UUID is not used */
 
 	switch (dinode_fmt(dinoc)) {
@@ -1947,6 +2102,10 @@ process_inode_data_fork(
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		err = process_rtrmap(mp, agno, ino, dino, type, dirty,
+			totblocks, nextents, dblkmap, check_dups);
+		break;
 	case XFS_DINODE_FMT_DEV:	/* fall through */
 		err = 0;
 		break;
@@ -1986,6 +2145,7 @@ process_inode_data_fork(
 				XFS_DATA_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_DEV:	/* fall through */
+		case XFS_DINODE_FMT_RMAP:
 			err = 0;
 			break;
 		default:
@@ -2395,7 +2555,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	 * free inodes since technically any format is legal
 	 * as we reset the inode when we re-use it.
 	 */
-	if (di_mode != 0 && check_dinode_mode_format(dino) != 0) {
+	if (di_mode != 0 && check_dinode_mode_format(mp, lino, dino) != 0) {
 		if (!uncertain)
 			do_warn(
 	_("bad inode format in inode %" PRIu64 "\n"), lino);
diff --git a/repair/dinode.h b/repair/dinode.h
index 61d0736..70d5d91 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -30,6 +30,8 @@ int
 verify_dfsbno(xfs_mount_t	*mp,
 		xfs_fsblock_t	fsbno);
 
+int verify_drtbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
+
 void
 convert_extent(
 	xfs_bmbt_rec_t		*rp,
diff --git a/repair/scan.c b/repair/scan.c
index 8935be7..7c88b6f 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -824,7 +824,10 @@ process_rmap_rec(
 			break;
 		default:
 			/* file data */
-			set_bmap_ext(agno, b, blen, XR_E_INUSE1);
+			if (owner == mp->m_sb.sb_rrmapino)
+				set_bmap_ext(agno, b, blen, XR_E_FS_MAP1);
+			else
+				set_bmap_ext(agno, b, blen, XR_E_INUSE1);
 			break;
 		}
 		break;
@@ -896,13 +899,6 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
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
@@ -1218,6 +1214,385 @@ out:
 		rmap_avoid_check();
 }
 
+int
+process_rtrmap_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_rtrmap_rec	*rp,
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
+		xfs_fsblock_t		b, end;
+		xfs_filblks_t		len;
+		uint64_t		owner, offset;
+
+		b = be64_to_cpu(rp[i].rm_startblock);
+		len = be64_to_cpu(rp[i].rm_blockcount);
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
+		if (!verify_drtbno(mp, b)) {
+			do_warn(
+_("invalid start block %llu in record %u of %s\n"),
+				(unsigned long long)b, i, name);
+			suspect++;
+			continue;
+		}
+		if (len == 0 || !verify_drtbno(mp, end - 1)) {
+			do_warn(
+_("invalid length %llu in record %u of %s\n"),
+				(unsigned long long)len, i, name);
+			suspect++;
+			continue;
+		}
+
+		/* We only store inode data in the rtrmap. */
+		if (XFS_RMAP_NON_INODE_OWNER(owner)) {
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
+	__uint64_t		*nex,
+	blkmap_t		**blkmapp,
+	bmap_cursor_t		*bm_cursor,
+	int			isroot,
+	int			check_dups,
+	int			*dirty,
+	__uint64_t		magic,
+	void			*priv)
+{
+	const char		*name = "rtrmap";
+	char			rootname[256];
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_rtrmap_rec	*rp;
+	struct rmap_priv	*rmap_priv = priv;
+	int			hdr_errors = 0;
+	int			numrecs;
+	int			state;
+	struct xfs_rtrmap_key	*kp;
+	struct xfs_rmap_irec	oldkey;
+	struct xfs_rmap_irec	key;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	int			suspect = 0;
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
+			ino, be64_to_cpu(block->bb_u.l.bb_owner), name, fsbno);
+		return 1;
+	}
+	/* verify block number */
+	if (be64_to_cpu(block->bb_u.l.bb_blkno) !=
+	    XFS_FSB_TO_DADDR(mp, fsbno)) {
+		do_warn(
+_("expected block %" PRIu64 ", got %llu, %s block %" PRIu64 "\n"),
+			XFS_FSB_TO_DADDR(mp, fsbno),
+			be64_to_cpu(block->bb_u.l.bb_blkno), name, fsbno);
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
+	/* check for btree blocks multiply claimed */
+	state = get_bmap(agno, agbno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_FS_MAP1))  {
+		set_bmap(agno, agbno, XR_E_MULT);
+		do_warn(
+_("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+				name, state, agno, agbno, suspect);
+		suspect++;
+		goto out;
+	}
+
+	set_bmap(agno, agbno, XR_E_FS_MAP);
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
+		rp = XFS_RTRMAP_REC_ADDR(block, 1);
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
+	pp = XFS_RTRMAP_PTR_ADDR(block, 1, mp->m_rtrmap_mxr[1]);
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
+		kp = XFS_RTRMAP_HIGH_KEY_ADDR(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be64_to_cpu(kp->rm_startblock);
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
+		kp = XFS_RTRMAP_KEY_ADDR(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be64_to_cpu(kp->rm_startblock);
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
+		kp = XFS_RTRMAP_HIGH_KEY_ADDR(block, i + 1);
+		rmap_priv->high_key.rm_flags = 0;
+		rmap_priv->high_key.rm_startblock =
+				be64_to_cpu(kp->rm_startblock);
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
+		if (!verify_dfsbno(mp, pbno)) {
+			do_warn(
+_("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
+			       name, (unsigned long long)pbno, ino);
+			return 1;
+		}
+
+		error = scan_lbtree(pbno, level, scan_rtrmapbt,
+				type, whichfork, ino, tot, nex, blkmapp,
+				bm_cursor, 0, check_dups, magic,
+				rmap_priv,
+				&xfs_rtrmapbt_buf_ops);
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
index 854897c..f51f950 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -73,4 +73,37 @@ scan_ags(
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
+	struct xfs_rtrmap_rec	*rp,
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
+	__uint64_t		*nex,
+	struct blkmap		**blkmapp,
+	bmap_cursor_t		*bm_cursor,
+	int			isroot,
+	int			check_dups,
+	int			*dirty,
+	__uint64_t		magic,
+	void			*priv);
+
 #endif /* _XR_SCAN_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
