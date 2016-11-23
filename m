Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20146 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753651AbcKWCo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 21:44:56 -0500
Date: Tue, 22 Nov 2016 18:44:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161123024419.GQ16813@birch.djwong.org>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161123020210.GW21290@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com

On Tue, Nov 22, 2016 at 09:02:10PM -0500, Zygo Blaxell wrote:
> On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> > 3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
> >    implicit EOF gets around this in the existing XFS implementation. I
> >    copied this for the Btrfs implementation.
> 
> Somewhat tangential to this patch, but on the dedup topic:  Can we raise
> or drop that 16MB limit?
> 
> The maximum btrfs extent length is 128MB.  Currently the btrfs dedup
> behavior for a 128MB extent is to generate 8x16MB shared extent references
> with different extent offsets to a single 128MB physical extent.
> These references no longer look like the original 128MB extent to a
> userspace dedup tool.  That raises the difficulty level substantially
> for a userspace dedup tool when it tries to figure out which extents to
> keep and which to discard or rewrite.
> 
> XFS may not have this problem--I haven't checked.  On btrfs it's
> definitely not as simple as "bang two inode/offset/length pairs together
> with dedup and disk space will be freed automagically."  If dedup is
> done incorrectly on btrfs, it can end up just making the filesystem slow
> without freeing any space.

I copied the 16M limit into xfs/ocfs2 because btrfs had it. :)

The VFS now limits the size of the incoming struct file_dedupe_range to
whatever a page size is.  On x86 that only allows us 126 dedupe
candidates, which means that a single call can perform up to ~2GB of IO.
Storage is getting faster, but 2GB is still a fair amount for a single
call.  Of course in XFS we do the dedupe one file and one page at a time
to keep the memory footprint sane.

On ppc64 with its huge 64k pages that comes out to 32GB of IO.

One thing we (speaking for XFS, anyway) /could/ do is limit based on the
theoretical IO count instead of clamping the length, e.g.

if ((u64)dest_count * len >= (1ULL << 31))
	return -E2BIG;

That way you /could/ specify a larger extent size if you pass in fewer
file descriptors.  OTOH XFS will merge all the records together, so even
if you deduped the whole 128M in 4k chunks you'll still end up with a
single block mapping record and a single backref.

Were I starting from scratch I'd probably just dump the existing dedupe
interface in favor of a non-vectorized dedupe_range call taking the same
parameters as clone_range:

int dedupe_range(src_fd, src_off, dest_fd, dest_off);

I'd also change the semantics to "Find and share all identical blocks in
this subrange.  Differing blocks are left alone." because it seems silly
that duperemove can issue large requests but a single byte difference in
the middle causes info->status to be set to FILE_DEDUPE_RANGE_DIFFERS
and info->bytes_deduped only changes if the entire range was deduped.

> The 16MB limit doesn't seem to be useful in practice.  The two useful
> effects of the limit seem to be DoS mitigation.  There is no checking of
> the RAM usage that I can find (i.e. if you fire off 16 dedup threads,
> they want 256MB of RAM; put another way, if you want to tie up 16GB of
> kernel RAM, all you have to do is create 1024 dedup threads), so it's
> not an effective DoS mitigation feature.  Internally dedup could verify
> blocks in batches of 16MB and check for signals/release and reacquire
> locks in between, so it wouldn't tie up the kernel or the two inodes
> for excessively long periods.

(Does btrfs actually do the extent_same stuff in parallel??)

> Even if we want to keep the 16MB limit, there's also no way to query the
> kernel from userspace to find out what the limit is, other than by trial
> and error.  It's not even in a header file, userspace just has to *know*.

-E2BIG?

--D
