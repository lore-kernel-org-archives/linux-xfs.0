Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:25 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B2KM012299
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:05 -0800
From: xaiki@sgi.com
Subject: [PATCH TAKE 2 3/6] Drop the ability to turn unwritten extents off completly
Date: Tue, 13 Nov 2007 15:10:54 +1100
Message-Id: <1194927057-26415-4-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194927057-26415-3-git-send-email-xaiki@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
 <1194927057-26415-1-git-send-email-xaiki@sgi.com>
 <1194927057-26415-2-git-send-email-xaiki@sgi.com>
 <1194927057-26415-3-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

unwritten extents on linux are generally a bad idea, this option
should not be used.

Remove the mount option from xfs_mkfs.c:
  remove it from option list,
  remove it from mkfs output.

Update xfs.mkfs manpage.
---
 xfsprogs/doc/CHANGES          |    1 +
 xfsprogs/growfs/xfs_growfs.c  |   11 ++++-------
 xfsprogs/man/man8/mkfs.xfs.8  |   16 ----------------
 xfsprogs/man/man8/xfs_admin.8 |    3 ++-
 xfsprogs/mkfs/xfs_mkfs.c      |   38 +++++++++++++-------------------------
 xfsprogs/mkfs/xfs_mkfs.h      |    6 +++---
 6 files changed, 23 insertions(+), 52 deletions(-)

diff --git a/xfsprogs/doc/CHANGES b/xfsprogs/doc/CHANGES
index 1858a87..5a3e165 100644
--- a/xfsprogs/doc/CHANGES
+++ b/xfsprogs/doc/CHANGES
@@ -5,6 +5,7 @@ xfsprogs-2.9.x
 	  warning in certain device sizes.
 	- Man page fixes. Thanks to Utako Kusaka <u-kusaka@wm.jp.nec.com>
 	  for this.
+	- Disable the ability to turn off unwritten extents in mkfs.
 
 xfsprogs-2.9.4 (7 Sep 2007)
 	- Fixed xfs_repair segfaulting with directory block size different
diff --git a/xfsprogs/growfs/xfs_growfs.c b/xfsprogs/growfs/xfs_growfs.c
index b029e1b..5767f10 100644
--- a/xfsprogs/growfs/xfs_growfs.c
+++ b/xfsprogs/growfs/xfs_growfs.c
@@ -58,7 +58,6 @@ report_info(
 	int		isint,
 	char		*logname,
 	char		*rtname,
-	int		unwritten,
 	int		lazycount,
 	int		dirversion,
 	int		logversion,
@@ -68,7 +67,7 @@ report_info(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
 	    "         =%-22s sectsz=%-5u attr=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-	    "         =%-22s sunit=%-6u swidth=%u blks, unwritten=%u\n"
+	    "         =%-22s sunit=%-6u swidth=%u blks"
 	    "naming   =version %-14u bsize=%-6u\n"
 	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
 	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
@@ -78,7 +77,7 @@ report_info(
 		"", geo.sectsize, attrversion,
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
-		"", geo.sunit, geo.swidth, unwritten,
+		"", geo.sunit, geo.swidth,
   		dirversion, geo.dirblocksize,
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
@@ -115,7 +114,6 @@ main(int argc, char **argv)
 	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
-	int			unwritten; /* unwritten extent flag */
 	int			lazycount; /* lazy superblock counters */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
@@ -236,7 +234,6 @@ main(int argc, char **argv)
 		}
 	}
 	isint = geo.logstart > 0;
-	unwritten = geo.flags & XFS_FSOP_GEOM_FLAGS_EXTFLG ? 1 : 0;
 	lazycount = geo.flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
 	dirversion = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2 ? 2 : 1;
 	logversion = geo.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
@@ -245,7 +242,7 @@ main(int argc, char **argv)
 
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
-				unwritten, lazycount, dirversion, logversion,
+				lazycount, dirversion, logversion,
 				attrversion);
 		exit(0);
 	}
@@ -282,7 +279,7 @@ main(int argc, char **argv)
 	}
 
 	report_info(geo, datadev, isint, logdev, rtdev,
-			unwritten, lazycount, dirversion, logversion,
+			lazycount, dirversion, logversion,
 			attrversion);
 
 	ddsize = xi.dsize;
diff --git a/xfsprogs/man/man8/mkfs.xfs.8 b/xfsprogs/man/man8/mkfs.xfs.8
index 0d27901..b6024c3 100644
--- a/xfsprogs/man/man8/mkfs.xfs.8
+++ b/xfsprogs/man/man8/mkfs.xfs.8
@@ -240,22 +240,6 @@ will automatically query the logical volume for appropriate
 and
 .B swidth
 values.
-.TP
-.BI unwritten[= value ]
-This is used to specify whether unwritten extents are flagged as such,
-or not.
-The
-.I value
-is either 0 or 1, with 1 signifying that unwritten
-extent flagging should occur.
-If the suboption is omitted, unwritten extent flagging is enabled.
-If unwritten extents are flagged, filesystem write performance
-will be negatively affected for preallocated file extents, since
-extra filesystem transactions are required to convert extent flags
-for the range of the file written.
-This suboption should be disabled if the filesystem
-needs to be used on operating system versions which do not support the
-flagging capability.
 .RE
 .TP
 .B \-f
diff --git a/xfsprogs/man/man8/xfs_admin.8 b/xfsprogs/man/man8/xfs_admin.8
index c0017b9..c38a942 100644
--- a/xfsprogs/man/man8/xfs_admin.8
+++ b/xfsprogs/man/man8/xfs_admin.8
@@ -31,7 +31,8 @@ command.
 .TP
 .B \-e
 Enables unwritten extent support on a filesystem that does not
-already have this enabled.
+already have this enabled (for legacy filesystems, it can't be
+disabled anymore at mkfs time).
 .TP
 .B \-f
 Specifies that the filesystem image to be processed is stored in a
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
1.5.3.5
