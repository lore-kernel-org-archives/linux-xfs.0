Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3Fo6GT170177 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 09:50:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3FEC59D94
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 07:50:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Baw8cy3xcR51oT1D for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2009 07:50:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N5LeF-0007t3-Iu
	for xfs@oss.sgi.com; Tue, 03 Nov 2009 15:50:19 +0000
Date: Tue, 3 Nov 2009 10:50:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] db: stop using xfs_bmbt_rec_32_t
Message-ID: <20091103155019.GA28991@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_db uses the xfs_bmbt_rec_32_t type to pass around extent information in a
few places.  But everywhere where we actually use it we use the normal
xfs_bmbt_rec_t just casting from/to xfs_bmbt_rec_32_t to pass it around.

Just pass the xfs_bmbt_rec_t directly and thus get rid of the last use
of xfs_bmbt_rec_32_t in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/db/check.c
===================================================================
--- xfsprogs-dev.orig/db/check.c	2009-10-11 03:16:17.350004081 +0200
+++ xfsprogs-dev/db/check.c	2009-11-03 16:46:56.067277983 +0100
@@ -265,7 +265,7 @@ static int		ncheck_f(int argc, char **ar
 static char		*prepend_path(char *oldpath, char *parent);
 static xfs_ino_t	process_block_dir_v2(blkmap_t *blkmap, int *dot,
 					     int *dotdot, inodata_t *id);
-static void		process_bmbt_reclist(xfs_bmbt_rec_32_t *rp, int numrecs,
+static void		process_bmbt_reclist(xfs_bmbt_rec_t *rp, int numrecs,
 					     dbm_t type, inodata_t *id,
 					     xfs_drfsbno_t *tot,
 					     blkmap_t **blkmapp);
@@ -2012,7 +2012,7 @@ process_block_dir_v2(
 
 static void
 process_bmbt_reclist(
-	xfs_bmbt_rec_32_t	*rp,
+	xfs_bmbt_rec_t		*rp,
 	int			numrecs,
 	dbm_t			type,
 	inodata_t		*id,
@@ -2038,7 +2038,7 @@ process_bmbt_reclist(
 	iagno = XFS_INO_TO_AGNO(mp, id->ino);
 	iagbno = XFS_INO_TO_AGBNO(mp, id->ino);
 	for (i = 0; i < numrecs; i++, rp++) {
-		convert_extent((xfs_bmbt_rec_64_t *)rp, &o, &s, &c, &f);
+		convert_extent(rp, &o, &s, &c, &f);
 		if (v)
 			dbprintf(_("inode %lld extent [%lld,%lld,%lld,%d]\n"),
 				id->ino, o, s, c, f);
@@ -2120,7 +2120,6 @@ process_btinode(
 	xfs_bmdr_block_t	*dib;
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
-	xfs_bmbt_rec_32_t	*rp;
 
 	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	if (be16_to_cpu(dib->bb_level) >= XFS_BM_MAXLEVELS(mp, whichfork)) {
@@ -2146,7 +2145,7 @@ process_btinode(
 		return;
 	}
 	if (be16_to_cpu(dib->bb_level) == 0) {
-		rp = (xfs_bmbt_rec_32_t *)XFS_BMDR_REC_ADDR(dib, 1);
+		xfs_bmbt_rec_t	*rp = XFS_BMDR_REC_ADDR(dib, 1);
 		process_bmbt_reclist(rp, be16_to_cpu(dib->bb_numrecs), type, 
 							id, totd, blkmapp);
 		*nex += be16_to_cpu(dib->bb_numrecs);
@@ -2579,12 +2578,12 @@ process_exinode(
 	blkmap_t		**blkmapp,
 	int			whichfork)
 {
-	xfs_bmbt_rec_32_t	*rp;
+	xfs_bmbt_rec_t		*rp;
 
-	rp = (xfs_bmbt_rec_32_t *)XFS_DFORK_PTR(dip, whichfork);
+	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) / 
-						sizeof(xfs_bmbt_rec_32_t)) {
+						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
 			dbprintf(_("bad number of extents %d for inode %lld\n"),
 				*nex, id->ino);
@@ -4207,7 +4206,7 @@ scanfunc_bmap(
 	xfs_agnumber_t		agno;
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
-	xfs_bmbt_rec_32_t	*rp;
+	xfs_bmbt_rec_t		*rp;
 
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
@@ -4240,7 +4239,7 @@ scanfunc_bmap(
 			error++;
 			return;
 		}
-		rp = (xfs_bmbt_rec_32_t *)XFS_BMBT_REC_ADDR(mp, block, 1);
+		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
 		*nex += be16_to_cpu(block->bb_numrecs);
 		process_bmbt_reclist(rp, be16_to_cpu(block->bb_numrecs), type, id, totd,
 			blkmapp);
Index: xfsprogs-dev/db/frag.c
===================================================================
--- xfsprogs-dev.orig/db/frag.c	2009-10-11 03:16:17.364007469 +0200
+++ xfsprogs-dev/db/frag.c	2009-11-03 16:46:56.068277413 +0100
@@ -66,7 +66,7 @@ static void		extmap_set_ext(extmap_t **e
 				       xfs_extlen_t c);
 static int		frag_f(int argc, char **argv);
 static int		init(int argc, char **argv);
-static void		process_bmbt_reclist(xfs_bmbt_rec_32_t *rp, int numrecs,
+static void		process_bmbt_reclist(xfs_bmbt_rec_t *rp, int numrecs,
 					     extmap_t **extmapp);
 static void		process_btinode(xfs_dinode_t *dip, extmap_t **extmapp,
 					int whichfork);
@@ -223,7 +223,7 @@ init(
 
 static void
 process_bmbt_reclist(
-	xfs_bmbt_rec_32_t	*rp,
+	xfs_bmbt_rec_t		*rp,
 	int			numrecs,
 	extmap_t		**extmapp)
 {
@@ -234,7 +234,7 @@ process_bmbt_reclist(
 	xfs_dfsbno_t		s;
 
 	for (i = 0; i < numrecs; i++, rp++) {
-		convert_extent((xfs_bmbt_rec_64_t *)rp, &o, &s, &c, &f);
+		convert_extent(rp, &o, &s, &c, &f);
 		extmap_set_ext(extmapp, (xfs_fileoff_t)o, (xfs_extlen_t)c);
 	}
 }
@@ -248,11 +248,10 @@ process_btinode(
 	xfs_bmdr_block_t	*dib;
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
-	xfs_bmbt_rec_32_t	*rp;
 
 	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	if (be16_to_cpu(dib->bb_level) == 0) {
-		rp = (xfs_bmbt_rec_32_t *)XFS_BMDR_REC_ADDR(dib, 1);
+		xfs_bmbt_rec_t		*rp = XFS_BMDR_REC_ADDR(dib, 1);
 		process_bmbt_reclist(rp, be16_to_cpu(dib->bb_numrecs), extmapp);
 		return;
 	}
@@ -270,9 +269,9 @@ process_exinode(
 	extmap_t		**extmapp,
 	int			whichfork)
 {
-	xfs_bmbt_rec_32_t	*rp;
+	xfs_bmbt_rec_t		*rp;
 
-	rp = (xfs_bmbt_rec_32_t *)XFS_DFORK_PTR(dip, whichfork);
+	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
 }
 
@@ -448,8 +447,7 @@ scanfunc_bmap(
 			return;
 		}
 		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
-		process_bmbt_reclist((xfs_bmbt_rec_32_t *)rp, 
-				nrecs, extmapp);
+		process_bmbt_reclist(rp, nrecs, extmapp);
 		return;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
