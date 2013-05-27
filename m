Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 504B929E07
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:38:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1A47AC006
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:38:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	arcL7OzGBfYa41Ic for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 23:38:48 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugr4p-0008FW-Lz
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugr4f-0003x3-J5
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfs: don't emit v5 superblock warnings on write
Date: Mon, 27 May 2013 16:38:19 +1000
Message-Id: <1369636707-15150-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

We write the superblock every 30s or so which results in the
verifier being called. Right now that results in this output
every 30s:

XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
Use of these features in this kernel is at your own risk!

And spamming the logs.

We don't need to check for whether we support v5 superblocks or
whether there are feature bits we don't support set as these are
only relevant when we first mount the filesytem. i.e. on superblock
read. Hence for the write verification we can just skip all the
checks (and hence verbose output) altogether.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f6bfbd7..e8e310c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -314,7 +314,8 @@ STATIC int
 xfs_mount_validate_sb(
 	xfs_mount_t	*mp,
 	xfs_sb_t	*sbp,
-	bool		check_inprogress)
+	bool		check_inprogress,
+	bool		check_version)
 {
 
 	/*
@@ -337,9 +338,10 @@ xfs_mount_validate_sb(
 
 	/*
 	 * Version 5 superblock feature mask validation. Reject combinations the
-	 * kernel cannot support up front before checking anything else.
+	 * kernel cannot support up front before checking anything else. For
+	 * write validation, we don't need to check feature masks.
 	 */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
 		xfs_alert(mp,
 "Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!\n"
 "Use of these features in this kernel is at your own risk!");
@@ -675,7 +677,8 @@ xfs_sb_to_disk(
 
 static int
 xfs_sb_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf	*bp,
+	bool		check_version)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
@@ -686,7 +689,8 @@ xfs_sb_verify(
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
 	 */
-	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR);
+	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR,
+				     check_version);
 }
 
 /*
@@ -719,7 +723,7 @@ xfs_sb_read_verify(
 			goto out_error;
 		}
 	}
-	error = xfs_sb_verify(bp);
+	error = xfs_sb_verify(bp, true);
 
 out_error:
 	if (error) {
@@ -758,7 +762,7 @@ xfs_sb_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	int			error;
 
-	error = xfs_sb_verify(bp);
+	error = xfs_sb_verify(bp, false);
 	if (error) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
