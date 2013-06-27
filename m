Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 568747F8C
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 01:05:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41FFE30405F
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 23:05:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wi8P3HMAYNExiDjC for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 23:05:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Us5Kb-0008Hf-UM
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Us5KR-00028p-RJ
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/15] xfs: implement inode change count
Date: Thu, 27 Jun 2013 16:04:59 +1000
Message-Id: <1372313099-8121-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1372313099-8121-1-git-send-email-david@fromorbit.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
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

For CRC enabled filesystems, add support for the monotonic inode
version change counter that is needed by protocols like NFSv4 for
determining if the inode has changed in any way at all between two
unrelated operations on the inode.

This bumps the change count the first time an inode is dirtied in a
transaction. Since all modifications to the inode are logged, this
will catch all changes that are made to the inode, including
timestamp updates that occur during data writes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c       |    4 ++++
 fs/xfs/xfs_trans_inode.c |   11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f59e27f..a1587f9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1482,6 +1482,10 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
+	/* version 5 superblocks support inode version counters. */
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+		sb->s_flags |= MS_I_VERSION;
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index ac6d567..53dfe46 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -112,6 +112,17 @@ xfs_trans_log_inode(
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
+	/*
+	 * First time we log the inode in a transaction, bump the inode change
+	 * counter if it is configured for this to occur.
+	 */
+	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
+	    IS_I_VERSION(VFS_I(ip))) {
+		inode_inc_iversion(VFS_I(ip));
+		ip->i_d.di_changecount = VFS_I(ip)->i_version;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
