Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27565 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725736AbeHUEHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 00:07:03 -0400
Date: Tue, 21 Aug 2018 10:49:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180821004907.GW2234@dastard>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820153349.GA4334@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 20, 2018 at 08:33:49AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
....
> > So why was this dedupe request even accepted by the kernel? Well,
> > I think there's a bug in the check just above this:
> > 
> >         /* If we're linking to EOF, continue to the block boundary. */
> >         if (pos_in + *len == isize)
> >                 blen = ALIGN(isize, bs) - pos_in;
> >         else
> >                 blen = *len;
> > 
> > basically, when the "in" file dedupe/reflink range is to EOF, it
> > expands the range to include /all/ of the block that contains the
> > EOF byte. IOWs, it now requests us to dedupe /undefined data beyond
> > EOF/. But when we go to compare the data in these ranges, it
> > truncates the comparison to the length that the user asked for
> > (i.e. *len) and not the extended block length.
> > 
> > IOWs, it doesn't compare the bytes beyond EOF in the source block to
> > the data in the destination block it would replace, and so doesn't
> > fail the compare like it should.
......
> > i.e. the dedupe request should fail as we cannot dedupe the EOF
> > block.
> > 
> > The patch below does this for the VFS dedupe code. it's not a final
> > patch, it's just a demonstration of how this should never have got
> > past the range checks. Open questions:
> 
> (Here's my five minutes of XFS that I'm allowed per day... :/)
> 
> > 	- is documenting rejection on request alignment grounds
> > 	  (i.e. EINVAL) in the man page sufficient for app
> > 	  developers to understand what is going on here?
> 
> I think so.  The manpage says: "The filesystem does not support
> reflinking the ranges of the given files", which (to my mind) covers
> this case of not supporting dedupe of EOF blocks.

Ok.

> > 	- should we just round down the EOF dedupe request to the
> > 	  block before EOF so dedupe still succeeds?
> 
> I've often wondered if the interface should (have) be(en) that we start
> at src_off/dst_off and share as many common blocks as possible until we
> find a mismatch, then tell userspace where we stopped... instead of like
> now where we compare the entire extent and fail if any part of it
> doesn't match.

I think that the ioctl_fideduperange() man page description gives us
the flexibility to do this. That is, this text:

	Upon successful completion of this ioctl, the number of
	bytes successfully deduplicated is returned in bytes_deduped
	and a status code for the deduplication operation is
	returned in status.  If even a single byte in the range does
	not match, the deduplication request will be ignored  and
	status set  to FILE_DEDUPE_RANGE_DIFFERS.

This implies we can dedupe less than the entire range as long as the
entire range matches. If the entire range does not match, we have
to return FILE_DEDUPE_RANGE_DIFFERS, but in this case it does match
so we can pick and choose how much we deduplicate. How much we
dedupe is then returned as a byte count. In this case, it will be a
few bytes short of the entire length requested because we aligned
the dedupe inwards....

Does that sound reasonable?

> > 	- should file cloning (i.e. reflink) be allow allowing the
> > 	  EOF block to be shared somewhere inside EOF in the
> > 	  destination file?
> 
> I don't think we should.
> 
> > That's stale data exposure, yes?
> 
> Haven't tested that, but seems likely.

Yeah, I haven't tested it either, but it I can't see how the current
behaviour ends well.

> > 	- should clone only allow sharing of the EOF block if it's a
> > 	  either a full file clone or a matching range clone and
> > 	  isize is the same for both src and dest files?
> 
> The above sound reasonable for clone, though I would also allow clone to
> share the EOF block if we extend isize of the dest file.

Hmmm. That covers the only valid rule for sharing the EOF block,
right? i.e. That the source EOF lands exactly at or beyond the
destination EOF, so it remains the EOF block in both files?

FWIW, I just noticed that the ioctl_ficlonerange man page doesn't
document the return value on success of a clone.

> The above also nearly sound reasonable for dedupe too.  If we encounter
> EOF at the same places in the src range and the dest range, should we
> allow sharing there?  The post-eof bytes are undefined by definition;
> does undefined == undefined?

It's undefined, espescially as different fs implementations may be
doing different things with partial blocks (e.g. tail packing).

>From an XFS perspective, I don't think we should physically share
partial EOF blocks on dedupe because it means extending either file
becomes a COW operation and then a new allocation instead of just a
new allocation (i.e. a fragmentation vector). So seems better to me
to just leave the partial EOF block unshared in this case.

> > [RFC] vfs: fix data corruption w/ unaligned dedupe ranges
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Exposed by fstests generic/505 on XFS, caused by extending the
> > bblock match range to include the partial EOF block, but then
> > allowing unknown data beyond EOF to be considered a "match" to data
> > in the destination file because the comparison is only made to the
> > end of the source file. This corrupts the destination file when the
> > source extent is shared with it.
> > 
> > Open questions:
> > 
> > 	- is documenting rejection on request alignment grounds
> > 	  (i.e. EINVAL) in the man page sufficient for app
> > 	  developers to understand what is going on here?
> > 	- should we just silently round down the EOF dedupe request
> > 	  to the block before EOF so dedupe still succeeds?
> > 	- should file cloning (i.e. reflink) be allow allowing the
> > 	  EOF block to be shared somewhere inside EOF in the
> > 	  destination file? That's stale data exposure, yes?
> > 	- should clone only allow sharing of the EOF block if it's a
> > 	  either a full file clone or a matching range clone and
> > 	  isize is the same for both src and dest files?
> > 
> > Btrfs also has the same bug in extent_same_check_offsets() and
> > btrfs_extent_same_range() that is not addressed by this patch.
> 
> <nod> (xfs/ocfs2) clone ioctls tend to be bug-for-bug compatible with
> btrfs more often than we probably ought to... :/

*nod*

> (I also sorta wonder if btrfs should be ported to the common vfs
> routines for clone prep and dedupe comparison...?)

If someone feels like trying to tame that dragon, then I'm not going
to stop them. I'm not going to try, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
