Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDD4E7F60
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF66D8F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1iTdueE8mtjbeIBK for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWO-0003wg-Fn
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWE-0001Mk-BC
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 40/48] xfsprogs: support CRC enabled filesystem detection
Date: Fri,  7 Jun 2013 10:26:03 +1000
Message-Id: <1370564771-4929-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Add the XFS_FSOP_GEOM_FLAGS_V5SB flag to the XFS_IOC_FSGEOMETRY
ioctl to allow utilities like xfs_info to detect that the filesystem
is CRC enabled.

While touching xfs_info, add projid32bit output as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 growfs/xfs_growfs.c |   16 ++++++++++++----
 include/xfs_fs.h    |    1 +
 mkfs/xfs_mkfs.c     |    2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 5d544da..cad2b7f 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -53,11 +53,14 @@ report_info(
 	int		dirversion,
 	int		logversion,
 	int		attrversion,
+	int		projid32bit,
+	int		crcs_enabled,
 	int		cimode)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
-	    "         =%-22s sectsz=%-5u attr=%u\n"
+	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+	    "         =%-22s crc=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
 	    "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
@@ -66,7 +69,8 @@ report_info(
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
 
 		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
-		"", geo.sectsize, attrversion,
+		"", geo.sectsize, attrversion, projid32bit,
+		"", crcs_enabled,
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
@@ -115,6 +119,8 @@ main(int argc, char **argv)
 	char			*rtdev;	/*   RT device name */
 	fs_path_t		*fs;	/* mount point information */
 	libxfs_init_t		xi;	/* libxfs structure */
+	int			projid32bit;
+	int			crcs_enabled;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -234,10 +240,12 @@ main(int argc, char **argv)
 	attrversion = geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
 			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
 	ci = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
+	projid32bit = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
+	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
-				attrversion, ci);
+				attrversion, projid32bit, crcs_enabled, ci);
 		exit(0);
 	}
 
@@ -274,7 +282,7 @@ main(int argc, char **argv)
 
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
-			attrversion, ci);
+			attrversion, projid32bit, crcs_enabled, ci);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 1cc1aa0..44b69e7 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
 #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
+#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 
 
 /*
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9987dde..bb5d8d4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2424,7 +2424,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-5u\n"
+		   "         =%-22s crc=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
