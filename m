Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50791 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751305AbdHQLDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 07:03:30 -0400
Date: Thu, 17 Aug 2017 21:03:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
Message-ID: <20170817110324.GR21024@dastard>
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-5-jtulak@redhat.com>
 <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
 <20170816213812.GC4796@magnolia>
 <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

I'm going to put my 2c worth in here in the form of a patch.  The
tl;dr of it all is that I think we need to reset and reflect on what
I was originally trying to acheive with the table based option
parsing: factoring and simplifying mkfs into an easy to understand,
maintainable code base....

And, while I remember, there's a handful of input validation bugs I
found in the code whiel I was doing this (like missing conflict
checks).

Anyway, have a look, based on the current for-next branch.

> >> [1] # mkfs.xfs -dfile,name=fsfile,size=1g,sectsize=4k -lfile,name=logfile,size=512m,sectsize=512
> >
> > I see -d sectsize is in the --help screen but not the manpage.  Can we
> > fix that?
> 
> I made it, but Dave would rather see the -d sectsize option removed.
> Which I'm not sure about...
> See "[PATCH] xfsprogs: add sectsize/sectlog to the man page"

Slash and burn - there is so much useless, redundant crap in the CLI
we've been holding onto for 15 years that we should just get rid of
it. That's what I was intending to do originally with this rework
and I still see no reason why we should be keeping stuff that just
causes user confusion and implemention complexity.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

mkfs.xfs: factor the crap out of input parsing

From: Dave Chinner <dchinner@redhat.com>

Up front: this compiles, but I haven't even smoke tested it.
It's a patch for discussion and reflection, not for testing....

After spending most of today talking to Eric about this mkfs
factoring that doesn't seem to be going in the right direction,
I figured I'd spend the afternoon and pick up where I left the
original patchset I wrote all those years ago.

The primary goal I had for that work was to make mkfs.xfs
maintainable and lay a solid foundation for being able to modify it
in future. The goal wasn't to store all the config information the
options table - the goal was to provide a structure that we could
refactor the code around. We seem to have lost sight of this.

So, what this patch does is make a start on factoring the crap out
of the input parsing and parameter validation. It's based on the
current for-next tree, so I've ignored all the other patches that
are out there, even though there are some with changes in them that
are useful and good.

Instead, I hacked together a quick global "cli geometry" structure
that holds the handful of values that can be set from the CLI, and
pushed all the other feature flag things into the existing sb_feat
global structure.

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

It's far, far easier to see what mkfs is doing now, and what appears
to be random futzing with flags and input parameters has turned into
code that has clear and obvious meaning.

This is what the table based input option parsing was supposed to
lead to. Instead of a forest of similar but not at all the same
flags and varaibles, we get clear, obvious code that can then be
easily understood. Then we can abstract out all the calculated and
validated config variables into a single structure that we then use
to build the on-disk filesystem structure. And once the building of
the fs structure uses abstracted config structures, we can look at
adding new input and output methods that manipulate those config
structures rather than the CLI option parsing table.....

Luis, some of this factoring isn't that much different in concept
from your original patch set for config file support. The difference
is in the way it is acheived - by abstracting it into individual
option parameter type parser functions. Jan - the combining of all
the option parameter structures is similar in concept to your merged
tables, but it does it via a separate table designed specifically
the generic sub-option parsing code. So some of the concepts should
be recognisable, the difference is in the simplicity of
implementation.

Now, I need to be clear here: do not think that the hacky "cli
geometry" structure is a permanent fixture or will even last through
tomorrow. It's just a means to an end to make the initial factoring
simple and fast. That's the mistake that's been made with the option
parsing - we've ended up focussing on the option parsing table
rather than where the option table parsing was supposed to take us.

Keep in mind that I said to Eric 4 hours ago "I might send a patch"
less than 5 hours ago because it's the best way to get people to
understand why I think we need to reset and where we need to go
first before even thinking about other ways of getting config
information into and out of mkfs.

So, yeah, there's still a lot of work in this to finish it off to
the point where I can think about how to split it for review (maybe
another full day of uninterrrupted hacking on my part), but I'm done
for the day now and I think everyone needs to have a look and a
think about it before I get back to it in the morning...

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 1690 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 916 insertions(+), 774 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7bb6408f9b77..aeb081add83e 100644
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
@@ -729,74 +733,6 @@ struct opt_params mopts = {
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
@@ -1161,6 +1097,31 @@ struct sb_feat_args {
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
@@ -1283,7 +1244,7 @@ check_opt(
 		fprintf(stderr,
 	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
 			sp->index, index);
-		reqval(opts->name, (char **)opts->subopts, index);
+		reqval(opts->name, opts->subopts, index);
 	}
 
 	/*
@@ -1296,11 +1257,11 @@ check_opt(
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
 
@@ -1312,7 +1273,7 @@ check_opt(
 			break;
 		if (opts->subopt_params[conflict_opt].seen ||
 		    opts->subopt_params[conflict_opt].str_seen)
-			conflict(opts->name, (char **)opts->subopts,
+			conflict(opts->name, opts->subopts,
 				 conflict_opt, index);
 	}
 }
@@ -1330,7 +1291,7 @@ getnum(
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
-			reqval(opts->name, (char **)opts->subopts, index);
+			reqval(opts->name, opts->subopts, index);
 		return sp->defaultval;
 	}
 
@@ -1386,615 +1347,472 @@ getstr(
 
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
+libxfs_init_t		xi;
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
+
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
+	}
+	return 0;
+}
+
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
+		break;
+	case D_SECTSIZE:
+		cligeo.sectorsize = getnum(value, opts, D_SECTSIZE);
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
+	}
+	return 0;
+}
+
+static int
+inode_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
 	int			inodelog;
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
 	int			lsectorlog;
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
 
-	platform_uuid_generate(&uuid);
-	progname = basename(argv[0]);
-	setlocale(LC_ALL, "");
-	bindtextdomain(PACKAGE, LOCALEDIR);
-	textdomain(PACKAGE);
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
 
-	memset(&xi, 0, sizeof(xi));
-	xi.isdirect = LIBXFS_DIRECT;
-	xi.isreadonly = LIBXFS_EXCLUSIVELY;
+static int
+naming_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value)
+{
+	int			dirblocklog;
 
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
 		}
+		break;
+	case N_FTYPE:
+		sb_feat.dirftype = getnum(value, opts, N_FTYPE);
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
 
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
 	 */
-	if (!blflag && !bsflag) {
-		blocklog = XFS_DFL_BLOCKSIZE_LOG;
-		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
+	if (!cligeo.blocksize) {
+		*size_log = XFS_DFL_BLOCKSIZE_LOG;
+		*size = 1 << XFS_DFL_BLOCKSIZE_LOG;
+	} else {
+		*size = cligeo.blocksize;
+		*size_log = libxfs_highbit32(cligeo.blocksize);
 	}
-	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
-		fprintf(stderr, _("illegal block size %d\n"), blocksize);
+
+	/* validate block sizes are in range */
+	if (*size < XFS_MIN_BLOCKSIZE || *size > XFS_MAX_BLOCKSIZE) {
+		fprintf(stderr, _("illegal block size %d\n"), *size);
 		usage();
 	}
-	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+	if (sb_feat.crcs_enabled && *size < XFS_MIN_CRC_BLOCKSIZE) {
 		fprintf(stderr,
 _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 			XFS_MIN_CRC_BLOCKSIZE);
 		usage();
 	}
-	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
-		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
-		usage();
-	}
+}
 
-	if (!slflag && !ssflag) {
-		sectorlog = XFS_MIN_SECTORSIZE_LOG;
-		sectorsize = XFS_MIN_SECTORSIZE;
-	}
-	if (!lslflag && !lssflag) {
-		lsectorlog = sectorlog;
-		lsectorsize = sectorsize;
+static void
+validate_sectorsize(
+	unsigned int	*size,
+	int		*size_log,
+	struct fs_topology *ft,
+	char		*dfile,
+	int		Nflag,
+	int		force_overwrite)
+{
+	/* set configured sector sizes in preparation for checks */
+	if (!cligeo.sectorsize) {
+		*size_log = XFS_MIN_SECTORSIZE_LOG;
+		*size = XFS_MIN_SECTORSIZE;
+	} else {
+		*size = cligeo.sectorsize;
+		*size_log = libxfs_highbit32(cligeo.sectorsize);
 	}
 
 	/*
 	 * Before anything else, verify that we are correctly operating on
 	 * files or block devices and set the control parameters correctly.
-	 * Explicitly disable direct IO for image files so we don't error out on
-	 * sector size mismatches between the new filesystem and the underlying
-	 * host filesystem.
 	 */
-	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
+	check_device_type(dfile, &xi.disfile, !cligeo.dsize, !dfile,
 			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
-	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
-				  Nflag ? NULL : &xi.lcreat,
+	if (!cligeo.loginternal)
+		check_device_type(xi.logname, &xi.lisfile, !cligeo.logsize,
+				  !xi.logname, Nflag ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
-				  Nflag ? NULL : &xi.rcreat,
+		check_device_type(xi.rtname, &xi.risfile, !cligeo.rtsize,
+				  !xi.rtname, Nflag ? NULL : &xi.rcreat,
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
@@ -2004,56 +1822,93 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
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
+	if (cligeo.lsectorsize && cligeo.loginternal) {
+		fprintf(stderr, _("Can't set sector size on internal log!\n"));
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
+	if (*lsize > XFS_MIN_SECTORSIZE &&
+	    cligeo.lsu <= 0 && cligeo.lsunit <= 0) {
+		cligeo.lsu = blocksize;
 		sb_feat.log_version = 2;
 	}
 
+	/* if lsu or lsunit was specified, automatically use v2 logs */
+	if ((cligeo.lsu || cligeo.lsunit) && sb_feat.log_version == 1) {
+		fprintf(stderr,
+			_("log stripe unit specified, using v2 logs\n"));
+		sb_feat.log_version = 2;
+	}
+
+}
+
+static void
+validate_sb_features(void)
+{
+
 	/*
 	 * Now we have blocks and sector sizes set up, check parameters that are
 	 * no longer optional for CRC enabled filesystems.  Catch them up front
@@ -2061,7 +1916,8 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 */
 	if (sb_feat.crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		if (cligeo.inodesize &&
+		    cligeo.inodesize < (1 << XFS_DINODE_DFL_CRC_LOG)) {
 			fprintf(stderr,
 _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2103,6 +1959,14 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
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
@@ -2149,103 +2013,137 @@ _("rmapbt not supported with realtime devices\n"));
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
@@ -2253,70 +2151,314 @@ _("rmapbt not supported with realtime devices\n"));
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
+	int		dsectsz,
+	int		lsectsz,
+	int		*dsunit,
+	int		*dswidth,
+	int		*lsunit)
+{
+	int		dsu;
+	int		dsw;
+	int		lsu;
 
-		fprintf(stderr, _("illegal inode size %d\n"), isize);
-		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
-			    XFS_DINODE_MAX_SIZE);
-		if (XFS_DINODE_MIN_SIZE == maxsz)
+	*dsunit = cligeo.dsunit == -1 ? 0 : cligeo.dsunit;
+	*dswidth = cligeo.dswidth == -1 ? 0 : cligeo.dswidth;
+	*lsunit = cligeo.lsunit == -1 ? 0 : cligeo.lsunit;
+
+	dsu = cligeo.dsu == -1 ? 0 : cligeo.dsu;
+	dsw = cligeo.dsw == -1 ? 0 : cligeo.dsw;
+	lsu = cligeo.lsu == -1 ? 0 : cligeo.lsu;
+
+	/* Handle data sunit/swidth options */
+	if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
+		fprintf(stderr,
+_("both data sunit and data swidth options must be specified\n"));
+		usage();
+	}
+
+	if (dsu || dsw) {
+		if ((dsu && !dsw) || (!dsu && dsw)) {
 			fprintf(stderr,
-			_("allowable inode size with %d byte blocks is %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE);
-		else
+_("both data su and data sw options must be specified\n"));
+			usage();
+		}
+
+		if (dsu % dsectsz) {
 			fprintf(stderr,
-	_("allowable inode size with %d byte blocks is between %d and %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
-		exit(1);
+_("data su must be a multiple of the sector size (%d)\n"), dsectsz);
+			usage();
+		}
+
+		*dsunit  = (int)BTOBBT(dsu);
+		*dswidth = *dsunit * dsw;
 	}
 
-	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && sb_feat.log_version == 1) {
+	if (*dsunit && (*dswidth % *dsunit != 0)) {
 		fprintf(stderr,
-			_("log stripe unit specified, using v2 logs\n"));
-		sb_feat.log_version = 2;
+_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
+			*dswidth, *dsunit);
+		usage();
 	}
 
-	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
-				&dsunit, &dswidth, &lsunit);
+	/* Handle log sunit options */
+
+	if (lsu)
+		*lsunit = (int)BTOBBT(lsu);
+
+	/* verify if lsu/lsunit is a multiple block size */
+	if (lsu % blocksize != 0) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+			lsu, blocksize);
+		exit(1);
+	}
+	if ((BBTOB(*lsunit) % blocksize != 0)) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+		BBTOB(*lsunit), blocksize);
+		exit(1);
+	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
-	if (dsflag && !dsunit && !dswidth)
-		nodsflag = 1;
+	if (cligeo.dsunit != -1 && !dsunit && !dswidth)
+		sb_feat.nodalign = true;
+}
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	uint64_t		agcount;
+	xfs_agf_t		*agf;
+	xfs_agi_t		*agi;
+	xfs_agnumber_t		agno;
+	uint64_t		agsize;
+	xfs_alloc_rec_t		*arec;
+	struct xfs_btree_block	*block;
+	int			blocklog;
+	int			bsize;
+	xfs_buf_t		*buf;
+	int			c;
+	int			daflag;
+	int			dasize;
+	xfs_rfsblock_t		dblocks;
+	char			*dfile;
+	int			dirblocklog;
+	int			dirblocksize;
+	char			*dsize;
+	int			dsunit;
+	int			dswidth;
+	int			force_overwrite;
+	int			imaxpct;
+	int			imflag;
+	int			inodelog;
+	int			inopblock;
+	int			ipflag;
+	int			isflag;
+	int			isize;
+	char			*label = NULL;
+	int			laflag;
+	int			lalign;
+	int			ldflag;
+	int			liflag;
+	xfs_agnumber_t		logagno;
+	xfs_rfsblock_t		logblocks;
+	char			*logfile;
+	int			loginternal;
+	char			*logsize;
+	xfs_fsblock_t		logstart;
+	int			lvflag;
+	int			lsflag;
+	int			lsuflag;
+	int			lsunitflag;
+	int			lsectorlog;
+	int			lsectorsize;
+	int			lsu;
+	int			lsunit;
+	int			min_logblocks;
+	xfs_mount_t		*mp;
+	xfs_mount_t		mbuf;
+	xfs_extlen_t		nbmblocks;
+	int			nlflag;
+	int			nodsflag;
+	int			norsflag;
+	xfs_alloc_rec_t		*nrec;
+	int			nsflag;
+	int			nvflag;
+	int			Nflag;
+	int			discard = 1;
+	char			*protofile;
+	char			*protostring;
+	int			qflag;
+	xfs_rfsblock_t		rtblocks;
+	xfs_extlen_t		rtextblocks;
+	xfs_rtblock_t		rtextents;
+	char			*rtextsize;
+	char			*rtfile;
+	char			*rtsize;
+	xfs_sb_t		*sbp;
+	int			sectorlog;
+	uint64_t		sector_mask;
+	uint64_t		tmp_agsize;
+	uuid_t			uuid;
+	int			worst_freelist;
+	struct fs_topology	ft;
+
+	platform_uuid_generate(&uuid);
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	blocklog = blocksize = 0;
+	sectorlog = lsectorlog = 0;
+	sectorsize = lsectorsize = 0;
+	agsize = daflag = dasize = dblocks = 0;
+	imflag = ipflag = isflag = 0;
+	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
+	loginternal = 1;
+	logagno = logblocks = rtblocks = rtextblocks = 0;
+	Nflag = nlflag = nsflag = nvflag = 0;
+	dirblocklog = dirblocksize = 0;
+	qflag = 0;
+	imaxpct = inodelog = inopblock = isize = 0;
+	dfile = logfile = rtfile = NULL;
+	dsize = logsize = rtsize = rtextsize = protofile = NULL;
+	dsunit = dswidth = lalign = lsu = lsunit = 0;
+	nodsflag = norsflag = 0;
+	force_overwrite = 0;
+	worst_freelist = 0;
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
+			Nflag = 1;
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
+			qflag = 1;
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
+	validate_sectorsize(&sectorsize, &sectorlog, &ft, dfile, Nflag,
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
+
+	calc_stripe_factors(sectorsize, lsectorsize, &dsunit, &dswidth, &lsunit);
 
-	xi.setblksize = sectorsize;
 
 	/*
 	 * Initialize.  This will open the log and rt devices as well.
 	 */
+	xi.setblksize = sectorsize;
 	if (!libxfs_init(&xi))
 		usage();
 	if (!xi.ddev) {
@@ -3364,7 +3506,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 static void
 conflict(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		oldidx,
 	int		newidx)
 {
@@ -3393,7 +3535,7 @@ ispow2(
 static void __attribute__((noreturn))
 reqval(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		idx)
 {
 	fprintf(stderr, _("-%c %s option requires a value\n"), opt, tab[idx]);
@@ -3403,7 +3545,7 @@ reqval(
 static void
 respec(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		idx)
 {
 	fprintf(stderr, "-%c ", opt);
