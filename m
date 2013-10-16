Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F161A7F52
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 17:47:47 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D92A0304032
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 15:47:47 -0700 (PDT)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r9GMllpo004644
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 17:47:47 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131016223812.698179281@sgi.com>
Date: Wed, 16 Oct 2013 17:36:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 3/3] xfsprog: add mkfs.xfs sb v4 support for dirent filetype
	field
References: <20131016223654.505433792@sgi.com>
Content-Disposition: inline;
	filename=3-3-xfsprog-add-mkfs.xfs-sb-v4-support-for-dirent-filetype-field.patch
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

Add directory inode type feature to mkfs.xfs and its manual page.

In sb v4, "mkfs.xfs -n ftype=1" turns on the feature. The feature is
still automatically turned on for sb v5. Reject the "ftype=1" request
if used with the "crc=1" setting.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
updated the manual entry.
changed the variables in xfs_mkfs.c
call usage() if the crc and ftype are used together.
update the sb_features_incompat entry for sb v5 and feature bit for v4

man/man8/mkfs.xfs.8 |    7 +++++++
 man/man8/mkfs.xfs.8 |   15 +++++++++++++++
 mkfs/xfs_mkfs.c     |   42 +++++++++++++++++++++++++++++++-----------
 mkfs/xfs_mkfs.h     |    4 +++-
 3 files changed, 49 insertions(+), 12 deletions(-)

Index: b/man/man8/mkfs.xfs.8
===================================================================
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -517,6 +517,21 @@ option enables ASCII only case-insensiti
 are stored in directories using the case they were created with.
 .IP
 Note: Version 1 directories are not supported.
+.TP
+.BI ftype= value
+This feature introduced in Linux 3.12 allows the inode type to
+be stored in the directory structure so that readdir(3) and getdents(2)
+do not need to look up the inode to determine the inode type.
+
+The
+.I value
+is either 0 or 1, with 1 signifiying that filetype information
+will be stored in the directory structure. The default value is 0.
+
+When CRCs are enabled via "mkfs.xfs -m crc=1", the ftype functionality is
+always enabled. This feature can not be turned off for such filesystem
+configurations.
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
@@ -930,6 +933,7 @@ main(
 	int			nodsflag;
 	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
+	int			nftype;
 	int			nsflag;
 	int			nvflag;
 	int			nci;
@@ -977,6 +981,7 @@ main(
 	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = nci = 0;
+	nftype = dirftype = 0;		/* inode type information in the dir */
 	dirblocklog = dirblocksize = 0;
 	dirversion = XFS_DFL_DIR_VERSION;
 	qflag = 0;
@@ -1475,6 +1480,8 @@ main(
 					if (c < 0 || c > 1)
 						illegal(value, "m crc");
 					crcs_enabled = c;
+					if (dirftype && crcs_enabled)
+						usage();
 					break;
 				default:
 					unknown('m', value);
@@ -1533,6 +1540,16 @@ main(
 					}
 					nvflag = 1;
 					break;
+				case N_FTYPE:
+					if (!value || *value == '\0')
+						reqval('n', nopts, N_FTYPE);
+					if (nftype)
+						respec('n', nopts, N_FTYPE);
+					dirftype = atoi(value);
+					if (crcs_enabled)
+						usage();
+					nftype = 1;
+					break;
 				default:
 					unknown('n', value);
 				}
@@ -2434,6 +2451,14 @@ _("size %s specified for log subvolume i
 	}
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
+	/*
+	 * dirent filetype field always enabled on v5 superblocks
+	 */
+	if (crcs_enabled) {
+		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
+		dirftype = 1;
+	}
+
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
@@ -2441,7 +2466,7 @@ _("size %s specified for log subvolume i
 		   "         =%-22s crc=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
-		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
+		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
@@ -2450,7 +2475,7 @@ _("size %s specified for log subvolume i
 			"", crcs_enabled,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
-			dirversion, dirblocksize, nci,
+			dirversion, dirblocksize, nci, dirftype,
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
@@ -2512,8 +2537,10 @@ _("size %s specified for log subvolume i
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
 	}
+
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
-					attrversion == 2, !projid16bit, 0);
+				   attrversion == 2, !projid16bit, 0,
+				   (crcs_enabled && dirftype));
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
 					dsunit != 0,
 					logversion == 2, attrversion == 1,
@@ -2521,13 +2548,6 @@ _("size %s specified for log subvolume i
 							lsectorsize != BBSIZE),
 					nci, sbp->sb_features2 != 0);
 	/*
-	 * dirent filetype field always enabled on v5 superblocks
-	 */
-	if (crcs_enabled) {
-		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
-	}
-
-	/*
 	 * Due to a structure alignment issue, sb_features2 ended up in one
 	 * of two locations, the second "incorrect" location represented by
 	 * the sb_bad_features2 field. To avoid older kernels mounting
@@ -3065,7 +3085,7 @@ usage( void )
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
