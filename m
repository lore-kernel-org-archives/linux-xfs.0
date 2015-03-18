Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30DCA7F37
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 18:23:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1144AC005
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 16:23:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	A0TEKP7LwHcjNbrB for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 16:23:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YYNIV-0007Ru-9l
	for xfs@oss.sgi.com; Thu, 19 Mar 2015 10:22:47 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YYNIV-000296-7T
	for xfs@oss.sgi.com; Thu, 19 Mar 2015 10:22:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] mkfs: default to CRC enabled filesystems
Date: Thu, 19 Mar 2015 10:22:47 +1100
Message-Id: <1426720967-8215-1-git-send-email-david@fromorbit.com>
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
default, too, as that functioanlity has also had long enough to make
it into distro kernels, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 484e7a8..d7e70fa 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1024,8 +1024,8 @@ main(
 	force_overwrite = 0;
 	worst_freelist = 0;
 	lazy_sb_counters = 1;
-	crcs_enabled = 0;
-	finobt = 0;
+	crcs_enabled = 1;
+	finobt = 1;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1866,15 +1866,14 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
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
-_("warning: finobt not supported without CRC support, disabled.\n"));
+	} else {
+		/*
+		 * The kernel doesn't currently support crc=0,finobt=1
+		 * filesystems. If crcs are not enabled, the user has
+		 * explicitly turned them off, so just silently turn off finobt
+		 * so that we don't issue unnecessary warnings when non-default
+		 * options are selected.
+		 */
 		finobt = 0;
 	}
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
