Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 23:20:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S6Jt2o008578
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 23:19:57 -0700
Date: Mon, 28 Apr 2008 16:20:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Don't initialise new inode generation numbers to zero V2
Message-ID: <20080428062032.GI103491721@sgi.com>
References: <20080422015806.GU108924158@sgi.com> <480D641B.8060301@melbourne.sgi.com> <20080422050447.GV103491721@sgi.com> <20080425085750.GA6395@infradead.org> <20080428031120.GD103491721@sgi.com> <20080428055922.GD3192@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428055922.GD3192@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Greg Banks <gnb@melbourne.sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 28, 2008 at 01:59:22AM -0400, Christoph Hellwig wrote:
> On Mon, Apr 28, 2008 at 01:11:20PM +1000, David Chinner wrote:
> > Ok, so is random32() good enough or does it need to be get_random_int()?
> 
> I'm not sure offhand what random32 actually is, but a not
> cryptographically strong random number should be enough.

>From lib/random32.c:

  This is a maximally equidistributed combined Tausworthe generator
  based on code from GNU Scientific Library 1.5 (30 Jun 2004)

   x_n = (s1_n ^ s2_n ^ s3_n)

   s1_{n+1} = (((s1_n & 4294967294) <<12) ^ (((s1_n <<13) ^ s1_n) >>19))
   s2_{n+1} = (((s2_n & 4294967288) << 4) ^ (((s2_n << 2) ^ s2_n) >>25))
   s3_{n+1} = (((s3_n & 4294967280) <<17) ^ (((s3_n << 3) ^ s3_n) >>11))

   The period of this generator is about 2^88.

   From: P. L'Ecuyer, "Maximally Equidistributed Combined Tausworthe
   Generators", Mathematics of Computation, 65, 213 (1996), 203--213.

-----

And uses per-cpu state to for the next number. Should be good enough.

Patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---

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

Version 3:
o use random32 rather than get_random_int() as cryptographically
  secure random numbers are not really necessary here.

Version 2:
o remove persistent per-AGI agi_newinogen field and replace with
  randomly generated 32 bit number for each new cluster. This prevents
  NFS clients from potentially guessing what the next generation
  number is going to be and removes the need for persistent numbers on
  disk.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_ialloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2008-04-28 16:12:57.376445802 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2008-04-28 16:15:04.427919630 +1000
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
+	 * number from easily guessable.
+	 */
+	gen = random32();
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
