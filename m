Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F2F87F60
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 22:52:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0713F304032
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 20:52:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6vU3LzztUY5AHsbV for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 20:52:30 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yp7Qi-0003S7-3f
	for xfs@oss.sgi.com; Mon, 04 May 2015 13:52:28 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yp7Qi-0006t5-23
	for xfs@oss.sgi.com; Mon, 04 May 2015 13:52:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [V2] mkfs: default to CRC enabled filesystems
Date: Mon,  4 May 2015 13:52:28 +1000
Message-Id: <1430711548-26441-1-git-send-email-david@fromorbit.com>
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

It's time to change the mkfs defaults to enable CRCs for all new
filesystems. While there, also enable the free inode btree by
default, too, as that functionality has also had long enough to make
it into distro kernels, too. Also update the man page to reflect the
change in defaults.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 man/man8/mkfs.xfs.8 |  9 +++++----
 mkfs/xfs_mkfs.c     | 27 +++++++++++++++++----------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index ad9ff3d..e18f6d1 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -150,7 +150,7 @@ of calculating and checking the CRCs is not noticable in normal operation.
 .IP
 By default,
 .B mkfs.xfs
-will not enable metadata CRCs.
+will enable metadata CRCs.
 .TP
 .BI finobt= value
 This option enables the use of a separate free inode btree index in each
@@ -164,10 +164,11 @@ filesystems age.
 .IP
 By default,
 .B mkfs.xfs
-will not create free inode btrees. This feature is also currently only available
-for filesystems created with the
+will create free inode btrees for filesystems created with the (default)
 .B \-m crc=1
-option set.
+option set. When the option
+.B \-m crc=0
+is used, the free inode btree feature is not supported and is disabled.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5084d75..0218491 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1004,6 +1004,7 @@ main(
 	int			lazy_sb_counters;
 	int			crcs_enabled;
 	int			finobt;
+	bool			finobtflag;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1036,8 +1037,9 @@ main(
 	force_overwrite = 0;
 	worst_freelist = 0;
 	lazy_sb_counters = 1;
-	crcs_enabled = 0;
-	finobt = 0;
+	crcs_enabled = 1;
+	finobt = 1;
+	finobtflag = false;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1538,6 +1540,7 @@ _("cannot specify both crc and ftype\n"));
 					if (c < 0 || c > 1)
 						illegal(value, "m finobt");
 					finobt = c;
+					finobtflag = true;
 					break;
 				default:
 					unknown('m', value);
@@ -1878,15 +1881,19 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			usage();
 		}
-	}
-
-	/*
-	 * The kernel doesn't currently support crc=0,finobt=1 filesystems.
-	 * Catch it here, disable finobt and warn the user.
-	 */
-	if (finobt && !crcs_enabled) {
-		fprintf(stderr,
+	} else {
+		/*
+		 * The kernel doesn't currently support crc=0,finobt=1
+		 * filesystems. If crcs are not enabled and the user has
+		 * explicitly turned them off then silently turn them off
+		 * to avoid an unnecessary warning. If the user explicitly
+		 * tried to use crc=0,finobt=1, then issue a warning before
+		 * turning them off.
+		 */
+		if (finobt && finobtflag) {
+			fprintf(stderr,
 _("warning: finobt not supported without CRC support, disabled.\n"));
+		}
 		finobt = 0;
 	}
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
