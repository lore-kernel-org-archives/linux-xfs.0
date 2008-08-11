Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 09:38:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7BGcLkB024791
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 09:38:23 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95AC0381BB4
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 09:39:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id CkfskiuL5EB7HDx0 for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 09:39:37 -0700 (PDT)
Date: Mon, 11 Aug 2008 12:39:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20080811163937.GA13472@infradead.org>
References: <1216558002-838-1-git-send-email-david@fromorbit.com> <20080721075449.GB6692@infradead.org> <20080721110814.GC6761@disturbed> <20080721115228.GA14077@infradead.org> <20080721120440.GE6761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721120440.GE6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 10:04:40PM +1000, Dave Chinner wrote:
> > Indeed. The patch looks good but a little description like the one above
> > in the commit message would be nice.
> 
> Updated patch below.

Missing the needed xfsidbg changes.  Updated version below:

Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-08-11 13:02:32.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-08-11 13:36:50.000000000 -0300
@@ -230,7 +230,6 @@ typedef struct xfs_inode {
 	unsigned short		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
 	unsigned char		i_update_size;	/* di_size field is dirty */
-	unsigned int		i_gen;		/* generation count */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-08-11 13:02:32.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-08-11 13:36:50.000000000 -0300
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
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-08-11 13:02:32.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-08-11 13:36:50.000000000 -0300
@@ -1625,8 +1625,6 @@ xfs_create(
 		xfs_trans_set_sync(tp);
 	}
 
-	dp->i_gen++;
-
 	/*
 	 * Attach the dquot(s) to the inodes and modify them incore.
 	 * These ids of the inode couldn't have changed since the new
@@ -1985,13 +1983,6 @@ xfs_remove(
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
@@ -2009,8 +2000,8 @@ xfs_remove(
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
@@ -2170,7 +2161,6 @@ xfs_link(
 	if (error)
 		goto abort_return;
 	xfs_ichgtime(tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	tdp->i_gen++;
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	error = xfs_bumplink(tp, sip);
@@ -2347,18 +2337,10 @@ xfs_mkdir(
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
@@ -2645,13 +2627,6 @@ xfs_symlink(
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
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-08-11 13:02:32.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-08-11 13:36:50.000000000 -0300
@@ -3633,7 +3633,6 @@ xfs_prdinode_incore(xfs_icdinode_t *dip)
 		xfs_fmtformat((xfs_dinode_fmt_t)dip->di_aformat),
 		dip->di_dmevmask, dip->di_dmstate);
 	printflags(dip->di_flags, diflags, "flags");
-	kdb_printf("gen 0x%x\n", dip->di_gen);
 }
 
 #ifdef XFS_RW_TRACE
@@ -6385,11 +6384,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	kdb_printf("\n");
 	kdb_printf("update_core %d update size %d\n",
 		(int)(ip->i_update_core), (int) ip->i_update_size);
-	kdb_printf("gen 0x%x delayed blks %d",
-		ip->i_gen,
-		ip->i_delayed_blks);
-	kdb_printf("size %lld\n",
-		ip->i_size);
+	kdb_printf("delayed blks %d size %lld\n",
+		ip->i_delayed_blks, ip->i_size);
 
 #ifdef	XFS_INODE_TRACE
 	qprintf(" trace 0x%p\n", ip->i_trace);
