Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A838229E07
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 02:15:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95F79304039
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 00:15:24 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yXFstJsmfSEDFv8X for <xfs@oss.sgi.com>;
	Mon, 27 May 2013 00:15:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugrdy-0008LC-Jb
	for xfs@oss.sgi.com; Mon, 27 May 2013 17:14:58 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugrdy-0006Tr-Ej
	for xfs@oss.sgi.com; Mon, 27 May 2013 17:14:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] mkfs.xfs: validate options for CRCs up front.
Date: Mon, 27 May 2013 17:14:53 +1000
Message-Id: <1369638896-24872-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1369638896-24872-1-git-send-email-david@fromorbit.com>
References: <1369312565-6266-1-git-send-email-david@fromorbit.com>
	<1369638896-24872-1-git-send-email-david@fromorbit.com>
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
 mkfs/xfs_mkfs.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 291bab4..dad7dab 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1476,6 +1476,7 @@ main(
 					if (c < 0 || c > 1)
 						illegal(value, "m crc");
 					crcs_enabled = c;
+					projid32bit = 1;
 					break;
 				default:
 					unknown('m', value);
@@ -1754,6 +1755,57 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
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
+		if (projid32bit != 1) {
+			fprintf(stderr,
+_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+	}
+
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
