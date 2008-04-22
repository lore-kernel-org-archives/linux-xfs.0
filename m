Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 18:57:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M1vWXB018318
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 18:57:35 -0700
Date: Tue, 22 Apr 2008 11:58:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Don't initialise new inode generation numbers to zero V2
Message-ID: <20080422015806.GU108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, gnb@sgi.com

Don't initialise new inode generation numbers to zero

When we allocation new inode chunks, we initialise the generation
numbers to zero. This works fine until we delete a chunk and then
reallocate it, resulting in the same inode numbers but with a
reset generation count. This can result in inode/generation
pairs of different inodes occurring relatively close together.

Given that the inode/gen pair makes up the "unique" portion of
an NFS filehandle on XFS, this can result in file handles cached
on clients being seen on the wire from the server but refer to
a different file. This causes .... issues for NFS clients.

Hence we need a unique generation number initialisation for
each inode to prevent reuse of a small portion of the generation
number space. Make this initialiser per-allocation group so
that it is not a single point of contention in the filesystem,
and increment it on every allocation within an AG to reduce the
chance that a generation number is reused for a given inode number
if the inode chunk is deleted and reallocated immediately
afterwards.

Version 2:
o remove persistent per-AGI agi_newinogen field and replace with
  randomly generated 32 bit number for each new cluster. This prevents
  NFS clients from potentially guessing what the next generation
  number is going to be.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 drivers/char/random.c |    1 +
 fs/xfs/xfs_ialloc.c   |   10 ++++++++++
 2 files changed, 11 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2008-04-21 09:48:39.279043874 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2008-04-21 10:14:07.242106131 +1000
@@ -147,6 +147,7 @@ xfs_ialloc_ag_alloc(
 	int		version;	/* inode version number to use */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
+	unsigned int	gen;
 
 	args.tp = tp;
 	args.mp = tp->t_mountp;
@@ -290,6 +291,14 @@ xfs_ialloc_ag_alloc(
 	else
 		version = XFS_DINODE_VERSION_1;
 
+	/*
+	 * Seed the new inode cluster with a random generation number. This
+	 * prevents short-term reuse of generation numbers if a chunk is
+	 * freed and then immediately reallocated. We use random numbers
+	 * rather than a linear progression to prevent the next generation
+	 * number from being guessable.
+	 */
+	gen = get_random_int();
 	for (j = 0; j < nbufs; j++) {
 		/*
 		 * Get the block.
@@ -309,6 +318,7 @@ xfs_ialloc_ag_alloc(
 			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
 			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_core.di_version = version;
+			free->di_core.di_gen = cpu_to_be32(gen);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			xfs_ialloc_log_di(tp, fbuf, i,
 				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
Index: 2.6.x-xfs-new/drivers/char/random.c
===================================================================
--- 2.6.x-xfs-new.orig/drivers/char/random.c	2008-03-13 13:05:54.000000000 +1100
+++ 2.6.x-xfs-new/drivers/char/random.c	2008-04-21 10:12:18.464202803 +1000
@@ -1646,6 +1646,7 @@ unsigned int get_random_int(void)
 	 */
 	return secure_ip_id((__force __be32)(current->pid + jiffies));
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
