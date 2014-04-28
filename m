Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F17BC29E21
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 16:05:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 695FEAC002
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 14:05:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NQkXAOdsLZ4Y9NIz for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 14:05:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WesjV-000513-Kz
	for xfs@oss.sgi.com; Tue, 29 Apr 2014 07:05:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WesjV-000514-KA
	for xfs@oss.sgi.com; Tue, 29 Apr 2014 07:05:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] repair: remove more dirv1 leftovers
Date: Tue, 29 Apr 2014 07:04:57 +1000
Message-Id: <1398719099-19194-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1398719099-19194-1-git-send-email-david@fromorbit.com>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

get_bmapi() and it's children were only called by dirv1 code. There
are no current callers, so remove them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 239 --------------------------------------------------------
 repair/dinode.h |   6 --
 2 files changed, 245 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 48f17ac..b086bec 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -870,245 +870,6 @@ get_agino_buf(xfs_mount_t	 *mp,
 }
 
 /*
- * these next routines return the filesystem blockno of the
- * block containing the block "bno" in the file whose bmap
- * tree (or extent list) is rooted by "rootblock".
- *
- * the next routines are utility routines for the third
- * routine, get_bmapi().
- *
- * NOTE: getfunc_extlist only used by dirv1 checking code
- */
-static xfs_dfsbno_t
-getfunc_extlist(xfs_mount_t		*mp,
-		xfs_ino_t		ino,
-		xfs_dinode_t		*dip,
-		xfs_dfiloff_t		bno,
-		int			whichfork)
-{
-	xfs_bmbt_irec_t		irec;
-	xfs_dfsbno_t		final_fsbno = NULLDFSBNO;
-	xfs_bmbt_rec_t		*rootblock = (xfs_bmbt_rec_t *)
-						XFS_DFORK_PTR(dip, whichfork);
-	xfs_extnum_t		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
-	int			i;
-
-	for (i = 0; i < nextents; i++)  {
-		libxfs_bmbt_disk_get_all(rootblock + i, &irec);
-		if (irec.br_startoff <= bno &&
-				bno < irec.br_startoff + irec.br_blockcount) {
-			final_fsbno = bno - irec.br_startoff + irec.br_startblock;
-			break;
-		}
-	}
-
-	return(final_fsbno);
-}
-
-/*
- * NOTE: getfunc_btree only used by dirv1 checking code... 
- */
-static xfs_dfsbno_t
-getfunc_btree(xfs_mount_t		*mp,
-		xfs_ino_t		ino,
-		xfs_dinode_t		*dip,
-		xfs_dfiloff_t		bno,
-		int			whichfork)
-{
-	int			i;
-#ifdef DEBUG
-	int			prev_level;
-#endif
-	int			found;
-	int			numrecs;
-	xfs_bmbt_rec_t		*rec;
-	xfs_bmbt_irec_t		irec;
-	xfs_bmbt_ptr_t		*pp;
-	xfs_bmbt_key_t		*key;
-	xfs_bmdr_key_t		*rkey;
-	xfs_bmdr_ptr_t		*rp;
-	xfs_dfsbno_t		fsbno;
-	xfs_buf_t		*bp;
-	xfs_dfsbno_t		final_fsbno = NULLDFSBNO;
-	struct xfs_btree_block	*block;
-	xfs_bmdr_block_t	*rootblock = (xfs_bmdr_block_t *)
-						XFS_DFORK_PTR(dip, whichfork);
-
-	ASSERT(rootblock->bb_level != 0);
-	/*
-	 * deal with root block, it's got a slightly different
-	 * header structure than interior nodes.  We know that
-	 * a btree should have at least 2 levels otherwise it
-	 * would be an extent list.
-	 */
-	rkey = XFS_BMDR_KEY_ADDR(rootblock, 1);
-	rp = XFS_BMDR_PTR_ADDR(rootblock, 1,
-		xfs_bmdr_maxrecs(mp, XFS_DFORK_SIZE(dip, mp, whichfork), 1));
-	found = -1;
-	for (i = 0; i < be16_to_cpu(rootblock->bb_numrecs) - 1; i++) {
-		if (be64_to_cpu(rkey[i].br_startoff) <= bno && 
-				bno < be64_to_cpu(rkey[i + 1].br_startoff)) {
-			found = i;
-			break;
-		}
-	}
-	if (i == be16_to_cpu(rootblock->bb_numrecs) - 1 && 
-				bno >= be64_to_cpu(rkey[i].br_startoff))
-		found = i;
-
-	ASSERT(found != -1);
-
-	fsbno = be64_to_cpu(rp[found]);
-
-	ASSERT(verify_dfsbno(mp, fsbno));
-
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (!bp) {
-		do_error(_("cannot read bmap block %" PRIu64 "\n"), fsbno);
-		return(NULLDFSBNO);
-	}
-	block = XFS_BUF_TO_BLOCK(bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-
-	/*
-	 * ok, now traverse any interior btree nodes
-	 */
-#ifdef DEBUG
-	prev_level = be16_to_cpu(block->bb_level);
-#endif
-
-	while (be16_to_cpu(block->bb_level) > 0)  {
-#ifdef DEBUG
-		ASSERT(be16_to_cpu(block->bb_level) < prev_level);
-
-		prev_level = be16_to_cpu(block->bb_level);
-#endif
-		if (numrecs > mp->m_bmap_dmxr[1]) {
-			do_warn(
-_("# of bmap records in inode %" PRIu64 " exceeds max (%u, max - %u)\n"),
-				ino, numrecs,
-				mp->m_bmap_dmxr[1]);
-			libxfs_putbuf(bp);
-			return(NULLDFSBNO);
-		}
-		if (verbose && numrecs < mp->m_bmap_dmnr[1]) {
-			do_warn(
-_("- # of bmap records in inode %" PRIu64 " less than minimum (%u, min - %u), proceeding ...\n"),
-				ino, numrecs, mp->m_bmap_dmnr[1]);
-		}
-		key = XFS_BMBT_KEY_ADDR(mp, block, 1);
-		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
-		for (found = -1, i = 0; i < numrecs - 1; i++) {
-			if (be64_to_cpu(key[i].br_startoff) <= bno && bno < 
-					be64_to_cpu(key[i + 1].br_startoff)) {
-				found = i;
-				break;
-			}
-		}
-		if (i == numrecs - 1 && bno >= be64_to_cpu(key[i].br_startoff))
-			found = i;
-
-		ASSERT(found != -1);
-		fsbno = be64_to_cpu(pp[found]);
-
-		ASSERT(verify_dfsbno(mp, fsbno));
-
-		/*
-		 * release current btree block and read in the
-		 * next btree block to be traversed
-		 */
-		libxfs_putbuf(bp);
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL);
-		if (!bp) {
-			do_error(_("cannot read bmap block %" PRIu64 "\n"),
-				fsbno);
-			return(NULLDFSBNO);
-		}
-		block = XFS_BUF_TO_BLOCK(bp);
-		numrecs = be16_to_cpu(block->bb_numrecs);
-	}
-
-	/*
-	 * current block must be a leaf block
-	 */
-	ASSERT(be16_to_cpu(block->bb_level) == 0);
-	if (numrecs > mp->m_bmap_dmxr[0]) {
-		do_warn(
-_("# of bmap records in inode %" PRIu64 " greater than maximum (%u, max - %u)\n"),
-			ino, numrecs, mp->m_bmap_dmxr[0]);
-		libxfs_putbuf(bp);
-		return(NULLDFSBNO);
-	}
-	if (verbose && numrecs < mp->m_bmap_dmnr[0])
-		do_warn(
-_("- # of bmap records in inode %" PRIu64 " less than minimum (%u, min - %u), continuing...\n"),
-			ino, numrecs, mp->m_bmap_dmnr[0]);
-
-	rec = XFS_BMBT_REC_ADDR(mp, block, 1);
-	for (i = 0; i < numrecs; i++)  {
-		libxfs_bmbt_disk_get_all(rec + i, &irec);
-		if (irec.br_startoff <= bno &&
-				bno < irec.br_startoff + irec.br_blockcount) {
-			final_fsbno = bno - irec.br_startoff +
-							irec.br_startblock;
-			break;
-		}
-	}
-	libxfs_putbuf(bp);
-
-	if (final_fsbno == NULLDFSBNO)
-		do_warn(_("could not map block %" PRIu64 "\n"), bno);
-
-	return(final_fsbno);
-}
-
-/*
- * this could be smarter.  maybe we should have an open inode
- * routine that would get the inode buffer and return back
- * an inode handle.  I'm betting for the moment that this
- * is used only by the directory and attribute checking code
- * and that the avl tree find and buffer cache search are
- * relatively cheap.  If they're too expensive, we'll just
- * have to fix this and add an inode handle to the da btree
- * cursor.
- *
- * caller is responsible for checking doubly referenced blocks
- * and references to holes
- *
- * NOTE: get_bmapi only used by dirv1 checking code
- */
-xfs_dfsbno_t
-get_bmapi(xfs_mount_t *mp, xfs_dinode_t *dino_p,
-		xfs_ino_t ino_num, xfs_dfiloff_t bno, int whichfork)
-{
-	xfs_dfsbno_t		fsbno;
-
-	switch (XFS_DFORK_FORMAT(dino_p, whichfork)) {
-	case XFS_DINODE_FMT_EXTENTS:
-		fsbno = getfunc_extlist(mp, ino_num, dino_p, bno, whichfork);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		fsbno = getfunc_btree(mp, ino_num, dino_p, bno, whichfork);
-		break;
-	case XFS_DINODE_FMT_LOCAL:
-		do_error(_("get_bmapi() called for local inode %" PRIu64 "\n"),
-			ino_num);
-		fsbno = NULLDFSBNO;
-		break;
-	default:
-		/*
-		 * shouldn't happen
-		 */
-		do_error(_("bad inode format for inode %" PRIu64 "\n"), ino_num);
-		fsbno = NULLDFSBNO;
-	}
-
-	return(fsbno);
-}
-
-/*
  * higher level inode processing stuff starts here:
  * first, one utility routine for each type of inode
  */
diff --git a/repair/dinode.h b/repair/dinode.h
index 5ee51ca..80f3e4e 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -119,12 +119,6 @@ get_agino_buf(xfs_mount_t	*mp,
 		xfs_agino_t	agino,
 		xfs_dinode_t	**dipp);
 
-xfs_dfsbno_t
-get_bmapi(xfs_mount_t		*mp,
-		xfs_dinode_t	*dip,
-		xfs_ino_t	ino_num,
-		xfs_dfiloff_t	bno,
-		int             whichfork );
 
 void dinode_bmbt_translation_init(void);
 char * get_forkname(int whichfork);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
