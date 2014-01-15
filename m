Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB80829E20
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91CE0304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:53 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0Utgj003664
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:55 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.661118493@sgi.com>
Date: Wed, 15 Jan 2014 16:00:29 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 17/17] xfsprogs: add parent GEOM information
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=05-xfsprogs-pptr-add-to-xfs_info.patch
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

Add the XFS_FSOP_GEOM_FLAGS information for xfs_growfs/xfs_info.

---
 growfs/xfs_growfs.c |   14 +++++++++-----
 include/xfs_fs.h    |    2 +-
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: b/growfs/xfs_growfs.c
===================================================================
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -56,7 +56,8 @@ report_info(
 	int		projid32bit,
 	int		crcs_enabled,
 	int		cimode,
-	int		ftype_enabled)
+	int		ftype_enabled,
+	int		parentptr)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
@@ -64,7 +65,7 @@ report_info(
 	    "         =%-22s crc=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
-	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d parent=%d\n"
 	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
 	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
@@ -75,7 +76,7 @@ report_info(
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize, cimode, ftype_enabled,
+  		dirversion, geo.dirblocksize, cimode, ftype_enabled, parentptr,
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
 		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -123,6 +124,7 @@ main(int argc, char **argv)
 	int			projid32bit;
 	int			crcs_enabled;
 	int			ftype_enabled = 0;
+	int			parent_enabled = 0;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -245,11 +247,12 @@ main(int argc, char **argv)
 	projid32bit = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
 	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
 	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
+	parent_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
-				ftype_enabled);
+				ftype_enabled, parent_enabled);
 		exit(0);
 	}
 
@@ -286,7 +289,8 @@ main(int argc, char **argv)
 
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
-			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled);
+			attrversion, projid32bit, crcs_enabled, ci,
+			ftype_enabled, parent_enabled);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
Index: b/include/xfs_fs.h
===================================================================
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -238,7 +238,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
-
+#define XFS_FSOP_GEOM_FLAGS_PARENT	0x20000	/* parent inode support */
 
 /*
  * Minimum and maximum sizes need for growth checks.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
