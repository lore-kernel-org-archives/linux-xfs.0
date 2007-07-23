Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 22:07:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N56tbm008283
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 22:06:57 -0700
Date: Mon, 23 Jul 2007 15:06:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Allocating inodes from a single block
Message-ID: <20070723050644.GX12413810@sgi.com>
References: <200707231240.23425.david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707231240.23425.david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Michael,

Sorry for taking so long to get back to you on this; this mail
never got through to my @sgi.com account and I only just noticed
it earlier today when trolling my personal email account....

Michael Nishimoto <miken@agami.com> wrote:
> David Chinner wrote:
> >The issue here is not the cluster size - that is purely an in-memory
> >arrangement for reading/writing muliple inodes at once. The issue
> >here is inode *chunks* (as Eric pointed out).
> >
> >Basically, each record in the AGI btree has a 64 bit but-field for
> >indicating whether the inodes in the chunk are used or free and a
> >64bit address of the first block of the inode chunk.
> >
> >It is assumed that all the inodes in the chunk are contiguous as
> >they are addressed in a compressed form - AG #, block # of first inode,
> >inode number in chunk.
> >
> >That means that:
> >
> >	a) the inode size across the entire AG must be fixed
> >	b) the inodes must be allocated in contiguous chunks of
> >	   64 inodes regardless of their size
> >
> >To change this, you need to completely change the AGI format, the
> >inode allocation code and the inode freeing code and all the code that
> >assumes that inodes appear in 64 inode chunks e.g. bulkstat. Then
> >repair, xfs_db, mkfs, check, etc....
> >
> >The best you can do to try to avoid these sorts of problems is
> >use the "ikeep" option to keep empty inode chunks around. That way
> >if you remove a bunch of files then fragement free space you'll
> >still be able to create new files until you run out of pre-allocated
> >inodes....
> 
> There certainly are alot of places where code will need to change, but
> the changes might not be as dramatic if we assume that the ondisk
> format stays mostly the same.

Ok....

> One of the ideas that we've been tossing around is to steal a single byte
> from xfs_inobt_rec and use it as a bitmap to indicate which of the blocks
> within an 8 block chunk have inodes allocated in them.  We certainly haven't
> gone through all the places in the code that need to change; and hence, 
> don't
> understand the entire magnitude of this change, but it looks
> like this might allow ondisk formats to remain backwards compatible.

It's not backward compatible - the moment you allocate a
short chunk you need to set a new version bit in either the SB or
the AGI because older kernels will interpret the freecount in the
xfs_inobt_rec incorrectly.

> We were thinking that it's possible to steal a byte from ir_freecount
> because that field doesn't need 32 bits.

True, but I don't think the code complexity is really an issue here.
The issue is what it would do to the way stuff gets stored on disk
and the impact that has on everything else:

	a) reduces the inodes per AGI btree record.
		- tree gets deeper
		- tree requires more blocks
		- tree requires more frequent splits
		- tree gets more fragmented as the number of blocks
		  it requires increases near ENOSPC when space is
		  typically fragmented.
		- i.e. tree takes longer to write back and has a higher
		  log overhead
		- transaction reservations need increasing as tree
		  depth is no longer a function of AG size (*nasty*).
		  i.e. less allocation transaction on the fly at once
		  and greater potential for reservation overruns.
		- free inode searches take longer (already a limiting factor)
		- searching left+right is no longer symmetric so
		  we'd lose some determinism

	b) places small blocks into the filesystem on a much longer
	   term than single block file data
		- increases long term free space fragmenation
		- less likely to coalesce free space into large extents
		  as old data is freed up.
	
	c) inode clusters are placed further apart.
		- more seeks for directory traversal + stat workloads
		- slower writeback due to more seeks
	
	d) inode clusters limited to smallest allocation size
		- more I/O to read and write inodes
		- more seeks for directory traversal + stat workloads
		- slower writeback due to more seeks

The inode cluster issues could be solved, but it's still a nasty
thing because the inode caching code does not know about different
cluster sizes and there's no easy way to propagate that info from
the btree.

However, I still don't think that going to single block inode clusters
make a lot of sense given the amount of effort we go to everywhere
else to ensure large contiguous allocations. To me it seems like a
step backwards - it's not a solution to the general free space
fragmentation situation that XFS can get itself into, and that's
the problem we really need to fix.

FWIW, when we fragment data files, we use xfs_fsr to fix it up and
we have mechanisms in the kernel for optimising and ensuring
correctness of that operation.  We should treat free-space
fragmentation the same way because, like data file fragmentation,
it's not something that is a common problem and it can be fixed
up from userspace.....

FWIW-2, free space defragmentation for xfs_fsr is something
that has long been on the to-do list, but this problem is rare
enough that it's never been a high priority to implement....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
