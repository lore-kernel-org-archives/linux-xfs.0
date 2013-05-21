Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2965029DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 03:02:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 172D98F8039
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 01:02:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9D22blVP4u9Yygql for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 01:02:22 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/11] xfs: don't emit v5 superblock warnings on write
Date: Tue, 21 May 2013 18:02:07 +1000
Message-Id: <1369123330-9579-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1369123330-9579-1-git-send-email-david@fromorbit.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

We write the superblock every 30s or so which results in the
verifier being called. Right now that results in this output
every 30s:

XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
Use of these features in this kernel is at your own risk!

And spamming the logs. Stop this output from occurring on superblock
writes.

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
