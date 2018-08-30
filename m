Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60996 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726169AbeH3K2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 06:28:21 -0400
Date: Thu, 30 Aug 2018 16:27:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180830062743.GF5631@dastard>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180823125849.GF13528@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> On Mon, Aug 20, 2018 at 08:33:49AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
> > > 	- is documenting rejection on request alignment grounds
> > > 	  (i.e. EINVAL) in the man page sufficient for app
> > > 	  developers to understand what is going on here?
> > 
> > I think so.  The manpage says: "The filesystem does not support
> > reflinking the ranges of the given files", which (to my mind) covers
> > this case of not supporting dedupe of EOF blocks.
> 
> Older versions of btrfs dedupe (before v4.2 or so) used to do exactly
> this; however, on btrfs, not supporting dedupe of EOF blocks means small
> files (one extent) cannot be deduped at all, because the EOF block holds
> a reference to the entire dst extent.  If a dedupe app doesn't go all the
> way to EOF on btrfs, then it should not attempt to dedupe any part of the
> last extent of the file as the benefit would be zero or slightly negative.

That's a filesystem implementation issue, not an API or application
issue.

> The app developer would need to be aware that such a restriction could
> exist on some filesystems, and be able to distinguish this from other
> cases that could lead to EINVAL.  Portable code would have to try a dedupe
> up to EOF, then if that failed, round down and retry, and if that failed
> too, the app would have to figure out which filesystem it's running on
> to know what to do next.  Performance demands the app know what the FS
> will do in advance, and avoid a whole class of behavior.

Nobody writes "portable" applications like that. They read the man
page first, and work out what the common subset of functionality is
and then code from that. Man page says:

"Disk filesystems generally require the offset and length arguments
to be aligned to the fundamental block size."

IOWs, code compatible with starts with supporting the general case.
i.e. a range rounded to filesystem block boundaries (it's already
run fstat() on the files it wants to dedupe to find their size,
yes?), hence ignoring the partial EOF block. Will just work on
everything.

Code that then wants to optimise for btrfs/xfs/ocfs quirks runs
fstatvfs to determine what fs it's operating on and applies the
necessary quirks. For btrfs it can extend the range to include the
partial EOF block, and hence will handle the implementation quirks
btrfs has with single extent dedupe.

Simple, reliable, and doesn't require any sort of flailing
about with offsets and lengths to avoid unexpected EINVAL errors.

> btrfs dedupe reports success if the src extent is inline and the same
> size as the dst extent (i.e. file is smaller than one page).  No dedupe
> can occur in such cases--a clone results in a simple copy, so the best
> a dedupe could do would be a no-op.  Returning EINVAL there would break
> a few popular tools like "cp --reflink".  Returning OK but doing nothing
> seems to be the best option in that case.

Again, those are a filesystem implementation issues, not problems
with the API itself.

> > > 	- should we just round down the EOF dedupe request to the
> > > 	  block before EOF so dedupe still succeeds?
> > 
> > I've often wondered if the interface should (have) be(en) that we start
> > at src_off/dst_off and share as many common blocks as possible until we
> > find a mismatch, then tell userspace where we stopped... instead of like
> > now where we compare the entire extent and fail if any part of it
> > doesn't match.
> 
> The usefulness or harmfulness of that approach depends a lot on what
> the application expects the filesystem to do.
> 
> In btrfs, the dedupe operation acts on references to data, not the
> underlying data blocks.  If there are 1000 slightly overlapping references
> to a single contiguous range of data blocks in dst on disk, each dedupe
> operation acts on only one of those, leaving the other 999 untouched.
> If the app then submits 999 other dedupe requests, no references to the
> dst blocks remain and the underlying data blocks can be deleted.

Assuming your strawman is valid, if you have a thousand separate
references across the same set of data blocks on disk, then that data is
already heavily deduplicated.  Trying to optimise that further
seems.... misguided, way down the curve of diminishing returns.

> In a parallel universe (or a better filesystem, or a userspace emulation
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> built out of dedupe and other ioctls), dedupe could work at the extent
> data (physical) level.  The app points at src and dst extent references
> (inode/offset/length tuples), and the filesystem figures out which
> physical blocks these point to, then adjusts all the references to the
> dst blocks at once,

That's XFS dedupe in a nutshell. And we aren't in a parallel
universe here. :P

> dealing with partial overlaps and snapshots and nodatacow
> and whatever other exotic features might be lurking in the
> filesystem, ending with every reference to every part of dst replaced
> by the longest possible contiguous reference(s) to src.

XFS doesn't have partial overlaps, we don't have nodatacow hacks,
and the subvol snapshot stuff I'm working on just uses shared data
extents so it's 100% compatible with dedupe.

[snip btrfs dedupe issues]

Again, it just seems to me like the problems you are describing are
complexity problems that arise from the filesystem implementation
and all the hoops you have to jump through to work around them. It
doesn't seem to have anything to do with problems in the dedupe
API...

> If we want to design a new interface, it should allow the app to specify
> maximum and minimum length, so that the kernel knows how much flexibility
> it is allowed by the application.  Maximum length lets one app say
> "dedupe as much as you can find, up to EOF", while minimum length lets
> another app say "don't bother if the match is less than 12K, the space
> saving is not worth the write iops", and setting them equal lets the
> third app say "I have a plan that requires you to do precisely what I
> tell you or do nothing at all."

OK, we didn't need a "btrfs is insane" story to justify this
proposal - it's an entirely reasonable set of control requests.
IOWs, you want the current API (do exactly what I say),
Darricks proposed API (do as much as you can) and a new behaviour
(do at least this much) all rolled into one interface.

So, cribbing from copy_file_range(), a syscall like:

ssize_t dedupe_file_range(int fd_src, loff_t *off_src,
			 int fd_dst, loff_t *off_dst,
			 size_t len, unsigned int flags, u64 optval);

With the control flags:

#define DDFR_F_TRY		(0)	/* default: as much as possible */
#define DDFR_F_EXACT		(1<<0)	/* exactly what is asked or fail */
#define DDFR_F_MINLEN		(1<<1)	/* at least as much as optval says or fail */

And all return the number of bytes deduped in the range that was
specified.

Perhaps you'd like to write a man page describing how it should all
work?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
