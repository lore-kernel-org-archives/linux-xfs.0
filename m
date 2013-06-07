Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA83B7F77
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6B76304077
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	b10o1fA9FH1jKT8V for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkvjQ-0005TY-Ob
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkvjQ-00031l-LE
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/12] xfs: don't emit v5 superblock warnings on write
Date: Fri,  7 Jun 2013 22:25:01 +1000
Message-Id: <1370607901-11538-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_mount.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index e7e7445..db3785d 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -120,7 +120,8 @@ STATIC int
 xfs_mount_validate_sb(
 	xfs_mount_t	*mp,
 	xfs_sb_t	*sbp,
-	bool		check_inprogress)
+	bool		check_inprogress,
+	bool		check_version)
 {
 
 	/*
@@ -145,7 +146,7 @@ xfs_mount_validate_sb(
 	 * Version 5 superblock feature mask validation. Reject combinations the
 	 * kernel cannot support up front before checking anything else.
 	 */
-	if (check_inprogress && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
 		xfs_alert(mp,
 "Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!\n"
 "Use of these features is at your own risk!");
@@ -370,7 +371,7 @@ xfs_sb_to_disk(
 static int
 xfs_sb_verify(
 	struct xfs_buf	*bp,
-	bool		verbose)
+	bool		check_version)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
@@ -381,8 +382,8 @@ xfs_sb_verify(
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
 	 */
-	return xfs_mount_validate_sb(mp, &sb,
-				     verbose && bp->b_bn == XFS_SB_DADDR);
+	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR,
+				     check_version);
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
