Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 875197F47
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:15:55 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:15:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 32/35] xfsprogs: add utf8 support to mkfs.xfs
Message-ID: <20141003221555.GF1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Set the utf-8 feature bit.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

[v2: add support for utf8version. -bpm]
---
 man/man8/mkfs.xfs.8 |  9 ++++-
 mkfs/xfs_mkfs.c     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 mkfs/xfs_mkfs.h     |  3 +-
 3 files changed, 105 insertions(+), 5 deletions(-)

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
index c85258a..8cf5f9a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -25,6 +25,7 @@
 #include <disk/volume.h>
 #endif
 #include "xfs_mkfs.h"
+#include <xfs/utf8norm.h>
 
 /*
  * Device topology information.
@@ -149,6 +150,8 @@ char	*nopts[] = {
 	"version",
 #define	N_FTYPE		3
 	"ftype",
+#define	N_UTF8		4
+	"utf8",
 	NULL,
 };
 
@@ -958,6 +961,11 @@ main(
 	int			nsflag;
 	int			nvflag;
 	int			nci;
+	unsigned int		utf8;
+	unsigned int		utf8_major;
+	unsigned int		utf8_minor;
+	unsigned int		utf8_revision;
+	char			utf8_version_string[10];
 	int			Nflag;
 	int			discard = 1;
 	char			*p;
@@ -984,6 +992,7 @@ main(
 	int			lazy_sb_counters;
 	int			crcs_enabled;
 	int			finobt;
+	int			ret;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1004,6 +1013,7 @@ main(
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = nci = 0;
 	nftype = dirftype = 0;		/* inode type information in the dir */
+	utf8 = 0;			/* utf-8 support */
 	dirblocklog = dirblocksize = 0;
 	dirversion = XFS_DFL_DIR_VERSION;
 	qflag = 0;
@@ -1565,7 +1575,8 @@ _("cannot specify both crc and ftype\n"));
 					if (nvflag)
 						respec('n', nopts, N_VERSION);
 					if (!strcasecmp(value, "ci")) {
-						nci = 1; /* ASCII CI mode */
+						/* ASCII or UTF-8 CI mode */
+						nci = 1;
 					} else {
 						dirversion = atoi(value);
 						if (dirversion != 2)
@@ -1587,6 +1598,62 @@ _("cannot specify both crc and ftype\n"));
 					}
 					nftype = 1;
 					break;
+				case N_UTF8:
+					if (!value || *value == '\0')
+						value = "7.0.0";
+					ret = sscanf(value, "%d.%d.%d",
+							&utf8_major,
+							&utf8_minor,
+							&utf8_revision);
+					if (ret == 3) {
+						utf8 = UNICODE_AGE(
+							utf8_major,
+							utf8_minor,
+							utf8_revision);
+						if (!utf8version_is_supported(
+									utf8)) {
+							fprintf(stderr,
+_("utf8 version %d.%d.%d not supported\n"),
+							utf8_major,
+							utf8_minor,
+							utf8_revision);
+							usage();
+						}
+						break;
+					}
+					ret = sscanf(value, "%d.%d",
+							&utf8_major,
+							&utf8_minor);
+					if (ret == 2) {
+						utf8 = UNICODE_AGE(
+							utf8_major,
+							utf8_minor,
+							0);
+						if (!utf8version_is_supported(
+									utf8)) {
+							fprintf(stderr,
+_("utf8 version %d.%d not supported\n"),
+							utf8_major,
+							utf8_minor);
+							usage();
+						}
+						break;
+					}
+					ret = sscanf(value, "%d", &utf8_major);
+					if (ret == 1) {
+						utf8 = UNICODE_AGE(
+							utf8_major,
+							0, 0);
+						if (!utf8version_is_supported(
+									utf8)) {
+							fprintf(stderr,
+_("utf8 version %d not supported\n"),
+							utf8_major);
+							usage();
+						}
+						break;
+					}
+					/* fallthrough */
 				default:
 					unknown('n', value);
 				}
@@ -2460,7 +2527,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 */
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
 					attrversion == 2, !projid16bit, 0,
-					(!crcs_enabled && dirftype));
+					(!crcs_enabled && dirftype),
+					(!crcs_enabled && utf8));
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
 					dsunit != 0,
 					logversion == 2, attrversion == 1,
@@ -2534,6 +2602,26 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	if (crcs_enabled) {
 		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
 		dirftype = 1;
+		/* turn on the utf-8 support */
+		if (utf8)
+			sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_UTF8;
+	}
+	if (utf8) {
+		int	major, minor, revision;
+
+		major = utf8 >> UNICODE_MAJ_SHIFT;
+		minor = (utf8 & 0xff00) >> UNICODE_MIN_SHIFT;
+		revision = utf8 & 0xff;
+
+		if (!revision && !minor)
+			sprintf(utf8_version_string, "%d", major);
+		else if (!revision)
+			sprintf(utf8_version_string, "%d.%d", major, minor);
+		else
+			sprintf(utf8_version_string, "%d.%d.%d",
+						major, minor, revision);
+	} else {
+		strcpy(utf8_version_string, "0");
 	}
 
 	if (!qflag || Nflag) {
@@ -2544,6 +2632,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+		   "         =%-22s utf8=%s\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
@@ -2553,6 +2642,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
+			"", utf8_version_string,
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
@@ -2617,6 +2707,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
 	}
+	sbp->sb_utf8version = utf8;
 
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
@@ -3171,7 +3262,8 @@ usage( void )
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
 			    lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1\n\
+			    utf8=0|7]\n\
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
