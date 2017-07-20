Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933242AbdGTJwD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:52:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FD39C058ECA
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:52:03 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/5] mkfs: replace variables with opts table: -b,d,s options
Date: Thu, 20 Jul 2017 11:51:52 +0200
Message-Id: <20170720095156.35417-2-jtulak@redhat.com>
In-Reply-To: <20170720095156.35417-1-jtulak@redhat.com>
References: <20170720095156.35417-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Remove variables that can be replaced with a direct access to the opts
table, so we have it all in a single place, accessible from anywhere.

In future, we can remove some instances where we are passing values as
arguments to helper functions, when we have the values in the opts
struct and could pass only the struct.  But for now, limit the changes
to simple replacement without any change in the logic.

This is first of multiple similar patches that do the same, but for
other options.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 872 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 532 insertions(+), 340 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bf480efe..27043684 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -32,13 +32,6 @@ static void respec(char opt, char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
-/*
- * The configured block and sector sizes are defined as global variables so
- * that they don't need to be passed to functions that require them.
- */
-unsigned int		blocksize;
-unsigned int		sectorsize;
-
 #define MAX_OPTS	16
 #define MAX_SUBOPTS	16
 #define SUBOPT_NEEDS_VAL	(-1LL)
@@ -740,7 +733,8 @@ struct opt_params {
 /*
  * Use this macro before we have superblock and mount structure
  */
-#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (blocklog - BBSHIFT)))
+#define	DTOBT(d) \
+	((xfs_rfsblock_t)((d) >> (get_conf_val(OPT_B, B_LOG) - BBSHIFT)))
 
 /*
  * Use this for block reservations needed for mkfs's conditions
@@ -760,14 +754,14 @@ struct opt_params {
 /*
  * Get and set values to the opts table.
  */
-static inline uint64_t
+static inline long long
 get_conf_val(int opt, int subopt)
 {
 	return opts[opt].subopt_params[subopt].value;
 }
 
 static void
-set_conf_val(int opt, int subopt, uint64_t val)
+set_conf_val(int opt, int subopt, long long val)
 {
 	struct subopt_param *sp = &opts[opt].subopt_params[subopt];
 
@@ -883,7 +877,8 @@ getnum(
 	 * number.
 	 */
 	if (sp->convert)
-		c = cvtnum(blocksize, sectorsize, str);
+		c = cvtnum(get_conf_val(OPT_B, B_SIZE),
+			   get_conf_val(OPT_D, D_SECTSIZE), str);
 	else {
 		char		*str_end;
 
@@ -907,7 +902,7 @@ getnum(
 /*
  * A wrapper for getnum and set_conf_val.
  */
-static inline uint64_t
+static inline long long
 parse_conf_val(int opt, int subopt, char *value)
 {
 	uint64_t num = getnum(value, &opts[opt], subopt);
@@ -970,16 +965,16 @@ calc_stripe_factors(
 		*lsunit = (int)BTOBBT(lsu);
 
 	/* verify if lsu/lsunit is a multiple block size */
-	if (lsu % blocksize != 0) {
+	if (lsu % get_conf_val(OPT_B, B_SIZE) != 0) {
 		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-		lsu, blocksize);
+_("log stripe unit (%d) must be a multiple of the block size (%lld)\n"),
+		lsu, get_conf_val(OPT_B, B_SIZE));
 		exit(1);
 	}
-	if ((BBTOB(*lsunit) % blocksize != 0)) {
+	if ((BBTOB(*lsunit) % get_conf_val(OPT_B, B_SIZE) != 0)) {
 		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-		BBTOB(*lsunit), blocksize);
+_("log stripe unit (%d) must be a multiple of the block size (%lld)\n"),
+		BBTOB(*lsunit), get_conf_val(OPT_B, B_SIZE));
 		exit(1);
 	}
 }
@@ -1135,7 +1130,7 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
 			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
 		usage();
 	}
-	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
+	if ((logblocks << get_conf_val(OPT_B, B_LOG)) > XFS_MAX_LOG_BYTES) {
 		fprintf(stderr,
 	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
 			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
@@ -1229,9 +1224,9 @@ validate_ag_geometry(
 	}
 
 	/*
-	 * If agcount is too large, make it smaller.
+	 * If D_AGCOUNT is too large, make it smaller.
 	 */
-	if (agcount > XFS_MAX_AGNUMBER + 1) {
+	if (get_conf_val(OPT_D, D_AGCOUNT) > XFS_MAX_AGNUMBER + 1) {
 		fprintf(stderr,
 	_("%lld allocation groups is too many, maximum is %lld\n"),
 			(long long)agcount, (long long)XFS_MAX_AGNUMBER + 1);
@@ -1465,15 +1460,12 @@ main(
 	int			argc,
 	char			**argv)
 {
-	__uint64_t		agcount;
 	xfs_agf_t		*agf;
 	xfs_agi_t		*agi;
 	xfs_agnumber_t		agno;
-	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
 	struct xfs_btree_block	*block;
 	int			blflag;
-	int			blocklog;
 	int			bsflag;
 	int			bsize;
 	xfs_buf_t		*buf;
@@ -1484,11 +1476,6 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	int			dbytes;
-	int			dsu;
-	int			dsw;
-	int			dsunit;
-	int			dswidth;
 	bool			force_overwrite;
 	struct fsxattr		fsx;
 	int			ilflag;
@@ -1525,7 +1512,6 @@ main(
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
 	int			nlflag;
-	int			nodsflag;
 	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
@@ -1543,7 +1529,6 @@ main(
 	int		rtextbytes;
 	char			*rtfile;
 	xfs_sb_t		*sbp;
-	int			sectorlog;
 	__uint64_t		sector_mask;
 	int			slflag;
 	int			ssflag;
@@ -1576,12 +1561,11 @@ main(
 	textdomain(PACKAGE);
 
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
-	blocklog = blocksize = 0;
-	sectorlog = lsectorlog = 0;
-	sectorsize = lsectorsize = 0;
-	agsize = daflag = dasize = dblocks = 0;
-	ilflag = imflag = ipflag = isflag = 0;
-	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
+	lsectorlog = 0;
+	lsectorsize = 0;
+	dasize = dblocks = 0;
+	daflag = ilflag = imflag = ipflag = isflag = false;
+	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = false;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = 0;
@@ -1590,10 +1574,10 @@ main(
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
 	protofile = NULL;
-	rtbytes = rtextbytes = logbytes = dbytes = 0;
-	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
-	nodsflag = norsflag = 0;
-	force_overwrite = 0;
+	rtbytes = rtextbytes = logbytes = 0;
+	lalign = lsu = lsunit = 0;
+	norsflag = false;
+	force_overwrite = false;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
@@ -1609,6 +1593,7 @@ main(
 			break;
 		case 'b':
 			p = optarg;
+			uint64_t tmp;
 			while (*p != '\0') {
 				char	**subopts =
 						(char **)opts[OPT_B].subopts;
@@ -1616,19 +1601,17 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case B_LOG:
-					blocklog = parse_conf_val(OPT_B, B_LOG,
-								  value);
-					blocksize = 1 << blocklog;
+					tmp = parse_conf_val(OPT_B, B_LOG,
+							     value);
+					set_conf_val(OPT_B, B_SIZE, 1 << tmp);
 					blflag = 1;
-					set_conf_val(OPT_B, B_SIZE, blocksize);
 					break;
 				case B_SIZE:
-					blocksize = parse_conf_val(OPT_B,
-								   B_SIZE,
-								   value);
-					blocklog = libxfs_highbit32(blocksize);
+					tmp = parse_conf_val(OPT_B, B_SIZE,
+							     value);
+					set_conf_val(OPT_B, B_LOG,
+						libxfs_highbit32(tmp));
 					bsflag = 1;
-					set_conf_val(OPT_B, B_LOG, blocklog);
 					break;
 				default:
 					unknown('b', value);
@@ -1641,18 +1624,17 @@ main(
 				char	**subopts =
 						(char **)opts[OPT_D].subopts;
 				char	*value;
+				uint64_t tmp;
+
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case D_AGCOUNT:
-					agcount = parse_conf_val(OPT_D,
-								 D_AGCOUNT,
-								 value);
+					parse_conf_val(OPT_D, D_AGCOUNT,
+						       value);
 					daflag = 1;
 					break;
 				case D_AGSIZE:
-					agsize = parse_conf_val(OPT_D,
-								D_AGSIZE,
-								value);
+					parse_conf_val(OPT_D, D_AGSIZE, value);
 					dasize = 1;
 					break;
 				case D_FILE:
@@ -1666,49 +1648,70 @@ main(
 					set_conf_val(OPT_D, D_NAME,  1);
 					break;
 				case D_SIZE:
-					dbytes = parse_conf_val(OPT_D, D_SIZE,
-								value);
+					parse_conf_val(OPT_D, D_SIZE, value);
 					break;
 				case D_SUNIT:
-					dsunit = parse_conf_val(OPT_D, D_SUNIT,
-								value);
+					parse_conf_val(OPT_D, D_SUNIT, value);
 					break;
 				case D_SWIDTH:
-					dswidth = parse_conf_val(OPT_D,
-								 D_SWIDTH,
-								 value);
+					parse_conf_val(OPT_D, D_SWIDTH, value);
 					break;
 				case D_SU:
-					dsu = parse_conf_val(OPT_D, D_SU,
-							     value);
+					parse_conf_val(OPT_D, D_SU, value);
 					break;
 				case D_SW:
-					dsw = parse_conf_val(OPT_D, D_SW,
-							     value);
+					parse_conf_val(OPT_D, D_SW, value);
 					break;
 				case D_NOALIGN:
-					nodsflag = parse_conf_val(OPT_D,
-								  D_NOALIGN,
-								  value);
+					parse_conf_val(OPT_D, D_NOALIGN,
+						       value);
 					break;
 				case D_SECTLOG:
-					sectorlog = parse_conf_val(OPT_D,
-								   D_SECTLOG,
-								   value);
-					sectorsize = 1 << sectorlog;
-					slflag = 1;
+					/*
+					 * we can set sector size both as
+					 * -d sectsize/sectlog and as -s option.
+					 * Thus we need to fill the same value
+					 * into multiple options to make sure
+					 * that we are doing the parsing right.
+					 * Only D_SECTSIZE/D_SECTLOG is used
+					 * later in the code, though.
+					 */
+					tmp = parse_conf_val(OPT_D, D_SECTLOG,
+							     value);
+
+					set_conf_val(OPT_S, S_LOG, tmp);
+					set_conf_val(OPT_S, S_SECTLOG, tmp);
 					set_conf_val(OPT_D, D_SECTSIZE,
-						     sectorsize);
+						     1 << tmp);
+					set_conf_val(OPT_S, S_SECTSIZE,
+						     1 << tmp);
+					set_conf_val(OPT_S, S_SIZE,
+						     1 << tmp);
+					slflag = 1;
 					break;
 				case D_SECTSIZE:
-					sectorsize = parse_conf_val(OPT_D,
-								    D_SECTSIZE,
-								    value);
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					ssflag = 1;
+					/*
+					 * we can set sector size both as
+					 * -d sectsize/sectlog and as -s option.
+					 * Thus we need to fill the same value
+					 * into multiple options to make sure
+					 * that we are doing the parsing right.
+					 * Only D_SECTSIZE/D_SECTLOG is used
+					 * later in the code, though.
+					 */
+					tmp = parse_conf_val(OPT_D, D_SECTSIZE,
+							     value);
+
+					set_conf_val(OPT_S, S_SIZE, tmp);
+					set_conf_val(OPT_S, S_SECTSIZE, tmp);
 					set_conf_val(OPT_D, D_SECTLOG,
-						     sectorlog);
+						libxfs_highbit32(tmp));
+					set_conf_val(OPT_S, S_LOG,
+						libxfs_highbit32(tmp));
+					set_conf_val(OPT_S, S_SECTLOG,
+						libxfs_highbit32(tmp));
+
+					ssflag = 1;
 					break;
 				case D_RTINHERIT:
 					c = parse_conf_val(OPT_D, D_RTINHERIT,
@@ -2053,6 +2056,16 @@ main(
 				char	**subopts =
 						(char **)opts[OPT_S].subopts;
 				char	*value;
+				uint64_t tmp;
+				/*
+				 * we can set sector size both as
+				 * -d sectsize/sectlog and as -s option.
+				 * Thus we need to fill the same value
+				 * into multiple options to make sure
+				 * that we are doing the parsing right.
+				 * Only D_SECTSIZE/D_SECTLOG is used
+				 * later in the code, though.
+				 */
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case S_LOG:
@@ -2061,14 +2074,21 @@ main(
 						conflict('s', subopts,
 							 S_SECTSIZE,
 							 S_SECTLOG);
-					sectorlog = parse_conf_val(OPT_S,
+					tmp = parse_conf_val(OPT_S,
 								   S_SECTLOG,
 								   value);
-					lsectorlog = sectorlog;
-					sectorsize = 1 << sectorlog;
-					lsectorsize = sectorsize;
+
+					set_conf_val(OPT_S, S_LOG, tmp);
+					set_conf_val(OPT_D, D_SECTLOG, tmp);
+					lsectorlog = tmp;
+					set_conf_val(OPT_D, D_SECTSIZE,
+						     1 << tmp);
+					set_conf_val(OPT_S, S_SIZE, 1 << tmp);
+					set_conf_val(OPT_S, S_SECTSIZE,
+						     1 << tmp);
+
+					lsectorsize = tmp;
 					lslflag = slflag = 1;
-					set_conf_val(OPT_S, S_LOG, sectorsize);
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
@@ -2076,16 +2096,22 @@ main(
 						conflict('s', subopts,
 							 S_SECTLOG,
 							 S_SECTSIZE);
-					sectorsize = parse_conf_val(OPT_S,
+					tmp = parse_conf_val(OPT_S,
 								    S_SECTSIZE,
 								    value);
-					lsectorsize = sectorsize;
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					lsectorlog = sectorlog;
+
+					set_conf_val(OPT_S, S_SIZE, tmp);
+					set_conf_val(OPT_D, D_SECTSIZE, tmp);
+					lsectorsize = tmp;
+					set_conf_val(OPT_D, D_SECTLOG,
+						libxfs_highbit32(tmp));
+					set_conf_val(OPT_S, S_LOG,
+						libxfs_highbit32(tmp));
+					set_conf_val(OPT_S, S_SECTLOG,
+						libxfs_highbit32(tmp));
+					lsectorlog = libxfs_highbit32(tmp);
+
 					lssflag = ssflag = 1;
-					set_conf_val(OPT_S,
-						     S_SIZE, sectorlog);
 					break;
 				default:
 					unknown('s', value);
@@ -2109,19 +2135,22 @@ main(
 		dfile = xi.dname;
 
 	/*
-	 * Blocksize and sectorsize first, other things depend on them
+	 * Blocksize and D_SECTSIZE first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
 	 */
 	if (!blflag && !bsflag) {
-		blocklog = XFS_DFL_BLOCKSIZE_LOG;
-		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
+		set_conf_val(OPT_B, B_LOG, XFS_DFL_BLOCKSIZE_LOG);
+		set_conf_val(OPT_B, B_SIZE, 1 << XFS_DFL_BLOCKSIZE_LOG);
 	}
-	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
-		fprintf(stderr, _("illegal block size %d\n"), blocksize);
+	if (get_conf_val(OPT_B, B_SIZE) < XFS_MIN_BLOCKSIZE ||
+	    get_conf_val(OPT_B, B_SIZE) > XFS_MAX_BLOCKSIZE) {
+		fprintf(stderr, _("illegal block size %lld\n"),
+			get_conf_val(OPT_B, B_SIZE));
 		usage();
 	}
-	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+	if (sb_feat.crcs_enabled &&
+	    get_conf_val(OPT_B, B_SIZE) < XFS_MIN_CRC_BLOCKSIZE) {
 		fprintf(stderr,
 _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 			XFS_MIN_CRC_BLOCKSIZE);
@@ -2133,12 +2162,12 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	}
 
 	if (!slflag && !ssflag) {
-		sectorlog = XFS_MIN_SECTORSIZE_LOG;
-		sectorsize = XFS_MIN_SECTORSIZE;
+		set_conf_val(OPT_D, D_SECTLOG, XFS_MIN_SECTORSIZE_LOG);
+		set_conf_val(OPT_D, D_SECTSIZE, XFS_MIN_SECTORSIZE);
 	}
 	if (!lslflag && !lssflag) {
-		lsectorlog = sectorlog;
-		lsectorsize = sectorsize;
+		lsectorlog = get_conf_val(OPT_D, D_SECTLOG);
+		lsectorsize = get_conf_val(OPT_D, D_SECTSIZE);
 	}
 
 	/*
@@ -2148,7 +2177,8 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	 * sector size mismatches between the new filesystem and the underlying
 	 * host filesystem.
 	 */
-	check_device_type(dfile, &xi.disfile, !dbytes, !dfile,
+	check_device_type(dfile, &xi.disfile, !get_conf_val(OPT_D, D_SIZE),
+			  !dfile,
 			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
 	if (!loginternal)
 		check_device_type(xi.logname, &xi.lisfile, !logbytes,
@@ -2177,50 +2207,58 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		if (!ft.psectorsize)
 			ft.psectorsize = ft.lsectorsize;
 
-		sectorsize = ft.psectorsize ? ft.psectorsize :
-					      XFS_MIN_SECTORSIZE;
+		set_conf_val(OPT_D, D_SECTSIZE,
+			     ft.psectorsize ? ft.psectorsize :
+					      XFS_MIN_SECTORSIZE);
 
-		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
+		if ((get_conf_val(OPT_B, B_SIZE) <
+		     get_conf_val(OPT_D, D_SECTSIZE)) &&
+		    (get_conf_val(OPT_B, B_SIZE) >= ft.lsectorsize)) {
 			fprintf(stderr,
-_("specified blocksize %d is less than device physical sector size %d\n"),
-				blocksize, ft.psectorsize);
+_("specified blocksize %lld is less than device physical sector size %d\n"),
+				get_conf_val(OPT_B, B_SIZE), ft.psectorsize);
 			fprintf(stderr,
 _("switching to logical sector size %d\n"),
 				ft.lsectorsize);
-			sectorsize = ft.lsectorsize ? ft.lsectorsize :
-						      XFS_MIN_SECTORSIZE;
+			set_conf_val(OPT_D, D_SECTSIZE,
+				     ft.lsectorsize ? ft.lsectorsize :
+						      XFS_MIN_SECTORSIZE);
 		}
 	}
 
 	if (!ssflag) {
-		sectorlog = libxfs_highbit32(sectorsize);
+		set_conf_val(OPT_D, D_SECTLOG,
+			     libxfs_highbit32(get_conf_val(OPT_D, D_SECTSIZE)));
 		if (loginternal) {
-			lsectorsize = sectorsize;
-			lsectorlog = sectorlog;
+			lsectorsize = get_conf_val(OPT_D, D_SECTSIZE);
+			lsectorlog = get_conf_val(OPT_D, D_SECTLOG);
 		}
 	}
 
-	if (sectorsize < XFS_MIN_SECTORSIZE ||
-	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
+	if (get_conf_val(OPT_D, D_SECTSIZE) < XFS_MIN_SECTORSIZE ||
+	    get_conf_val(OPT_D, D_SECTSIZE) > XFS_MAX_SECTORSIZE ||
+	    get_conf_val(OPT_D, D_SECTSIZE) > get_conf_val(OPT_B, B_SIZE)) {
 		if (ssflag)
-			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
+			fprintf(stderr, _("illegal sector size %lld\n"),
+				get_conf_val(OPT_D, D_SECTSIZE));
 		else
 			fprintf(stderr,
-_("block size %d cannot be smaller than logical sector size %d\n"),
-				blocksize, ft.lsectorsize);
+_("block size %lld cannot be smaller than logical sector size %d\n"),
+				get_conf_val(OPT_B, B_SIZE), ft.lsectorsize);
 		usage();
 	}
-	if (sectorsize < ft.lsectorsize) {
-		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
-			sectorsize, ft.lsectorsize);
+	if (get_conf_val(OPT_D, D_SECTSIZE) < ft.lsectorsize) {
+		fprintf(stderr, _("illegal sector size %lld; hw sector is %d\n"),
+			get_conf_val(OPT_D, D_SECTSIZE), ft.lsectorsize);
 		usage();
 	}
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
+	    lsectorsize > XFS_MAX_SECTORSIZE ||
+	    lsectorsize > get_conf_val(OPT_B, B_SIZE)) {
 		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
 		usage();
 	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
-		lsu = blocksize;
+		lsu = get_conf_val(OPT_B, B_SIZE);
 		sb_feat.log_version = 2;
 	}
 
@@ -2322,37 +2360,41 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 	if (nsflag || nlflag) {
-		if (dirblocksize < blocksize ||
+		if (dirblocksize < get_conf_val(OPT_B, B_SIZE) ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
 			fprintf(stderr, _("illegal directory block size %d\n"),
 				dirblocksize);
 			usage();
 		}
 	} else {
-		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
+		if (get_conf_val(OPT_B, B_SIZE) < (1 << XFS_MIN_REC_DIRSIZE))
 			dirblocklog = XFS_MIN_REC_DIRSIZE;
 		else
-			dirblocklog = blocklog;
+			dirblocklog = get_conf_val(OPT_B, B_LOG);
 		dirblocksize = 1 << dirblocklog;
 	}
 
 
-	if (dbytes) {
-		if (dbytes % XFS_MIN_BLOCKSIZE) {
+	if (get_conf_val(OPT_D, D_SIZE)) {
+		if (get_conf_val(OPT_D, D_SIZE) % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
-				(long long)dbytes, XFS_MIN_BLOCKSIZE);
+				get_conf_val(OPT_D, D_SIZE), XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
-		if (dbytes % blocksize)
+		dblocks = (xfs_rfsblock_t)(get_conf_val(OPT_D, D_SIZE) >>
+					   get_conf_val(OPT_B, B_LOG));
+		if (get_conf_val(OPT_D, D_SIZE) % get_conf_val(OPT_B, B_SIZE))
 			fprintf(stderr, _("warning: "
-	"data length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)dbytes, blocksize,
-				(long long)(dblocks << blocklog));
+	"data length %lld not a multiple of %lld, truncated to %lld\n"),
+				get_conf_val(OPT_D, D_SIZE),
+				get_conf_val(OPT_B, B_SIZE),
+				(long long)(dblocks <<
+					   get_conf_val(OPT_B, B_LOG)));
 	}
 	if (ipflag) {
-		inodelog = blocklog - libxfs_highbit32(inopblock);
+		inodelog = get_conf_val(OPT_B, B_LOG) -
+			libxfs_highbit32(inopblock);
 		isize = 1 << inodelog;
 	} else if (!ilflag && !isflag) {
 		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
@@ -2373,12 +2415,14 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)logbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
-		if (logbytes % blocksize)
+		logblocks = (xfs_rfsblock_t)(logbytes >>
+					     get_conf_val(OPT_B, B_LOG));
+		if (logbytes % get_conf_val(OPT_B, B_SIZE))
 			fprintf(stderr,
-	_("warning: log length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)logbytes, blocksize,
-				(long long)(logblocks << blocklog));
+	_("warning: log length %lld not a multiple of %lld, truncated to %lld\n"),
+				(long long)logbytes, get_conf_val(OPT_B, B_SIZE),
+				(long long)(logblocks <<
+					   get_conf_val(OPT_B, B_LOG)));
 	}
 	if (rtbytes) {
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
@@ -2387,24 +2431,27 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
-		if (rtbytes % blocksize)
+		rtblocks = (xfs_rfsblock_t)(rtbytes >>
+					    get_conf_val(OPT_B, B_LOG));
+		if (rtbytes % get_conf_val(OPT_B, B_SIZE))
 			fprintf(stderr,
-	_("warning: rt length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)rtbytes, blocksize,
-				(long long)(rtblocks << blocklog));
+	_("warning: rt length %lld not a multiple of %lld, truncated to %lld\n"),
+				(long long)rtbytes, get_conf_val(OPT_B, B_SIZE),
+				(long long)(rtblocks <<
+					   get_conf_val(OPT_B, B_LOG)));
 	}
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
 	if (rtextbytes) {
-		if (rtextbytes % blocksize) {
+		if (rtextbytes % get_conf_val(OPT_B, B_SIZE)) {
 			fprintf(stderr,
-		_("illegal rt extent size %lld, not a multiple of %d\n"),
-				(long long)rtextbytes, blocksize);
+		_("illegal rt extent size %lld, not a multiple of %lld\n"),
+				(long long)rtextbytes, get_conf_val(OPT_B, B_SIZE));
 			usage();
 		}
-		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
+		rtextblocks = (xfs_extlen_t)(rtextbytes >>
+					     get_conf_val(OPT_B, B_LOG));
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2419,18 +2466,21 @@ _("rmapbt not supported with realtime devices\n"));
 		else
 			rswidth = 0;
 
-		/* check that rswidth is a multiple of fs blocksize */
-		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
+		/* check that rswidth is a multiple of fs B_SIZE */
+		if (!norsflag && rswidth &&
+		    !(BBTOB(rswidth) % get_conf_val(OPT_B, B_SIZE))) {
 			rswidth = DTOBT(rswidth);
-			rtextbytes = rswidth << blocklog;
+			rtextbytes = rswidth << get_conf_val(OPT_B, B_LOG);
 			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
 			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
 				rtextblocks = rswidth;
 			}
 		}
 		if (!rtextblocks) {
-			rtextblocks = (blocksize < XFS_MIN_RTEXTSIZE) ?
-					XFS_MIN_RTEXTSIZE >> blocklog : 1;
+			rtextblocks = (get_conf_val(OPT_B, B_SIZE) <
+				       XFS_MIN_RTEXTSIZE) ?
+				       XFS_MIN_RTEXTSIZE >>
+				       get_conf_val(OPT_B, B_LOG) : 1;
 		}
 	}
 	ASSERT(rtextblocks);
@@ -2438,22 +2488,25 @@ _("rmapbt not supported with realtime devices\n"));
 	/*
 	 * Check some argument sizes against mins, maxes.
 	 */
-	if (isize > blocksize / XFS_MIN_INODE_PERBLOCK ||
+	if (isize > get_conf_val(OPT_B, B_SIZE) / XFS_MIN_INODE_PERBLOCK ||
 	    isize < XFS_DINODE_MIN_SIZE ||
 	    isize > XFS_DINODE_MAX_SIZE) {
 		int	maxsz;
 
 		fprintf(stderr, _("illegal inode size %d\n"), isize);
-		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
+		maxsz = MIN(get_conf_val(OPT_B, B_SIZE) /
+			    XFS_MIN_INODE_PERBLOCK,
 			    XFS_DINODE_MAX_SIZE);
 		if (XFS_DINODE_MIN_SIZE == maxsz)
 			fprintf(stderr,
-			_("allowable inode size with %d byte blocks is %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE);
+			_("allowable inode size with %lld byte blocks is %d\n"),
+				get_conf_val(OPT_B, B_SIZE),
+				XFS_DINODE_MIN_SIZE);
 		else
 			fprintf(stderr,
-	_("allowable inode size with %d byte blocks is between %d and %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
+	_("allowable inode size with %lld byte blocks is between %d and %d\n"),
+				get_conf_val(OPT_B, B_SIZE),
+				XFS_DINODE_MIN_SIZE, maxsz);
 		exit(1);
 	}
 
@@ -2464,10 +2517,20 @@ _("rmapbt not supported with realtime devices\n"));
 		sb_feat.log_version = 2;
 	}
 
-	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
+	int dsunit = get_conf_val(OPT_D, D_SUNIT);
+	int dswidth = get_conf_val(OPT_D, D_SWIDTH);
+
+	calc_stripe_factors(get_conf_val(OPT_D, D_SU),
+			    get_conf_val(OPT_D, D_SW),
+			    get_conf_val(OPT_D, D_SECTSIZE),
+			    lsu,
+			    lsectorsize,
 				&dsunit, &dswidth, &lsunit);
 
-	xi.setblksize = sectorsize;
+	set_conf_val(OPT_D, D_SUNIT, dsunit);
+	set_conf_val(OPT_D, D_SWIDTH, dswidth);
+
+	xi.setblksize = get_conf_val(OPT_D, D_SECTSIZE);
 
 	/*
 	 * Initialize.  This will open the log and rt devices as well.
@@ -2490,7 +2553,8 @@ _("rmapbt not supported with realtime devices\n"));
 	 * multiple of the sector size, or 1024, whichever is larger.
 	 */
 
-	sector_mask = (__uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
+	sector_mask = (__uint64_t)-1 <<
+		(MAX(get_conf_val(OPT_D, D_SECTLOG), 10) - BBSHIFT);
 	xi.dsize &= sector_mask;
 	xi.rtsize &= sector_mask;
 	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
@@ -2525,16 +2589,17 @@ _("rmapbt not supported with realtime devices\n"));
 		rtfile = _("volume rt");
 	else if (!xi.rtdev)
 		rtfile = _("none");
-	if (dbytes && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
+	if (get_conf_val(OPT_D, D_SIZE) &&
+	    xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
 			"maximum is %lld blocks\n"),
 			get_conf_raw(OPT_D, D_SIZE),
 			(long long)DTOBT(xi.dsize));
 		usage();
-	} else if (!dbytes && xi.dsize > 0)
+	} else if (!get_conf_val(OPT_D, D_SIZE) && xi.dsize > 0)
 		dblocks = DTOBT(xi.dsize);
-	else if (!dbytes) {
+	else if (!get_conf_val(OPT_D, D_SIZE)) {
 		fprintf(stderr, _("can't get size of data subvolume\n"));
 		usage();
 	}
@@ -2549,17 +2614,18 @@ _("rmapbt not supported with realtime devices\n"));
 		fprintf(stderr,
 			_("can't have both external and internal logs\n"));
 		usage();
-	} else if (loginternal && sectorsize != lsectorsize) {
+	} else if (loginternal &&
+		   get_conf_val(OPT_D, D_SECTSIZE) != lsectorsize) {
 		fprintf(stderr,
 	_("data and log sector sizes must be equal for internal logs\n"));
 		usage();
 	}
 
-	if (xi.dbsize > sectorsize) {
+	if (xi.dbsize > get_conf_val(OPT_D, D_SECTSIZE)) {
 		fprintf(stderr, _(
-"Warning: the data subvolume sector size %u is less than the sector size \n\
+"Warning: the data subvolume sector size %lld is less than the sector size \n\
 reported by the device (%u).\n"),
-			sectorsize, xi.dbsize);
+			get_conf_val(OPT_D, D_SECTSIZE), xi.dbsize);
 	}
 	if (!loginternal && xi.lbsize > lsectorsize) {
 		fprintf(stderr, _(
@@ -2567,11 +2633,12 @@ reported by the device (%u).\n"),
 reported by the device (%u).\n"),
 			lsectorsize, xi.lbsize);
 	}
-	if (rtbytes && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
+	if (rtbytes && xi.rtsize > 0 &&
+	    xi.rtbsize > get_conf_val(OPT_D, D_SECTSIZE)) {
 		fprintf(stderr, _(
-"Warning: the realtime subvolume sector size %u is less than the sector size\n\
+"Warning: the realtime subvolume sector size %lld is less than the sector size\n\
 reported by the device (%u).\n"),
-			sectorsize, xi.rtbsize);
+			get_conf_val(OPT_D, D_SECTSIZE), xi.rtbsize);
 	}
 
 	if (rtbytes && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
@@ -2590,119 +2657,173 @@ reported by the device (%u).\n"),
 	}
 	if (xi.rtdev) {
 		rtextents = rtblocks / rtextblocks;
-		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY * blocksize);
+		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY *
+						  get_conf_val(OPT_B, B_SIZE));
 	} else {
 		rtextents = rtblocks = 0;
 		nbmblocks = 0;
 	}
 
-	if (!nodsflag) {
-		if (dsunit) {
-			if (ft.dsunit && ft.dsunit != dsunit) {
+	if (!get_conf_val(OPT_D, D_NOALIGN)) {
+		if (get_conf_val(OPT_D, D_SUNIT)) {
+			if (ft.dsunit &&
+			    ft.dsunit != get_conf_val(OPT_D, D_SUNIT)) {
 				fprintf(stderr,
-					_("%s: Specified data stripe unit %d "
+					_("%s: Specified data stripe unit %lld "
 					"is not the same as the volume stripe "
 					"unit %d\n"),
-					progname, dsunit, ft.dsunit);
+					progname,
+					get_conf_val(OPT_D, D_SUNIT),
+					ft.dsunit);
 			}
-			if (ft.dswidth && ft.dswidth != dswidth) {
+			if (ft.dswidth &&
+			    ft.dswidth != get_conf_val(OPT_D, D_SWIDTH)) {
 				fprintf(stderr,
-					_("%s: Specified data stripe width %d "
+					_("%s: Specified data stripe width %lld "
 					"is not the same as the volume stripe "
 					"width %d\n"),
-					progname, dswidth, ft.dswidth);
+					progname,
+					get_conf_val(OPT_D, D_SWIDTH),
+					ft.dswidth);
 			}
 		} else {
-			dsunit = ft.dsunit;
-			dswidth = ft.dswidth;
-			nodsflag = 1;
+			set_conf_val(OPT_D, D_SUNIT, ft.dsunit);
+			set_conf_val(OPT_D, D_SWIDTH, ft.dswidth);
+			set_conf_val(OPT_D, D_NOALIGN, 1);
 		}
-	} /* else dsunit & dswidth can't be set if nodsflag is set */
+	} /* else D_SUNIT & D_SWIDTH can't be set if D_NOALIGN is set */
 
 	if (dasize) {		/* User-specified AG size */
 		/*
-		 * Check specified agsize is a multiple of blocksize.
+		 * Check specified D_AGSIZE is a multiple of B_SIZE.
 		 */
-		if (agsize % blocksize) {
+		if (get_conf_val(OPT_D, D_AGSIZE) %
+		    get_conf_val(OPT_B, B_SIZE)) {
 			fprintf(stderr,
-		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
-				(long long)agsize, blocksize);
+		_("agsize (%lld) not a multiple of fs blk size (%lld)\n"),
+				get_conf_val(OPT_D, D_AGSIZE),
+				get_conf_val(OPT_B, B_SIZE));
 			usage();
 		}
-		agsize /= blocksize;
-		agcount = dblocks / agsize + (dblocks % agsize != 0);
+		set_conf_val(OPT_D, D_AGSIZE,
+			     get_conf_val(OPT_D, D_AGSIZE) /
+			     get_conf_val(OPT_B, B_SIZE));
+		set_conf_val(OPT_D, D_AGCOUNT,
+			     dblocks / get_conf_val(OPT_D, D_AGSIZE) +
+			     (dblocks % get_conf_val(OPT_D, D_AGSIZE) != 0));
 
 	} else if (daflag) {	/* User-specified AG count */
-		agsize = dblocks / agcount + (dblocks % agcount != 0);
+		set_conf_val(OPT_D, D_AGSIZE,
+			     dblocks / get_conf_val(OPT_D, D_AGCOUNT) +
+			     (dblocks % get_conf_val(OPT_D, D_AGCOUNT) != 0));
 	} else {
-		calc_default_ag_geometry(blocklog, dblocks,
-				dsunit | dswidth, &agsize, &agcount);
+		uint64_t agcount = get_conf_val(OPT_D, D_AGCOUNT);
+		uint64_t agsize = get_conf_val(OPT_D, D_AGSIZE);
+
+		calc_default_ag_geometry(get_conf_val(OPT_B, B_LOG),
+					 dblocks, get_conf_val(OPT_D, D_SUNIT)
+					 | get_conf_val(OPT_D, D_SWIDTH),
+					 &agsize, &agcount);
+		set_conf_val(OPT_D, D_AGCOUNT, agcount);
+		set_conf_val(OPT_D, D_AGSIZE, agsize);
 	}
 
 	/*
-	 * If dsunit is a multiple of fs blocksize, then check that is a
-	 * multiple of the agsize too
+	 * If D_SUNIT is a multiple of fs B_SIZE,
+	 * then check that is a multiple of the D_AGSIZE too
 	 */
-	if (dsunit && !(BBTOB(dsunit) % blocksize) &&
-	    dswidth && !(BBTOB(dswidth) % blocksize)) {
-
-		/* convert from 512 byte blocks to fs blocksize */
-		dsunit = DTOBT(dsunit);
-		dswidth = DTOBT(dswidth);
+	if (get_conf_val(OPT_D, D_SUNIT) &&
+	    !(BBTOB(get_conf_val(OPT_D, D_SUNIT)) %
+	      get_conf_val(OPT_B, B_SIZE)) &&
+	    get_conf_val(OPT_D, D_SWIDTH) &&
+	    !(BBTOB(get_conf_val(OPT_D, D_SWIDTH)) %
+	      get_conf_val(OPT_B, B_SIZE))) {
+
+		/* convert from 512 byte blocks to fs B_SIZE
+		 */
+		set_conf_val(OPT_D, D_SUNIT,
+			     DTOBT(get_conf_val(OPT_D, D_SUNIT)));
+		set_conf_val(OPT_D, D_SWIDTH,
+			     DTOBT(get_conf_val(OPT_D, D_SWIDTH)));
 
 		/*
-		 * agsize is not a multiple of dsunit
+		 * D_AGSIZE is not a multiple of D_SUNIT
 		 */
-		if ((agsize % dsunit) != 0) {
+		if ((get_conf_val(OPT_D, D_AGSIZE) %
+		     get_conf_val(OPT_D, D_SUNIT)) != 0) {
 			/*
 			 * Round up to stripe unit boundary. Also make sure
-			 * that agsize is still larger than
-			 * XFS_AG_MIN_BLOCKS(blocklog)
+			 * that D_AGSIZE is still larger than
+			 * XFS_AG_MIN_BLOCKS(get_conf_val(OPT_B, B_LOG))
 		 	 */
-			tmp_agsize = ((agsize + (dsunit - 1))/ dsunit) * dsunit;
+			tmp_agsize = ((get_conf_val(OPT_D, D_AGSIZE) +
+				       (get_conf_val(OPT_D, D_SUNIT) - 1)) /
+				      get_conf_val(OPT_D, D_SUNIT)) *
+				get_conf_val(OPT_D, D_SUNIT);
 			/*
 			 * Round down to stripe unit boundary if rounding up
 			 * created an AG size that is larger than the AG max.
 			 */
-			if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
-				tmp_agsize = ((agsize) / dsunit) * dsunit;
-
-			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(blocklog)) &&
-			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog))) {
-				agsize = tmp_agsize;
+			if (tmp_agsize >
+			    XFS_AG_MAX_BLOCKS(get_conf_val(OPT_B, B_LOG)))
+				tmp_agsize = ((get_conf_val(OPT_D, D_AGSIZE)) /
+					      get_conf_val(OPT_D, D_SUNIT)) *
+					get_conf_val(OPT_D, D_SUNIT);
+
+			if ((tmp_agsize >=
+			     XFS_AG_MIN_BLOCKS(get_conf_val(OPT_B, B_LOG))) &&
+			    (tmp_agsize <=
+			     XFS_AG_MAX_BLOCKS(get_conf_val(OPT_B, B_LOG)))) {
+				set_conf_val(OPT_D, D_AGSIZE, tmp_agsize);
 				if (!daflag)
-					agcount = dblocks/agsize +
-						(dblocks % agsize != 0);
+					set_conf_val(OPT_D, D_AGCOUNT,
+						dblocks /
+						get_conf_val(OPT_D, D_AGSIZE) +
+						(dblocks %
+						 get_conf_val(OPT_D, D_AGSIZE)
+						!= 0));
 				if (dasize)
 					fprintf(stderr,
-				_("agsize rounded to %lld, swidth = %d\n"),
-						(long long)agsize, dswidth);
+				_("agsize rounded to %lld, swidth = %lld\n"),
+						get_conf_val(OPT_D, D_AGSIZE),
+						get_conf_val(OPT_D, D_SWIDTH));
 			} else {
-				if (nodsflag) {
-					dsunit = dswidth = 0;
+				if (get_conf_val(OPT_D, D_NOALIGN)) {
+					set_conf_val(OPT_D, D_SUNIT, 0);
+					set_conf_val(OPT_D, D_SWIDTH, 0);
 				} else {
 					/*
-					 * agsize is out of bounds, this will
+					 * D_AGSIZE is out of bounds, this will
 					 * print nice details & exit.
 					 */
-					validate_ag_geometry(blocklog, dblocks,
-							    agsize, agcount);
+					validate_ag_geometry(
+						get_conf_val(OPT_B, B_LOG),
+						dblocks,
+						get_conf_val(OPT_D, D_AGSIZE),
+						get_conf_val(OPT_D, D_AGCOUNT));
 					exit(1);
 				}
 			}
 		}
-		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
+		if (get_conf_val(OPT_D, D_SWIDTH) &&
+		    ((get_conf_val(OPT_D, D_AGSIZE) %
+		      get_conf_val(OPT_D, D_SWIDTH)) == 0) &&
+		    (get_conf_val(OPT_D, D_AGCOUNT) > 1)) {
 			/* This is a non-optimal configuration because all AGs
 			 * start on the same disk in the stripe.  Changing
 			 * the AG size by one sunit will guarantee that this
 			 * does not happen.
 			 */
-			tmp_agsize = agsize - dsunit;
-			if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
-				tmp_agsize = agsize + dsunit;
-				if (dblocks < agsize) {
+			tmp_agsize = get_conf_val(OPT_D, D_AGSIZE) -
+				get_conf_val(OPT_D, D_SUNIT);
+			if (tmp_agsize <
+			    XFS_AG_MIN_BLOCKS(get_conf_val(OPT_B, B_LOG))) {
+				tmp_agsize = get_conf_val(OPT_D, D_AGSIZE) +
+					get_conf_val(OPT_D, D_SUNIT);
+				if (dblocks < get_conf_val(OPT_D, D_AGSIZE)) {
 					/* oh well, nothing to do */
-					tmp_agsize = agsize;
+					tmp_agsize =
+						get_conf_val(OPT_D, D_AGSIZE);
 				}
 			}
 			if (daflag || dasize) {
@@ -2712,30 +2833,46 @@ problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
 an AG size that is one stripe unit smaller, for example %llu.\n"),
 					(unsigned long long)tmp_agsize);
 			} else {
-				agsize = tmp_agsize;
-				agcount = dblocks/agsize + (dblocks % agsize != 0);
+				set_conf_val(OPT_D, D_AGSIZE, tmp_agsize);
+				set_conf_val(OPT_D, D_AGCOUNT,
+					dblocks/get_conf_val(OPT_D, D_AGSIZE) +
+					     (dblocks %
+					      get_conf_val(OPT_D, D_AGSIZE)
+					      != 0));
 				/*
 				 * If the last AG is too small, reduce the
 				 * filesystem size and drop the blocks.
 				 */
-				if ( dblocks % agsize != 0 &&
-				    (dblocks % agsize <
-				    XFS_AG_MIN_BLOCKS(blocklog))) {
-					dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-					agcount--;
-					ASSERT(agcount != 0);
+				if (dblocks % get_conf_val(OPT_D, D_AGSIZE)
+				    != 0 &&
+				    (dblocks % get_conf_val(OPT_D, D_AGSIZE) <
+				    XFS_AG_MIN_BLOCKS(
+					get_conf_val(OPT_B, B_LOG)))) {
+
+					dblocks = (xfs_rfsblock_t)(
+						(get_conf_val(OPT_D, D_AGCOUNT)
+						 - 1) *
+						get_conf_val(OPT_D, D_AGSIZE));
+					set_conf_val(OPT_D, D_AGCOUNT,
+						get_conf_val(OPT_D, D_AGCOUNT)
+						- 1);
+					ASSERT(get_conf_val(OPT_D, D_AGCOUNT)
+					       != 0);
 				}
 			}
 		}
 	} else {
-		if (nodsflag)
-			dsunit = dswidth = 0;
-		else {
+		if (get_conf_val(OPT_D, D_NOALIGN)) {
+			set_conf_val(OPT_D, D_SWIDTH, 0);
+			set_conf_val(OPT_D, D_SUNIT, 0);
+		} else {
 			fprintf(stderr,
-				_("%s: Stripe unit(%d) or stripe width(%d) is "
-				"not a multiple of the block size(%d)\n"),
-				progname, BBTOB(dsunit), BBTOB(dswidth),
-				blocksize);
+				_("%s: Stripe unit(%lld) or stripe width(%lld) is "
+				"not a multiple of the block size(%lld)\n"),
+				progname,
+				BBTOB(get_conf_val(OPT_D, D_SUNIT)),
+				BBTOB(get_conf_val(OPT_D, D_SWIDTH)),
+				get_conf_val(OPT_B, B_SIZE));
 			exit(1);
 		}
 	}
@@ -2744,53 +2881,69 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * If the last AG is too small, reduce the filesystem size
 	 * and drop the blocks.
 	 */
-	if ( dblocks % agsize != 0 &&
-	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
+	if (dblocks % get_conf_val(OPT_D, D_AGSIZE) != 0 &&
+	     (dblocks % get_conf_val(OPT_D, D_AGSIZE) <
+	      XFS_AG_MIN_BLOCKS(get_conf_val(OPT_B, B_LOG)))) {
 		ASSERT(!daflag);
-		dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-		agcount--;
-		ASSERT(agcount != 0);
+		dblocks = (xfs_rfsblock_t)(
+				(get_conf_val(OPT_D, D_AGCOUNT) - 1) *
+				get_conf_val(OPT_D, D_AGSIZE));
+		set_conf_val(OPT_D, D_AGCOUNT,
+			     get_conf_val(OPT_D, D_AGCOUNT) - 1);
+		ASSERT(get_conf_val(OPT_D, D_AGCOUNT) != 0);
 	}
 
-	validate_ag_geometry(blocklog, dblocks, agsize, agcount);
+	validate_ag_geometry(get_conf_val(OPT_B, B_LOG),
+			     dblocks,
+			     get_conf_val(OPT_D, D_AGSIZE),
+			     get_conf_val(OPT_D, D_AGCOUNT));
 
 	if (!imflag)
-		imaxpct = calc_default_imaxpct(blocklog, dblocks);
+		imaxpct = calc_default_imaxpct(get_conf_val(OPT_B, B_LOG),
+					       dblocks);
 
 	/*
-	 * check that log sunit is modulo fsblksize or default it to dsunit.
+	 * check that log sunit is modulo fsblksize or default it to D_SUNIT.
 	 */
 
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
 		lsunit = DTOBT(lsunit);
-	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
-		/* lsunit and dsunit now in fs blocks */
-		lsunit = dsunit;
+	} else if (sb_feat.log_version == 2 &&
+		   loginternal &&
+		   get_conf_val(OPT_D, D_SUNIT)) {
+		/* lsunit and get_conf_val(OPT_D, D_SUNIT) now in fs blocks */
+		lsunit = get_conf_val(OPT_D, D_SUNIT);
 	}
 
-	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
+	if (sb_feat.log_version == 2 &&
+	    (lsunit * get_conf_val(OPT_B, B_SIZE)) > 256 * 1024) {
 		/* Warn only if specified on commandline */
 		if (lsuflag || lsunitflag) {
 			fprintf(stderr,
-	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
-				(lsunit * blocksize));
+	_("log stripe unit (%lld bytes) is too large (maximum is 256KiB)\n"),
+				(lsunit * get_conf_val(OPT_B, B_SIZE)));
 			fprintf(stderr,
 	_("log stripe unit adjusted to 32KiB\n"));
 		}
-		lsunit = (32 * 1024) >> blocklog;
+		lsunit = (32 * 1024) >> get_conf_val(OPT_B, B_LOG);
 	}
 
-	min_logblocks = max_trans_res(agsize,
+	min_logblocks = max_trans_res(get_conf_val(OPT_D, D_AGSIZE),
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
-				   sectorlog, blocklog, inodelog, dirblocklog,
+				   get_conf_val(OPT_D, D_SECTLOG),
+				   get_conf_val(OPT_B, B_LOG),
+				   inodelog, dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt,
 				   sb_feat.rmapbt, sb_feat.reflink,
 				   sb_feat.inode_align);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logbytes && dblocks >= (1024*1024*1024) >> blocklog)
-		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
+	if (!logbytes &&
+	    dblocks >= (1024*1024*1024) >> get_conf_val(OPT_B, B_LOG))
+		min_logblocks = MAX(min_logblocks,
+				    XFS_MIN_LOG_BYTES >>
+				    get_conf_val(OPT_B, B_LOG));
 	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
@@ -2811,17 +2964,19 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		logblocks = 0;
 	} else if (loginternal && !logbytes) {
 
-		if (dblocks < GIGABYTES(1, blocklog)) {
+		if (dblocks < GIGABYTES(1, get_conf_val(OPT_B, B_LOG))) {
 			/* tiny filesystems get minimum sized logs. */
 			logblocks = min_logblocks;
-		} else if (dblocks < GIGABYTES(16, blocklog)) {
+		} else if (dblocks <
+			   GIGABYTES(16, get_conf_val(OPT_B, B_LOG))) {
 
 			/*
 			 * For small filesystems, we want to use the
 			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
 			 * at all possible, ramping up to 128MB at 256GB.
 			 */
-			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
+			logblocks = MIN(XFS_MIN_LOG_BYTES >>
+					get_conf_val(OPT_B, B_LOG),
 					min_logblocks * XFS_DFL_LOG_FACTOR);
 		} else {
 			/*
@@ -2830,34 +2985,38 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			 * max log size of 128M at 256GB fs size. IOWs,
 			 * the ratio of fs size to log size is 2048:1.
 			 */
-			logblocks = (dblocks << blocklog) / 2048;
-			logblocks = logblocks >> blocklog;
+			logblocks = (dblocks <<
+				     get_conf_val(OPT_B, B_LOG)) / 2048;
+			logblocks = logblocks >> get_conf_val(OPT_B, B_LOG);
 		}
 
 		/* Ensure the chosen size meets minimum log size requirements */
 		logblocks = MAX(min_logblocks, logblocks);
 
 		/* make sure the log fits wholly within an AG */
-		if (logblocks >= agsize)
+		if (logblocks >= get_conf_val(OPT_D, D_AGSIZE))
 			logblocks = min_logblocks;
 
 		/* and now clamp the size to the maximum supported size */
 		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES)
-			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
+		if ((logblocks << get_conf_val(OPT_B, B_LOG)) >
+		    XFS_MAX_LOG_BYTES)
+			logblocks = XFS_MAX_LOG_BYTES >>
+				get_conf_val(OPT_B, B_LOG);
 
 	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
+	validate_log_size(logblocks, get_conf_val(OPT_B, B_LOG), min_logblocks);
 
 	protostring = setup_proto(protofile);
-	bsize = 1 << (blocklog - BBSHIFT);
+	bsize = 1 << (get_conf_val(OPT_B, B_LOG) - BBSHIFT);
 	mp = &mbuf;
 	sbp = &mp->m_sb;
 	memset(mp, 0, sizeof(xfs_mount_t));
-	sbp->sb_blocklog = (__uint8_t)blocklog;
-	sbp->sb_sectlog = (__uint8_t)sectorlog;
-	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)agsize);
-	sbp->sb_agblocks = (xfs_agblock_t)agsize;
+	sbp->sb_blocklog = (__uint8_t)get_conf_val(OPT_B, B_LOG);
+	sbp->sb_sectlog = (__uint8_t)get_conf_val(OPT_D, D_SECTLOG);
+	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup(
+				(unsigned int)get_conf_val(OPT_D, D_AGSIZE));
+	sbp->sb_agblocks = (xfs_agblock_t)get_conf_val(OPT_D, D_AGSIZE);
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
@@ -2865,7 +3024,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * sb_versionnum, finobt and rmapbt flags must be set before we use
 	 * libxfs_prealloc_blocks().
 	 */
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
+	sb_set_features(&mp->m_sb, &sb_feat,
+			get_conf_val(OPT_D, D_SECTSIZE),
+			lsectorsize,
+			get_conf_val(OPT_D, D_SUNIT));
 
 
 	if (loginternal) {
@@ -2878,9 +3040,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 					libxfs_alloc_ag_max_usable(mp));
 
 			/* revalidate the log size is valid if we changed it */
-			validate_log_size(logblocks, blocklog, min_logblocks);
+			validate_log_size(logblocks,
+					  get_conf_val(OPT_B, B_LOG),
+					  min_logblocks);
 		}
-		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
+		if (logblocks > get_conf_val(OPT_D, D_AGSIZE) -
+		    libxfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
 	_("internal log size %lld too large, must fit in allocation group\n"),
 				(long long)logblocks);
@@ -2888,14 +3053,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		}
 
 		if (laflag) {
-			if (logagno >= agcount) {
+			if (logagno >= get_conf_val(OPT_D, D_AGCOUNT)) {
 				fprintf(stderr,
 		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)agcount);
+					logagno,
+					get_conf_val(OPT_D, D_AGCOUNT));
 				usage();
 			}
 		} else
-			logagno = (xfs_agnumber_t)(agcount / 2);
+			logagno = (xfs_agnumber_t)(
+					get_conf_val(OPT_D, D_AGCOUNT) / 2);
 
 		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
 		/*
@@ -2903,45 +3070,53 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 */
 		if (lsunit) {
 			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, lsunit,
-					&logblocks, blocklog, &lalign);
-		} else if (dsunit) {
+					lsflag, logstart,
+					get_conf_val(OPT_D, D_AGSIZE), lsunit,
+					&logblocks,
+					get_conf_val(OPT_B, B_LOG), &lalign);
+		} else if (get_conf_val(OPT_D, D_SUNIT)) {
 			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, dsunit,
-					&logblocks, blocklog, &lalign);
+					lsflag, logstart,
+					get_conf_val(OPT_D, D_AGSIZE),
+					get_conf_val(OPT_D, D_SUNIT),
+					&logblocks,
+					get_conf_val(OPT_B, B_LOG), &lalign);
 		}
 	} else {
 		logstart = 0;
 		if (lsunit)
 			fixup_log_stripe_unit(lsflag, lsunit,
-					&logblocks, blocklog);
+					&logblocks, get_conf_val(OPT_B, B_LOG));
 	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
+	validate_log_size(logblocks, get_conf_val(OPT_B, B_LOG), min_logblocks);
 
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
-		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+		   "         =%-22s sectsz=%-5lld attr=%u, projid32bit=%u\n"
 		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
-		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-		   "         =%-22s sunit=%-6u swidth=%u blks\n"
+		   "data     =%-22s bsize=%-6lld blocks=%llu, imaxpct=%u\n"
+		   "         =%-22s sunit=%-6lld swidth=%lld blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, sb_feat.attr_version,
+			dfile, isize, get_conf_val(OPT_D, D_AGCOUNT),
+			get_conf_val(OPT_D, D_AGSIZE),
+			"", get_conf_val(OPT_D, D_SECTSIZE),
+			sb_feat.attr_version,
 				    !sb_feat.projid16bit,
 			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
 			sb_feat.rmapbt, sb_feat.reflink,
-			"", blocksize, (long long)dblocks, imaxpct,
-			"", dsunit, dswidth,
+			"", get_conf_val(OPT_B, B_SIZE), (long long)dblocks, imaxpct,
+			"", get_conf_val(OPT_D, D_SUNIT),
+			get_conf_val(OPT_D, D_SWIDTH),
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
 				sb_feat.dirftype,
-			logfile, 1 << blocklog, (long long)logblocks,
+			logfile, 1 << get_conf_val(OPT_B, B_LOG), (long long)logblocks,
 			sb_feat.log_version, "", lsectorsize, lsunit,
 				sb_feat.lazy_sb_counters,
-			rtfile, rtextblocks << blocklog,
+			rtfile, rtextblocks << get_conf_val(OPT_B, B_LOG),
 			(long long)rtblocks, (long long)rtextents);
 		if (Nflag)
 			exit(0);
@@ -2950,7 +3125,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	if (label)
 		strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
 	sbp->sb_magicnum = XFS_SB_MAGIC;
-	sbp->sb_blocksize = blocksize;
+	sbp->sb_blocksize = get_conf_val(OPT_B, B_SIZE);
 	sbp->sb_dblocks = dblocks;
 	sbp->sb_rblocks = rtblocks;
 	sbp->sb_rextents = rtextents;
@@ -2960,15 +3135,15 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_logstart = logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
 	sbp->sb_rextsize = rtextblocks;
-	sbp->sb_agcount = (xfs_agnumber_t)agcount;
+	sbp->sb_agcount = (xfs_agnumber_t)get_conf_val(OPT_D, D_AGCOUNT);
 	sbp->sb_rbmblocks = nbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
-	sbp->sb_sectsize = (__uint16_t)sectorsize;
+	sbp->sb_sectsize = (__uint16_t)get_conf_val(OPT_D, D_SECTSIZE);
 	sbp->sb_inodesize = (__uint16_t)isize;
-	sbp->sb_inopblock = (__uint16_t)(blocksize / isize);
-	sbp->sb_sectlog = (__uint8_t)sectorlog;
+	sbp->sb_inopblock = (__uint16_t)(get_conf_val(OPT_B, B_SIZE) / isize);
+	sbp->sb_sectlog = (__uint8_t)get_conf_val(OPT_D, D_SECTLOG);
 	sbp->sb_inodelog = (__uint8_t)inodelog;
-	sbp->sb_inopblog = (__uint8_t)(blocklog - inodelog);
+	sbp->sb_inopblog = (__uint8_t)(get_conf_val(OPT_B, B_LOG) - inodelog);
 	sbp->sb_rextslog =
 		(__uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
@@ -2976,14 +3151,15 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_imax_pct = imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * libxfs_prealloc_blocks(mp) -
+	sbp->sb_fdblocks = dblocks -
+		get_conf_val(OPT_D, D_AGCOUNT) * libxfs_prealloc_blocks(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
-	sbp->sb_unit = dsunit;
-	sbp->sb_width = dswidth;
-	sbp->sb_dirblklog = dirblocklog - blocklog;
+	sbp->sb_unit = get_conf_val(OPT_D, D_SUNIT);
+	sbp->sb_width = get_conf_val(OPT_D, D_SWIDTH);
+	sbp->sb_dirblklog = dirblocklog - get_conf_val(OPT_B, B_LOG);
 	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
 		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
 		sbp->sb_logsunit = lsunit;
@@ -2993,11 +3169,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
 		if (sb_feat.crcs_enabled)
 			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
-		sbp->sb_inoalignmt = cluster_size >> blocklog;
+		sbp->sb_inoalignmt = cluster_size >> get_conf_val(OPT_B, B_LOG);
 		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
-	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
+	if (lsectorsize != BBSIZE ||
+	    get_conf_val(OPT_D, D_SECTSIZE) != BBSIZE) {
 		sbp->sb_logsectlog = (__uint8_t)lsectorlog;
 		sbp->sb_logsectsize = (__uint16_t)lsectorsize;
 	} else {
@@ -3005,7 +3182,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectsize = 0;
 	}
 
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
+	sb_set_features(&mp->m_sb, &sb_feat,
+			get_conf_val(OPT_D, D_SECTSIZE),
+			lsectorsize,
+			get_conf_val(OPT_D, D_SUNIT));
 
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
@@ -3025,7 +3205,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	/* OK, now write the superblock */
 	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
-	memset(XFS_BUF_PTR(buf), 0, sectorsize);
+	memset(XFS_BUF_PTR(buf), 0, get_conf_val(OPT_D, D_SECTSIZE));
 	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	libxfs_purgebuf(buf);
@@ -3035,8 +3215,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * if needed so that the reads for the end of the device in the mount
 	 * code will succeed.
 	 */
-	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * blocksize) {
-		if (ftruncate(xi.dfd, dblocks * blocksize) < 0) {
+	if (xi.disfile &&
+	    xi.dsize * xi.dbsize < dblocks * get_conf_val(OPT_B, B_SIZE)) {
+		if (ftruncate(xi.dfd,
+			     dblocks * get_conf_val(OPT_B, B_SIZE)) < 0) {
 			fprintf(stderr,
 				_("%s: Growing the data section failed\n"),
 				progname);
@@ -3078,7 +3260,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * These initialisations should be pulled into libxfs to keep the
 	 * kernel/userspace header initialisation code the same.
 	 */
-	for (agno = 0; agno < agcount; agno++) {
+	for (agno = 0; agno < get_conf_val(OPT_D, D_AGCOUNT); agno++) {
 		struct xfs_agfl	*agfl;
 		int		bucket;
 		struct xfs_perag *pag = libxfs_perag_get(mp, agno);
@@ -3090,7 +3272,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1));
 		buf->b_ops = &xfs_sb_buf_ops;
-		memset(XFS_BUF_PTR(buf), 0, sectorsize);
+		memset(XFS_BUF_PTR(buf), 0, get_conf_val(OPT_D, D_SECTSIZE));
 		libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
@@ -3102,13 +3284,17 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				XFS_FSS_TO_BB(mp, 1));
 		buf->b_ops = &xfs_agf_buf_ops;
 		agf = XFS_BUF_TO_AGF(buf);
-		memset(agf, 0, sectorsize);
-		if (agno == agcount - 1)
-			agsize = dblocks - (xfs_rfsblock_t)(agno * agsize);
+		memset(agf, 0, get_conf_val(OPT_D, D_SECTSIZE));
+		if (agno == get_conf_val(OPT_D, D_AGCOUNT) - 1)
+			set_conf_val(OPT_D, D_AGSIZE,
+				dblocks -
+				(xfs_rfsblock_t)(agno *
+					get_conf_val(OPT_D, D_AGSIZE)));
+
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 		agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 		agf->agf_seqno = cpu_to_be32(agno);
-		agf->agf_length = cpu_to_be32(agsize);
+		agf->agf_length = cpu_to_be32(get_conf_val(OPT_D, D_AGSIZE));
 		agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
 		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
@@ -3130,7 +3316,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - libxfs_prealloc_blocks(mp));
+		nbmblocks = (xfs_extlen_t)(get_conf_val(OPT_D, D_AGSIZE) -
+					   libxfs_prealloc_blocks(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -3138,7 +3325,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		if (loginternal && agno == logagno) {
 			be32_add_cpu(&agf->agf_freeblks, -logblocks);
-			agf->agf_longest = cpu_to_be32(agsize -
+			agf->agf_longest =
+				cpu_to_be32(get_conf_val(OPT_D, D_AGSIZE) -
 				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
 		}
 		if (libxfs_alloc_min_freelist(mp, pag) > worst_freelist)
@@ -3154,7 +3342,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		buf->b_ops = &xfs_agfl_buf_ops;
 		agfl = XFS_BUF_TO_AGFL(buf);
 		/* setting to 0xff results in initialisation to NULLAGBLOCK */
-		memset(agfl, 0xff, sectorsize);
+		memset(agfl, 0xff, get_conf_val(OPT_D, D_SECTSIZE));
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 			agfl->agfl_seqno = cpu_to_be32(agno);
@@ -3173,11 +3361,13 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				XFS_FSS_TO_BB(mp, 1));
 		agi = XFS_BUF_TO_AGI(buf);
 		buf->b_ops = &xfs_agi_buf_ops;
-		memset(agi, 0, sectorsize);
+		memset(agi, 0, get_conf_val(OPT_D, D_SECTSIZE));
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
 		agi->agi_seqno = cpu_to_be32(agno);
-		agi->agi_length = cpu_to_be32((xfs_agblock_t)agsize);
+		agi->agi_length =
+			cpu_to_be32(
+				(xfs_agblock_t)get_conf_val(OPT_D, D_AGSIZE));
 		agi->agi_count = 0;
 		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
 		agi->agi_level = cpu_to_be32(1);
@@ -3202,7 +3392,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				bsize);
 		buf->b_ops = &xfs_allocbt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
+		memset(block, 0, get_conf_val(OPT_B, B_SIZE));
 		libxfs_btree_init_block(mp, buf, XFS_BTNUM_BNO, 0, 1, agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
@@ -3237,7 +3427,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * so, reset the record count to 0 to avoid exposure of an invalid
 		 * record start block.
 		 */
-		arec->ar_blockcount = cpu_to_be32(agsize -
+		arec->ar_blockcount =
+			cpu_to_be32(get_conf_val(OPT_D, D_AGSIZE) -
 					be32_to_cpu(arec->ar_startblock));
 		if (!arec->ar_blockcount)
 			block->bb_numrecs = 0;
@@ -3252,7 +3443,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				bsize);
 		buf->b_ops = &xfs_allocbt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
+		memset(block, 0, get_conf_val(OPT_B, B_SIZE));
 		libxfs_btree_init_block(mp, buf, XFS_BTNUM_CNT, 0, 1, agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
@@ -3277,7 +3468,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * so, reset the record count to 0 to avoid exposure of an invalid
 		 * record start block.
 		 */
-		arec->ar_blockcount = cpu_to_be32(agsize -
+		arec->ar_blockcount =
+			cpu_to_be32(get_conf_val(OPT_D, D_AGSIZE) -
 					be32_to_cpu(arec->ar_startblock));
 		if (!arec->ar_blockcount)
 			block->bb_numrecs = 0;
@@ -3295,7 +3487,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			buf->b_ops = &xfs_refcountbt_buf_ops;
 
 			block = XFS_BUF_TO_BLOCK(buf);
-			memset(block, 0, blocksize);
+			memset(block, 0, get_conf_val(OPT_B, B_SIZE));
 			libxfs_btree_init_block(mp, buf, XFS_BTNUM_REFC, 0,
 						0, agno, 0);
 
@@ -3310,7 +3502,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				bsize);
 		buf->b_ops = &xfs_inobt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
+		memset(block, 0, get_conf_val(OPT_B, B_SIZE));
 		libxfs_btree_init_block(mp, buf, XFS_BTNUM_INO, 0, 0, agno, 0);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
@@ -3323,7 +3515,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 					bsize);
 			buf->b_ops = &xfs_inobt_buf_ops;
 			block = XFS_BUF_TO_BLOCK(buf);
-			memset(block, 0, blocksize);
+			memset(block, 0, get_conf_val(OPT_B, B_SIZE));
 			libxfs_btree_init_block(mp, buf, XFS_BTNUM_FINO, 0, 0, agno, 0);
 			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 		}
@@ -3337,7 +3529,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				bsize);
 			buf->b_ops = &xfs_rmapbt_buf_ops;
 			block = XFS_BUF_TO_BLOCK(buf);
-			memset(block, 0, blocksize);
+			memset(block, 0, get_conf_val(OPT_B, B_SIZE));
 
 			libxfs_btree_init_block(mp, buf, XFS_BTNUM_RMAP, 0, 0, agno, 0);
 
@@ -3413,7 +3605,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 */
 	buf = libxfs_getbuf(mp->m_ddev_targp,
 		(xfs_daddr_t)XFS_FSB_TO_BB(mp, dblocks - 1LL), bsize);
-	memset(XFS_BUF_PTR(buf), 0, blocksize);
+	memset(XFS_BUF_PTR(buf), 0, get_conf_val(OPT_B, B_SIZE));
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 	/*
@@ -3422,14 +3614,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	if (mp->m_rtdev_targp->dev && rtblocks > 0) {
 		buf = libxfs_getbuf(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, rtblocks - 1LL), bsize);
-		memset(XFS_BUF_PTR(buf), 0, blocksize);
+		memset(XFS_BUF_PTR(buf), 0, get_conf_val(OPT_B, B_SIZE));
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	}
 
 	/*
 	 * BNO, CNT free block list
 	 */
-	for (agno = 0; agno < agcount; agno++) {
+	for (agno = 0; agno < get_conf_val(OPT_D, D_AGCOUNT); agno++) {
 		xfs_alloc_arg_t	args;
 		xfs_trans_t	*tp;
 		struct xfs_trans_res tres = {0};
-- 
2.11.0

