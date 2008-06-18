Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 09:33:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IGX0p9007596
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:33:00 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8093C17E1173
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:33:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 7g44ArIiV60mDTR1 for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:33:57 -0700 (PDT)
Date: Wed, 18 Jun 2008 12:33:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Directory mtime update issue (kernel 2.6.25)
Message-ID: <20080618163356.GA6330@infradead.org>
References: <20080618144534.GC11301@aurora.pimp.org.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618144534.GC11301@aurora.pimp.org.za>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael-John Turner <mj@mjturner.net>
Cc: xfs@oss.sgi.com

On Wed, Jun 18, 2008 at 03:45:34PM +0100, Michael-John Turner wrote:
> Hi all,
> 
> I'm a recent convert to XFS and am experiencing something that I consider
> rather odd. When I move a directory on the same filesystem, XFS updates the
> directory's mtime, which is something I wouldn't expect to happen. I tested
> the same set of commands on a tmpfs filesystem and the renamed directory's
> mtime doesn't change. Similarly, when I move a file between directories on
> an XFS filesystem, the file's mtime doesn't change (as expected).
> 
> Is this behaviour correct? I'm running Linux kernel 2.6.25.6 on an x86_64
> system, filesystem mounted with the standard options (see below).

Posix says about rename(2):

Upon successful completion, rename() shall mark for update the st_ctime
and st_mtime fields of the parent directory of each file.

It doesn't mention anything about timestampt updates on the renamed
file nor the victim.  Ext2 and friends update ctime on the renamed
inode and victim and have this comment:

/*
 * Like most other Unix systems, set the ctime for inodes on a
 * rename.
 * inode_dec_link_count() will mark the inode dirty.
 */

XFS does indeed updated the mtime too for the case when the source is
a directory and we get a new parent but just the ctime in all other
cases, which seems highly dubious to me.

XFS also has an interesting comment on why ctime is updated at all:

		/*      
		 * We always want to hit the ctime on the source inode.
		 * We do it in the if clause above for the 'new_parent &&
		 * src_is_directory' case, and here we get all the other
		 * cases.  This isn't strictly required by the standards
		 * since the source inode isn't really being changed,
		 * but old unix file systems did it and some incremental
		 * backup programs won't work without it.
		 */

Below is an untested patch to always just update the ctime:


Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-06-18 18:24:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-06-18 18:30:17.000000000 +0200
@@ -336,22 +336,18 @@ xfs_rename(
 		ASSERT(error != EEXIST);
 		if (error)
 			goto abort_return;
-		xfs_ichgtime(src_ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	} else {
-		/*
-		 * We always want to hit the ctime on the source inode.
-		 * We do it in the if clause above for the 'new_parent &&
-		 * src_is_directory' case, and here we get all the other
-		 * cases.  This isn't strictly required by the standards
-		 * since the source inode isn't really being changed,
-		 * but old unix file systems did it and some incremental
-		 * backup programs won't work without it.
-		 */
-		xfs_ichgtime(src_ip, XFS_ICHGTIME_CHG);
 	}
 
 	/*
+	 * We always want to hit the ctime on the source inode.
+	 *
+	 * This isn't strictly required by the standards since the source
+	 * inode isn't really being changed, but old unix file systems did
+	 * it and some incremental backup programs won't work without it.
+	 */
+	xfs_ichgtime(src_ip, XFS_ICHGTIME_CHG);
+
+	/*
 	 * Adjust the link count on src_dp.  This is necessary when
 	 * renaming a directory, either within one parent when
 	 * the target existed, or across two parent directories.
