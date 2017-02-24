Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145847.2ftctqqh3s2q7y7f@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18707 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751585AbdBXAJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 19:09:47 -0500
Date: Fri, 24 Feb 2017 11:08:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Clarification on inode alignment
Message-ID: <20170224000852.GF17542@dastard>
References: <1735943.rpnT4cuqyx@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1735943.rpnT4cuqyx@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: dchinner@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "Darrick J . Wong" <darrick.wong@oracle.com>, david@fromorbit.com

[Please use david@fromorbit.com if you want my attention for
upstream stuff]

On Thu, Feb 23, 2017 at 11:51:12AM +0530, Chandan Rajendra wrote:
> Hi Dave,
> 
> Last week, during a discussion on #xfs you stated that,
> 
> "inode alignment is necessary to avoid needing to do an inobt lookup to find
> the location of the inode every time we map an inode to disk".
> 
> Also, The following statement appears at
> http://xfs.org/index.php/Improving_inode_Caching,
> 
> "The main problem we have is that XFS uses inode chunk size and alignment to
> optimise inode number to disk location conversion. That is, the conversion
> becomes a single set of shifts and masks instead of an AGI btree lookup. This
> optimisation substantially reduces the CPU and I/O overhead of inode lookups,
> but it does limit our flexibility. If we break the alignment restriction,
> every lookup has to go back to a btree search. Hence we really want to avoid
> breaking chunk alignment and size rules."
> 
> For the 4k block size scenario, I noticed that we have inode alignment of 4
> blocks.

For some filesystem configurations. Not all.

> I did go through macros such as XFS_INO_TO_AGNO(),
> XFS_INO_TO_AGBNO() and XFS_INO_TO_OFFSET() which deal with extracting the
> components from an inode number.
> 
> However I still don't understand how non-aligned inode clusters (64 inodes in
> a single cluster) would break the inode number to disk location
> arithmetic calculations. Could you please explain it?

First, you need to understand the correct terminology: "inode
cluster" vs "inode chunk"

inode chunk: unit of inode allocation, always 64 contiguous inodes
		referenced by a single inobt record

inode cluster: a buffer used to do inode IO, whose size is dependent
		on superblock flags and field values

The inobt record records the AGBNO of the inode chunk, and
internally then indexes the inodes in the chunk from 0 to 63.

Inode clusters are independent of the inobt record. The number of
inodes in a cluster buffer is dependent on the inode size and the
inode cluster buffer size. The size of the inode cluster buffer is
dependent on filesystem block size and inode alignment.

Take, for example, v4 filesystem, 4k fsb, 256 byte inodes, with
everything indexed to zero to show that the maths to derive
everything from chunk_agbno + ino # is simple:

chunk @ agbno
	+-------------------------------------------+
ino#	0          16	      32         48

block	0	   1	      2          3
	+----------+----------+----------+----------+
agbno   +0	   +1	      +2	 +3

cluster	0		      1
	+---------------------+---------------------+
agbno	+0		      +2

All nice an simple, yes? So we can clearly see that an inode number
of AGBNO | INO# can be mapped to the physical block

	chunk_agbno + (INO# / inodes per block)

And the cluster buffer physical location is:

	chunk_agbno + (INO# / inodes per cluster)

Ok, so the math is simple (as you've noticed), but it doesn't
explain the alignment constraints. The question is this:
what assumption does this math make about the relationship
between the inode number and the physical location of the inode?

....

....

That's right, it assumes that chunk_agbno + INO# can only map to a
single physical location and so never overlaps with another inode
chunk. i.e. this cannot happen as a result of a inode free/alloc
operation pair:

Free:
chunk @ agbno
	+-------------------------------------------+
ino#	0          16	      32         48

Alloc:
chunk @ agbno+3
					+-------------------------------------------+
				ino#	0          16	      32         48

If we have the overlapping chunk allocation ranges like this, then
we can have multiple inode numbers that map to the same physical
location.  in the above case, both of the inode numbers (agbno | 48)
and (agbno + 3 | 0) map to the same physical location but they have
different cluster buffer address (i.e. agbno+2 vs agbno+3)

So, when you get an inode number, how do you know it is valid and
you haven't raced with an unlink that just removed the underlying
inode chunk? You can do a buffer lookup to see if it's stale, but
that has all sorts of problems in that a key constraint is that we
must not have overlapping buffers in the cache.  How do we know what
buffers we need to look up (and how do we do it in a race free
manner) to ensure that all the original inode cluster buffers have
been invalidated and their transactions committed during an
allocation?

IOWs, without jumping through all sorts of cluster buffer coherence
validation hoops we end up with free vs allocation and free vs
lookup races on the cluster buffers if we just use inode number
conversions for physical buffer mapping. That's complex, costly and
extremely error prone, so we essentially have to treat all inode
numbers as untrusted because of these races.

There are two ways to solve this problem.
	1) always look up the inobt record for an inode number to
	get the chunk_agbno from the inobt as locking the AGI for
	lookup guarantees no alloc/lookup/free races can occur; or

	2) Ensure that inode chunks never overlap by physically
	aligning them at allocation time, hence ensuring that every
	physical address maps to exactly one inode number and
	cluster buffer address.

XFS implemented 1) back in 1994 when inode cluster buffers were
introduced.  The issue with this is that inobt lookups every time we
want to map an inode number is that it is excitingly expensive. If
we know the inode number is correct (i.e. cames from other internal
metadata that we've already validated), then this is overhead we can
avoid if we constraint the disk format via method 2).

That was done more than 20 years ago:

commit 07d3e5d3764a8cf02d2e40397da0018c5c60f70a
Author: Doug Doucette <doucette@engr.sgi.com>
Date:   Tue Jun 4 19:08:18 1996 +0000

    Support for aligned inode allocation (bug 385316).  Support for
    superblock versioning (bug 385292).  Some cleanup.

And we've used aligned inodes ever since....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
