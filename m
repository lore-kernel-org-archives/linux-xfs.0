Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:27406 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726892AbeIJN7z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Sep 2018 09:59:55 -0400
Date: Mon, 10 Sep 2018 19:06:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180910090646.GB5631@dastard>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org>
 <20180906083809.GF27618@dastard>
 <20180907035305.GJ26989@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907035305.GJ26989@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 06, 2018 at 11:53:06PM -0400, Zygo Blaxell wrote:
> On Thu, Sep 06, 2018 at 06:38:09PM +1000, Dave Chinner wrote:
> > On Fri, Aug 31, 2018 at 01:10:45AM -0400, Zygo Blaxell wrote:
> > > On Thu, Aug 30, 2018 at 04:27:43PM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> > > For future development I've abandoned the entire dedupe_file_range
> > > approach.  I need to be able to read and dedupe the data blocks of
> > > the filesystem directly without having to deal with details like which
> > > files those blocks belong to, especially on filesystems with lots of
> > > existing deduped blocks and snapshots. 
> > 
> > IOWs, your desired OOB dedupe algorithm is:
> > 
> > 	a) ask the filesystem where all it's file data is
> 
> Actually, it's "ask the filesystem where all the *new* file data is"
> since we don't want to read any unique data twice on subsequent runs.

Sorry, how do you read "unique data" twice? By definition, unique
data only occurs once....

Oh, and you still need to hash the old data so you can find
collisions with the new data that got written. Unless, of course,
you are keeping your hash tree in a persistent database and can work
out how to prune stale entries out of it efficiently....

And, well, see my comments about media scrubbing below.

> > 	b) read that used space to build a data hash index
> > 	c) on all the data hash collisions find the owners of the
> > 	   colliding blocks
> > 	d) if the block data is the same dedupe it
> > 
> > I agree - that's a simple and effective algorithm. It's also the
> > obvious solution to an expert in the field.
> 
> It's obvious, but if you literally implement that, you end up with a
> filesystem shattered into billions of fragments.

Well, yes, that's obvious. I thought that "details omitted for
reasons of brevity" would be understood, not require omitted details
to be explained to me.

> At step c) I need to figure out _which_ colliding block I want to keep.
> That's where the algorithm needs to inspect the higher-level file
> structure to determine the physical and logical situation for each block.
> That leads to one of:
> 
> 	a) store the hashes and block locations in the hash table
> 	b) relocate the blocks (defrag)
> 	c) replace some blocks with a reference to other blocks (dedupe)
> 
> This sounds a bit like what xfs_fsr does (or will do?).

xfs_fsr currently does the defrag bit w/ the swapext ioctl(*). It'll
get extended to also do dedupe scans eventually, as defrag and
dedupe obviously need to be integrated to prevent them from
duelling.

(*) swapext - in case you might not know about it - atomically
swaps a range of extents between two files without copying data.  So
you remember those dedupe selection problems you were talking about
(details omitted for brevity):

inode 1:	ABCDEFG|H|I|JK|L|M|N|O|P
inode 2:	a|b|c|d|e|f|g|hijklmop

The XFS solution will be to first defrag the master file (inode 1)
with the larger extents from inode 2:

swapext(H-P, h-p)

inode 1:	ABCDEFG|hijklmop
inode 2:	a|b|c|d|e|f|g|H|I|JK|L|M|N|O|P

And the we dedupe to the defragged file:

dedupe(inode 1, inode 2)

inode 1:	ABCDEFG|hijklmop
inode 2:	ABCDEFG|hijklmop

> Bees also operates under a constant-RAM constraint, so it doesn't operate
> in two distinct "collect data" and "act on data collected" passes,
> and cannot spend memory to store data about more than a few extents at
> any time.

I suspect that I'm thinking at a completely different scale to you.
I don't really care for highly constrained or optimal dedupe
algorithms  because those last few dedupe percentages really don't
matter that much to me. I care much more about using all the
resources we can and running as fast as we possibly can, then
providing the admin with means to throttle performance back to what
they need.

i.e. I'm concerned about how to effectively scan and dedupe PBs of
data, where scan rates may need to be measured in tens of GB/s.  In
these cases the limiting factor is either suboptimal IO patterns
(low IO throughput), or not having enough CPU and memory bandwidth
for hashing the data the IO engine is streaming through memory.
Once we get past a certain point, we'll gain far more by
parallelising the dedupe scan over lots of CPU than we ever will by
optimising an algorithm that cannot be parallelised. Hence we need
to start with a parallelisable algorithm, not an artificially
constrained one.

e.g. a soft requirement is that we need to scan the entire fs at
least once a month. That will need to be broken up into nightly
work, with a full 1PB filesystem needing 33+TB a night to be
scanned. We typically get 1 hour a night to do this sort of thing,
meaning the dedupe scan rate needs to sustain 1GB/s for that entire
hour.  Doing this with a single threaded, few extents at a time
algorithm is going to be a real stretch, so we need RAM and
concurrency at both the IO and CPU level to acheive this.

A simple piece-wise per-AG scanning algorithm (like we use in
xfs_repair) could easily work within a 3GB RAM per AG constraint and
would scale very well. We'd only need to scan 30-40 AGs in the hour,
and a single AG at 1GB/s will only take 2 minutes to scan. We can
then do the processing while the next AG gets scanned. If we've got
10-20GB RAM to use (and who doesn't when they have 1PB of storage?)
then we can scan 5-10AGs at once to keep the IO rate up, and process
them in bulk as we scan more.

Then consider that we can use that slowly iterating nightly dedupe
block scan to replace the online media scrubber. i.e. We get a
storage bitrot detecting scan for free with such a OOB dedupe
algorithm.  That's a massive win for enterprise filesystems - we
can cram all our maintenance tasks (defrag, scrubbing and dedupe)
into a single nightly scan, then it's highly predictable and
repeatable behaviour that admins can plan for and save themselves a
lot of unnecessary pain.

> > > The file structure is frankly
> > > just noise for dedupe on large filesystems.
> > 
> > We learnt that lesson back in the late 1990s. xfsdump, xfs_fsr, all
> > the SGI^WHPE HSM scanning tools, etc all avoid the directory
> > structure because it's so slow. XFS's bulkstat interface, OTOH, can
> > scan for target inodes at a over a million inodes/sec if you've got
> > the IO and CPU to throw at it....
> 
> A million inodes/sec?

Yeah, 2.1GHZ Xeons can scan ~200,000 inodes/s each when CPU bound,
and the above number comes from bulkstating 8 different AGs in
parallel on a 100 million inode, 500TB filesystem. It's limited by
lock contention on the sb inode list lock, so fixing that will allow
it to go faster.

> btrfs TREE_SEARCH_V2 barely manages 2000 inodes/sec on a 2.2GHz
> AMD A6--and that's just in the kernel, not counting delivery of
> the data to userspace.  I'm clearly using the wrong filesystem
> here.

Perhaps so.

> > FYI, in 2012 I came up with a plan for dedupe in XFS:
> > 
> > 	a) GETFSMAP to query reverse map tree to find file
> > 	   data blocks (don't try to dedupe unused space)
> > 	b) read the underlying block device in ascending block
> > 	   order and hash each block to build a collision tree.
> > 	   Trivially parallelised.
> > 	c) GETFSMAP to query rmap for the owners of colliding
> > 	   blocks
> > 	d) For all file data owner maps of a colliding block
> > 		- bulkstat the inode numbers returned by GETFSMAP
> > 		  and open_by_handle to get fd's
> > 		- run dedupe syscall
> 
> I think steps c and d show room for improvement.
> 
> I'd like the filesystem to receive a pair of contiguous colliding block
> ranges, and have the filesystem locate and update all the owners at once
> after performing the comparison (skip updating any owners that have
> changed after the comparison).

I'd like a pony, too.

However, I think that such bottom up operations are nearly
impossible to do atomically because they invert the locking orders
of normal operations and are completely open-ended in scope in what
they may need to update.  syscalls are better designed as simple, self
contained operations that you can build into bigger operations, not
provide massive, complex, open-ended operations themselves.

> I wonder if a future btrfs implementation of GETFSMAP will use the
> device ID and physical offset fields, or just return a constant device
> ID with .physical carrying the 64-bit virtual address that the rest of
> the filesystem uses.
> 
> I wonder how compressed data would work with GETFSMAP?  In btrfs the
> LOGICAL_INO and FIEMAP ioctls treat the entire compressed extent as a
> single entity with no distinct blocks inside.  Bees needs a unique address
> for every block, even the compressed ones, so some of that is handled
> by emulation using TREE_SEARCH_V2 in the translation layer (the physical
> data type is 64-bit extent base plus an uncompressed block offset).

Whoever implements GETFSMAP for btrfs will have to work through
those complexities. If btrfs treats something as a undividable
complete object, then GETFSMAP will probably have to report it as
such and not be able to report things like offsets into the object.
It will just have to be documented in the man page in the "btrfs
specific objects" section.

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
