Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7OLrx7r113455 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 16:53:59 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 2/3] xfsprogs: xfs_quota: don't double project block counts
Date: Wed, 24 Aug 2011 16:53:42 -0500
Message-Id: <e874ff01906d10e2ff4812b6badcc246f6a43af4.1314222483.git.aelder@sgi.com>
In-Reply-To: <1314222823-24101-1-git-send-email-aelder@sgi.com>
References: <1314222823-24101-1-git-send-email-aelder@sgi.com>
In-Reply-To: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
References: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

In projects_free_space_data() all of the block counts returned are
doubled.  This was probably a mistaken attempt to convert to or from
512-byte basic block units.  The caller expects the value returned
to be in 512-byte units, which is exactly what the fs_disk_quota
structure holds, so there should be no doubling.

The effect of this bug is that the disk space used by the "df"
xfs_quota command shows block counts twice what they should be.

SGI PV 1015651

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 quota/free.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/quota/free.c b/quota/free.c
index 26ec293..71a7cb2 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -41,6 +41,10 @@ free_help(void)
 "\n"));
 }
 
+/*
+ * The data and realtime block counts returned (count, used, and
+ * free) are all in basic block units.
+ */
 static int
 mount_free_space_data(
 	struct fs_path		*mount,
@@ -104,6 +108,10 @@ mount_free_space_data(
 	return 1;
 }
 
+/*
+ * The data and realtime block counts returned (count, used, and
+ * free) are all in basic block units.
+ */
 static int
 projects_free_space_data(
 	struct fs_path		*path,
@@ -173,10 +181,10 @@ projects_free_space_data(
 	}
 
 	if (d.d_blk_softlimit) {
-		*bcount = d.d_blk_softlimit << 1;
-		*bfree = (d.d_blk_softlimit - d.d_bcount) << 1;
+		*bcount = d.d_blk_softlimit;
+		*bfree = (d.d_blk_softlimit - d.d_bcount);
 	}
-	*bused = d.d_bcount << 1;
+	*bused = d.d_bcount;
 
 	if (d.d_ino_softlimit) {
 		*icount = d.d_ino_softlimit;
@@ -185,10 +193,10 @@ projects_free_space_data(
 	*iused = d.d_icount;
 
 	if (d.d_rtb_softlimit) {
-		*rcount = d.d_rtb_softlimit << 1;
-		*rfree = (d.d_rtb_softlimit - d.d_rtbcount) << 1;
+		*rcount = d.d_rtb_softlimit;
+		*rfree = (d.d_rtb_softlimit - d.d_rtbcount);
 	}
-	*rused = d.d_rtbcount << 1;
+	*rused = d.d_rtbcount;
 
 	close(fd);
 	return 1;
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
