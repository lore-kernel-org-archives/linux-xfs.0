Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C11337FA3
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0209304087
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1dnt8RRTtahgaJSq for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:59 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkW9-0003wE-D4
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkW9-0001Me-AC
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 39/48] mkfs.xfs: validate options for CRCs up front.
Date: Fri,  7 Jun 2013 10:26:02 +1000
Message-Id: <1370564771-4929-40-git-send-email-david@fromorbit.com>
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

With CRC enabled filesystems, certain options are now not optional
and so are always enabled. Validate these options up front and
abort if options are specified that cannot be set.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 291bab4..9987dde 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -870,7 +870,7 @@ main(
 	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
 	int			attrversion;
-	int			projid32bit;
+	int			projid16bit;
 	struct xfs_btree_block	*block;
 	int			blflag;
 	int			blocklog;
@@ -966,7 +966,7 @@ main(
 	textdomain(PACKAGE);
 
 	attrversion = 2;
-	projid32bit = 0;
+	projid16bit = 0;
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
@@ -1310,7 +1310,7 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "i projid32bit");
-					projid32bit = c;
+					projid16bit = c ? 0 : 1;
 					break;
 				default:
 					unknown('i', value);
@@ -1754,6 +1754,57 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 		logversion = 2;
 	}
 
+	/*
+	 * Now we have blocks and sector sizes set up, check parameters that are
+	 * no longer optional for CRC enabled filesystems.  Catch them up front
+	 * here before doing anything else.
+	 */
+	if (crcs_enabled) {
+		/* minimum inode size is 512 bytes, ipflag checked later */
+		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+			fprintf(stderr,
+_("Minimum inode size for CRCs is %d bytes\n"),
+				1 << XFS_DINODE_DFL_CRC_LOG);
+			usage();
+		}
+
+		/* inodes always aligned */
+		if (iaflag != 1) {
+			fprintf(stderr,
+_("Inodes always aligned for CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* lazy sb counters always on */
+		if (lazy_sb_counters != 1) {
+			fprintf(stderr,
+_("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* version 2 logs always on */
+		if (logversion != 2) {
+			fprintf(stderr,
+_("V2 logs always enabled for CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* attr2 always on */
+		if (attrversion != 2) {
+			fprintf(stderr,
+_("V2 attribute format always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* 32 bit project quota always on */
+		/* attr2 always on */
+		if (projid16bit == 1) {
+			fprintf(stderr,
+_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+	}
+
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
@@ -2381,7 +2432,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, attrversion, projid32bit,
+			"", sectorsize, attrversion, !projid16bit,
 			"", crcs_enabled,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
@@ -2449,7 +2500,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		sbp->sb_logsectsize = 0;
 	}
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
-					attrversion == 2, projid32bit == 1, 0);
+					attrversion == 2, !projid16bit, 0);
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
 					dsunit != 0,
 					logversion == 2, attrversion == 1,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
