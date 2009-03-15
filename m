Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBlIoQ008379 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:47:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B99E419A0DE
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail09.adl2.internode.on.net
	[203.16.214.73]) by cuda.sgi.com with ESMTP id ygvAPB6UxrxtD87e
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	58261949-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:53 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006nN-Od
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] [XFS] Factor out inode validation for reclaim
Date: Sun, 15 Mar 2009 22:46:41 +1100
Message-Id: <1237117603-26071-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1237117603-26071-1-git-send-email-david@fromorbit.com>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
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

Separate the validation of inodes found by the radix
tree walk from the radix tree lookup.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index a83438a..1fa29de 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -711,6 +711,18 @@ xfs_inode_clear_reclaim_tag(
 	xfs_put_perag(mp, pag);
 }
 
+static int
+xfs_reclaim_inode_valid(
+	xfs_mount_t	*mp,
+	xfs_inode_t	*ip)
+{
+	ASSERT(xfs_iflags_test(ip, (XFS_IRECLAIMABLE|XFS_IRECLAIM)));
+
+	/* ignore if already under reclaim */
+	if (xfs_iflags_test(ip, XFS_IRECLAIM))
+		return -ENOENT;
+	return 0;
+}
 
 STATIC void
 xfs_reclaim_inodes_ag(
@@ -729,6 +741,8 @@ restart:
 	first_index = 0;
 	skipped = 0;
 	do {
+		int	error;
+
 		/*
 		 * use a gang lookup to find the next inode in the tree
 		 * as the tree is sparse and a gang lookup walks to find
@@ -756,8 +770,8 @@ restart:
 			break;
 		}
 
-		/* ignore if already under reclaim */
-		if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		error = xfs_reclaim_inode_valid(mp, ip);
+		if (error) {
 			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
