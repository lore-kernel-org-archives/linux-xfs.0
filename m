Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20975 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935289AbdDFOlr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 10:41:47 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [RFC PATCH 1/2] mkfs: unify numeric types of main variables in main()
Date: Thu,  6 Apr 2017 16:41:38 +0200
Message-Id: <20170406144139.20284-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mcgrof@kernel.org, sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

Followup of my "[xfsprogs] Do we need so many data types for user input?" email.

In the past, when mkfs was first written, it used atoi and
similar calls, so the variables were ints. However, the situation moved
since then and in course of the time, mkfs began to use other types too.

Clean and unify it. We don't need negative values anywhere in the code and
some numbers has to be 64bit. Thus, uint64 is the best candidate as the target
type.

This patch changes variables declared at the beginning of main() + block/sectorsize, making only minimal changes. The following patch cleans some now-unnecessary type casts.

It would be nice to change types in some of the structures too, but
this might lead to changes outside of mkfs, so I'm skipping them for
this moment to keep it simple.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 184 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 92 insertions(+), 92 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5aac4d1b..71382f70 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -39,8 +39,8 @@ static int  ispow2(unsigned int i);
  * The configured block and sector sizes are defined as global variables so
  * that they don't need to be passed to functions that require them.
  */
-unsigned int		blocksize;
-unsigned int		sectorsize;
+__uint64_t		blocksize;
+__uint64_t		sectorsize;
 
 #define MAX_SUBOPTS	16
 #define SUBOPT_NEEDS_VAL	(-1LL)
@@ -742,9 +742,9 @@ calc_stripe_factors(
 	int		dsectsz,
 	int		lsu,
 	int		lsectsz,
-	int		*dsunit,
-	int		*dswidth,
-	int		*lsunit)
+	__uint64_t	*dsunit,
+	__uint64_t	*dswidth,
+	__uint64_t	*lsunit)
 {
 	/* Handle data sunit/swidth options */
 	if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
@@ -769,32 +769,32 @@ calc_stripe_factors(
 			usage();
 		}
 
-		*dsunit  = (int)BTOBBT(dsu);
+		*dsunit  = BTOBBT(dsu);
 		*dswidth = *dsunit * dsw;
 	}
 
 	if (*dsunit && (*dswidth % *dsunit != 0)) {
 		fprintf(stderr,
-			_("data stripe width (%d) must be a multiple of the "
-			"data stripe unit (%d)\n"), *dswidth, *dsunit);
+			_("data stripe width (%lu) must be a multiple of the "
+			"data stripe unit (%lu)\n"), *dswidth, *dsunit);
 		usage();
 	}
 
 	/* Handle log sunit options */
 
 	if (lsu)
-		*lsunit = (int)BTOBBT(lsu);
+		*lsunit = BTOBBT(lsu);
 
 	/* verify if lsu/lsunit is a multiple block size */
 	if (lsu % blocksize != 0) {
 		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+_("log stripe unit (%d) must be a multiple of the block size (%lu)\n"),
 		lsu, blocksize);
 		exit(1);
 	}
 	if ((BBTOB(*lsunit) % blocksize != 0)) {
 		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+_("log stripe unit (%lu) must be a multiple of the block size (%lu)\n"),
 		BBTOB(*lsunit), blocksize);
 		exit(1);
 	}
@@ -917,7 +917,7 @@ fixup_internal_log_stripe(
 	int		sunit,
 	xfs_rfsblock_t	*logblocks,
 	int		blocklog,
-	int		*lalign)
+	__uint64_t	*lalign)
 {
 	if ((logstart % sunit) != 0) {
 		logstart = ((logstart + (sunit - 1))/sunit) * sunit;
@@ -1405,70 +1405,70 @@ main(
 	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
 	struct xfs_btree_block	*block;
-	int			blflag;
-	int			blocklog;
-	int			bsflag;
-	int			bsize;
+	__uint64_t		blflag;
+	__uint64_t		blocklog;
+	__uint64_t		bsflag;
+	__uint64_t		bsize;
 	xfs_buf_t		*buf;
-	int			c;
-	int			daflag;
-	int			dasize;
+	__uint64_t		c;
+	__uint64_t		daflag;
+	__uint64_t		dasize;
 	xfs_rfsblock_t		dblocks;
 	char			*dfile;
-	int			dirblocklog;
-	int			dirblocksize;
+	__uint64_t		dirblocklog;
+	__uint64_t		dirblocksize;
 	char			*dsize;
-	int			dsu;
-	int			dsw;
-	int			dsunit;
-	int			dswidth;
-	int			force_overwrite;
+	__uint64_t		dsu;
+	__uint64_t		dsw;
+	__uint64_t		dsunit;
+	__uint64_t		dswidth;
+	__uint64_t		force_overwrite;
 	struct fsxattr		fsx;
-	int			ilflag;
-	int			imaxpct;
-	int			imflag;
-	int			inodelog;
-	int			inopblock;
-	int			ipflag;
-	int			isflag;
-	int			isize;
+	__uint64_t		ilflag;
+	__uint64_t		imaxpct;
+	__uint64_t		imflag;
+	__uint64_t		inodelog;
+	__uint64_t		inopblock;
+	__uint64_t		ipflag;
+	__uint64_t		isflag;
+	__uint64_t		isize;
 	char			*label = NULL;
-	int			laflag;
-	int			lalign;
-	int			ldflag;
-	int			liflag;
+	__uint64_t		laflag;
+	__uint64_t		lalign;
+	__uint64_t		ldflag;
+	__uint64_t		liflag;
 	xfs_agnumber_t		logagno;
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
-	int			loginternal;
+	__uint64_t		loginternal;
 	char			*logsize;
 	xfs_fsblock_t		logstart;
-	int			lvflag;
-	int			lsflag;
-	int			lsuflag;
-	int			lsunitflag;
-	int			lsectorlog;
-	int			lsectorsize;
-	int			lslflag;
-	int			lssflag;
-	int			lsu;
-	int			lsunit;
-	int			min_logblocks;
+	__uint64_t		lvflag;
+	__uint64_t		lsflag;
+	__uint64_t		lsuflag;
+	__uint64_t		lsunitflag;
+	__uint64_t		lsectorlog;
+	__uint64_t		lsectorsize;
+	__uint64_t		lslflag;
+	__uint64_t		lssflag;
+	__uint64_t		lsu;
+	__uint64_t		lsunit;
+	__uint64_t		min_logblocks;
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
-	int			nlflag;
-	int			nodsflag;
-	int			norsflag;
+	__uint64_t		nlflag;
+	__uint64_t		nodsflag;
+	__uint64_t		norsflag;
 	xfs_alloc_rec_t		*nrec;
-	int			nsflag;
-	int			nvflag;
-	int			Nflag;
-	int			discard = 1;
+	__uint64_t		nsflag;
+	__uint64_t		nvflag;
+	__uint64_t		Nflag;
+	__uint64_t		discard = 1;
 	char			*p;
 	char			*protofile;
 	char			*protostring;
-	int			qflag;
+	__uint64_t		qflag;
 	xfs_rfsblock_t		rtblocks;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
@@ -1476,13 +1476,13 @@ main(
 	char			*rtfile;
 	char			*rtsize;
 	xfs_sb_t		*sbp;
-	int			sectorlog;
+	__uint64_t		sectorlog;
 	__uint64_t		sector_mask;
-	int			slflag;
-	int			ssflag;
+	__uint64_t		slflag;
+	__uint64_t		ssflag;
 	__uint64_t		tmp_agsize;
 	uuid_t			uuid;
-	int			worst_freelist;
+	__uint64_t		worst_freelist;
 	libxfs_init_t		xi;
 	struct fs_topology	ft;
 	struct sb_feat_args	sb_feat = {
@@ -1946,7 +1946,7 @@ main(
 		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
 	}
 	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
-		fprintf(stderr, _("illegal block size %d\n"), blocksize);
+		fprintf(stderr, _("illegal block size %lu\n"), blocksize);
 		usage();
 	}
 	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
@@ -2010,7 +2010,7 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 
 		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
 			fprintf(stderr,
-_("specified blocksize %d is less than device physical sector size %d\n"),
+_("specified blocksize %lu is less than device physical sector size %d\n"),
 				blocksize, ft.psectorsize);
 			fprintf(stderr,
 _("switching to logical sector size %d\n"),
@@ -2031,21 +2031,21 @@ _("switching to logical sector size %d\n"),
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
 		if (ssflag)
-			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
+			fprintf(stderr, _("illegal sector size %lu\n"), sectorsize);
 		else
 			fprintf(stderr,
-_("block size %d cannot be smaller than logical sector size %d\n"),
+_("block size %lu cannot be smaller than logical sector size %d\n"),
 				blocksize, ft.lsectorsize);
 		usage();
 	}
 	if (sectorsize < ft.lsectorsize) {
-		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
+		fprintf(stderr, _("illegal sector size %lu; hw sector is %d\n"),
 			sectorsize, ft.lsectorsize);
 		usage();
 	}
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||
 	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
-		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
+		fprintf(stderr, _("illegal log sector size %lu\n"), lsectorsize);
 		usage();
 	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
 		lsu = blocksize;
@@ -2151,7 +2151,7 @@ _("rmapbt not supported with realtime devices\n"));
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
-			fprintf(stderr, _("illegal directory block size %d\n"),
+			fprintf(stderr, _("illegal directory block size %lu\n"),
 				dirblocksize);
 			usage();
 		}
@@ -2177,7 +2177,7 @@ _("rmapbt not supported with realtime devices\n"));
 		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
 		if (dbytes % blocksize)
 			fprintf(stderr, _("warning: "
-	"data length %lld not a multiple of %d, truncated to %lld\n"),
+	"data length %lld not a multiple of %lu, truncated to %lld\n"),
 				(long long)dbytes, blocksize,
 				(long long)(dblocks << blocklog));
 	}
@@ -2209,7 +2209,7 @@ _("rmapbt not supported with realtime devices\n"));
 		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
 		if (logbytes % blocksize)
 			fprintf(stderr,
-	_("warning: log length %lld not a multiple of %d, truncated to %lld\n"),
+	_("warning: log length %lld not a multiple of %lu, truncated to %lld\n"),
 				(long long)logbytes, blocksize,
 				(long long)(logblocks << blocklog));
 	}
@@ -2226,7 +2226,7 @@ _("rmapbt not supported with realtime devices\n"));
 		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
 		if (rtbytes % blocksize)
 			fprintf(stderr,
-	_("warning: rt length %lld not a multiple of %d, truncated to %lld\n"),
+	_("warning: rt length %lld not a multiple of %lu, truncated to %lld\n"),
 				(long long)rtbytes, blocksize,
 				(long long)(rtblocks << blocklog));
 	}
@@ -2239,7 +2239,7 @@ _("rmapbt not supported with realtime devices\n"));
 		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
-		_("illegal rt extent size %lld, not a multiple of %d\n"),
+		_("illegal rt extent size %lld, not a multiple of %lu\n"),
 				(long long)rtextbytes, blocksize);
 			usage();
 		}
@@ -2282,16 +2282,16 @@ _("rmapbt not supported with realtime devices\n"));
 	    isize > XFS_DINODE_MAX_SIZE) {
 		int	maxsz;
 
-		fprintf(stderr, _("illegal inode size %d\n"), isize);
+		fprintf(stderr, _("illegal inode size %lu\n"), isize);
 		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
 			    XFS_DINODE_MAX_SIZE);
 		if (XFS_DINODE_MIN_SIZE == maxsz)
 			fprintf(stderr,
-			_("allowable inode size with %d byte blocks is %d\n"),
+			_("allowable inode size with %lu byte blocks is %d\n"),
 				blocksize, XFS_DINODE_MIN_SIZE);
 		else
 			fprintf(stderr,
-	_("allowable inode size with %d byte blocks is between %d and %d\n"),
+	_("allowable inode size with %lu byte blocks is between %d and %d\n"),
 				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
 		exit(1);
 	}
@@ -2395,19 +2395,19 @@ _("rmapbt not supported with realtime devices\n"));
 
 	if (xi.dbsize > sectorsize) {
 		fprintf(stderr, _(
-"Warning: the data subvolume sector size %u is less than the sector size \n\
+"Warning: the data subvolume sector size %lu is less than the sector size \n\
 reported by the device (%u).\n"),
 			sectorsize, xi.dbsize);
 	}
 	if (!loginternal && xi.lbsize > lsectorsize) {
 		fprintf(stderr, _(
-"Warning: the log subvolume sector size %u is less than the sector size\n\
+"Warning: the log subvolume sector size %lu is less than the sector size\n\
 reported by the device (%u).\n"),
 			lsectorsize, xi.lbsize);
 	}
 	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
-"Warning: the realtime subvolume sector size %u is less than the sector size\n\
+"Warning: the realtime subvolume sector size %lu is less than the sector size\n\
 reported by the device (%u).\n"),
 			sectorsize, xi.rtbsize);
 	}
@@ -2437,14 +2437,14 @@ reported by the device (%u).\n"),
 		if (dsunit) {
 			if (ft.dsunit && ft.dsunit != dsunit) {
 				fprintf(stderr,
-					_("%s: Specified data stripe unit %d "
+					_("%s: Specified data stripe unit %lu "
 					"is not the same as the volume stripe "
 					"unit %d\n"),
 					progname, dsunit, ft.dsunit);
 			}
 			if (ft.dswidth && ft.dswidth != dswidth) {
 				fprintf(stderr,
-					_("%s: Specified data stripe width %d "
+					_("%s: Specified data stripe width %lu "
 					"is not the same as the volume stripe "
 					"width %d\n"),
 					progname, dswidth, ft.dswidth);
@@ -2462,7 +2462,7 @@ reported by the device (%u).\n"),
 		 */
 		if (agsize % blocksize) {
 			fprintf(stderr,
-		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
+		_("agsize (%lld) not a multiple of fs blk size (%lu)\n"),
 				(long long)agsize, blocksize);
 			usage();
 		}
@@ -2512,7 +2512,7 @@ reported by the device (%u).\n"),
 						(dblocks % agsize != 0);
 				if (dasize)
 					fprintf(stderr,
-				_("agsize rounded to %lld, swidth = %d\n"),
+				_("agsize rounded to %lld, swidth = %lu\n"),
 						(long long)agsize, dswidth);
 			} else {
 				if (nodsflag) {
@@ -2569,8 +2569,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			dsunit = dswidth = 0;
 		else {
 			fprintf(stderr,
-				_("%s: Stripe unit(%d) or stripe width(%d) is "
-				"not a multiple of the block size(%d)\n"),
+				_("%s: Stripe unit(%lu) or stripe width(%lu) is "
+				"not a multiple of the block size(%lu)\n"),
 				progname, BBTOB(dsunit), BBTOB(dswidth),
 				blocksize);
 			exit(1);
@@ -2610,7 +2610,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		/* Warn only if specified on commandline */
 		if (lsuflag || lsunitflag) {
 			fprintf(stderr,
-	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
+	_("log stripe unit (%lu bytes) is too large (maximum is 256KiB)\n"),
 				(lsunit * blocksize));
 			fprintf(stderr,
 	_("log stripe unit adjusted to 32KiB\n"));
@@ -2755,14 +2755,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	if (!qflag || Nflag) {
 		printf(_(
-		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
-		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+		   "meta-data=%-22s isize=%-6lu agcount=%lld, agsize=%lld blks\n"
+		   "         =%-22s sectsz=%-5lu attr=%u, projid32bit=%u\n"
 		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
-		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-		   "         =%-22s sunit=%-6u swidth=%u blks\n"
-		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+		   "data     =%-22s bsize=%-6lu blocks=%llu, imaxpct=%lu\n"
+		   "         =%-22s sunit=%-6lu swidth=%lu blks\n"
+		   "naming   =version %-14u bsize=%-6lu ascii-ci=%d ftype=%d\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
-		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
+		   "         =%-22s sectsz=%-5lu sunit=%lu blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, sb_feat.attr_version,
-- 
2.12.1

