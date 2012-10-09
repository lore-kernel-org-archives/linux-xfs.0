Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99JJi9M090955 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:19:44 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id N1yTpOtJEdpG5k7f for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:21:14 -0700 (PDT)
Message-ID: <5074792A.2080509@sandeen.net>
Date: Tue, 09 Oct 2012 14:21:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsprogs: report projid32 status in growfs output
References: <50747753.6040105@redhat.com>
In-Reply-To: <50747753.6040105@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

With the projid32 flag now in the FSGEOM ioctl results we
can report projid32 status in xfs_growfs / xfs_info output,
to match the mkfs.xfs output.

However, since the flag was only recently added to the kernel,
we may get some incorrect reports of "projid32bit=0"

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

... and I don't know how big a problem those incorrect reports
might be ...

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a6d298b..ca5adcf 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -62,11 +62,12 @@ report_info(
 	int		dirversion,
 	int		logversion,
 	int		attrversion,
-	int		cimode)
+	int		cimode,
+	int		projid32)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
-	    "         =%-22s sectsz=%-5u attr=%u\n"
+	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
 	    "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
@@ -75,7 +76,7 @@ report_info(
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
 
 		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
-		"", geo.sectsize, attrversion,
+		"", geo.sectsize, attrversion, projid32,
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
@@ -117,6 +118,7 @@ main(int argc, char **argv)
 	long long		rsize;	/* new rt size in fs blocks */
 	int			ci;	/* ASCII case-insensitive fs */
 	int			lazycount; /* lazy superblock counters */
+	int			projid32; /* 32-bit project IDs */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
 	char			*datadev; /* data device name */
@@ -243,10 +245,11 @@ main(int argc, char **argv)
 	attrversion = geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
 			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
 	ci = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
+	projid32 = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
-				attrversion, ci);
+				attrversion, ci, projid32);
 		exit(0);
 	}
 
@@ -283,7 +286,7 @@ main(int argc, char **argv)
 
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
-			attrversion, ci);
+			attrversion, ci, projid32);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
