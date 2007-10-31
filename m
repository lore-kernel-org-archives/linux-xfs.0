Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 16:35:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9VNZEt3018981
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 16:35:18 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA28388 for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 10:35:18 +1100
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l9VNZHdD83765271
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 10:35:17 +1100 (AEDT)
Received: (from xaiki@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l9VNZGq989111981
	for xfs@oss.sgi.com; Thu, 1 Nov 2007 10:35:16 +1100 (AEDT)
Date: Thu, 1 Nov 2007 10:35:16 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071031233516.GB88034736@melbourne.sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20071029075657.GA84369978@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thanks for all your insightfull replys

Here's the state of my xfsprogs/TODO:

DONE - version 2 logs
DONE - attr2

BUG - lazy superblock counters

It looks like it's a fixed bug that should be commited soon:

>[itchy] dmesg -c
>[itchy] dd if=/dev/zero of=blah bs=1 seek=100G count=1
1+0 records in
1+0 records out
1 byte (1 B) copied, 0.00151443 s, 0.7 kB/s
# this is my patched mkfs
>[itchy] mkfs.xfs -f -l lazy-count=1 blah
meta-data=/home/xaiki/blah       isize=256    agcount=8, agsize=3276800 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
>[itchy] mount -o loop blah /mnt
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

>[itchy] dmesg -c
XFS: bad version
XFS: SB validate failed

DONE - version 2 inodes

DONE - dropping the ability to turn unwritten extents off completely

DONE/ASK - imaxpct default can be reduced

> Given that 25% on a 4GB filesystem will allow about 5million inodes,
> I think it's probably reasonable to bring it down to 5% by the time we
> pass 1TB and 1% by 50TB.....

I implemented this as a simple step function, do we need something smarter ?

ASK - larger log

> Another one for you - make the log larger. The kernel code supports
> a log of up to 2GB, so mkfs could making a larger log without
> requiring changes elsewhere.

dchiner told me that we have issues with big logs, anyway, how much shall 
I increase the default ?

ASK - less allocation groups for single disk configs

Again, being quite new, I'd need magnitude orders of what's reasonable, I now multiply
by 2 the AG size, witch gives me 2x less AGs.

Eric: mkfs.conf sounds like a great idea to me, but i don't think it should
be exclusive to XFS.

Please find attached the early patches, comments are welcome.

Cheers,
-- 
Niv

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Default-to-log-version-2.patch"

>From af7d810cc78c541e91b712cebbfc6a0f342ac38f Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@itchy.(none)>
Date: Mon, 29 Oct 2007 14:56:45 +1100
Subject: [PATCH] Default to log version 2

---
 xfsprogs/mkfs/xfs_mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 6e84a4e..5f3299d 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -686,7 +686,7 @@ main(
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = ldflag = lvflag = 0;
 	loginternal = 1;
-	logversion = 1;
+	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = 0;
 	dirblocklog = dirblocksize = dirversion = 0;
-- 
1.5.3.4


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-Default-to-version-2-attributes.patch"

>From 92b5a69925f10b42daadad29d2269b71d4f0f23d Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@itchy.(none)>
Date: Mon, 29 Oct 2007 14:57:21 +1100
Subject: [PATCH] Default to version 2 attributes.

---
 xfsprogs/mkfs/xfs_mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 5f3299d..b378800 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -677,7 +677,7 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	attrversion = 0;
+	attrversion = 2;
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
-- 
1.5.3.4


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-Drop-the-ability-to-turn-unwritten-extents-off-compl.patch"

>From 42508704dfd2674847347c3266aebff20fae77ba Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@cxhome.ath.cx>
Date: Mon, 29 Oct 2007 15:23:22 +1100
Subject: [PATCH] Drop the ability to turn unwritten extents off completly

---
 xfsprogs/mkfs/xfs_mkfs.c |   38 +++++++++++++-------------------------
 xfsprogs/mkfs/xfs_mkfs.h |    6 +++---
 2 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index b378800..3689eb7 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -56,25 +56,23 @@ char	*dopts[] = {
 	"sunit",
 #define D_SWIDTH	5
 	"swidth",
-#define D_UNWRITTEN	6
-	"unwritten",
-#define D_AGSIZE	7
+#define D_AGSIZE	6
 	"agsize",
-#define D_SU		8
+#define D_SU		7
 	"su",
-#define D_SW		9
+#define D_SW		8
 	"sw",
-#define D_SECTLOG	10
+#define D_SECTLOG	9
 	"sectlog",
-#define D_SECTSIZE	11
+#define D_SECTSIZE	10
 	"sectsize",
-#define D_NOALIGN	12
+#define D_NOALIGN	11
 	"noalign",
-#define D_RTINHERIT	13
+#define D_RTINHERIT	12
 	"rtinherit",
-#define D_PROJINHERIT	14
+#define D_PROJINHERIT	13
 	"projinherit",
-#define D_EXTSZINHERIT	15
+#define D_EXTSZINHERIT	14
 	"extszinherit",
 	NULL
 };
@@ -604,7 +602,6 @@ main(
 	int			dsw;
 	int			dsunit;
 	int			dswidth;
-	int			extent_flagging;
 	int			force_overwrite;
 	struct fsxattr		fsx;
 	int			iaflag;
@@ -697,7 +694,6 @@ main(
 	dsize = logsize = rtsize = rtextsize = protofile = NULL;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
 	nodsflag = norsflag = 0;
-	extent_flagging = 1;
 	force_overwrite = 0;
 	worst_freelist = 0;
 	lazy_sb_counters = 0;
@@ -877,14 +873,6 @@ main(
 							 D_NOALIGN);
 					nodsflag = 1;
 					break;
-				case D_UNWRITTEN:
-					if (!value)
-						reqval('d', dopts, D_UNWRITTEN);
-					c = atoi(value);
-					if (c < 0 || c > 1)
-						illegal(value, "d unwritten");
-					extent_flagging = c;
-					break;
 				case D_SECTLOG:
 					if (!value)
 						reqval('d', dopts, D_SECTLOG);
@@ -1990,7 +1978,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-		   "         =%-22s sunit=%-6u swidth=%u blks, unwritten=%u\n"
+		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
@@ -1999,7 +1987,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			"", sectorsize, attrversion,
 			"", blocksize, (long long)dblocks,
 				imflag ? imaxpct : XFS_DFL_IMAXIMUM_PCT,
-			"", dsunit, dswidth, extent_flagging,
+			"", dsunit, dswidth,
 			dirversion, dirversion == 1 ? blocksize : dirblocksize,
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
@@ -2066,7 +2054,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	}
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(lazy_sb_counters, attrversion == 2, 0);
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(
-			iaflag, dsunit != 0, extent_flagging,
+			iaflag, dsunit != 0,
 			dirversion == 2, logversion == 2, attrversion == 1,
 			(sectorsize != BBSIZE || lsectorsize != BBSIZE),
 			sbp->sb_features2 != 0);
@@ -2537,7 +2525,7 @@ usage( void )
 /* blocksize */		[-b log=n|size=num]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num),\n\
-			    sectlog=n|sectsize=num,unwritten=0|1]\n\
+			    sectlog=n|sectsize=num\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
diff --git a/xfsprogs/mkfs/xfs_mkfs.h b/xfsprogs/mkfs/xfs_mkfs.h
index 1ab85fd..f19f917 100644
--- a/xfsprogs/mkfs/xfs_mkfs.h
+++ b/xfsprogs/mkfs/xfs_mkfs.h
@@ -18,12 +18,12 @@
 #ifndef __XFS_MKFS_H__
 #define	__XFS_MKFS_H__
 
-#define XFS_SB_VERSION_MKFS(ia,dia,extflag,dir2,log2,attr1,sflag,more) (\
-	((ia)||(dia)||(extflag)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
+#define XFS_SB_VERSION_MKFS(ia,dia,dir2,log2,attr1,sflag,more) (\
+	((ia)||(dia)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
 	( XFS_SB_VERSION_4 |						\
 		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
 		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-		((extflag) ? XFS_SB_VERSION_EXTFLGBIT : 0) |		\
+	        (XFS_SB_VERSION_EXTFLGBIT) |				\
 		((dir2) ? XFS_SB_VERSION_DIRV2BIT : 0) |		\
 		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
 		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
-- 
1.5.3.4


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0004-V2-inodes-per-default-and-move-DFL-bits-to-XFS_DFL_.patch"

>From a9b95cc4636501870155479787ec32b325afa512 Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@cxhome.ath.cx>
Date: Tue, 30 Oct 2007 11:15:33 +1100
Subject: [PATCH] V2 inodes per default, and move DFL bits to XFS_DFL_SB_VERSION_BITS,

Activate XFS_SB_VERSION_NLINKBIT per default, witch will enable V2 INODES.
refactor bits that we want everytime in XFS_DFL_SB_VERSION_BITS.
---
 xfsprogs/mkfs/xfs_mkfs.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.h b/xfsprogs/mkfs/xfs_mkfs.h
index f19f917..9291e33 100644
--- a/xfsprogs/mkfs/xfs_mkfs.h
+++ b/xfsprogs/mkfs/xfs_mkfs.h
@@ -18,17 +18,19 @@
 #ifndef __XFS_MKFS_H__
 #define	__XFS_MKFS_H__
 
+#define XFS_DFL_SB_VERSION_BITS XFS_SB_VERSION_NLINKBIT|XFS_SB_VERSION_EXTFLGBIT
+
 #define XFS_SB_VERSION_MKFS(ia,dia,dir2,log2,attr1,sflag,more) (\
 	((ia)||(dia)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
 	( XFS_SB_VERSION_4 |						\
 		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
 		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-	        (XFS_SB_VERSION_EXTFLGBIT) |				\
 		((dir2) ? XFS_SB_VERSION_DIRV2BIT : 0) |		\
 		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
 		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
 		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
 		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
+	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
 
 #define XFS_SB_VERSION2_MKFS(lazycount, attr2, parent) (\
-- 
1.5.3.4


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0005-reduce-imaxpct-for-big-filesystems.patch"

>From c8e590185adb8b48e6765b9de7fe7afa19c6ea20 Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@cxhome.ath.cx>
Date: Tue, 30 Oct 2007 12:26:35 +1100
Subject: [PATCH] reduce imaxpct for big filesystems,

imaxpct is set to 25% for FS < 1 TB,
then 5% for FS < 50 TB,
and then 1%.

It is implemented as a step function in calc_default_imaxpct()
---
 xfsprogs/mkfs/xfs_mkfs.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 3689eb7..78c2c77 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -374,6 +374,21 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
+int
+calc_default_imaxpct(
+	int		blocklog,
+	__uint64_t	dblocks)
+{
+	if (dblocks < TERABYTES(1, blocklog)) {
+		return XFS_DFL_IMAXIMUM_PCT;
+	} else if (dblocks < TERABYTES(50, blocklog)) {
+		return 5;
+	}
+
+	return 1;
+}
+
+
 void
 calc_default_ag_geometry(
 	int		blocklog,
@@ -1986,7 +2001,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion,
 			"", blocksize, (long long)dblocks,
-				imflag ? imaxpct : XFS_DFL_IMAXIMUM_PCT,
+			       calc_default_imaxpct(blocklog, dblocks),
 			"", dsunit, dswidth,
 			dirversion, dirversion == 1 ? blocksize : dirblocksize,
 			logfile, 1 << blocklog, (long long)logblocks,
@@ -2023,7 +2038,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		(__uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
-	sbp->sb_imax_pct = imflag ? imaxpct : XFS_DFL_IMAXIMUM_PCT;
+	sbp->sb_imax_pct = calc_default_imaxpct(blocklog, dblocks);
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
-- 
1.5.3.4


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0006-less-AGs-for-single-disks-configs.patch"

>From bab3fed25bc5f44aef5b02af88a8ef968d08ddcb Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@cxhome.ath.cx>
Date: Tue, 30 Oct 2007 12:26:35 +1100
Subject: [PATCH] less AGs for single disks configs.

This patch modifies get_subvol_stripe_wrapper() to return 0 on multi disk configs,
<0 on error, and >0 on single disk configs (Ideally I'd like it to be able to return the
count of disks or something more usefull).

it then uses the output of the new get_subvol_stripe_wrapper() in calc_default_ag_geometry()
to get bigger AGs when in single disk configs (currently only x2 bigger).
---
 xfsprogs/include/volume.h  |    2 +-
 xfsprogs/libdisk/drivers.c |   15 ++++++++-------
 xfsprogs/mkfs/xfs_mkfs.c   |   18 ++++++++++++------
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/xfsprogs/include/volume.h b/xfsprogs/include/volume.h
index 0cc931d..e4cd26c 100644
--- a/xfsprogs/include/volume.h
+++ b/xfsprogs/include/volume.h
@@ -46,7 +46,7 @@ typedef enum sv_type_e {
 	SVTYPE_LAST		=255
 } sv_type_t;
 
-extern void get_subvol_stripe_wrapper (char *, sv_type_t, int *, int *, int *);
+extern int  get_subvol_stripe_wrapper (char *, sv_type_t, int *, int *, int *);
 extern int  get_driver_block_major (const char *, int);
 
 #endif /* __VOLUME_H__ */
diff --git a/xfsprogs/libdisk/drivers.c b/xfsprogs/libdisk/drivers.c
index 26c6ec1..9bdc270 100644
--- a/xfsprogs/libdisk/drivers.c
+++ b/xfsprogs/libdisk/drivers.c
@@ -18,7 +18,7 @@
 
 #include "drivers.h"
 
-void
+int
 get_subvol_stripe_wrapper(
 	char		*dev,
 	sv_type_t	type,
@@ -29,7 +29,7 @@ get_subvol_stripe_wrapper(
 	struct stat64	sb;
 
 	if (dev == NULL)
-		return;
+		return -ENODEV;
 
 	if (stat64(dev, &sb)) {
 		fprintf(stderr, _("Cannot stat %s: %s\n"),
@@ -38,16 +38,17 @@ get_subvol_stripe_wrapper(
 	}
 
 	if (  dm_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if (  md_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if ( lvm_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if ( xvm_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if (evms_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 
+	return 1;
 	/* ... add new device drivers here */
 }
 
diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 78c2c77..1eb8cf9 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -393,6 +393,7 @@ void
 calc_default_ag_geometry(
 	int		blocklog,
 	__uint64_t	dblocks,
+	int		dswidth,
 	__uint64_t	*agsize,
 	__uint64_t	*agcount)
 {
@@ -428,12 +429,13 @@ calc_default_ag_geometry(
 	 *
 	 * This scales us up smoothly between min/max AG sizes.
 	 */
+
 	if (dblocks > GIGABYTES(512, blocklog))
-		shift = 5;
+		shift = 5 - (dswidth == 0);
 	else if (dblocks > GIGABYTES(8, blocklog))
-		shift = 4;
+		shift = 4 - (dswidth == 0);
 	else if (dblocks >= MEGABYTES(128, blocklog))
-		shift = 3;
+		shift = 3 - (dswidth == 0);
 	else
 		ASSERT(0);
 	blocks = dblocks >> shift;
@@ -1771,10 +1773,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agsize /= blocksize;
 		agcount = dblocks / agsize + (dblocks % agsize != 0);
 
-	} else if (daflag)	/* User-specified AG size */
+	} else if (daflag)	/* User-specified AG count */
 		agsize = dblocks / agcount + (dblocks % agcount != 0);
-	else
-		calc_default_ag_geometry(blocklog, dblocks, &agsize, &agcount);
+	else {
+		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
+				&xlv_dsunit, &xlv_dswidth, &sectoralign);
+
+		calc_default_ag_geometry(blocklog, dblocks, xlv_dswidth, &agsize, &agcount);
+	}
 
 	/*
 	 * If the last AG is too small, reduce the filesystem size
-- 
1.5.3.4


--azLHFNyN32YCQGCU--
