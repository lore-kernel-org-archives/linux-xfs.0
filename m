Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1C867F52
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:40:17 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:40:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 10/13] xfsprogs: add utf8 support to growfs
Message-ID: <20140918204016.GX4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
 <20140918203114.GN4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918203114.GN4482@sgi.com>
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
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Add reporting of the utf-8 mkfs options to xfs_growfs and xfs_info.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 growfs/xfs_growfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 8e611b6..6c41803 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -57,7 +57,8 @@ report_info(
 	int		crcs_enabled,
 	int		cimode,
 	int		ftype_enabled,
-	int		finobt_enabled)
+	int		finobt_enabled,
+	int		utf8)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
@@ -65,7 +66,7 @@ report_info(
 	    "         =%-22s crc=%-8u finobt=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
-	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d utf8=%d\n"
 	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
 	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
@@ -76,7 +77,7 @@ report_info(
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize, cimode, ftype_enabled,
+  		dirversion, geo.dirblocksize, cimode, ftype_enabled, utf8,
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
 		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -114,6 +115,7 @@ main(int argc, char **argv)
 	long long		rsize;	/* new rt size in fs blocks */
 	int			ci;	/* ASCII case-insensitive fs */
 	int			lazycount; /* lazy superblock counters */
+	int			utf8;	/* Unicode chars supported */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
 	char			*datadev; /* data device name */
@@ -247,11 +249,12 @@ main(int argc, char **argv)
 	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
 	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
 	finobt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FINOBT ? 1 : 0;
+	utf8 = geo.flags & XFS_FSOP_GEOM_FLAGS_UTF8 ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
-				ftype_enabled, finobt_enabled);
+				ftype_enabled, finobt_enabled, utf8);
 		exit(0);
 	}
 
@@ -289,7 +292,7 @@ main(int argc, char **argv)
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
 			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
-			finobt_enabled);
+			finobt_enabled, utf8);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
