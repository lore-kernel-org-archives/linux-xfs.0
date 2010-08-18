Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBaDR6110432 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:36:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 045791E4AE00
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:36:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	90xjb2cz62RfDvko for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:36:41 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	35775345-1927428
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 21:06:40 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Olgwh-0005Kr-2m
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:39 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Olgwd-0007o0-4e
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: ensure f_ffree returned by statfs() is non-negative
Date: Wed, 18 Aug 2010 21:36:16 +1000
Message-Id: <1282131379-29932-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1282131379-29932-1-git-send-email-david@fromorbit.com>
References: <1282131379-29932-1-git-send-email-david@fromorbit.com>
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

From: Stuart Brodsky <sbrodsky@sgi.com>

Because of delayed updates to sb_icount field in the super block, it
is possible to allocate over maxicount number of inodes.  This
causes the arithmetic to calculate a negative number of free inodes
in user commands like df or stat -f.

Since maxicount is a somewhat arbitrary number, a slight over
allocation is not critical but user commands should be displayed as
0 or greater and never go negative.  To do this the value in the
stats buffer f_ffree is capped to never go negative.

[ Modified to use max_t as per Christoph's comment. ]

Signed-off-by: Stu Brodsky <sbrodsky@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index d09cd14..a4e0797 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1226,6 +1226,7 @@ xfs_fs_statfs(
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
 	__uint64_t		fakeinos, id;
 	xfs_extlen_t		lsize;
+	__int64_t		ffree;
 
 	statp->f_type = XFS_SB_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
@@ -1249,7 +1250,11 @@ xfs_fs_statfs(
 		statp->f_files = min_t(typeof(statp->f_files),
 					statp->f_files,
 					mp->m_maxicount);
-	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+
+	/* make sure statp->f_ffree does not underflow */
+	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+	statp->f_ffree = max_t(__int64_t, ffree, 0);
+
 	spin_unlock(&mp->m_sb_lock);
 
 	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
