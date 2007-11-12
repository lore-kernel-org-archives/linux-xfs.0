Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:05:31 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAC45Iig027766
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:05:20 -0800
From: xaiki@sgi.com
Subject: [[PATCH, RESEND]] Drop the ability to turn unwritten extents off completly
Date: Mon, 12 Nov 2007 14:48:46 +1100
Message-Id: <1194839329-22003-3-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194839329-22003-2-git-send-email-xaiki@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com>
 <1194839329-22003-1-git-send-email-xaiki@sgi.com>
 <1194839329-22003-2-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

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
1.5.3.5
