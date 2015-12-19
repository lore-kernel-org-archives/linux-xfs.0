Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00BF529E08
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 686F0AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:43 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EwflIeXaN4DURK3T (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:40 -0800 (PST)
Subject: [PATCH 25/53] xfs_repair: use rmap btree data to check block types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:36 -0800
Message-ID: <20151219090736.14255.82930.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <david@fromorbit.com>

Use the rmap btree to pre-populate the block type information so that
when repair iterates the primary metadata, we can confirm the block
type.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[split patch, add commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c     |    6 +
 repair/incore.h     |   16 +-
 repair/scan.c       |  336 ++++++++++++++++++++++++++++++++++++++++++++++++---
 repair/xfs_repair.c |    2 
 4 files changed, 331 insertions(+), 29 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 269f9d8..caa4c1b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -744,6 +744,7 @@ _("%s fork in ino %" PRIu64 " claims dup extent, "
 _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 					forkname, ino, (__uint64_t) b);
 				/* fall through ... */
+			case XR_E_INUSE1:	/* seen by rmap */
 			case XR_E_UNKNOWN:
 				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
 				break;
@@ -751,6 +752,11 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 			case XR_E_BAD_STATE:
 				do_error(_("bad state in block map %" PRIu64 "\n"), b);
 
+			case XR_E_FS_MAP1:
+			case XR_E_INO1:
+			case XR_E_INUSE_FS1:
+				do_warn(_("rmap claims metadata use!\n"));
+				/* fall through */
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
diff --git a/repair/incore.h b/repair/incore.h
index c92475e..bc0810b 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -102,17 +102,11 @@ typedef struct rt_extent_tree_node  {
 #define XR_E_MULT	5	/* extent is multiply referenced */
 #define XR_E_INO	6	/* extent used by inodes (inode blocks) */
 #define XR_E_FS_MAP	7	/* extent used by fs space/inode maps */
-#define XR_E_BAD_STATE	8
-
-/* extent states, in 64 bit word chunks */
-#define	XR_E_UNKNOWN_LL		0x0000000000000000LL
-#define	XR_E_FREE1_LL		0x1111111111111111LL
-#define	XR_E_FREE_LL		0x2222222222222222LL
-#define	XR_E_INUSE_LL		0x3333333333333333LL
-#define	XR_E_INUSE_FS_LL	0x4444444444444444LL
-#define	XR_E_MULT_LL		0x5555555555555555LL
-#define	XR_E_INO_LL		0x6666666666666666LL
-#define	XR_E_FS_MAP_LL		0x7777777777777777LL
+#define XR_E_INUSE1	8	/* used block (marked by rmap btree) */
+#define XR_E_INUSE_FS1	9	/* used by fs ag header or log (rmap btree) */
+#define XR_E_INO1	10	/* used by inodes (marked by rmap btree) */
+#define XR_E_FS_MAP1	11	/* used by fs space/inode maps (rmap btree) */
+#define XR_E_BAD_STATE	12
 
 /* separate state bit, OR'ed into high (4th) bit of ex_state field */
 
diff --git a/repair/scan.c b/repair/scan.c
index 1e7a4da..c1ab6df 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -44,6 +44,7 @@ struct aghdr_cnts {
 	__uint32_t	agicount;
 	__uint32_t	agifreecount;
 	__uint64_t	fdblocks;
+	__uint64_t	usedblocks;
 	__uint64_t	ifreecount;
 	__uint32_t	fibtfreecount;
 };
@@ -308,6 +309,13 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 		pthread_mutex_lock(&ag_locks[agno].lock);
 		state = get_bmap(agno, agbno);
 		switch (state) {
+		case XR_E_INUSE1:
+			/*
+			 * block was claimed as in use data by the rmap
+			 * btree, but has not been found in the data extent
+			 * map for the inode. That means this bmbt block hasn't
+			 * yet been claimed as in use, which means -it's ours-
+			 */
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
@@ -763,6 +771,252 @@ ino_issparse(
 
 	return xfs_inobt_is_sparse_disk(rp, offset);
 }
+ 
+static void
+scan_rmapbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot,
+	__uint32_t		magic,
+	void			*priv)
+{
+	struct aghdr_cnts	*agcnts = priv;
+	const char		*name = "rmap";
+	int			i;
+	xfs_rmap_ptr_t		*pp;
+	struct xfs_rmap_rec	*rp;
+	int			hdr_errors = 0;
+	int			numrecs;
+	int			state;
+	xfs_agblock_t		lastblock = 0;
+
+	if (magic != XFS_RMAP_CRC_MAGIC) {
+		name = "(unknown)";
+		assert(0);
+	}
+
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(_("bad magic # %#x in bt%s block %d/%d\n"),
+			be32_to_cpu(block->bb_magic), name, agno, bno);
+		hdr_errors++;
+		if (suspect)
+			return;
+	}
+
+	/*
+	 * All RMAP btree blocks except the roots are freed for a
+	 * fully empty filesystem, thus they are counted towards the
+	 * free data block counter.
+	 */
+	if (!isroot) {
+		agcnts->agfbtreeblks++;
+		agcnts->fdblocks++;
+	}
+
+	if (be16_to_cpu(block->bb_level) != level) {
+		do_warn(_("expected level %d got %d in bt%s block %d/%d\n"),
+			level, be16_to_cpu(block->bb_level), name, agno, bno);
+		hdr_errors++;
+		if (suspect)
+			return;
+	}
+
+	/* check for btree blocks multiply claimed */
+	state = get_bmap(agno, bno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_FS_MAP1))  {
+		set_bmap(agno, bno, XR_E_MULT);
+		do_warn(
+_("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+				name, state, agno, bno, suspect);
+		return;
+	}
+	set_bmap(agno, bno, XR_E_FS_MAP);
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level == 0) {
+		if (numrecs > mp->m_rmap_mxr[0])  {
+			numrecs = mp->m_rmap_mxr[0];
+			hdr_errors++;
+		}
+		if (isroot == 0 && numrecs < mp->m_rmap_mnr[0])  {
+			numrecs = mp->m_rmap_mnr[0];
+			hdr_errors++;
+		}
+
+		if (hdr_errors) {
+			do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_rmap_mnr[0], mp->m_rmap_mxr[0],
+				name, agno, bno);
+			suspect++;
+		}
+
+		rp = XFS_RMAP_REC_ADDR(block, 1);
+		for (i = 0; i < numrecs; i++) {
+			xfs_agblock_t		b, end;
+			xfs_extlen_t		len, blen;
+			int64_t			owner;
+
+			b = be32_to_cpu(rp[i].rm_startblock);
+			len = be32_to_cpu(rp[i].rm_blockcount);
+			owner = be64_to_cpu(rp[i].rm_owner);
+			end = b + len;
+
+			if (!verify_agbno(mp, agno, b)) {
+				do_warn(
+	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
+					b, i, name, agno, bno);
+				continue;
+			}
+			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+				do_warn(
+	_("invalid length %u in record %u of %s btree block %u/%u\n"),
+					len, i, name, agno, bno);
+				continue;
+			}
+
+			/* XXX: range check owner */
+
+			if (b && b <= lastblock) {
+				do_warn(_(
+	"out-of-order rmap btree record %d (%u %u) block %u/%u\n"),
+					i, b, len, agno, bno);
+			} else {
+				lastblock = b;
+			}
+
+			for ( ; b < end; b += blen)  {
+				state = get_bmap_ext(agno, b, end, &blen);
+				switch (state) {
+				case XR_E_UNKNOWN:
+					switch (owner) {
+					case XFS_RMAP_OWN_FS:
+					case XFS_RMAP_OWN_LOG:
+						set_bmap(agno, b, XR_E_INUSE_FS1);
+						break;
+					case XFS_RMAP_OWN_AG:
+					case XFS_RMAP_OWN_INOBT:
+						set_bmap(agno, b, XR_E_FS_MAP1);
+						break;
+					case XFS_RMAP_OWN_INODES:
+						set_bmap(agno, b, XR_E_INO1);
+						break;
+					case XFS_RMAP_OWN_NULL:
+						/* still unknown */
+						break;
+					default:
+						/* file data */
+						set_bmap(agno, b, XR_E_INUSE1);
+						break;
+					}
+					break;
+				case XR_E_INUSE_FS:
+					if (owner == XFS_RMAP_OWN_FS ||
+					    owner == XFS_RMAP_OWN_LOG)
+						break;
+					do_warn(
+_("Static meta block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+						agno, b, b + blen - 1,
+						name, state, owner);
+					break;
+				case XR_E_FS_MAP:
+					if (owner == XFS_RMAP_OWN_AG ||
+					    owner == XFS_RMAP_OWN_INOBT)
+						break;
+					do_warn(
+_("AG meta block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+						agno, b, b + blen - 1,
+						name, state, owner);
+					break;
+				case XR_E_INO:
+					if (owner == XFS_RMAP_OWN_INODES)
+						break;
+					do_warn(
+_("inode block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+						agno, b, b + blen - 1,
+						name, state, owner);
+					break;
+				case XR_E_INUSE:
+					if (owner >= 0 &&
+					    owner < mp->m_sb.sb_dblocks)
+						break;
+					do_warn(
+_("in use block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+						agno, b, b + blen - 1,
+						name, state, owner);
+					break;
+				case XR_E_FREE1:
+				case XR_E_FREE:
+					/*
+					 * May be on the AGFL. If not, they'll
+					 * be caught later.
+					 */
+					break;
+				default:
+					do_warn(
+_("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
+						agno, b, b + blen - 1,
+						name, state, owner);
+					break;
+				}
+			}
+		}
+		return;
+	}
+
+	/*
+	 * interior record
+	 */
+	pp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
+
+	if (numrecs > mp->m_rmap_mxr[1])  {
+		numrecs = mp->m_rmap_mxr[1];
+		hdr_errors++;
+	}
+	if (isroot == 0 && numrecs < mp->m_rmap_mnr[1])  {
+		numrecs = mp->m_rmap_mnr[1];
+		hdr_errors++;
+	}
+
+	/*
+	 * don't pass bogus tree flag down further if this block
+	 * looked ok.  bail out if two levels in a row look bad.
+	 */
+	if (hdr_errors)  {
+		do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs),
+			mp->m_rmap_mnr[1], mp->m_rmap_mxr[1],
+			name, agno, bno);
+		if (suspect)
+			return;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
+	}
+
+	for (i = 0; i < numrecs; i++)  {
+		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
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
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			scan_sbtree(bno, level, agno, suspect, scan_rmapbt, 0,
+				    magic, priv, &xfs_rmapbt_buf_ops);
+		}
+	}
+}
 
 /*
  * The following helpers are to help process and validate individual on-disk
@@ -976,20 +1230,27 @@ scan_single_ino_chunk(
 
 			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
 			state = get_bmap(agno, agbno);
-			if (state == XR_E_UNKNOWN)  {
-				set_bmap(agno, agbno, XR_E_INO);
-			} else if (state == XR_E_INUSE_FS && agno == 0 &&
-				   ino + j >= first_prealloc_ino &&
-				   ino + j < last_prealloc_ino)  {
+			switch (state) {
+			case XR_E_INO:
+				break;
+			case XR_E_UNKNOWN:
+			case XR_E_INO1:	/* seen by rmap */
 				set_bmap(agno, agbno, XR_E_INO);
-			} else  {
+				break;
+			case XR_E_INUSE_FS:
+			case XR_E_INUSE_FS1:
+				if (agno == 0 &&
+				    ino + j >= first_prealloc_ino &&
+				    ino + j < last_prealloc_ino) {
+					set_bmap(agno, agbno, XR_E_INO);
+					break;
+				}
+				/* fall through */
+			default:
+				/* XXX - maybe should mark block a duplicate */
 				do_warn(
 _("inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"),
 					agno, agbno, mp->m_sb.sb_inopblock);
-				/*
-				 * XXX - maybe should mark
-				 * block a duplicate
-				 */
 				return ++suspect;
 			}
 		}
@@ -1099,19 +1360,35 @@ _("sparse inode chunk claims inode block, finobt block - agno %d, bno %d, inopb
 				continue;
 			}
 
-			if (state == XR_E_INO) {
-				continue;
-			} else if ((state == XR_E_UNKNOWN) ||
-				   (state == XR_E_INUSE_FS && agno == 0 &&
-				    ino + j >= first_prealloc_ino &&
-				    ino + j < last_prealloc_ino)) {
+			switch (state) {
+			case XR_E_INO:
+				break;
+			case XR_E_INO1:	/* seen by rmap */
+				set_bmap(agno, agbno, XR_E_INO);
+				break;
+			case XR_E_UNKNOWN:
 				do_warn(
 _("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
 					agno, agbno, mp->m_sb.sb_inopblock);
 
 				set_bmap(agno, agbno, XR_E_INO);
 				suspect++;
-			} else {
+				break;
+			case XR_E_INUSE_FS:
+			case XR_E_INUSE_FS1:
+				if (agno == 0 &&
+				    ino + j >= first_prealloc_ino &&
+				    ino + j < last_prealloc_ino) {
+					do_warn(
+_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
+						agno, agbno, mp->m_sb.sb_inopblock);
+
+					set_bmap(agno, agbno, XR_E_INO);
+					suspect++;
+					break;
+				}
+				/* fall through */
+			default:
 				do_warn(
 _("inode chunk claims used block, finobt block - agno %d, bno %d, inopb %d\n"),
 					agno, agbno, mp->m_sb.sb_inopblock);
@@ -1280,6 +1557,7 @@ scan_inobt(
 	 */
 	state = get_bmap(agno, bno);
 	switch (state)  {
+	case XR_E_FS_MAP1: /* already been seen by an rmap scan */
 	case XR_E_UNKNOWN:
 	case XR_E_FREE1:
 	case XR_E_FREE:
@@ -1420,7 +1698,7 @@ scan_freelist(
 	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
 	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
 	    XFS_AGI_BLOCK(mp) != XFS_AGFL_BLOCK(mp))
-		set_bmap(agno, XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
+		set_bmap(agno, XFS_AGFL_BLOCK(mp), XR_E_INUSE_FS);
 
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
@@ -1505,6 +1783,19 @@ validate_agf(
 			bno, agno);
 	}
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			scan_sbtree(bno,
+				    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
+				    agno, 0, scan_rmapbt, 1, XFS_RMAP_CRC_MAGIC,
+				    agcnts, &xfs_rmapbt_buf_ops);
+		} else  {
+			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
+				bno, agno);
+		}
+	}
+
 	if (be32_to_cpu(agf->agf_freeblks) != agcnts->agffreeblks) {
 		do_warn(_("agf_freeblks %u, counted %u in ag %u\n"),
 			be32_to_cpu(agf->agf_freeblks), agcnts->agffreeblks, agno);
@@ -1520,6 +1811,7 @@ validate_agf(
 		do_warn(_("agf_btreeblks %u, counted %" PRIu64 " in ag %u\n"),
 			be32_to_cpu(agf->agf_btreeblks), agcnts->agfbtreeblks, agno);
 	}
+
 }
 
 static void
@@ -1759,6 +2051,7 @@ scan_ags(
 	__uint64_t	fdblocks = 0;
 	__uint64_t	icount = 0;
 	__uint64_t	ifreecount = 0;
+	__uint64_t	usedblocks = 0;
 	xfs_agnumber_t	i;
 	work_queue_t	wq;
 
@@ -1781,6 +2074,7 @@ scan_ags(
 		fdblocks += agcnts[i].fdblocks;
 		icount += agcnts[i].agicount;
 		ifreecount += agcnts[i].ifreecount;
+		usedblocks += agcnts[i].usedblocks;
 	}
 
 	free(agcnts);
@@ -1802,5 +2096,11 @@ scan_ags(
 		do_warn(_("sb_fdblocks %" PRIu64 ", counted %" PRIu64 "\n"),
 			mp->m_sb.sb_fdblocks, fdblocks);
 	}
+
+	if (usedblocks &&
+	    usedblocks != mp->m_sb.sb_dblocks - fdblocks) {
+		do_warn(_("used blocks %" PRIu64 ", counted %" PRIu64 "\n"),
+			mp->m_sb.sb_dblocks - fdblocks, usedblocks);
+	}
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 1aeac5b..2fe2e4e 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -416,6 +416,8 @@ calc_mkfs(xfs_mount_t *mp)
 	fino_bno = inobt_root + (2 * min(2, mp->m_ag_maxlevels)) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		fino_bno++;
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		fino_bno++;
 
 	/*
 	 * If the log is allocated in the first allocation group we need to

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
