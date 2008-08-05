Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:36:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m757a8RH013247
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:36:08 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A607E35CE61
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 00:37:21 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 7i03jcvdICXypBot for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 00:37:21 -0700 (PDT)
Date: Tue, 5 Aug 2008 17:37:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
Message-ID: <20080805073711.GA21635@disturbed>
References: <4897F691.6010806@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897F691.6010806@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
> Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
> gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O

xfs_free()? What's that?

> completions still running (file size updates and unwritten extent conversions)
> may be working on an inode that is no longer valid.

The linux inode does not get freed until after ->clear_inode
completes, hence it is perfectly valid to reference it anywhere
in the ->clear_inode path.

My bet is that you are seeing I/O completion mark an inode dirty
that is being freed. ie.  Calling mark_inode_dirty_sync() in the I/O
completion blindly assumes that the linux inode is still valid, 
when it may be in the 'being freed' path. e.g. we can put it back on the
superblock dirty list just before it gets freed for real...

I came across this about a week ago when tracking down a QA failure
with a combined linux/XFS inode patch. The fix is to make I/O
completion call xfs_mark_inode_dirty_sync() so we check that this
linux inode not in the process of being freed before we try to
mark it dirty.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Never call mark_inode_dirty_sync() directly

Once the Linux inode and the XFS inode are combined, we cannot rely
on just checking if the linux inode exists as a method of determining
if it is valid or not. Hence we should always call
xfs_mark_inode_dirty_sync() as it does the correct checks to
determine if the linux inode is in a valid state or not before
marking it dirty.

---
 fs/xfs/linux-2.6/xfs_aops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c  |    4 ++--
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 0b211cb..45c53a7 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -192,7 +192,7 @@ xfs_setfilesize(
 		ip->i_d.di_size = isize;
 		ip->i_update_core = 1;
 		ip->i_update_size = 1;
-		mark_inode_dirty_sync(ioend->io_inode);
+		xfs_mark_inode_dirty_sync(ip);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 1240b73..379f19b 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -133,7 +133,7 @@ xfs_ichgtime(
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
 	if (!(inode->i_state & I_NEW))
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(ip);
 }
 
 /*
@@ -178,7 +178,7 @@ xfs_ichgtime_fast(
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
 	if (!(inode->i_state & I_NEW))
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(ip);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index fc00499..e9cb0e9 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -963,7 +963,7 @@ xfs_fs_write_inode(
 	 * it dirty again so we'll try again later.
 	 */
 	if (error)
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(XFS_I(inode));
 
 	return -error;
 }
