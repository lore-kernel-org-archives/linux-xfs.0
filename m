Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E04307FAA
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 16:03:46 -0500 (CDT)
Date: Thu, 11 Sep 2014 16:03:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 11/13] xfsprogs: add utf8 support to mkfs.xfs
Message-ID: <20140911210343.GT13262@sgi.com>
References: <20140911203735.GA19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911203735.GA19952@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tinguely@sgi.com, olaf@sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Set the utf-8 feature bit.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 man/man8/mkfs.xfs.8 |  9 ++++++++-
 mkfs/xfs_mkfs.c     | 27 ++++++++++++++++++++++-----
 mkfs/xfs_mkfs.h     |  3 ++-
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index ad9ff3d..aa43cf5 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -558,7 +558,7 @@ any power of 2 size from the filesystem block size up to 65536.
 .IP
 The
 .B version=ci
-option enables ASCII only case-insensitive filename lookup and version
+option enables ASCII or UTF-8 case-insensitive filename lookup and version
 2 directories. Filenames are case-preserving, that is, the names
 are stored in directories using the case they were created with.
 .IP
@@ -582,6 +582,13 @@ When CRCs are enabled via
 the ftype functionality is always enabled. This feature can not be turned
 off for such filesystem configurations.
 .IP
+.TP
+.BI utf8[= value ]
+This is used to enable the UTF-8 character set support. The
+.I value
+is either 0 or 1, with 1 signifying that UTF-8 character support is to be
+enabled. If the value is omitted, 1 is assumed.
+.IP
 .RE
 .TP
 .BI \-p " protofile"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c85258a..1829e51 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -149,6 +149,8 @@ char	*nopts[] = {
 	"version",
 #define	N_FTYPE		3
 	"ftype",
+#define	N_UTF8		4
+	"utf8",
 	NULL,
 };
 
@@ -958,6 +960,7 @@ main(
 	int			nsflag;
 	int			nvflag;
 	int			nci;
+	int			utf8;
 	int			Nflag;
 	int			discard = 1;
 	char			*p;
@@ -1004,6 +1007,7 @@ main(
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = nci = 0;
 	nftype = dirftype = 0;		/* inode type information in the dir */
+	utf8 = 0;			/* utf-8 support */
 	dirblocklog = dirblocksize = 0;
 	dirversion = XFS_DFL_DIR_VERSION;
 	qflag = 0;
@@ -1565,7 +1569,8 @@ _("cannot specify both crc and ftype\n"));
 					if (nvflag)
 						respec('n', nopts, N_VERSION);
 					if (!strcasecmp(value, "ci")) {
-						nci = 1; /* ASCII CI mode */
+						/* ASCII or UTF-8 CI mode */
+						nci = 1;
 					} else {
 						dirversion = atoi(value);
 						if (dirversion != 2)
@@ -1587,6 +1592,14 @@ _("cannot specify both crc and ftype\n"));
 					}
 					nftype = 1;
 					break;
+				case N_UTF8:
+					if (!value || *value == '\0')
+						value = "1";
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "n utf8");
+					utf8 = c;
+					break;
 				default:
 					unknown('n', value);
 				}
@@ -2460,7 +2473,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 */
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
 					attrversion == 2, !projid16bit, 0,
-					(!crcs_enabled && dirftype));
+					(!crcs_enabled && dirftype),
+					(!crcs_enabled && utf8));
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
 					dsunit != 0,
 					logversion == 2, attrversion == 1,
@@ -2534,6 +2548,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	if (crcs_enabled) {
 		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
 		dirftype = 1;
+		/* turn on the utf-8 support */
+		if (utf8)
+			sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_UTF8;
 	}
 
 	if (!qflag || Nflag) {
@@ -2543,7 +2560,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "         =%-22s crc=%-8u finobt=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
-		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d utf8=%d\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
@@ -2552,7 +2569,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			"", crcs_enabled, finobt,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
-			dirversion, dirblocksize, nci, dirftype,
+			dirversion, dirblocksize, nci, dirftype, utf8,
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
@@ -3171,7 +3188,7 @@ usage( void )
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
 			    lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1,utf8=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
diff --git a/mkfs/xfs_mkfs.h b/mkfs/xfs_mkfs.h
index 9df5f37..f40b284 100644
--- a/mkfs/xfs_mkfs.h
+++ b/mkfs/xfs_mkfs.h
@@ -37,13 +37,14 @@
 	0 ) : XFS_SB_VERSION_1 )
 
 #define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent, \
-			     ftype) (\
+			     ftype, utf8) (\
 	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
 	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
 	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
 	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
 	((crc) ? XFS_SB_VERSION2_CRCBIT : 0) |				\
 	((ftype) ? XFS_SB_VERSION2_FTYPE : 0) |				\
+	((utf8) ? XFS_SB_VERSION2_UTF8BIT : 0) |			\
 	0 )
 
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
