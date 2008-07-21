Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 05:03:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LC3a37025559
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 05:03:36 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1F7E12E8233
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 05:04:44 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id wrApXEwF8WMbWeQ9 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 05:04:44 -0700 (PDT)
Date: Mon, 21 Jul 2008 22:04:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20080721120440.GE6761@disturbed>
References: <1216558002-838-1-git-send-email-david@fromorbit.com> <20080721075449.GB6692@infradead.org> <20080721110814.GC6761@disturbed> <20080721115228.GA14077@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721115228.GA14077@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 07:52:28AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 21, 2008 at 09:08:14PM +1000, Dave Chinner wrote:
> > On Mon, Jul 21, 2008 at 03:54:49AM -0400, Christoph Hellwig wrote:
> > > On Sun, Jul 20, 2008 at 10:46:42PM +1000, Dave Chinner wrote:
> > > > i_gen is incremented in directory operations when the
> > > > directory is changed. It is never read or otherwise used
> > > > so it should be removed to help reduce the size of the
> > > > struct xfs_inode.
> > > 
> > > It also removes a xfs_trans_log_inode in xfs_remove, which looks
> > > fine to me from a quick glance, but this should be verified and
> > > documented.
> > 
> > If you note in the very next if/else statement the directory inode
> > gets logged - either by dropping the link or directly. IOWs, we
> > were logging the directory inode twice with the same value
> > (XFS_ILOG_CORE). So I don't think there??s any problem here.
> 
> Indeed. The patch looks good but a little description like the one above
> in the commit message would be nice.

Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: remove i_gen from incore inode

i_gen is incremented in directory operations when the
directory is changed. It is never read or otherwise used
so it should be removed to help reduce the size of the
struct xfs_inode.

The patch also removes a duplicate logging of the directory
inode core. We only need to do this once per transaction
so kill the one associated with the i_gen increment.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.h    |    1 -
 fs/xfs/xfs_rename.c   |   12 ++----------
 fs/xfs/xfs_vnodeops.c |   29 ++---------------------------
 3 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 440b443..316c374 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -223,7 +223,6 @@ typedef struct xfs_inode {
 	unsigned short		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
 	unsigned char		i_update_size;	/* di_size field is dirty */
-	unsigned int		i_gen;		/* generation count */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index d700dac..02f0e8f 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -367,19 +367,11 @@ xfs_rename(
 					&first_block, &free_list, spaceres);
 	if (error)
 		goto abort_return;
-	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-	/*
-	 * Update the generation counts on all the directory inodes
-	 * that we're modifying.
-	 */
-	src_dp->i_gen++;
+	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
-
-	if (new_parent) {
-		target_dp->i_gen++;
+	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
-	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 94ec74b..426c574 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1798,8 +1798,6 @@ xfs_create(
 		xfs_trans_set_sync(tp);
 	}
 
-	dp->i_gen++;
-
 	/*
 	 * Attach the dquot(s) to the inodes and modify them incore.
 	 * These ids of the inode couldn't have changed since the new
@@ -2229,13 +2227,6 @@ xfs_remove(
 	}
 	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-	/*
-	 * Bump the in memory generation count on the parent
-	 * directory so that other can know that it has changed.
-	 */
-	dp->i_gen++;
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-
 	if (is_dir) {
 		/*
 		 * Drop the link from ip's "..".
@@ -2253,8 +2244,8 @@ xfs_remove(
 	} else {
 		/*
 		 * When removing a non-directory we need to log the parent
-		 * inode here for the i_gen update.  For a directory this is
-		 * done implicitly by the xfs_droplink call for the ".." entry.
+		 * inode here.  For a directory this is done implicitly
+		 * by the xfs_droplink call for the ".." entry.
 		 */
 		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	}
@@ -2423,7 +2414,6 @@ xfs_link(
 	if (error)
 		goto abort_return;
 	xfs_ichgtime(tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	tdp->i_gen++;
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	error = xfs_bumplink(tp, sip);
@@ -2600,18 +2590,10 @@ xfs_mkdir(
 	}
 	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-	/*
-	 * Bump the in memory version number of the parent directory
-	 * so that other processes accessing it will recognize that
-	 * the directory has changed.
-	 */
-	dp->i_gen++;
-
 	error = xfs_dir_init(tp, cdp, dp);
 	if (error)
 		goto error2;
 
-	cdp->i_gen = 1;
 	error = xfs_bumplink(tp, dp);
 	if (error)
 		goto error2;
@@ -2898,13 +2880,6 @@ xfs_symlink(
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	/*
-	 * Bump the in memory version number of the parent directory
-	 * so that other processes accessing it will recognize that
-	 * the directory has changed.
-	 */
-	dp->i_gen++;
-
-	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
 	 * the user.
