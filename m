Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:15320 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751050AbdHUGwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 02:52:49 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1djgZm-0006YV-QX
        for linux-xfs@vger.kernel.org; Mon, 21 Aug 2017 16:52:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1djgZm-00083v-Na
        for linux-xfs@vger.kernel.org; Mon, 21 Aug 2017 16:52:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC, v2] mkfs.xfs: factor the crap out of input parsing
Date: Mon, 21 Aug 2017 16:52:42 +1000
Message-Id: <20170821065242.30953-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The mkfs.xfs code base is a mess. I started factoring it years ago, and
the primary goal I had for that work was to make mkfs.xfs
maintainable and lay a solid foundation for being able to modify it
in future.

This patch takes up where that work stalled at - factoring the crap
out of the input parsing and parameter validation. To do this I
hacked together a quick global "cli geometry" structure that holds
the handful of values that can be set from the CLI, and pushed all
the other feature flag things into the existing sb_feat global
structure.

I then factored the sub options parsing loop using a table setup
with to call a suboption specific parser function that does the
table based option parsing. This gets *all* the suboption parsing
out of the main option parsing loop which is soooo much simpler:


                case 'b':
                case 'd':
                case 'i':
                case 'l':
                case 'm':
                case 'n':
                case 'r':
                case 's':
                        parse_subopts(c, optarg);
                        break;

Having done that, I started on the mess that followed the option
parsing loop and started separating that out into functions that
validate and set a clear set of parameters that the mkfs code then
later uses. Hence we end up with code like this in the main
function.

        /*
         * Extract as much of the valid config as we can from the CLI input
         * before opening the libxfs devices.
         */
        validate_blocksize(&blocksize, &blocklog);
        validate_sectorsize(&sectorsize, &sectorlog, &ft, dfile, Nflag,
                            force_overwrite);
        validate_log_sectorsize(&lsectorsize, &lsectorlog,
                                sectorsize, sectorlog);
        validate_sb_features();

        validate_dirblocksize(&dirblocksize, &dirblocklog, blocklog);
        validate_inodesize(&isize, &inodelog, &inopblock, blocklog);

This has greatly reduced the spaghetti code and removed all the
duplicated checks and strangely dissociated nature of all teh
validation and calculations. The stripe unit validation is now all
in one function, instead of strewn across 5 disjoint hunks that
had some amount of duplicated functionality. Same goes for device
checks, calculating AG sizes, etc.

As such, it's far, far easier to see what the overall structure of
mkfs is doing now. The factoring of all the input validation and
format calculations results in the high level code in then main()
function documenting the steps we are taking quite clearly.

It also points out that we have a /lot/ of parameters that we
calculate and pass around within these functions, indicating this is
the next area of abstraction and simplification. This also points
out that we can separate the mkfs functionality clearly into three
parts: input parsing, validation and format calculations, and
finally creating the on-disk structures.

The patch as it stands has been smoke tested, but I have not checked
that the on-disk layout for every possible option is being correctly
handled. It passes xfs/191-mkfs-input-validation with the exception
of 2 cases try to set the sector size on an internal log, which this
patch disallows.

The next steps are to:

	- replace the hacking struct cligeo with a key-value
	  structure for input parameter storage to abstract input
	  parsing from validation and calculation

	- extend the key-value structure for holding superblock
	  feature defaults to holding all default parameter values
	  to be used when no values are provided by input parsing

	- clean up the validation and calculation code to use the
	  abstracted input and default structures

	- have the calculation code output into a single output
	  structure which we can then pass to the on-disk layout
	  code.

	- add a key-value config file interface to override the
	  build in default values structure members, hence allowing
	  distros to ship different default configs without needing
	  to change the source code.

	- split it all up into reviewable pieces.


Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |    2 +-
 mkfs/xfs_mkfs.c  | 2710 ++++++++++++++++++++++++++++++------------------------
 2 files changed, 1509 insertions(+), 1203 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index e5e152378c2c..b77819b1adcc 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -95,7 +95,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 /*
  * Argument structure for libxfs_init().
  */
-typedef struct {
+typedef struct libxfs_xinit {
 				/* input parameters */
 	char            *volname;       /* pathname of volume */
 	char            *dname;         /* pathname of data "subvolume" */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7bb6408f9b77..4819295d9a2f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -24,11 +24,11 @@
 /*
  * Prototypes for internal functions.
  */
-static void conflict(char opt, char *tab[], int oldidx, int newidx);
+static void conflict(char opt, const char *tab[], int oldidx, int newidx);
 static void illegal(const char *value, const char *opt);
 static __attribute__((noreturn)) void usage (void);
-static __attribute__((noreturn)) void reqval(char opt, char *tab[], int idx);
-static void respec(char opt, char *tab[], int idx);
+static __attribute__((noreturn)) void reqval(char opt, const char *tab[], int idx);
+static void respec(char opt, const char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
@@ -428,6 +428,8 @@ struct opt_params lopts = {
 		{ .index = L_INTERNAL,
 		  .conflicts = { L_FILE,
 				 L_DEV,
+				 L_SECTLOG,
+				 L_SECTSIZE,
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
@@ -469,6 +471,7 @@ struct opt_params lopts = {
 		},
 		{ .index = L_SECTLOG,
 		  .conflicts = { L_SECTSIZE,
+				 L_INTERNAL,
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
@@ -476,6 +479,7 @@ struct opt_params lopts = {
 		},
 		{ .index = L_SECTSIZE,
 		  .conflicts = { L_SECTLOG,
+				 L_INTERNAL,
 				 LAST_CONFLICT },
 		  .convert = true,
 		  .is_power_2 = true,
@@ -711,6 +715,8 @@ struct opt_params mopts = {
 
 /*
  * Use this macro before we have superblock and mount structure
+ *
+ * XXX: macros with undeclared variables are the spawn of a hateful deity
  */
 #define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (blocklog - BBSHIFT)))
 
@@ -729,74 +735,6 @@ struct opt_params mopts = {
  */
 #define WHACK_SIZE (128 * 1024)
 
-/*
- * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
- */
-static void
-calc_stripe_factors(
-	int		dsu,
-	int		dsw,
-	int		dsectsz,
-	int		lsu,
-	int		lsectsz,
-	int		*dsunit,
-	int		*dswidth,
-	int		*lsunit)
-{
-	/* Handle data sunit/swidth options */
-	if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
-		fprintf(stderr,
-			_("both data sunit and data swidth options "
-			"must be specified\n"));
-		usage();
-	}
-
-	if (dsu || dsw) {
-		if ((dsu && !dsw) || (!dsu && dsw)) {
-			fprintf(stderr,
-				_("both data su and data sw options "
-				"must be specified\n"));
-			usage();
-		}
-
-		if (dsu % dsectsz) {
-			fprintf(stderr,
-				_("data su must be a multiple of the "
-				"sector size (%d)\n"), dsectsz);
-			usage();
-		}
-
-		*dsunit  = (int)BTOBBT(dsu);
-		*dswidth = *dsunit * dsw;
-	}
-
-	if (*dsunit && (*dswidth % *dsunit != 0)) {
-		fprintf(stderr,
-			_("data stripe width (%d) must be a multiple of the "
-			"data stripe unit (%d)\n"), *dswidth, *dsunit);
-		usage();
-	}
-
-	/* Handle log sunit options */
-
-	if (lsu)
-		*lsunit = (int)BTOBBT(lsu);
-
-	/* verify if lsu/lsunit is a multiple block size */
-	if (lsu % blocksize != 0) {
-		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-		lsu, blocksize);
-		exit(1);
-	}
-	if ((BBTOB(*lsunit) % blocksize != 0)) {
-		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-		BBTOB(*lsunit), blocksize);
-		exit(1);
-	}
-}
-
 static void
 check_device_type(
 	const char	*name,
@@ -871,91 +809,6 @@ check_device_type(
 	usage();
 }
 
-static void
-fixup_log_stripe_unit(
-	int		lsflag,
-	int		sunit,
-	xfs_rfsblock_t	*logblocks,
-	int		blocklog)
-{
-	uint64_t	tmp_logblocks;
-
-	/*
-	 * Make sure that the log size is a multiple of the stripe unit
-	 */
-	if ((*logblocks % sunit) != 0) {
-		if (!lsflag) {
-			tmp_logblocks = ((*logblocks + (sunit - 1))
-						/ sunit) * sunit;
-			/*
-			 * If the log is too large, round down
-			 * instead of round up
-			 */
-			if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
-			    ((tmp_logblocks << blocklog) > XFS_MAX_LOG_BYTES)) {
-				tmp_logblocks = (*logblocks / sunit) * sunit;
-			}
-			*logblocks = tmp_logblocks;
-		} else {
-			fprintf(stderr, _("log size %lld is not a multiple "
-					  "of the log stripe unit %d\n"),
-				(long long) *logblocks, sunit);
-			usage();
-		}
-	}
-}
-
-static xfs_fsblock_t
-fixup_internal_log_stripe(
-	xfs_mount_t	*mp,
-	int		lsflag,
-	xfs_fsblock_t	logstart,
-	uint64_t	agsize,
-	int		sunit,
-	xfs_rfsblock_t	*logblocks,
-	int		blocklog,
-	int		*lalign)
-{
-	if ((logstart % sunit) != 0) {
-		logstart = ((logstart + (sunit - 1))/sunit) * sunit;
-		*lalign = 1;
-	}
-
-	fixup_log_stripe_unit(lsflag, sunit, logblocks, blocklog);
-
-	if (*logblocks > agsize - XFS_FSB_TO_AGBNO(mp, logstart)) {
-		fprintf(stderr,
-			_("Due to stripe alignment, the internal log size "
-			"(%lld) is too large.\n"), (long long) *logblocks);
-		fprintf(stderr, _("Must fit within an allocation group.\n"));
-		usage();
-	}
-	return logstart;
-}
-
-void
-validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
-{
-	if (logblocks < min_logblocks) {
-		fprintf(stderr,
-	_("log size %lld blocks too small, minimum size is %d blocks\n"),
-			(long long)logblocks, min_logblocks);
-		usage();
-	}
-	if (logblocks > XFS_MAX_LOG_BLOCKS) {
-		fprintf(stderr,
-	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
-			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
-		usage();
-	}
-	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
-		fprintf(stderr,
-	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
-			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
-		usage();
-	}
-}
-
 static int
 calc_default_imaxpct(
 	int		blocklog,
@@ -1054,7 +907,7 @@ validate_ag_geometry(
 
 static void
 zero_old_xfs_structures(
-	libxfs_init_t		*xi,
+	struct libxfs_xinit	*xi,
 	xfs_sb_t		*new_sb)
 {
 	void 			*buf;
@@ -1161,6 +1014,31 @@ struct sb_feat_args {
 	bool	parent_pointers;
 	bool	rmapbt;
 	bool	reflink;
+	bool	nodalign;
+	bool	nortalign;
+	uuid_t	m_uuid;
+};
+
+/*
+ * Default values for superblock features
+ */
+struct sb_feat_args	sb_feat = {
+	.finobt = 1,
+	.spinodes = 0,
+	.log_version = 2,
+	.attr_version = 2,
+	.dir_version = XFS_DFL_DIR_VERSION,
+	.inode_align = XFS_IFLAG_ALIGN,
+	.nci = false,
+	.lazy_sb_counters = true,
+	.projid16bit = false,
+	.crcs_enabled = true,
+	.dirftype = true,
+	.parent_pointers = false,
+	.rmapbt = false,
+	.reflink = false,
+	.nodalign = false,
+	.nortalign = false,
 };
 
 static void
@@ -1283,7 +1161,7 @@ check_opt(
 		fprintf(stderr,
 	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
 			sp->index, index);
-		reqval(opts->name, (char **)opts->subopts, index);
+		reqval(opts->name, opts->subopts, index);
 	}
 
 	/*
@@ -1296,11 +1174,11 @@ check_opt(
 	 */
 	if (!str_seen) {
 		if (sp->seen)
-			respec(opts->name, (char **)opts->subopts, index);
+			respec(opts->name, opts->subopts, index);
 		sp->seen = true;
 	} else {
 		if (sp->str_seen)
-			respec(opts->name, (char **)opts->subopts, index);
+			respec(opts->name, opts->subopts, index);
 		sp->str_seen = true;
 	}
 
@@ -1312,7 +1190,7 @@ check_opt(
 			break;
 		if (opts->subopt_params[conflict_opt].seen ||
 		    opts->subopt_params[conflict_opt].str_seen)
-			conflict(opts->name, (char **)opts->subopts,
+			conflict(opts->name, opts->subopts,
 				 conflict_opt, index);
 	}
 }
@@ -1330,7 +1208,7 @@ getnum(
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
-			reqval(opts->name, (char **)opts->subopts, index);
+			reqval(opts->name, opts->subopts, index);
 		return sp->defaultval;
 	}
 
@@ -1386,615 +1264,493 @@ getstr(
 
 	/* empty strings for string options are not valid */
 	if (!str || *str == '\0')
-		reqval(opts->name, (char **)opts->subopts, index);
+		reqval(opts->name, opts->subopts, index);
 	return str;
 }
 
-int
-main(
-	int			argc,
-	char			**argv)
+/* geometry specified on input. 0 is not specified */
+struct cli_geometry {
+	int	sectorsize;
+	int	blocksize;
+	char	*dsize;
+	int64_t	agsize;
+	int	agcount;
+	int	dsunit;
+	int	dswidth;
+	int	dsu;
+	int	dsw;
+	int	inodesize;
+	int	inopblock;
+	int	imaxpct;
+	int	dirblocksize;
+	int	logagno;
+	char	*logsize;
+	int	lsectorsize;
+	int	loginternal;
+	int	lsu;
+	int	lsunit;
+	char	*rtextsize;
+	char	*rtsize;
+
+} cligeo;
+
+/* root inode characteristics */
+struct fsxattr		fsx;
+
+/* libxfs file/device setup info */
+struct libxfs_xinit	xi;
+
+static int
+block_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
 {
-	uint64_t		agcount;
-	xfs_agf_t		*agf;
-	xfs_agi_t		*agi;
-	xfs_agnumber_t		agno;
-	uint64_t		agsize;
-	xfs_alloc_rec_t		*arec;
-	struct xfs_btree_block	*block;
-	int			blflag;
 	int			blocklog;
-	int			bsflag;
-	int			bsize;
-	xfs_buf_t		*buf;
-	int			c;
-	int			daflag;
-	int			dasize;
-	xfs_rfsblock_t		dblocks;
-	char			*dfile;
-	int			dirblocklog;
-	int			dirblocksize;
-	char			*dsize;
-	int			dsu;
-	int			dsw;
-	int			dsunit;
-	int			dswidth;
-	int			dsflag;
-	int			force_overwrite;
-	struct fsxattr		fsx;
-	int			ilflag;
-	int			imaxpct;
-	int			imflag;
-	int			inodelog;
-	int			inopblock;
-	int			ipflag;
-	int			isflag;
-	int			isize;
-	char			*label = NULL;
-	int			laflag;
-	int			lalign;
-	int			ldflag;
-	int			liflag;
-	xfs_agnumber_t		logagno;
-	xfs_rfsblock_t		logblocks;
-	char			*logfile;
-	int			loginternal;
-	char			*logsize;
-	xfs_fsblock_t		logstart;
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
-	xfs_mount_t		*mp;
-	xfs_mount_t		mbuf;
-	xfs_extlen_t		nbmblocks;
-	int			nlflag;
-	int			nodsflag;
-	int			norsflag;
-	xfs_alloc_rec_t		*nrec;
-	int			nsflag;
-	int			nvflag;
-	int			Nflag;
-	int			discard = 1;
-	char			*p;
-	char			*protofile;
-	char			*protostring;
-	int			qflag;
-	xfs_rfsblock_t		rtblocks;
-	xfs_extlen_t		rtextblocks;
-	xfs_rtblock_t		rtextents;
-	char			*rtextsize;
-	char			*rtfile;
-	char			*rtsize;
-	xfs_sb_t		*sbp;
-	int			sectorlog;
-	uint64_t		sector_mask;
-	int			slflag;
-	int			ssflag;
-	uint64_t		tmp_agsize;
-	uuid_t			uuid;
-	int			worst_freelist;
-	libxfs_init_t		xi;
-	struct fs_topology	ft;
-	struct sb_feat_args	sb_feat = {
-		.finobt = 1,
-		.spinodes = 0,
-		.log_version = 2,
-		.attr_version = 2,
-		.dir_version = XFS_DFL_DIR_VERSION,
-		.inode_align = XFS_IFLAG_ALIGN,
-		.nci = false,
-		.lazy_sb_counters = true,
-		.projid16bit = false,
-		.crcs_enabled = true,
-		.dirftype = true,
-		.parent_pointers = false,
-		.rmapbt = false,
-		.reflink = false,
-	};
-
-	platform_uuid_generate(&uuid);
-	progname = basename(argv[0]);
-	setlocale(LC_ALL, "");
-	bindtextdomain(PACKAGE, LOCALEDIR);
-	textdomain(PACKAGE);
 
-	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
-	blocklog = blocksize = 0;
-	sectorlog = lsectorlog = 0;
-	sectorsize = lsectorsize = 0;
-	agsize = daflag = dasize = dblocks = 0;
-	ilflag = imflag = ipflag = isflag = 0;
-	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
-	loginternal = 1;
-	logagno = logblocks = rtblocks = rtextblocks = 0;
-	Nflag = nlflag = nsflag = nvflag = 0;
-	dirblocklog = dirblocksize = 0;
-	qflag = 0;
-	imaxpct = inodelog = inopblock = isize = 0;
-	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
-	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
-	dsflag = nodsflag = norsflag = 0;
-	force_overwrite = 0;
-	worst_freelist = 0;
-	memset(&fsx, 0, sizeof(fsx));
-
-	memset(&xi, 0, sizeof(xi));
-	xi.isdirect = LIBXFS_DIRECT;
-	xi.isreadonly = LIBXFS_EXCLUSIVELY;
-
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
-		switch (c) {
-		case 'C':
-		case 'f':
-			force_overwrite = 1;
-			break;
-		case 'b':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)bopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case B_LOG:
-					blocklog = getnum(value, &bopts, B_LOG);
-					blocksize = 1 << blocklog;
-					blflag = 1;
-					break;
-				case B_SIZE:
-					blocksize = getnum(value, &bopts,
-							   B_SIZE);
-					blocklog = libxfs_highbit32(blocksize);
-					bsflag = 1;
-					break;
-				default:
-					unknown('b', value);
-				}
-			}
-			break;
-		case 'd':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)dopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case D_AGCOUNT:
-					agcount = getnum(value, &dopts,
-							 D_AGCOUNT);
-					daflag = 1;
-					break;
-				case D_AGSIZE:
-					agsize = getnum(value, &dopts, D_AGSIZE);
-					dasize = 1;
-					break;
-				case D_FILE:
-					xi.disfile = getnum(value, &dopts,
-							    D_FILE);
-					break;
-				case D_NAME:
-					xi.dname = getstr(value, &dopts, D_NAME);
-					break;
-				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
-					break;
-				case D_SUNIT:
-					dsunit = getnum(value, &dopts, D_SUNIT);
-					dsflag = 1;
-					break;
-				case D_SWIDTH:
-					dswidth = getnum(value, &dopts,
-							 D_SWIDTH);
-					dsflag = 1;
-					break;
-				case D_SU:
-					dsu = getnum(value, &dopts, D_SU);
-					dsflag = 1;
-					break;
-				case D_SW:
-					dsw = getnum(value, &dopts, D_SW);
-					dsflag = 1;
-					break;
-				case D_NOALIGN:
-					nodsflag = getnum(value, &dopts,
-								D_NOALIGN);
-					break;
-				case D_SECTLOG:
-					sectorlog = getnum(value, &dopts,
-							   D_SECTLOG);
-					sectorsize = 1 << sectorlog;
-					slflag = 1;
-					break;
-				case D_SECTSIZE:
-					sectorsize = getnum(value, &dopts,
-							    D_SECTSIZE);
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					ssflag = 1;
-					break;
-				case D_RTINHERIT:
-					c = getnum(value, &dopts, D_RTINHERIT);
-					if (c)
-						fsx.fsx_xflags |=
-							XFS_DIFLAG_RTINHERIT;
-					break;
-				case D_PROJINHERIT:
-					fsx.fsx_projid = getnum(value, &dopts,
-								D_PROJINHERIT);
-					fsx.fsx_xflags |=
-						XFS_DIFLAG_PROJINHERIT;
-					break;
-				case D_EXTSZINHERIT:
-					fsx.fsx_extsize = getnum(value, &dopts,
-								 D_EXTSZINHERIT);
-					fsx.fsx_xflags |=
-						XFS_DIFLAG_EXTSZINHERIT;
-					break;
-				default:
-					unknown('d', value);
-				}
-			}
-			break;
-		case 'i':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)iopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case I_ALIGN:
-					sb_feat.inode_align = getnum(value,
-								&iopts, I_ALIGN);
-					break;
-				case I_LOG:
-					inodelog = getnum(value, &iopts, I_LOG);
-					isize = 1 << inodelog;
-					ilflag = 1;
-					break;
-				case I_MAXPCT:
-					imaxpct = getnum(value, &iopts,
-							 I_MAXPCT);
-					imflag = 1;
-					break;
-				case I_PERBLOCK:
-					inopblock = getnum(value, &iopts,
-							   I_PERBLOCK);
-					ipflag = 1;
-					break;
-				case I_SIZE:
-					isize = getnum(value, &iopts, I_SIZE);
-					inodelog = libxfs_highbit32(isize);
-					isflag = 1;
-					break;
-				case I_ATTR:
-					sb_feat.attr_version =
-						getnum(value, &iopts, I_ATTR);
-					break;
-				case I_PROJID32BIT:
-					sb_feat.projid16bit =
-						!getnum(value, &iopts,
-							I_PROJID32BIT);
-					break;
-				case I_SPINODES:
-					sb_feat.spinodes = getnum(value,
-							&iopts, I_SPINODES);
-					break;
-				default:
-					unknown('i', value);
-				}
-			}
-			break;
-		case 'l':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)lopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case L_AGNUM:
-					logagno = getnum(value, &lopts, L_AGNUM);
-					laflag = 1;
-					break;
-				case L_FILE:
-					xi.lisfile = getnum(value, &lopts,
-							    L_FILE);
-					break;
-				case L_INTERNAL:
-					loginternal = getnum(value, &lopts,
-							     L_INTERNAL);
-					liflag = 1;
-					break;
-				case L_SU:
-					lsu = getnum(value, &lopts, L_SU);
-					lsuflag = 1;
-					break;
-				case L_SUNIT:
-					lsunit = getnum(value, &lopts, L_SUNIT);
-					lsunitflag = 1;
-					break;
-				case L_NAME:
-				case L_DEV:
-					logfile = getstr(value, &lopts, L_NAME);
-					xi.logname = logfile;
-					ldflag = 1;
-					loginternal = 0;
-					break;
-				case L_VERSION:
-					sb_feat.log_version =
-						getnum(value, &lopts, L_VERSION);
-					lvflag = 1;
-					break;
-				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
-					break;
-				case L_SECTLOG:
-					lsectorlog = getnum(value, &lopts,
-							    L_SECTLOG);
-					lsectorsize = 1 << lsectorlog;
-					lslflag = 1;
-					break;
-				case L_SECTSIZE:
-					lsectorsize = getnum(value, &lopts,
-							     L_SECTSIZE);
-					lsectorlog =
-						libxfs_highbit32(lsectorsize);
-					lssflag = 1;
-					break;
-				case L_LAZYSBCNTR:
-					sb_feat.lazy_sb_counters =
-							getnum(value, &lopts,
-							       L_LAZYSBCNTR);
-					break;
-				default:
-					unknown('l', value);
-				}
-			}
-			break;
-		case 'L':
-			if (strlen(optarg) > sizeof(sbp->sb_fname))
-				illegal(optarg, "L");
-			label = optarg;
-			break;
-		case 'm':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)mopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case M_CRC:
-					sb_feat.crcs_enabled =
-						getnum(value, &mopts, M_CRC);
-					if (sb_feat.crcs_enabled)
-						sb_feat.dirftype = true;
-					break;
-				case M_FINOBT:
-					sb_feat.finobt = getnum(
-						value, &mopts, M_FINOBT);
-					break;
-				case M_UUID:
-					if (!value || *value == '\0')
-						reqval('m', subopts, M_UUID);
-					if (platform_uuid_parse(value, &uuid))
-						illegal(optarg, "m uuid");
-					break;
-				case M_RMAPBT:
-					sb_feat.rmapbt = getnum(
-						value, &mopts, M_RMAPBT);
-					break;
-				case M_REFLINK:
-					sb_feat.reflink = getnum(
-						value, &mopts, M_REFLINK);
-					break;
-				default:
-					unknown('m', value);
-				}
-			}
-			break;
-		case 'n':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)nopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case N_LOG:
-					dirblocklog = getnum(value, &nopts,
-							     N_LOG);
-					dirblocksize = 1 << dirblocklog;
-					nlflag = 1;
-					break;
-				case N_SIZE:
-					dirblocksize = getnum(value, &nopts,
-							      N_SIZE);
-					dirblocklog =
-						libxfs_highbit32(dirblocksize);
-					nsflag = 1;
-					break;
-				case N_VERSION:
-					value = getstr(value, &nopts, N_VERSION);
-					if (!strcasecmp(value, "ci")) {
-						/* ASCII CI mode */
-						sb_feat.nci = true;
-					} else {
-						sb_feat.dir_version =
-							getnum(value, &nopts,
-							       N_VERSION);
-					}
-					nvflag = 1;
-					break;
-				case N_FTYPE:
-					sb_feat.dirftype = getnum(value, &nopts,
-								  N_FTYPE);
-					break;
-				default:
-					unknown('n', value);
-				}
-			}
-			break;
-		case 'N':
-			Nflag = 1;
-			break;
-		case 'K':
-			discard = 0;
-			break;
-		case 'p':
-			if (protofile)
-				respec('p', NULL, 0);
-			protofile = optarg;
-			break;
-		case 'q':
-			qflag = 1;
-			break;
-		case 'r':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)ropts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
-					break;
-				case R_FILE:
-					xi.risfile = getnum(value, &ropts,
-							    R_FILE);
-					break;
-				case R_NAME:
-				case R_DEV:
-					xi.rtname = getstr(value, &ropts,
-							   R_NAME);
-					break;
-				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
-					break;
-				case R_NOALIGN:
-					norsflag = getnum(value, &ropts,
-								R_NOALIGN);
-					break;
-				default:
-					unknown('r', value);
-				}
-			}
-			break;
-		case 's':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)sopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case S_LOG:
-				case S_SECTLOG:
-					if (lssflag)
-						conflict('s', subopts,
-							 S_SECTSIZE, S_SECTLOG);
-					sectorlog = getnum(value, &sopts,
-							   S_SECTLOG);
-					lsectorlog = sectorlog;
-					sectorsize = 1 << sectorlog;
-					lsectorsize = sectorsize;
-					lslflag = slflag = 1;
-					break;
-				case S_SIZE:
-				case S_SECTSIZE:
-					if (lslflag)
-						conflict('s', subopts, S_SECTLOG,
-							 S_SECTSIZE);
-					sectorsize = getnum(value, &sopts,
-							    S_SECTSIZE);
-					lsectorsize = sectorsize;
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					lsectorlog = sectorlog;
-					lssflag = ssflag = 1;
-					break;
-				default:
-					unknown('s', value);
-				}
-			}
-			break;
-		case 'V':
-			printf(_("%s version %s\n"), progname, VERSION);
-			exit(0);
-		case '?':
-			unknown(optopt, "");
-		}
+	switch (subopt) {
+	case B_LOG:
+		blocklog = getnum(value, &bopts, B_LOG);
+		cligeo.blocksize = 1 << blocklog;
+		break;
+	case B_SIZE:
+		cligeo.blocksize = getnum(value, &bopts, B_SIZE);
+		break;
+	default:
+		return -EINVAL;
 	}
-	if (argc - optind > 1) {
-		fprintf(stderr, _("extra arguments\n"));
-		usage();
-	} else if (argc - optind == 1) {
-		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
-	} else
-		dfile = xi.dname;
 
 	/*
-	 * Blocksize and sectorsize first, other things depend on them
-	 * For RAID4/5/6 we want to align sector size and block size,
-	 * so we need to start with the device geometry extraction too.
+	 * XXX: Hack: update global block size field so other number conversion
+	 * works. Should convert all the remaining fields that relay on
+	 * block/sector sizes in specifications to the two phase getstr/getnum
+	 * process already used for D_SIZE and others.
 	 */
-	if (!blflag && !bsflag) {
-		blocklog = XFS_DFL_BLOCKSIZE_LOG;
-		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
-	}
-	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
-		fprintf(stderr, _("illegal block size %d\n"), blocksize);
-		usage();
-	}
-	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
-		fprintf(stderr,
-_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
-			XFS_MIN_CRC_BLOCKSIZE);
-		usage();
-	}
-	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
-		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
-		usage();
-	}
+	blocksize = cligeo.blocksize;
+	return 0;
+}
 
-	if (!slflag && !ssflag) {
-		sectorlog = XFS_MIN_SECTORSIZE_LOG;
-		sectorsize = XFS_MIN_SECTORSIZE;
-	}
-	if (!lslflag && !lssflag) {
-		lsectorlog = sectorlog;
-		lsectorsize = sectorsize;
+static int
+data_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	int			sectorlog;
+
+	switch (subopt) {
+	case D_AGCOUNT:
+		cligeo.agcount = getnum(value, opts, D_AGCOUNT);
+		break;
+	case D_AGSIZE:
+		cligeo.agsize = getnum(value, opts, D_AGSIZE);
+		break;
+	case D_FILE:
+		xi.disfile = getnum(value, opts, D_FILE);
+		break;
+	case D_NAME:
+		xi.dname = getstr(value, opts, D_NAME);
+		break;
+	case D_SIZE:
+		cligeo.dsize = getstr(value, opts, D_SIZE);
+		break;
+	case D_SUNIT:
+		cligeo.dsunit = getnum(value, opts, D_SUNIT);
+		break;
+	case D_SWIDTH:
+		cligeo.dswidth = getnum(value, opts, D_SWIDTH);
+		break;
+	case D_SU:
+		cligeo.dsu = getnum(value, opts, D_SU);
+		break;
+	case D_SW:
+		cligeo.dsw = getnum(value, opts, D_SW);
+		break;
+	case D_NOALIGN:
+		sb_feat.nodalign = getnum(value, opts, D_NOALIGN);
+		break;
+	case D_SECTLOG:
+		if (cligeo.sectorsize)
+			conflict('d', opts->subopts, D_SECTSIZE, D_SECTLOG);
+		sectorlog = getnum(value, opts, D_SECTLOG);
+		cligeo.sectorsize = 1 << sectorlog;
+		/* XXX: Hack, see S_SECTLOG */
+		sectorsize = cligeo.sectorsize;
+		break;
+	case D_SECTSIZE:
+		cligeo.sectorsize = getnum(value, opts, D_SECTSIZE);
+		/* XXX: Hack, see S_SECTSIZE */
+		sectorsize = cligeo.sectorsize;
+		break;
+	case D_RTINHERIT:
+		if (getnum(value, opts, D_RTINHERIT))
+			fsx.fsx_xflags |= XFS_DIFLAG_RTINHERIT;
+		break;
+	case D_PROJINHERIT:
+		fsx.fsx_projid = getnum(value, opts, D_PROJINHERIT);
+		fsx.fsx_xflags |= XFS_DIFLAG_PROJINHERIT;
+		break;
+	case D_EXTSZINHERIT:
+		fsx.fsx_extsize = getnum(value, opts, D_EXTSZINHERIT);
+		fsx.fsx_xflags |= XFS_DIFLAG_EXTSZINHERIT;
+		break;
+	default:
+		return -EINVAL;
 	}
+	return 0;
+}
 
-	/*
-	 * Before anything else, verify that we are correctly operating on
-	 * files or block devices and set the control parameters correctly.
-	 * Explicitly disable direct IO for image files so we don't error out on
-	 * sector size mismatches between the new filesystem and the underlying
-	 * host filesystem.
+static int
+inode_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	int			inodelog;
+
+	switch (subopt) {
+	case I_ALIGN:
+		sb_feat.inode_align = getnum(value, &iopts, I_ALIGN);
+		break;
+	case I_LOG:
+		inodelog = getnum(value, &iopts, I_LOG);
+		cligeo.inodesize = 1 << inodelog;
+		break;
+	case I_MAXPCT:
+		cligeo.imaxpct = getnum(value, &iopts, I_MAXPCT);
+		break;
+	case I_PERBLOCK:
+		cligeo.inopblock = getnum(value, &iopts, I_PERBLOCK);
+		break;
+	case I_SIZE:
+		cligeo.inodesize = getnum(value, &iopts, I_SIZE);
+		break;
+	case I_ATTR:
+		sb_feat.attr_version = getnum(value, &iopts, I_ATTR);
+		break;
+	case I_PROJID32BIT:
+		sb_feat.projid16bit = !getnum(value, &iopts, I_PROJID32BIT);
+		break;
+	case I_SPINODES:
+		sb_feat.spinodes = getnum(value, &iopts, I_SPINODES);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+log_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	int			lsectorlog;
+
+	switch (subopt) {
+	case L_AGNUM:
+		cligeo.logagno = getnum(value, &lopts, L_AGNUM);
+		break;
+	case L_FILE:
+		xi.lisfile = getnum(value, &lopts, L_FILE);
+		break;
+	case L_INTERNAL:
+		cligeo.loginternal = getnum(value, &lopts, L_INTERNAL);
+		break;
+	case L_SU:
+		cligeo.lsu = getnum(value, &lopts, L_SU);
+		break;
+	case L_SUNIT:
+		cligeo.lsunit = getnum(value, &lopts, L_SUNIT);
+		break;
+	case L_NAME:
+	case L_DEV:
+		xi.logname = getstr(value, &lopts, L_NAME);
+		cligeo.loginternal = 0;
+		break;
+	case L_VERSION:
+		sb_feat.log_version = getnum(value, &lopts, L_VERSION);
+		break;
+	case L_SIZE:
+		cligeo.logsize = getstr(value, &lopts, L_SIZE);
+		break;
+	case L_SECTLOG:
+		lsectorlog = getnum(value, &lopts, L_SECTLOG);
+		cligeo.lsectorsize = 1 << lsectorlog;
+		break;
+	case L_SECTSIZE:
+		cligeo.lsectorsize = getnum(value, &lopts, L_SECTSIZE);
+		break;
+	case L_LAZYSBCNTR:
+		sb_feat.lazy_sb_counters = getnum(value, &lopts, L_LAZYSBCNTR);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+meta_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	switch (subopt) {
+	case M_CRC:
+		sb_feat.crcs_enabled = getnum(value, &mopts, M_CRC);
+		if (sb_feat.crcs_enabled)
+			sb_feat.dirftype = true;
+		break;
+	case M_FINOBT:
+		sb_feat.finobt = getnum(value, &mopts, M_FINOBT);
+		break;
+	case M_UUID:
+		if (!value || *value == '\0')
+			reqval('m', opts->subopts, M_UUID);
+		if (platform_uuid_parse(value, &sb_feat.m_uuid))
+			illegal(value, "m uuid");
+		break;
+	case M_RMAPBT:
+		sb_feat.rmapbt = getnum(value, &mopts, M_RMAPBT);
+		break;
+	case M_REFLINK:
+		sb_feat.reflink = getnum(value, &mopts, M_REFLINK);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+naming_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	int			dirblocklog;
+
+	switch (subopt) {
+	case N_LOG:
+		dirblocklog = getnum(value, opts, N_LOG);
+		cligeo.dirblocksize = 1 << dirblocklog;
+		break;
+	case N_SIZE:
+		cligeo.dirblocksize = getnum(value, opts, N_SIZE);
+		break;
+	case N_VERSION:
+		value = getstr(value, &nopts, N_VERSION);
+		if (!strcasecmp(value, "ci")) {
+			/* ASCII CI mode */
+			sb_feat.nci = true;
+		} else {
+			sb_feat.dir_version = getnum(value, opts, N_VERSION);
+		}
+		break;
+	case N_FTYPE:
+		sb_feat.dirftype = getnum(value, opts, N_FTYPE);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+rtdev_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	switch (subopt) {
+	case R_EXTSIZE:
+		cligeo.rtextsize = getstr(value, &ropts, R_EXTSIZE);
+		break;
+	case R_FILE:
+		xi.risfile = getnum(value, &ropts, R_FILE);
+		break;
+	case R_NAME:
+	case R_DEV:
+		xi.rtname = getstr(value, &ropts, R_NAME);
+		break;
+	case R_SIZE:
+		cligeo.rtsize = getstr(value, &ropts, R_SIZE);
+		break;
+	case R_NOALIGN:
+		sb_feat.nortalign = getnum(value, &ropts, R_NOALIGN);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+sector_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	int			sectorlog;
+
+	switch (subopt) {
+	case S_LOG:
+	case S_SECTLOG:
+		if (cligeo.sectorsize)
+			conflict('s', opts->subopts, S_SECTSIZE, S_SECTLOG);
+		sectorlog = getnum(value, &sopts, S_SECTLOG);
+		cligeo.sectorsize = 1 << sectorlog;
+		cligeo.lsectorsize = cligeo.sectorsize;
+		break;
+	case S_SIZE:
+	case S_SECTSIZE:
+		if (cligeo.sectorsize)
+			conflict('s', opts->subopts, S_SECTLOG, S_SECTSIZE);
+		cligeo.sectorsize = getnum(value, &sopts, S_SECTSIZE);
+		cligeo.lsectorsize = cligeo.sectorsize;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * XXX: Hack: update global sector size field so other number conversion
+	 * works. Should convert all the remaining fields that relay on
+	 * block/sector sizes in specifications to the two phase getstr/getnum
+	 * process already used for D_SIZE and others.
+	 */
+	sectorsize = cligeo.sectorsize;
+	return 0;
+}
+
+struct subopts {
+	char		opt;
+	struct opt_params *opts;
+	int		(*parser)();
+} subopt_tab[] = {
+	{ 'b', &bopts, block_opts_parser },
+	{ 'd', &dopts, data_opts_parser },
+	{ 'i', &iopts, inode_opts_parser },
+	{ 'l', &lopts, log_opts_parser },
+	{ 'm', &mopts, meta_opts_parser },
+	{ 'n', &nopts, naming_opts_parser },
+	{ 'r', &ropts, rtdev_opts_parser },
+	{ 's', &sopts, sector_opts_parser },
+	{ '\0', NULL, NULL },
+};
+
+static void
+parse_subopts(
+	char		opt,
+	char		*arg)
+{
+	struct subopts	*sop = &subopt_tab[0];
+	char		*p;
+	int		ret = 0;
+
+	while (sop->opts) {
+		if (sop->opt == opt)
+			break;
+		sop++;
+	}
+
+	/* should never happen */
+	if (!sop->opts)
+		return;
+
+	p = arg;
+	while (*p != '\0') {
+		char	**subopts = (char **)sop->opts->subopts;
+		char	*value;
+		int	subopt;
+
+		subopt = getsubopt(&p, subopts, &value);
+
+		ret = (sop->parser)(sop->opts, subopt, value);
+		if (ret)
+			unknown(opt, value);
+	}
+}
+
+static void
+validate_blocksize(
+	unsigned int	*size,
+	int		*size_log)
+{
+
+	/*
+	 * Blocksize and sectorsize first, other things depend on them
+	 * For RAID4/5/6 we want to align sector size and block size,
+	 * so we need to start with the device geometry extraction too.
+	 */
+	if (!cligeo.blocksize) {
+		*size_log = XFS_DFL_BLOCKSIZE_LOG;
+		*size = 1 << XFS_DFL_BLOCKSIZE_LOG;
+	} else {
+		*size = cligeo.blocksize;
+		*size_log = libxfs_highbit32(cligeo.blocksize);
+	}
+
+	/* validate block sizes are in range */
+	if (*size < XFS_MIN_BLOCKSIZE || *size > XFS_MAX_BLOCKSIZE) {
+		fprintf(stderr, _("illegal block size %d\n"), *size);
+		usage();
+	}
+	if (sb_feat.crcs_enabled && *size < XFS_MIN_CRC_BLOCKSIZE) {
+		fprintf(stderr,
+_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
+			XFS_MIN_CRC_BLOCKSIZE);
+		usage();
+	}
+}
+
+static void
+validate_sectorsize(
+	unsigned int	*size,
+	int		*size_log,
+	struct fs_topology *ft,
+	char		*dfile,
+	int		dry_run,
+	int		force_overwrite)
+{
+	/* set configured sector sizes in preparation for checks */
+	if (!cligeo.sectorsize) {
+		*size_log = XFS_MIN_SECTORSIZE_LOG;
+		*size = XFS_MIN_SECTORSIZE;
+	} else {
+		*size = cligeo.sectorsize;
+		*size_log = libxfs_highbit32(cligeo.sectorsize);
+	}
+
+	/*
+	 * Before anything else, verify that we are correctly operating on
+	 * files or block devices and set the control parameters correctly.
 	 */
-	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
-			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
-	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
-				  Nflag ? NULL : &xi.lcreat,
+	check_device_type(dfile, &xi.disfile, !cligeo.dsize, !dfile,
+			  dry_run ? NULL : &xi.dcreat, force_overwrite, "d");
+	if (!cligeo.loginternal)
+		check_device_type(xi.logname, &xi.lisfile, !cligeo.logsize,
+				  !xi.logname, dry_run ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
-				  Nflag ? NULL : &xi.rcreat,
+		check_device_type(xi.rtname, &xi.risfile, !cligeo.rtsize,
+				  !xi.rtname, dry_run ? NULL : &xi.rcreat,
 				  force_overwrite, "r");
+
+	/*
+	 * Explicitly disable direct IO for image files so we don't error out on
+	 * sector size mismatches between the new filesystem and the underlying
+	 * host filesystem.
+	 */
 	if (xi.disfile || xi.lisfile || xi.risfile)
 		xi.isdirect = 0;
 
-	memset(&ft, 0, sizeof(ft));
-	get_topology(&xi, &ft, force_overwrite);
+	memset(ft, 0, sizeof(*ft));
+	get_topology(&xi, ft, force_overwrite);
 
-	if (!ssflag) {
+	if (!cligeo.sectorsize) {
 		/*
 		 * Unless specified manually on the command line use the
 		 * advertised sector size of the device.  We use the physical
@@ -2004,56 +1760,100 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		 */
 
 		/* Older kernels may not have physical/logical distinction */
-		if (!ft.psectorsize)
-			ft.psectorsize = ft.lsectorsize;
+		if (!ft->psectorsize)
+			ft->psectorsize = ft->lsectorsize;
 
-		sectorsize = ft.psectorsize ? ft.psectorsize :
+		*size = ft->psectorsize ? ft->psectorsize :
 					      XFS_MIN_SECTORSIZE;
 
-		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
+		if ((blocksize < *size) && (blocksize >= ft->lsectorsize)) {
 			fprintf(stderr,
 _("specified blocksize %d is less than device physical sector size %d\n"),
-				blocksize, ft.psectorsize);
+				blocksize, ft->psectorsize);
 			fprintf(stderr,
 _("switching to logical sector size %d\n"),
-				ft.lsectorsize);
-			sectorsize = ft.lsectorsize ? ft.lsectorsize :
+				ft->lsectorsize);
+			*size = ft->lsectorsize ? ft->lsectorsize :
 						      XFS_MIN_SECTORSIZE;
 		}
-	}
 
-	if (!ssflag) {
-		sectorlog = libxfs_highbit32(sectorsize);
-		if (loginternal) {
-			lsectorsize = sectorsize;
-			lsectorlog = sectorlog;
-		}
+		*size_log = libxfs_highbit32(*size);
 	}
 
-	if (sectorsize < XFS_MIN_SECTORSIZE ||
-	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		if (ssflag)
-			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
+	/* validate specified/probed sector size */
+	if (*size < XFS_MIN_SECTORSIZE ||
+	    *size > XFS_MAX_SECTORSIZE || *size > blocksize) {
+		if (cligeo.sectorsize)
+			fprintf(stderr, _("illegal sector size %d\n"), *size);
 		else
 			fprintf(stderr,
 _("block size %d cannot be smaller than logical sector size %d\n"),
-				blocksize, ft.lsectorsize);
+				blocksize, ft->lsectorsize);
 		usage();
 	}
-	if (sectorsize < ft.lsectorsize) {
+	if (*size < ft->lsectorsize) {
 		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
-			sectorsize, ft.lsectorsize);
+			*size, ft->lsectorsize);
+		usage();
+	}
+}
+
+/*
+ * Grab log sector size and validate.
+ *
+ * XXX: probe sector size on external log device rather than using ssize?
+ */
+static void
+validate_log_sectorsize(
+	int	*lsize,
+	int	*lsize_log,
+	int	sectorsize,
+	int	sectorlog)
+{
+
+	if (cligeo.loginternal && cligeo.lsectorsize &&
+	    cligeo.lsectorsize != sectorsize) {
+		fprintf(stderr, _("Can't change sector size on internal log!\n"));
 		usage();
 	}
-	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
-		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
+	if (!cligeo.lsectorsize) {
+		*lsize_log = sectorlog;
+		*lsize = sectorsize;
+	} else {
+		*lsize = cligeo.lsectorsize;
+		*lsize_log = libxfs_highbit32(cligeo.lsectorsize);
+	}
+
+	if (*lsize < XFS_MIN_SECTORSIZE ||
+	    *lsize > XFS_MAX_SECTORSIZE || *lsize > blocksize) {
+		fprintf(stderr, _("illegal log sector size %d\n"), *lsize);
 		usage();
-	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
-		lsu = blocksize;
+	}
+	if (*lsize > XFS_MIN_SECTORSIZE) {
+		if (sb_feat.log_version < 2) {
+			/* user specified non-default log version */
+			fprintf(stderr,
+_("Version 1 logs do not support sector size %d\n"),
+				*lsize);
+			usage();
+		}
+		if (cligeo.lsu <= 0 && cligeo.lsunit <= 0)
+			cligeo.lsu = blocksize;
+	}
+
+	/* if lsu or lsunit was specified, automatically use v2 logs */
+	if ((cligeo.lsu || cligeo.lsunit) && sb_feat.log_version == 1) {
+		fprintf(stderr,
+			_("log stripe unit specified, using v2 logs\n"));
 		sb_feat.log_version = 2;
 	}
 
+}
+
+static void
+validate_sb_features(void)
+{
+
 	/*
 	 * Now we have blocks and sector sizes set up, check parameters that are
 	 * no longer optional for CRC enabled filesystems.  Catch them up front
@@ -2061,7 +1861,8 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 */
 	if (sb_feat.crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		if (cligeo.inodesize &&
+		    cligeo.inodesize < (1 << XFS_DINODE_DFL_CRC_LOG)) {
 			fprintf(stderr,
 _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2103,6 +1904,14 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			usage();
 		}
+
+		/* ftype always on */
+		if (!sb_feat.dirftype) {
+			fprintf(stderr,
+_("Directory ftype field always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+
 	} else {
 		/*
 		 * The kernel doesn't currently support crc=0,finobt=1
@@ -2149,103 +1958,137 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 		sb_feat.rmapbt = false;
 	}
+}
 
-	if (nsflag || nlflag) {
-		if (dirblocksize < blocksize ||
-					dirblocksize > XFS_MAX_BLOCKSIZE) {
-			fprintf(stderr, _("illegal directory block size %d\n"),
-				dirblocksize);
-			usage();
-		}
-	} else {
+static void
+validate_dirblocksize(
+	int	*size,
+	int	*size_log,
+	int	blocklog)
+{
+
+	if (cligeo.dirblocksize &&
+	    (cligeo.dirblocksize < blocksize ||
+	     cligeo.dirblocksize > XFS_MAX_BLOCKSIZE)) {
+		fprintf(stderr, _("illegal directory block size %d\n"),
+			cligeo.dirblocksize);
+		usage();
+	}
+
+	if (!cligeo.dirblocksize) {
 		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
-			dirblocklog = XFS_MIN_REC_DIRSIZE;
+			*size_log = XFS_MIN_REC_DIRSIZE;
 		else
-			dirblocklog = blocklog;
-		dirblocksize = 1 << dirblocklog;
+			*size_log = blocklog;
+		*size = 1 << *size_log;
+	} else {
+		*size = cligeo.dirblocksize;
+		*size_log = libxfs_highbit32(cligeo.dirblocksize);
 	}
+}
 
+static void
+validate_inodesize(
+	int	*size,
+	int	*size_log,
+	int	*inodes_per_block,
+	int	blocklog)
+{
 
-	if (dsize) {
-		uint64_t dbytes;
-
-		dbytes = getnum(dsize, &dopts, D_SIZE);
-		if (dbytes % XFS_MIN_BLOCKSIZE) {
-			fprintf(stderr,
-			_("illegal data length %lld, not a multiple of %d\n"),
-				(long long)dbytes, XFS_MIN_BLOCKSIZE);
-			usage();
-		}
-		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
-		if (dbytes % blocksize)
-			fprintf(stderr, _("warning: "
-	"data length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)dbytes, blocksize,
-				(long long)(dblocks << blocklog));
-	}
-	if (ipflag) {
-		inodelog = blocklog - libxfs_highbit32(inopblock);
-		isize = 1 << inodelog;
-	} else if (!ilflag && !isflag) {
-		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
+	if (cligeo.inopblock) {
+		*inodes_per_block = cligeo.inopblock;
+		*size_log = blocklog - libxfs_highbit32(cligeo.inopblock);
+		*size = 1 << *size_log;
+	} else if (cligeo.inodesize) {
+		*size = cligeo.inodesize;
+		*size_log = libxfs_highbit32(*size);
+		*inodes_per_block = blocksize / *size;
+	} else {
+		*size_log = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
 						: XFS_DINODE_DFL_LOG;
-		isize = 1 << inodelog;
+		*size = 1 << *size_log;
+		*inodes_per_block = blocksize / *size;
 	}
-	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+	if (sb_feat.crcs_enabled && *size_log < XFS_DINODE_DFL_CRC_LOG) {
 		fprintf(stderr,
 		_("Minimum inode size for CRCs is %d bytes\n"),
 			1 << XFS_DINODE_DFL_CRC_LOG);
 		usage();
 	}
 
-	if (logsize) {
-		uint64_t logbytes;
+	if (*size > blocksize / XFS_MIN_INODE_PERBLOCK ||
+	    *inodes_per_block < XFS_MIN_INODE_PERBLOCK ||
+	    *size < XFS_DINODE_MIN_SIZE ||
+	    *size > XFS_DINODE_MAX_SIZE) {
+		int	maxsz;
 
-		logbytes = getnum(logsize, &lopts, L_SIZE);
-		if (logbytes % XFS_MIN_BLOCKSIZE) {
+		fprintf(stderr, _("illegal inode size %d\n"), *size);
+		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
+			    XFS_DINODE_MAX_SIZE);
+		if (XFS_DINODE_MIN_SIZE == maxsz)
 			fprintf(stderr,
-			_("illegal log length %lld, not a multiple of %d\n"),
-				(long long)logbytes, XFS_MIN_BLOCKSIZE);
-			usage();
-		}
-		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
-		if (logbytes % blocksize)
+			_("allowable inode size with %d byte blocks is %d\n"),
+				blocksize, XFS_DINODE_MIN_SIZE);
+		else
 			fprintf(stderr,
-	_("warning: log length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)logbytes, blocksize,
-				(long long)(logblocks << blocklog));
+	_("allowable inode size with %d byte blocks is between %d and %d\n"),
+				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
+		exit(1);
 	}
-	if (rtsize) {
-		uint64_t rtbytes;
+}
 
-		rtbytes = getnum(rtsize, &ropts, R_SIZE);
-		if (rtbytes % XFS_MIN_BLOCKSIZE) {
-			fprintf(stderr,
-			_("illegal rt length %lld, not a multiple of %d\n"),
-				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
-			usage();
-		}
-		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
-		if (rtbytes % blocksize)
-			fprintf(stderr,
-	_("warning: rt length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)rtbytes, blocksize,
-				(long long)(rtblocks << blocklog));
+static xfs_rfsblock_t
+calc_dev_size(
+	char		*size,
+	struct opt_params *opts,
+	int		sizeopt,
+	int		blocklog,
+	char		*type)
+{
+	uint64_t	 dbytes;
+	xfs_rfsblock_t	dblocks;
+
+	if (!size)
+		return 0;
+
+	dbytes = getnum(size, opts, sizeopt);
+	if (dbytes % XFS_MIN_BLOCKSIZE) {
+		fprintf(stderr,
+		_("illegal %s length %lld, not a multiple of %d\n"),
+			type, (long long)dbytes, XFS_MIN_BLOCKSIZE);
+		usage();
+	}
+	dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
+	if (dbytes % blocksize) {
+		fprintf(stderr,
+_("warning: %s length %lld not a multiple of %d, truncated to %lld\n"),
+			type, (long long)dbytes, blocksize,
+			(long long)(dblocks << blocklog));
 	}
+	return dblocks;
+}
+
+static void
+validate_rtextsize(
+	xfs_extlen_t		*blocks,
+	struct fs_topology	*ft,
+	int			blocklog)
+{
+	uint64_t		rtextbytes;
+
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
-	if (rtextsize) {
-		uint64_t rtextbytes;
+	if (cligeo.rtextsize) {
 
-		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
+		rtextbytes = getnum(cligeo.rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
 				(long long)rtextbytes, blocksize);
 			usage();
 		}
-		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
+		*blocks = (xfs_extlen_t)(rtextbytes >> blocklog);
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2253,73 +2096,202 @@ _("rmapbt not supported with realtime devices\n"));
 		 * to the stripe width.
 		 */
 		uint64_t	rswidth;
-		uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
-			rswidth = ft.rtswidth;
+		if (!sb_feat.nortalign && !xi.risfile &&
+		    !(!cligeo.rtsize && xi.disfile))
+			rswidth = ft->rtswidth;
 		else
 			rswidth = 0;
 
 		/* check that rswidth is a multiple of fs blocksize */
-		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
+		if (!sb_feat.nortalign && rswidth &&
+		    !(BBTOB(rswidth) % blocksize)) {
 			rswidth = DTOBT(rswidth);
 			rtextbytes = rswidth << blocklog;
 			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
 			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
-				rtextblocks = rswidth;
+				*blocks = rswidth;
 			}
 		}
-		if (!rtextblocks) {
-			rtextblocks = (blocksize < XFS_MIN_RTEXTSIZE) ?
+		if (!*blocks) {
+			*blocks = (blocksize < XFS_MIN_RTEXTSIZE) ?
 					XFS_MIN_RTEXTSIZE >> blocklog : 1;
 		}
 	}
-	ASSERT(rtextblocks);
+	ASSERT(*blocks);
+}
 
-	/*
-	 * Check some argument sizes against mins, maxes.
-	 */
-	if (isize > blocksize / XFS_MIN_INODE_PERBLOCK ||
-	    isize < XFS_DINODE_MIN_SIZE ||
-	    isize > XFS_DINODE_MAX_SIZE) {
-		int	maxsz;
+/*
+ * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
+ */
+static void
+calc_stripe_factors(
+	struct fs_topology *ft,
+	int		blocklog,
+	int		dsectsz,
+	int		lsectsz,
+	int		*dsunit,
+	int		*dswidth,
+	int		*lsunit)
+{
+	int		dsu;
+	int		dsw;
+	int		lsu;
+	bool		use_dev = false;
 
-		fprintf(stderr, _("illegal inode size %d\n"), isize);
-		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
-			    XFS_DINODE_MAX_SIZE);
-		if (XFS_DINODE_MIN_SIZE == maxsz)
-			fprintf(stderr,
-			_("allowable inode size with %d byte blocks is %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE);
-		else
-			fprintf(stderr,
-	_("allowable inode size with %d byte blocks is between %d and %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
-		exit(1);
+	*dsunit = cligeo.dsunit == -1 ? 0 : cligeo.dsunit;
+	*dswidth = cligeo.dswidth == -1 ? 0 : cligeo.dswidth;
+	*lsunit = cligeo.lsunit == -1 ? 0 : cligeo.lsunit;
+
+	dsu = cligeo.dsu == -1 ? 0 : cligeo.dsu;
+	dsw = cligeo.dsw == -1 ? 0 : cligeo.dsw;
+	lsu = cligeo.lsu == -1 ? 0 : cligeo.lsu;
+
+
+	/* Process log sunit options first */
+	if (lsu)
+		*lsunit = (int)BTOBBT(lsu);
+
+	/* verify if lsu/lsunit is a multiple block size */
+	if (lsu % blocksize != 0) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+			lsu, blocksize);
+		usage();
+	}
+	if ((BBTOB(*lsunit) % blocksize != 0)) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+			BBTOB(*lsunit), blocksize);
+		usage();
 	}
 
-	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && sb_feat.log_version == 1) {
+
+	/* data sunit/swidth options */
+	if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
 		fprintf(stderr,
-			_("log stripe unit specified, using v2 logs\n"));
-		sb_feat.log_version = 2;
+_("both data sunit and data swidth options must be specified\n"));
+		usage();
 	}
 
-	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
-				&dsunit, &dswidth, &lsunit);
+	if (dsu || dsw) {
+		if ((dsu && !dsw) || (!dsu && dsw)) {
+			fprintf(stderr,
+_("both data su and data sw options must be specified\n"));
+			usage();
+		}
+
+		if (dsu % dsectsz) {
+			fprintf(stderr,
+_("data su must be a multiple of the sector size (%d)\n"), dsectsz);
+			usage();
+		}
+
+		*dsunit  = (int)BTOBBT(dsu);
+		*dswidth = *dsunit * dsw;
+	}
+
+	if (*dsunit && (*dswidth % *dsunit != 0)) {
+		fprintf(stderr,
+_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
+			*dswidth, *dsunit);
+		usage();
+	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
-	if (dsflag && !dsunit && !dswidth)
-		nodsflag = 1;
+	if ((cligeo.dsunit != -1 || cligeo.dsu != -1) && !*dsunit && !*dswidth)
+		sb_feat.nodalign = true;
+
+	/* if we are not using alignment, don't apply device defaults */
+	if (sb_feat.nodalign)
+		goto check_lsunit;
+
+	/* if no stripe config set, use the device default */
+	if (!*dsunit) {
+		*dsunit = ft->dsunit;
+		*dswidth = ft->dswidth;
+		use_dev = true;
+	} else {
+		/* check and warn is alignment is sub-optimal */
+		if (ft->dsunit && ft->dsunit != *dsunit) {
+			fprintf(stderr,
+_("%s: Specified data stripe unit %d is not the same as the volume stripe unit %d\n"),
+				progname, *dsunit, ft->dsunit);
+		}
+		if (ft->dswidth && ft->dswidth != *dswidth) {
+			fprintf(stderr,
+_("%s: Specified data stripe width %d is not the same as the volume stripe width %d\n"),
+				progname, *dswidth, ft->dswidth);
+		}
+	}
+
+	/*
+	 * now we have our stripe config, check it's a multiple of block
+	 * size.
+	 */
+	if ((BBTOB(*dsunit) % blocksize) || (BBTOB(*dswidth) % blocksize)) {
+		/*
+		 * If we are using device defaults, just clear them and we're
+		 * good to go. Otherwise bail out with an error.
+		 */
+		if (use_dev) {
+			*dsunit = 0;
+			*dswidth = 0;
+			sb_feat.nodalign = true;
+		} else {
+			fprintf(stderr,
+_("%s: Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%d)\n"),
+				progname, BBTOB(*dsunit), BBTOB(*dswidth),
+				blocksize);
+			exit(1);
+		}
+	}
+
+	/* convert from 512 byte blocks to fs blocksize */
+	*dsunit = DTOBT(*dsunit);
+	*dswidth = DTOBT(*dswidth);
+
+	/*
+	 * check that log sunit is modulo fsblksize or default it to dsunit.
+	 */
+check_lsunit:
+	if (*lsunit) {
+		/* convert from 512 byte blocks to fs blocks */
+		*lsunit = DTOBT(*lsunit);
+	} else if (sb_feat.log_version == 2 && cligeo.loginternal && *dsunit) {
+		/* lsunit and dsunit now in fs blocks */
+		*lsunit = *dsunit;
+	}
+
+	if (sb_feat.log_version == 2 && (*lsunit * blocksize) > 256 * 1024) {
+		/* Warn only if specified on commandline */
+		if (cligeo.lsunit != -1) {
+			fprintf(stderr,
+_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
+  "log stripe unit adjusted to 32KiB\n"),
+				(*lsunit * blocksize));
+		}
+		*lsunit = (32 * 1024) / blocksize;
+	}
+
+}
 
-	xi.setblksize = sectorsize;
+static void
+open_devices(
+	struct libxfs_xinit	*xi,
+	int			sectorlog,
+	int			lsectorlog,
+	bool			discard)
+{
+	uint64_t		sector_mask;
 
 	/*
 	 * Initialize.  This will open the log and rt devices as well.
 	 */
-	if (!libxfs_init(&xi))
+	xi->setblksize = sectorsize;
+	if (!libxfs_init(xi))
 		usage();
-	if (!xi.ddev) {
+	if (!xi->ddev) {
 		fprintf(stderr, _("no device name given in argument list\n"));
 		usage();
 	}
@@ -2334,328 +2306,481 @@ _("rmapbt not supported with realtime devices\n"));
 	 * So, we reduce the size (in basic blocks) to a perfect
 	 * multiple of the sector size, or 1024, whichever is larger.
 	 */
-
 	sector_mask = (uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
-	xi.dsize &= sector_mask;
-	xi.rtsize &= sector_mask;
-	xi.logBBsize &= (uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
+	xi->dsize &= sector_mask;
+	xi->rtsize &= sector_mask;
+	xi->logBBsize &= (uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
 
 
 	/* don't do discards on print-only runs or on files */
-	if (discard && !Nflag) {
-		if (!xi.disfile)
-			discard_blocks(xi.ddev, xi.dsize);
-		if (xi.rtdev && !xi.risfile)
-			discard_blocks(xi.rtdev, xi.rtsize);
-		if (xi.logdev && xi.logdev != xi.ddev && !xi.lisfile)
-			discard_blocks(xi.logdev, xi.logBBsize);
-	}
-
-	if (!liflag && !ldflag)
-		loginternal = xi.logdev == 0;
-	if (xi.logname)
-		logfile = xi.logname;
-	else if (loginternal)
-		logfile = _("internal log");
-	else if (xi.volname && xi.logdev)
-		logfile = _("volume log");
-	else if (!ldflag) {
-		fprintf(stderr, _("no log subvolume or internal log\n"));
-		usage();
-	}
-	if (xi.rtname)
-		rtfile = xi.rtname;
-	else
-	if (xi.volname && xi.rtdev)
-		rtfile = _("volume rt");
-	else if (!xi.rtdev)
-		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
-		fprintf(stderr,
-			_("size %s specified for data subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
-		usage();
-	} else if (!dsize && xi.dsize > 0)
-		dblocks = DTOBT(xi.dsize);
-	else if (!dsize) {
-		fprintf(stderr, _("can't get size of data subvolume\n"));
-		usage();
-	}
-	if (dblocks < XFS_MIN_DATA_BLOCKS) {
-		fprintf(stderr,
-	_("size %lld of data subvolume is too small, minimum %d blocks\n"),
-			(long long)dblocks, XFS_MIN_DATA_BLOCKS);
-		usage();
+	if (!discard)
+		return;
+
+	if (!xi->disfile)
+		discard_blocks(xi->ddev, xi->dsize);
+	if (xi->rtdev && !xi->risfile)
+		discard_blocks(xi->rtdev, xi->rtsize);
+	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
+		discard_blocks(xi->logdev, xi->logBBsize);
+}
+
+static void
+validate_datadev(
+	struct libxfs_xinit	*xi,
+	xfs_rfsblock_t		*dblocks,
+	int			blocklog)
+{
+
+	if (!xi->dsize) {
+		/*
+		 * if the device is a file, we can't validate the size here.
+		 * Instead, the file will be truncated to the correct length
+		 * later on. if it's not a file, we've got a dud device.
+		 */
+		if (!xi->disfile) {
+			fprintf(stderr, _("can't get size of data subvolume\n"));
+			usage();
+		}
+	} else if (!cligeo.dsize) {
+		/* no user size, so use the full block device size */
+		*dblocks = DTOBT(xi->dsize);
+	} else {
+		/* check the size fits into the underlying device */
+		if (*dblocks > DTOBT(xi->dsize)) {
+			fprintf(stderr,
+_("size %s specified for data subvolume is too large, maxi->um is %lld blocks\n"),
+				cligeo.dsize, (long long)DTOBT(xi->dsize));
+			usage();
+		}
 	}
 
-	if (loginternal && xi.logdev) {
-		fprintf(stderr,
-			_("can't have both external and internal logs\n"));
-		usage();
-	} else if (loginternal && sectorsize != lsectorsize) {
+	if (*dblocks < XFS_MIN_DATA_BLOCKS) {
 		fprintf(stderr,
-	_("data and log sector sizes must be equal for internal logs\n"));
+_("size %lld of data subvolume is too small, minimum %d blocks\n"),
+			(long long)*dblocks, XFS_MIN_DATA_BLOCKS);
 		usage();
 	}
 
-	if (xi.dbsize > sectorsize) {
+	if (xi->dbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the data subvolume sector size %u is less than the sector size \n\
 reported by the device (%u).\n"),
-			sectorsize, xi.dbsize);
+			sectorsize, xi->dbsize);
 	}
-	if (!loginternal && xi.lbsize > lsectorsize) {
-		fprintf(stderr, _(
-"Warning: the log subvolume sector size %u is less than the sector size\n\
-reported by the device (%u).\n"),
-			lsectorsize, xi.lbsize);
+}
+
+/*
+ * This is more complex than it needs to be because we still support volume
+ * based external logs. They are only discovered *after* the devices have been
+ * opened, hence the crazy "is this really an internal log" checks here.
+ */
+static void
+validate_logdev(
+	struct libxfs_xinit	*xi,
+	char			**devname,
+	xfs_rfsblock_t		*logblocks,
+	xfs_rfsblock_t		dblocks,
+	int			blocklog,
+	int			lsectorsize)
+{
+	*devname = NULL;
+
+	/* check for volume log first */
+	if (cligeo.loginternal && xi->volname && xi->logdev) {
+		*devname = _("volume log");
+		cligeo.loginternal = false;
+	}
+
+	/* now run device checks */
+	if (cligeo.loginternal) {
+		if (xi->logdev) {
+			fprintf(stderr,
+_("can't have both external and internal logs\n"));
+			usage();
+		}
+		if (sectorsize != lsectorsize) {
+			fprintf(stderr,
+_("data and log sector sizes must be equal for internal logs\n"));
+			usage();
+		}
+		if (cligeo.logsize && *logblocks >= dblocks) {
+			fprintf(stderr,
+_("log size %lld too large for internal log\n"),
+				(long long)logblocks);
+			usage();
+		}
+		*devname = _("internal log");
+		return;
 	}
-	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
+
+	/* External/log subvolume checks */
+	if (xi->logname)
+		*devname = xi->logname;
+	if (!*devname || !xi->logdev) {
+		fprintf(stderr, _("no log subvolume or external log.\n"));
+		usage();
+	}
+
+	if (!cligeo.logsize) {
+		if (xi->logBBsize == 0) {
+			fprintf(stderr,
+_("unable to get size of the log subvolume.\n"));
+			usage();
+		}
+		*logblocks = DTOBT(xi->logBBsize);
+	} else {
+		if (*logblocks > DTOBT(xi->logBBsize)) {
+			fprintf(stderr,
+_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
+				cligeo.logsize, (long long)DTOBT(xi->logBBsize));
+			usage();
+		}
+	}
+
+	if (xi->lbsize > lsectorsize) {
 		fprintf(stderr, _(
-"Warning: the realtime subvolume sector size %u is less than the sector size\n\
+"Warning: the log subvolume sector size %u is less than the sector size\n\
 reported by the device (%u).\n"),
-			sectorsize, xi.rtbsize);
+			lsectorsize, xi->lbsize);
 	}
+}
 
-	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
-		fprintf(stderr,
-			_("size %s specified for rt subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
-		usage();
-	} else if (!rtsize && xi.rtsize > 0)
-		rtblocks = DTOBT(xi.rtsize);
-	else if (rtsize && !xi.rtdev) {
-		fprintf(stderr,
-			_("size specified for non-existent rt subvolume\n"));
+static void
+validate_rtdev(
+	struct libxfs_xinit	*xi,
+	char			**devname,
+	xfs_rfsblock_t		*rtblocks,
+	xfs_rfsblock_t		*rtextents,
+	xfs_extlen_t		*nbmblocks,
+	int			blocklog,
+	xfs_extlen_t		rtextblocks)
+{
+	*devname = NULL;
+
+	if (!xi->rtdev) {
+		if (cligeo.rtsize) {
+			fprintf(stderr,
+_("size specified for non-exi->tent rt subvolume\n"));
+			usage();
+		}
+
+		*devname = _("none");
+		*rtblocks = 0;
+		*rtextents = 0;
+		*nbmblocks = 0;
+		return;
+	}
+	if (!xi->rtsize) {
+		fprintf(stderr, _("Invalid zero length rt subvolume found\n"));
 		usage();
 	}
-	if (xi.rtdev) {
-		rtextents = rtblocks / rtextblocks;
-		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY * blocksize);
-	} else {
-		rtextents = rtblocks = 0;
-		nbmblocks = 0;
-	}
-
-	if (!nodsflag) {
-		if (dsunit) {
-			if (ft.dsunit && ft.dsunit != dsunit) {
-				fprintf(stderr,
-					_("%s: Specified data stripe unit %d "
-					"is not the same as the volume stripe "
-					"unit %d\n"),
-					progname, dsunit, ft.dsunit);
-			}
-			if (ft.dswidth && ft.dswidth != dswidth) {
-				fprintf(stderr,
-					_("%s: Specified data stripe width %d "
-					"is not the same as the volume stripe "
-					"width %d\n"),
-					progname, dswidth, ft.dswidth);
-			}
-		} else {
-			dsunit = ft.dsunit;
-			dswidth = ft.dswidth;
-			nodsflag = 1;
+
+	/* volume rtdev */
+	if (xi->volname)
+		*devname = _("volume rt");
+	else
+		*devname = xi->rtname;
+
+	if (cligeo.rtsize) {
+		if (*rtblocks > DTOBT(xi->rtsize)) {
+			fprintf(stderr,
+_("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
+				cligeo.rtsize, (long long)DTOBT(xi->rtsize));
+			usage();
+		}
+		if (xi->rtbsize > sectorsize) {
+			fprintf(stderr, _(
+"Warning: the realtime subvolume sector size %u is less than the sector size\n\
+reported by the device (%u).\n"),
+				sectorsize, xi->rtbsize);
 		}
-	} /* else dsunit & dswidth can't be set if nodsflag is set */
+	} else {
+		/* grab volume size */
+		*rtblocks = DTOBT(xi->rtsize);
+	}
+
+	*rtextents = *rtblocks / rtextblocks;
+	*nbmblocks = (xfs_extlen_t)howmany(*rtextents, NBBY * blocksize);
+}
 
-	if (dasize) {		/* User-specified AG size */
+static void
+calculate_initial_ag_geometry(
+	int		blocklog,
+	uint64_t	dblocks,
+	int		multidisk,
+	uint64_t	*agsize,
+	uint64_t	*agcount)
+{
+	if (cligeo.agsize) {		/* User-specified AG size */
 		/*
 		 * Check specified agsize is a multiple of blocksize.
 		 */
-		if (agsize % blocksize) {
+		if (cligeo.agsize % blocksize) {
 			fprintf(stderr,
 		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
-				(long long)agsize, blocksize);
+				(long long)cligeo.agsize, blocksize);
 			usage();
 		}
-		agsize /= blocksize;
-		agcount = dblocks / agsize + (dblocks % agsize != 0);
+		*agsize = cligeo.agsize / blocksize;
+		*agcount = dblocks / *agsize + (dblocks % *agsize != 0);
 
-	} else if (daflag) {	/* User-specified AG count */
-		agsize = dblocks / agcount + (dblocks % agcount != 0);
+	} else if (cligeo.agcount) {	/* User-specified AG count */
+		*agcount = cligeo.agcount;
+		*agsize = dblocks / *agcount + (dblocks % *agcount != 0);
 	} else {
 		calc_default_ag_geometry(blocklog, dblocks,
-				dsunit | dswidth, &agsize, &agcount);
+					 multidisk, agsize, agcount);
 	}
+}
 
-	/*
-	 * If dsunit is a multiple of fs blocksize, then check that is a
-	 * multiple of the agsize too
-	 */
-	if (dsunit && !(BBTOB(dsunit) % blocksize) &&
-	    dswidth && !(BBTOB(dswidth) % blocksize)) {
+/*
+ * Align the AG size to stripe geometry. If this fails and we are using
+ * discovered stripe geometry, tell the caller to clear the stripe geometry.
+ * Otherwise, set the aligned geometry (valid or invalid!) so that the
+ * validation call will fail and exit.
+ */
+static bool
+align_ag_geometry(
+	int		dsunit,
+	int		dswidth,
+	int		blocklog,
+	xfs_rfsblock_t	*dblocks,
+	uint64_t	*agsize,
+	uint64_t	*agcount)
+{
+	uint64_t	tmp_agsize;
+	bool		ret = false;
 
-		/* convert from 512 byte blocks to fs blocksize */
-		dsunit = DTOBT(dsunit);
-		dswidth = DTOBT(dswidth);
+	if (!dsunit)
+		return false;
 
+	/*
+	 * agsize is not a multiple of dsunit
+	 */
+	if ((*agsize % dsunit) != 0) {
 		/*
-		 * agsize is not a multiple of dsunit
+		 * Round up to stripe unit boundary. Also make sure
+		 * that agsize is still larger than
+		 * XFS_AG_MIN_BLOCKS(blocklog)
 		 */
-		if ((agsize % dsunit) != 0) {
-			/*
-			 * Round up to stripe unit boundary. Also make sure
-			 * that agsize is still larger than
-			 * XFS_AG_MIN_BLOCKS(blocklog)
-		 	 */
-			tmp_agsize = ((agsize + (dsunit - 1))/ dsunit) * dsunit;
+		tmp_agsize = ((*agsize + (dsunit - 1))/ dsunit) * dsunit;
+		/*
+		 * Round down to stripe unit boundary if rounding up
+		 * created an AG size that is larger than the AG max.
+		 */
+		if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
+			tmp_agsize = ((*agsize) / dsunit) * dsunit;
+
+		if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog) &&
+		    tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
+			if (cligeo.dsunit == -1 && cligeo.dsu == -1) {
+				ret = true;
+				goto validate;
+			}
 			/*
-			 * Round down to stripe unit boundary if rounding up
-			 * created an AG size that is larger than the AG max.
+			 * set the agsize to the invalid value so the following
+			 * validation of the ag will fail and print a nice error
+			 * and exit.
 			 */
-			if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
-				tmp_agsize = ((agsize) / dsunit) * dsunit;
-
-			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(blocklog)) &&
-			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog))) {
-				agsize = tmp_agsize;
-				if (!daflag)
-					agcount = dblocks/agsize +
-						(dblocks % agsize != 0);
-				if (dasize)
-					fprintf(stderr,
-				_("agsize rounded to %lld, swidth = %d\n"),
-						(long long)agsize, dswidth);
-			} else {
-				if (nodsflag) {
-					dsunit = dswidth = 0;
-				} else {
-					/*
-					 * agsize is out of bounds, this will
-					 * print nice details & exit.
-					 */
-					validate_ag_geometry(blocklog, dblocks,
-							    agsize, agcount);
-					exit(1);
-				}
-			}
+			*agsize = tmp_agsize;
+			goto validate;
 		}
-		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
-			/* This is a non-optimal configuration because all AGs
-			 * start on the same disk in the stripe.  Changing
-			 * the AG size by one sunit will guarantee that this
-			 * does not happen.
-			 */
-			tmp_agsize = agsize - dsunit;
-			if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
-				tmp_agsize = agsize + dsunit;
-				if (dblocks < agsize) {
-					/* oh well, nothing to do */
-					tmp_agsize = agsize;
-				}
-			}
-			if (daflag || dasize) {
-				fprintf(stderr, _(
+
+		/* update geometry to be stripe unit aligned */
+		*agsize = tmp_agsize;
+		if (!cligeo.agcount)
+			*agcount = *dblocks / *agsize + (*dblocks % *agsize != 0);
+		if (cligeo.agsize)
+			fprintf(stderr,
+		_("agsize rounded to %lld, sunit = %d\n"),
+				(long long)*agsize, dsunit);
+	}
+
+	if ((*agsize % dswidth) == 0 && *agcount > 1) {
+
+		if (cligeo.agcount || cligeo.agsize) {
+			fprintf(stderr, _(
 "Warning: AG size is a multiple of stripe width.  This can cause performance\n\
 problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
-an AG size that is one stripe unit smaller, for example %llu.\n"),
-					(unsigned long long)tmp_agsize);
-			} else {
-				agsize = tmp_agsize;
-				agcount = dblocks/agsize + (dblocks % agsize != 0);
-				/*
-				 * If the last AG is too small, reduce the
-				 * filesystem size and drop the blocks.
-				 */
-				if ( dblocks % agsize != 0 &&
-				    (dblocks % agsize <
-				    XFS_AG_MIN_BLOCKS(blocklog))) {
-					dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-					agcount--;
-					ASSERT(agcount != 0);
-				}
-			}
+an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
+				(unsigned long long)*agsize - dsunit);
+			goto validate;
 		}
-	} else {
-		if (nodsflag)
-			dsunit = dswidth = 0;
-		else {
-			fprintf(stderr,
-				_("%s: Stripe unit(%d) or stripe width(%d) is "
-				"not a multiple of the block size(%d)\n"),
-				progname, BBTOB(dsunit), BBTOB(dswidth),
-				blocksize);
-			exit(1);
+
+		/*
+		 * This is a non-optimal configuration because all AGs start on
+		 * the same disk in the stripe.  Changing the AG size by one
+		 * sunit will guarantee that this does not happen.
+		 */
+		tmp_agsize = *agsize - dsunit;
+		if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
+			tmp_agsize = *agsize + dsunit;
+			if (*dblocks < *agsize) {
+				/* oh well, nothing to do */
+				tmp_agsize = *agsize;
+			}
 		}
+
+		*agsize = tmp_agsize;
+		*agcount = *dblocks / *agsize + (*dblocks % *agsize != 0);
 	}
 
 	/*
 	 * If the last AG is too small, reduce the filesystem size
 	 * and drop the blocks.
 	 */
-	if ( dblocks % agsize != 0 &&
-	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
-		ASSERT(!daflag);
-		dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-		agcount--;
-		ASSERT(agcount != 0);
+	if (*dblocks % *agsize != 0 &&
+	     (*dblocks % *agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
+		ASSERT(!cligeo.agcount);
+		*dblocks = (xfs_rfsblock_t)((*agcount - 1) * *agsize);
+		(*agcount)--;
+		ASSERT(*agcount != 0);
 	}
 
-	validate_ag_geometry(blocklog, dblocks, agsize, agcount);
+validate:
+	validate_ag_geometry(blocklog, *dblocks, *agsize, *agcount);
+	return ret;
+}
 
-	if (!imflag)
-		imaxpct = calc_default_imaxpct(blocklog, dblocks);
+/*
+ * Make sure that the log size is a multiple of the stripe unit
+ */
+static void
+align_log_size(
+	int		sunit,
+	xfs_rfsblock_t	*logblocks,
+	int		blocklog)
+{
+	uint64_t	tmp_logblocks;
 
-	/*
-	 * check that log sunit is modulo fsblksize or default it to dsunit.
-	 */
+	/* nothing to do if it's already aligned. */
+	if ((*logblocks % sunit) == 0)
+		return;
 
-	if (lsunit) {
-		/* convert from 512 byte blocks to fs blocks */
-		lsunit = DTOBT(lsunit);
-	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
-		/* lsunit and dsunit now in fs blocks */
-		lsunit = dsunit;
+	if (cligeo.logsize) {
+		fprintf(stderr,
+_("log size %lld is not a multiple of the log stripe unit %d\n"),
+			(long long) *logblocks, sunit);
+		usage();
 	}
 
-	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
-		/* Warn only if specified on commandline */
-		if (lsuflag || lsunitflag) {
-			fprintf(stderr,
-	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
-				(lsunit * blocksize));
-			fprintf(stderr,
-	_("log stripe unit adjusted to 32KiB\n"));
-		}
-		lsunit = (32 * 1024) >> blocklog;
+	tmp_logblocks = ((*logblocks + (sunit - 1)) / sunit) * sunit;
+
+	/* If the log is too large, round down instead of round up */
+	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
+	    ((tmp_logblocks << blocklog) > XFS_MAX_LOG_BYTES)) {
+		tmp_logblocks = (*logblocks / sunit) * sunit;
+	}
+	*logblocks = tmp_logblocks;
+}
+
+/*
+ * Make sure that the internal log is correctly aligned to the specified
+ * stripe unit.
+ */
+static void
+align_internal_log(
+	xfs_mount_t	*mp,
+	xfs_fsblock_t	*logstart,
+	uint64_t	agsize,
+	int		sunit,
+	xfs_rfsblock_t	*logblocks,
+	int		blocklog)
+{
+	uint64_t	agspace;
+
+	if ((*logstart % sunit) != 0)
+		*logstart = ((*logstart + (sunit - 1))/sunit) * sunit;
+
+	align_log_size(sunit, logblocks, blocklog);
+
+	/* check the aligned log still fits in an AG. */
+	agspace = agsize - libxfs_prealloc_blocks(mp);
+	if (*logblocks > agspace - XFS_FSB_TO_AGBNO(mp, *logstart)) {
+		fprintf(stderr,
+_("Due to stripe alignment, the internal log size (%lld) is too large.\n"
+  "Must fit within an allocation group.\n"),
+			(long long) *logblocks);
+		usage();
+	}
+}
+
+void
+validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
+{
+	if (logblocks < min_logblocks) {
+		fprintf(stderr,
+	_("log size %lld blocks too small, minimum size is %d blocks\n"),
+			(long long)logblocks, min_logblocks);
+		usage();
+	}
+	if (logblocks > XFS_MAX_LOG_BLOCKS) {
+		fprintf(stderr,
+	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
+			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
+		usage();
+	}
+	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
+		fprintf(stderr,
+	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
+			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
+		usage();
 	}
+}
+
+static void
+calculate_log_size(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		*logblocks,
+	xfs_fsblock_t		*logstart,
+	xfs_agnumber_t		*logagno,
+	xfs_rfsblock_t		dblocks,
+	int			lsunit,
+	int			dsunit,
+	int			sectorlog,
+	int			blocklog,
+	int			inodelog,
+	int			dirblocklog)
 
-	min_logblocks = max_trans_res(agsize,
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int			min_logblocks;
+
+	min_logblocks = max_trans_res(sbp->sb_agblocks,
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt,
 				   sb_feat.rmapbt, sb_feat.reflink,
 				   sb_feat.inode_align);
+
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
+
+	if (!cligeo.logsize && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
-		fprintf(stderr,
-_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
-		usage();
-	} else if (!logsize && xi.logBBsize > 0) {
-		logblocks = DTOBT(xi.logBBsize);
-	} else if (logsize && !xi.logdev && !loginternal) {
-		fprintf(stderr,
-			_("size specified for non-existent log subvolume\n"));
-		usage();
-	} else if (loginternal && logsize && logblocks >= dblocks) {
-		fprintf(stderr, _("size %lld too large for internal log\n"),
-			(long long)logblocks);
-		usage();
-	} else if (!loginternal && !xi.logdev) {
-		logblocks = 0;
-	} else if (loginternal && !logsize) {
+
+	if (!cligeo.loginternal) {
+		if (min_logblocks > *logblocks) {
+			fprintf(stderr,
+	_("external log device %lld too small, must be at least %lld blocks\n"),
+				(long long)logblocks, (long long)min_logblocks);
+			usage();
+		}
+		*logstart = 0;
+		*logagno = 0;
+		if (lsunit)
+			align_log_size(lsunit, logblocks, blocklog);
+
+		validate_log_size(*logblocks, blocklog, min_logblocks);
+		return;
+	}
+
+	/* internal log - if no size specified, calculate automatically */
+	if (!cligeo.logsize) {
 
 		if (dblocks < GIGABYTES(1, blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
-			logblocks = min_logblocks;
+			*logblocks = min_logblocks;
 		} else if (dblocks < GIGABYTES(16, blocklog)) {
 
 			/*
@@ -2663,7 +2788,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
 			 * at all possible, ramping up to 128MB at 256GB.
 			 */
-			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
+			*logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
 					min_logblocks * XFS_DFL_LOG_FACTOR);
 		} else {
 			/*
@@ -2672,25 +2797,253 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			 * max log size of 128M at 256GB fs size. IOWs,
 			 * the ratio of fs size to log size is 2048:1.
 			 */
-			logblocks = (dblocks << blocklog) / 2048;
-			logblocks = logblocks >> blocklog;
+			*logblocks = (dblocks << blocklog) / 2048;
+			*logblocks = *logblocks >> blocklog;
 		}
 
 		/* Ensure the chosen size meets minimum log size requirements */
-		logblocks = MAX(min_logblocks, logblocks);
+		*logblocks = MAX(min_logblocks, *logblocks);
 
 		/* make sure the log fits wholly within an AG */
-		if (logblocks >= agsize)
-			logblocks = min_logblocks;
+		*logblocks = MIN(*logblocks,
+				libxfs_alloc_ag_max_usable(mp));
 
 		/* and now clamp the size to the maximum supported size */
-		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES)
-			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
+		*logblocks = MIN(*logblocks, XFS_MAX_LOG_BLOCKS);
+		if ((*logblocks << blocklog) > XFS_MAX_LOG_BYTES)
+			*logblocks = XFS_MAX_LOG_BYTES >> blocklog;
+
+		validate_log_size(*logblocks, blocklog, min_logblocks);
+	}
+
+
+	if (*logblocks > sbp->sb_agblocks - libxfs_prealloc_blocks(mp)) {
+		fprintf(stderr,
+_("internal log size %lld too large, must fit in allocation group\n"),
+			(long long)*logblocks);
+		usage();
+	}
+
+	if (cligeo.logagno != -1) {
+		if (cligeo.logagno >= sbp->sb_agcount) {
+			fprintf(stderr,
+_("log ag number %d too large, must be less than %lld\n"),
+				cligeo.logagno, (long long)sbp->sb_agcount);
+			usage();
+		}
+		*logagno = cligeo.logagno;
+	} else
+		*logagno = (xfs_agnumber_t)(sbp->sb_agcount / 2);
+
+	*logstart = XFS_AGB_TO_FSB(mp, *logagno, libxfs_prealloc_blocks(mp));
+
+	/*
+	 * Align the logstart at stripe unit boundary.
+	 */
+	if (lsunit) {
+		align_internal_log(mp, logstart, sbp->sb_agblocks, lsunit,
+				   logblocks, blocklog);
+	} else if (dsunit) {
+		align_internal_log(mp, logstart, sbp->sb_agblocks, dsunit,
+				   logblocks, blocklog);
+	}
+	validate_log_size(*logblocks, blocklog, min_logblocks);
+}
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	uint64_t		agcount = 0;
+	xfs_agf_t		*agf;
+	xfs_agi_t		*agi;
+	xfs_agnumber_t		agno;
+	uint64_t		agsize = 0;
+	xfs_alloc_rec_t		*arec;
+	struct xfs_btree_block	*block;
+	int			blocklog = 0;
+	int			bsize;
+	xfs_buf_t		*buf;
+	int			c;
+	xfs_rfsblock_t		dblocks = 0;
+	char			*dfile = NULL;
+	int			dirblocklog = 0;
+	int			dirblocksize = 0;
+	int			dsunit = 0;
+	int			dswidth = 0;
+	int			force_overwrite = 0;
+	int			imaxpct = 0;
+	int			inodelog = 0;
+	int			inopblock = 0;
+	int			isize = 0;
+	char			*label = NULL;
+	int			lalign = 0;
+	xfs_agnumber_t		logagno = 0;
+	xfs_rfsblock_t		logblocks = 0;
+	char			*logfile = NULL;
+	xfs_fsblock_t		logstart = 0;
+	int			lsectorlog = 0;
+	int			lsectorsize = 0;
+	int			lsunit = 0;
+	xfs_mount_t		*mp = NULL;
+	xfs_mount_t		mbuf;
+	xfs_extlen_t		nbmblocks = 0;
+	xfs_alloc_rec_t		*nrec = NULL;
+	int			dry_run = 0;
+	int			discard = 1;
+	char			*protofile = NULL;
+	char			*protostring = NULL;
+	int			quiet = 0;
+	xfs_rfsblock_t		rtblocks = 0;
+	xfs_extlen_t		rtextblocks = 0;
+	xfs_rtblock_t		rtextents = 0;
+	char			*rtfile = NULL;
+	xfs_sb_t		*sbp;
+	int			sectorlog = 0;
+	uuid_t			uuid;
+	int			worst_freelist = 0;
+	struct fs_topology	ft;
+	int			ret;
+
+	platform_uuid_generate(&uuid);
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	/*
+	 * set parameters that can be set to zero to -1 or a default value so we
+	 * can tell if they have been set or not This gets rid of all the "was
+	 * it specified" flags.
+	 */
+	cligeo.dsu = -1;
+	cligeo.dsw = -1;
+	cligeo.dsunit = -1;
+	cligeo.dswidth = -1;
+	cligeo.loginternal = 1;
+	cligeo.logagno = -1;
+	cligeo.lsu = -1;
+	cligeo.lsunit = -1;
+
+	xi.isdirect = LIBXFS_DIRECT;
+	xi.isreadonly = LIBXFS_EXCLUSIVELY;
+
+	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+		switch (c) {
+		case 'C':
+		case 'f':
+			force_overwrite = 1;
+			break;
+		case 'b':
+		case 'd':
+		case 'i':
+		case 'l':
+		case 'm':
+		case 'n':
+		case 'r':
+		case 's':
+			parse_subopts(c, optarg);
+			break;
+		case 'L':
+			if (strlen(optarg) > sizeof(sbp->sb_fname))
+				illegal(optarg, "L");
+			label = optarg;
+			break;
+		case 'N':
+			dry_run = 1;
+			break;
+		case 'K':
+			discard = 0;
+			break;
+		case 'p':
+			if (protofile)
+				respec('p', NULL, 0);
+			protofile = optarg;
+			break;
+		case 'q':
+			quiet = 1;
+			break;
+		case 'V':
+			printf(_("%s version %s\n"), progname, VERSION);
+			exit(0);
+		case '?':
+			unknown(optopt, "");
+		}
+	}
+	if (argc - optind > 1) {
+		fprintf(stderr, _("extra arguments\n"));
+		usage();
+	} else if (argc - optind == 1) {
+		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
+	} else
+		dfile = xi.dname;
+
+	/*
+	 * Extract as much of the valid config as we can from the CLI input
+	 * before opening the libxfs devices.
+	 */
+	validate_blocksize(&blocksize, &blocklog);
+	validate_sectorsize(&sectorsize, &sectorlog, &ft, dfile, dry_run,
+			    force_overwrite);
+	validate_log_sectorsize(&lsectorsize, &lsectorlog,
+				sectorsize, sectorlog);
+	validate_sb_features();
+
+	validate_dirblocksize(&dirblocksize, &dirblocklog, blocklog);
+	validate_inodesize(&isize, &inodelog, &inopblock, blocklog);
+
+	/*
+	 * if the device size was specified convert it to a block count
+	 * now we have a valid block size. These will be set to zero if
+	 * nothing was specified, indicating we should use the full device.
+	 */
+	dblocks = calc_dev_size(cligeo.dsize, &dopts, D_SIZE, blocklog, "data");
+	logblocks = calc_dev_size(cligeo.logsize, &lopts, L_SIZE, blocklog, "log");
+	rtblocks = calc_dev_size(cligeo.rtsize, &ropts, R_SIZE, blocklog, "rt");
+
+	validate_rtextsize(&rtextblocks, &ft, blocklog);
+	calc_stripe_factors(&ft, blocklog, sectorsize, lsectorsize,
+			    &dsunit, &dswidth, &lsunit);
 
+	/*
+	 * Open and validate the device configurations
+	 */
+	open_devices(&xi, sectorlog, lsectorlog, (discard && !dry_run));
+
+	validate_datadev(&xi, &dblocks, blocklog);
+	validate_logdev(&xi, &logfile, &logblocks, dblocks, blocklog, lsectorsize);
+	validate_rtdev(&xi, &rtfile, &rtblocks, &rtextents,
+		       &nbmblocks, blocklog, rtextblocks);
+
+	/*
+	 * At this point when know exactly what size all the devices are,
+	 * so we can start validating and calculating layout options that are
+	 * dependent on device sizes.
+	 */
+	calculate_initial_ag_geometry(blocklog, dblocks, dsunit | dswidth,
+				      &agsize, &agcount);
+
+	/*
+	 * Alignment may fail and tell us that we need to clear the stripe
+	 * geometry to continue.
+	 */
+	ret = align_ag_geometry(dsunit, dswidth, blocklog,
+				&dblocks, &agsize, &agcount);
+	if (ret) {
+		dsunit = 0;
+		dswidth = 0;
 	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
 
+	imaxpct = cligeo.imaxpct;
+	if (!imaxpct)
+		imaxpct = calc_default_imaxpct(blocklog, dblocks);
+
+	/*
+	 * Set up the basic superblock parameters now so that we can use
+	 * the geometry information we've already validated in libxfs
+	 * provided functions to determine on-disk format information.
+	 */
 	protostring = setup_proto(protofile);
 	bsize = 1 << (blocklog - BBSHIFT);
 	mp = &mbuf;
@@ -2700,6 +3053,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_sectlog = (uint8_t)sectorlog;
 	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
 	sbp->sb_agblocks = (xfs_agblock_t)agsize;
+	sbp->sb_agcount = (xfs_agnumber_t)agcount;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
@@ -2709,58 +3063,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 */
 	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
 
+	calculate_log_size(mp, &logblocks, &logstart, &logagno, dblocks, lsunit,
+			   dsunit, sectorlog, blocklog, inodelog, dirblocklog);
 
-	if (loginternal) {
-		/*
-		 * Readjust the log size to fit within an AG if it was sized
-		 * automatically.
-		 */
-		if (!logsize) {
-			logblocks = MIN(logblocks,
-					libxfs_alloc_ag_max_usable(mp));
-
-			/* revalidate the log size is valid if we changed it */
-			validate_log_size(logblocks, blocklog, min_logblocks);
-		}
-		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
-			fprintf(stderr,
-	_("internal log size %lld too large, must fit in allocation group\n"),
-				(long long)logblocks);
-			usage();
-		}
-
-		if (laflag) {
-			if (logagno >= agcount) {
-				fprintf(stderr,
-		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)agcount);
-				usage();
-			}
-		} else
-			logagno = (xfs_agnumber_t)(agcount / 2);
-
-		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
-		/*
-		 * Align the logstart at stripe unit boundary.
-		 */
-		if (lsunit) {
-			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, lsunit,
-					&logblocks, blocklog, &lalign);
-		} else if (dsunit) {
-			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, dsunit,
-					&logblocks, blocklog, &lalign);
-		}
-	} else {
-		logstart = 0;
-		if (lsunit)
-			fixup_log_stripe_unit(lsflag, lsunit,
-					&logblocks, blocklog);
-	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
-
-	if (!qflag || Nflag) {
+	if (!quiet || dry_run) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
@@ -2785,7 +3091,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				sb_feat.lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
 			(long long)rtblocks, (long long)rtextents);
-		if (Nflag)
+		if (dry_run)
 			exit(0);
 	}
 
@@ -2819,7 +3125,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks - agcount * libxfs_prealloc_blocks(mp) -
-		(loginternal ? logblocks : 0);
+		(cligeo.loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
@@ -2978,7 +3284,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
 
-		if (loginternal && agno == logagno) {
+		if (cligeo.loginternal && agno == logagno) {
 			be32_add_cpu(&agf->agf_freeblks, -logblocks);
 			agf->agf_longest = cpu_to_be32(agsize -
 				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
@@ -3049,7 +3355,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
+		if (cligeo.loginternal && agno == logagno) {
 			if (lalign) {
 				/*
 				 * Have to insert two records
@@ -3099,7 +3405,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
+		if (cligeo.loginternal && agno == logagno) {
 			if (lalign) {
 				arec->ar_blockcount = cpu_to_be32(
 					XFS_FSB_TO_AGBNO(mp, logstart) -
@@ -3233,7 +3539,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			}
 
 			/* account for the log space */
-			if (loginternal && agno == logagno) {
+			if (cligeo.loginternal && agno == logagno) {
 				rrec = XFS_RMAP_REC_ADDR(block,
 					be16_to_cpu(block->bb_numrecs) + 1);
 				rrec->rm_startblock = cpu_to_be32(
@@ -3364,7 +3670,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 static void
 conflict(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		oldidx,
 	int		newidx)
 {
@@ -3393,7 +3699,7 @@ ispow2(
 static void __attribute__((noreturn))
 reqval(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		idx)
 {
 	fprintf(stderr, _("-%c %s option requires a value\n"), opt, tab[idx]);
@@ -3403,7 +3709,7 @@ reqval(
 static void
 respec(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		idx)
 {
 	fprintf(stderr, "-%c ", opt);
-- 
2.13.3

