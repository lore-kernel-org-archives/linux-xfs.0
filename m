Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2Z6V1005196 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:35:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0D6D19D2E38
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:36:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	McKzSP0xOtCIYNiC for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:36:40 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16902647-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:06:39 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr0AX-00016n-W2
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:36:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr0AV-0002yG-Av
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:36:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't warn about page discards on shutdown
Date: Mon, 15 Mar 2010 13:36:35 +1100
Message-Id: <1268620595-11389-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

If we are doing a forced shutdown, we can get lots of noise about
delalloc pages being discarded. This is happens by design during a
forced shutdown, so don't spam the logs with these messages.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 9083357..9962850 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -932,6 +932,9 @@ xfs_aops_discard_page(
 	if (!xfs_is_delayed_page(page, IOMAP_DELAY))
 		goto out_invalidate;
 
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		goto out_invalidate;
+
 	xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
 		"page discard on page %p, inode 0x%llx, offset %llu.",
 			page, ip->i_ino, offset);
@@ -964,8 +967,10 @@ xfs_aops_discard_page(
 
 		if (error) {
 			/* something screwed, just bail */
-			xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
-			"page discard failed delalloc mapping lookup.");
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+				"page discard failed delalloc mapping lookup.");
+			}
 			break;
 		}
 		if (!nimaps) {
@@ -991,8 +996,10 @@ xfs_aops_discard_page(
 		ASSERT(!flist.xbf_count && !flist.xbf_first);
 		if (error) {
 			/* something screwed, just bail */
-			xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
 			"page discard unable to remove delalloc mapping.");
+			}
 			break;
 		}
 next_buffer:
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
