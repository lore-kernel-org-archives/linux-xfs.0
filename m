Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64751 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728127AbeIFNMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:12:36 -0400
Date: Thu, 6 Sep 2018 18:38:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180906083809.GF27618@dastard>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831051045.GI26989@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Aug 31, 2018 at 01:10:45AM -0400, Zygo Blaxell wrote:
> On Thu, Aug 30, 2018 at 04:27:43PM +1000, Dave Chinner wrote:
> > On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> > > On Mon, Aug 20, 2018 at 08:33:49AM -0700, Darrick J. Wong wrote:
> > > > On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
> > > > > 	- is documenting rejection on request alignment grounds
> > > > > 	  (i.e. EINVAL) in the man page sufficient for app
> > > > > 	  developers to understand what is going on here?
> > > > 
> > > > I think so.  The manpage says: "The filesystem does not support
> > > > reflinking the ranges of the given files", which (to my mind) covers
> > > > this case of not supporting dedupe of EOF blocks.
> > > 
> > > Older versions of btrfs dedupe (before v4.2 or so) used to do exactly
> > > this; however, on btrfs, not supporting dedupe of EOF blocks means small
> > > files (one extent) cannot be deduped at all, because the EOF block holds
> > > a reference to the entire dst extent.  If a dedupe app doesn't go all the
> > > way to EOF on btrfs, then it should not attempt to dedupe any part of the
> > > last extent of the file as the benefit would be zero or slightly negative.
> > 
> > That's a filesystem implementation issue, not an API or application
> > issue.
> 
> The API and application issue remains even if btrfs is not considered.
> btrfs is just the worst case outcome.  Other filesystems still have
> fragmentation issues, and applications have efficiency-vs-capability
> tradeoffs to make if they can't rely on dedupe-to-EOF being available.
> 
> Tools like 'cp --reflink=auto' work by trying the best case, then falling
> back to a second choice if the first choice returns an error.

Well, yes. That's necessary for the "cp" tool to behave according to
user expectations.  That's not a kernel API issue - that's just an
implementation of an *application requirement*.  Indeed, this is
identical to the behaviour of rename() in "mv" - if rename fails
with -EXDEV, mv needs to fall back to a manual copy because the user
expects the file to be moved.

IOWS, these application level requirements you talk about are just
not relevant to the kernel API for dedupe/clone operations.

[snip]

> It is something that naive dedupe apps will do.  "naive" here meaning
> "does not dive deeply into the filesystem's physical structure (or survey
> the entire filesystem with FIEMAP) to determine that the thousand-refs
> situation does not exist at dst prior to invoking the dedupe() call."

/me sighs and points at FS_IOC_GETFSMAP

$ man ioctl_getfsmap
....
DESCRIPTION
       This ioctl(2) operation retrieves physical extent mappings
       for a filesystem.  This information can be used to discover
       which files are mapped to a physical block, examine free
       space, or find known bad blocks, among other things.
.....

I don't really care about "enabling" naive, inefficient
applications. I care about applications that scale to huge
filesystems and can get the job done quickly and efficiently.

> > XFS doesn't have partial overlaps, we don't have nodatacow hacks,
> > and the subvol snapshot stuff I'm working on just uses shared data
> > extents so it's 100% compatible with dedupe.
> 
> If you allow this sequence of operations, you get partial overlaps:
> 
> 	dedupe(fd1, 0, fd2, 0, 1048576);
> 
> 	dedupe(fd2, 16384, fd3, 0, 65536);

Oh, I misunderstood - I thought you were refering to sharing partial
filesystem blocks (like at EOF) because that's what this discussion
was originally about. XFS supports the above just fine.

[snip]

tl;dr we don't need a new clone or dedupe API

> For future development I've abandoned the entire dedupe_file_range
> approach.  I need to be able to read and dedupe the data blocks of
> the filesystem directly without having to deal with details like which
> files those blocks belong to, especially on filesystems with lots of
> existing deduped blocks and snapshots. 

IOWs, your desired OOB dedupe algorithm is:

	a) ask the filesystem where all it's file data is
	b) read that used space to build a data hash index
	c) on all the data hash collisions find the owners of the
	   colliding blocks
	d) if the block data is the same dedupe it

I agree - that's a simple and effective algorithm. It's also the
obvious solution to an expert in the field.

> The file structure is frankly
> just noise for dedupe on large filesystems.

We learnt that lesson back in the late 1990s. xfsdump, xfs_fsr, all
the SGI^WHPE HSM scanning tools, etc all avoid the directory
structure because it's so slow. XFS's bulkstat interface, OTOH, can
scan for target inodes at a over a million inodes/sec if you've got
the IO and CPU to throw at it....

> I'm building a translation
> layer for bees that does this--i.e. the main dedupe loop works only with
> raw data blocks, and the translation layer maps read(blocknr, length)
> and dedupe(block1, block2, length) requests onto the existing kernel
> read(fd, offset, length) and dedupe(fd1, off1, fd2, off2, length)i

That's FS_IOC_GETFSMAP. :P

FYI, in 2012 I came up with a plan for dedupe in XFS:

	a) GETFSMAP to query reverse map tree to find file
	   data blocks (don't try to dedupe unused space)
	b) read the underlying block device in ascending block
	   order and hash each block to build a collision tree.
	   Trivially parallelised.
	c) GETFSMAP to query rmap for the owners of colliding
	   blocks
	d) For all file data owner maps of a colliding block
		- bulkstat the inode numbers returned by GETFSMAP
		  and open_by_handle to get fd's
		- run dedupe syscall

We've finally got all the infrastructure we need to write this app
for XFS - we just need to write it and integrate it into xfs_fsr....

> calls.
> If the end result of that development work meets my performance
> targets--I've built over a dozen dedupe apps, and only two were good
> enough to release so far--then I'd propose moving those primitives into
> the kernel.

dedupe has been around for a long time and there hasn't been any
breakthroughs in IO efficient OOB dedupe scanning algorithms for
years.  OOB dedupe is not actually that difficult to do efficiently,
it's just that most people trying to do it lack the knowledge and/or
insight to make the jump that it requires reverse block mapping, not
directory traversal.

You've taken a dozen or so failures to realise what was obvious to
me at the outset - your translation layer will essentially hold the
same information that XFS already maintains on disk in it's rmap
btrees. IIRC btrfs has semi-equivalent reverse mapping functionality
on disk (back pointers?), so maybe your best bet would be to
implement FSMAP for btrfs and then you have a dedupe app that works
efficiently on both XFS and btrfs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
