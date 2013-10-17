Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C7217F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:43:10 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA8B5304059
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 08:43:09 -0700 (PDT)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r9HFhAoB002747
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:43:10 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131017152955.518585653@sgi.com>
Date: Thu, 17 Oct 2013 10:28:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3 2/4] xfsprog: add dirent filetype information for xfs_info
References: <20131017152804.204045257@sgi.com>
Content-Disposition: inline;
	filename=2-4-xfsprog-add-dirent-filetype-information-for-xfs_info.patch
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

Make xfs_info aware of the directory inode type by using the
XFS_FSOP_GEOM_FLAGS_FTYPE set in the kernel.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
v3 no change.

growfs/xfs_growfs.c |   14 +++++++++-----
 growfs/xfs_growfs.c |   14 +++++++++-----
 include/xfs_fs.h    |    3 ++-
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: b/growfs/xfs_growfs.c
===================================================================
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -55,7 +55,8 @@ report_info(
 	int		attrversion,
 	int		projid32bit,
 	int		crcs_enabled,
-	int		cimode)
+	int		cimode,
+	int		ftype_enabled)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
@@ -63,7 +64,7 @@ report_info(
 	    "         =%-22s crc=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
-	    "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
+	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
 	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
 	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
@@ -74,7 +75,7 @@ report_info(
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize, cimode,
+  		dirversion, geo.dirblocksize, cimode, ftype_enabled,
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
 		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -121,6 +122,7 @@ main(int argc, char **argv)
 	libxfs_init_t		xi;	/* libxfs structure */
 	int			projid32bit;
 	int			crcs_enabled;
+	int			ftype_enabled = 0;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -242,10 +244,12 @@ main(int argc, char **argv)
 	ci = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
 	projid32bit = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
 	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
+	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
-				attrversion, projid32bit, crcs_enabled, ci);
+				attrversion, projid32bit, crcs_enabled, ci,
+				ftype_enabled);
 		exit(0);
 	}
 
@@ -282,7 +286,7 @@ main(int argc, char **argv)
 
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
-			attrversion, projid32bit, crcs_enabled, ci);
+			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
Index: b/include/xfs_fs.h
===================================================================
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -233,10 +233,11 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
-#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
+#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800	/* 32-bit project IDs	*/
 #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
+#define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
