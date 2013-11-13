Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99D567F69
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80292304066
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3xzs3ceL1pfrmXOE for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:25 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADFuPXV015056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADFuPh8001420
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 19/20] xfsprogs/growfs: report finobt status in fs geometry
	(xfs_info)
Date: Wed, 13 Nov 2013 10:56:21 -0500
Message-Id: <1384358182-37967-20-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
References: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
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

Check and report on the free inode btree status bit in the fs
geometry.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 growfs/xfs_growfs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 2df68fb..87f689f 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -56,12 +56,13 @@ report_info(
 	int		projid32bit,
 	int		crcs_enabled,
 	int		cimode,
-	int		ftype_enabled)
+	int		ftype_enabled,
+	int		finobt_enabled)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
 	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-	    "         =%-22s crc=%u\n"
+	    "         =%-22s crc=%-8u finobt=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
 	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -71,7 +72,7 @@ report_info(
 
 		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
 		"", geo.sectsize, attrversion, projid32bit,
-		"", crcs_enabled,
+		"", crcs_enabled, finobt_enabled,
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
@@ -123,6 +124,7 @@ main(int argc, char **argv)
 	int			projid32bit;
 	int			crcs_enabled;
 	int			ftype_enabled = 0;
+	int			finobt_enabled;	/* free inode btree */
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -245,11 +247,12 @@ main(int argc, char **argv)
 	projid32bit = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
 	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
 	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
+	finobt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FINOBT ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
-				ftype_enabled);
+				ftype_enabled, finobt_enabled);
 		exit(0);
 	}
 
@@ -286,7 +289,8 @@ main(int argc, char **argv)
 
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
-			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled);
+			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
+			finobt_enabled);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
