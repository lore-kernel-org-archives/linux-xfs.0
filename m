Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0J68i069768 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:19:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 646E11C78F7D
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:20:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	2yP8lxHjf5NqQP6e for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:20:46 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	2734099-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:50:45 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMrU3-0000VY-QL
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMrTo-00049i-LC
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: delayed alloc blocks beyond EOF are valid after
	writeback
Date: Mon, 29 Nov 2010 11:20:22 +1100
Message-Id: <1290990024-15898-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1290990024-15898-1-git-send-email-david@fromorbit.com>
References: <1290990024-15898-1-git-send-email-david@fromorbit.com>
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

There is an assumption in the parts of XFS that flushing a dirty
file will make all the delayed allocation blocks disappear from an
inode. That is, that after calling xfs_flush_pages() then
ip->i_delayed_blks will be zero.

This is an invalid assumption as we may have specualtive
preallocation beyond EOF and they are recorded in
ip->i_delayed_blks. A flush of the dirty pages of an inode will not
change the state of these blocks beyond EOF, so a non-zero
deeelalloc block count after a flush is valid.

The bmap code has an invalid ASSERT() that needs to be removed, and
the swapext code has a bug in that while it swaps the data forks
around, it fails to swap the i_delayed_blks counter associated with
the fork and hence can get the block accounting wrong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c  |    9 +++++++--
 fs/xfs/xfs_dfrag.c |   13 +++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 08b179f..4111cd3 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5471,8 +5471,13 @@ xfs_getbmap(
 			if (error)
 				goto out_unlock_iolock;
 		}
-
-		ASSERT(ip->i_delayed_blks == 0);
+		/*
+		 * even after flushing the inode, there can still be delalloc
+		 * blocks on the inode beyond EOF due to speculative
+		 * preallocation. These are not removed until the release
+		 * function is called or the inode is inactivated. Hence we
+		 * cannot assert here that ip->i_delayed_blks == 0.
+		 */
 	}
 
 	lock = xfs_ilock_map_shared(ip);
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 3b9582c..e60490b 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -377,6 +377,19 @@ xfs_swap_extents(
 	ip->i_d.di_format = tip->i_d.di_format;
 	tip->i_d.di_format = tmp;
 
+	/*
+	 * The extents in the source inode could still contain speculative
+	 * preallocation beyond EOF (e.g. the file is open but not modified
+	 * while defrag is in progress). In that case, we need to copy over the
+	 * number of delalloc blocks the data fork in the source inode is
+	 * tracking beyond EOF so that when the fork is truncated away when the
+	 * temporary inode is unlinked we don't underrun the i_delayed_blks
+	 * counter on that inode.
+	 */
+	ASSERT(tip->i_delayed_blks == 0);
+	tip->i_delayed_blks = ip->i_delayed_blks;
+	ip->i_delayed_blks = 0;
+
 	ilf_fields = XFS_ILOG_CORE;
 
 	switch(ip->i_d.di_format) {
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
