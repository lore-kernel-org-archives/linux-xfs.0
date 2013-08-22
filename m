Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6834E7FA4
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:24:11 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1300AC001
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 12:24:10 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r7MJO99n002952
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:24:09 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130822191238.065073732@sgi.com>
Date: Thu, 22 Aug 2013 13:50:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/2] xfsprog: add mkfs.xfs sb v4 support for dirent filetype
	field
References: <20130822185026.111080968@sgi.com>
Content-Disposition: inline; filename=49-add-dir-filetype-to-inode-v2.patch
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

Add mkfs.xfs entry that enables the filetype field in the directory
feature bit.

In sb v4, "mkfs.xfs -n ftype=1 DEVICE" turns on the feature.
The feature is automatically turned on for sb v5 like it was
in the original patch.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 man/man8/mkfs.xfs.8 |    7 +++++++
 mkfs/xfs_mkfs.c     |   40 +++++++++++++++++++++++++++-------------
 mkfs/xfs_mkfs.h     |    4 +++-
 3 files changed, 37 insertions(+), 14 deletions(-)

Index: b/man/man8/mkfs.xfs.8
===================================================================
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -517,6 +517,13 @@ option enables ASCII only case-insensiti
 are stored in directories using the case they were created with.
 .IP
 Note: Version 1 directories are not supported.
+.TP
+.BI ftype= value
+The inode type is stored in the directory
+.I value
+can be either 0 or 1.
+With 0 meaning not supported (default) and 1 meaning supported.
+.IP
 .RE
 .TP
 .BI \-p " protofile"
Index: b/mkfs/xfs_mkfs.c
===================================================================
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -147,6 +147,8 @@ char	*nopts[] = {
 	"size",
 #define	N_VERSION	2
 	"version",
+#define	N_FTYPE		3
+	"ftype",
 	NULL,
 };
 
@@ -885,6 +887,7 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
+	int			dirftype;
 	int			dirversion;
 	char			*dsize;
 	int			dsu;
@@ -931,6 +934,7 @@ main(
 	int			nodsflag;
 	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
+	int			niflag;
 	int			nsflag;
 	int			nvflag;
 	int			nci;
@@ -977,8 +981,8 @@ main(
 	loginternal = 1;
 	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
-	Nflag = nlflag = nsflag = nvflag = nci = 0;
-	dirblocklog = dirblocksize = 0;
+	Nflag = niflag = nlflag = nsflag = nvflag = nci = 0;
+	dirftype = dirblocklog = dirblocksize = 0;
 	dirversion = XFS_DFL_DIR_VERSION;
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
@@ -1534,6 +1538,14 @@ main(
 					}
 					nvflag = 1;
 					break;
+				case N_FTYPE:
+					if (!value || *value == '\0')
+						reqval('n', nopts, N_FTYPE);
+					if (niflag)
+						respec('n', nopts, N_FTYPE);
+					dirftype = atoi(value);
+					niflag = 1;
+					break;
 				default:
 					unknown('n', value);
 				}
@@ -2433,7 +2445,7 @@ _("size %s specified for log subvolume i
 		   "         =%-22s crc=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
-		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
+		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
@@ -2442,7 +2454,7 @@ _("size %s specified for log subvolume i
 			"", crcs_enabled,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
-			dirversion, dirblocksize, nci,
+			dirversion, dirblocksize, nci, dirftype,
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
@@ -2504,21 +2516,23 @@ _("size %s specified for log subvolume i
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
 	}
-	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
-					attrversion == 2, !projid16bit, 0);
-	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
-					dsunit != 0,
-					logversion == 2, attrversion == 1,
-					(sectorsize != BBSIZE ||
-							lsectorsize != BBSIZE),
-					nci, sbp->sb_features2 != 0);
+
 	/*
 	 * dirent filetype field always enabled on v5 superblocks
 	 */
 	if (crcs_enabled) {
 		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
+		dirftype = 1;
 	}
 
+	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
+				   attrversion == 2, !projid16bit, 0, dirftype);
+	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
+					dsunit != 0,
+					logversion == 2, attrversion == 1,
+					(sectorsize != BBSIZE ||
+							lsectorsize != BBSIZE),
+					nci, sbp->sb_features2 != 0);
 	/*
 	 * Due to a structure alignment issue, sb_features2 ended up in one
 	 * of two locations, the second "incorrect" location represented by
@@ -3057,7 +3071,7 @@ usage( void )
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
 			    lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n log=n|size=num,version=2|ci]\n\
+/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
Index: b/mkfs/xfs_mkfs.h
===================================================================
--- a/mkfs/xfs_mkfs.h
+++ b/mkfs/xfs_mkfs.h
@@ -36,12 +36,14 @@
 	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
 
-#define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent) (\
+#define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent, \
+			     ftype) (\
 	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
 	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
 	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
 	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
 	((crc) ? XFS_SB_VERSION2_CRCBIT : 0) |				\
+	((ftype) ? XFS_SB_VERSION2_FTYPE : 0) |				\
 	0 )
 
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
