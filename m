Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E7B17F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 07:48:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C950304070
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 05:48:49 -0800 (PST)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	lW8vSlw8ivgg7nJ9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 05:48:47 -0800 (PST)
Received: by mail-wi0-f174.google.com with SMTP id g10so2618939wiw.7
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 05:48:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140113204314.GJ3469@dastard>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
Date: Tue, 14 Jan 2014 15:48:46 +0200
Message-ID: <CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
From: Alex Lyakas <alex@zadarastorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

[snip]

> Right, I understand this. Go back to this comment you had about
> allocating a range that a discard is currently being issued on:
>
> | If during xfs_alloc_fixup_trees() we discover that extent is already
> | being discarded, we need to wait. Assuming we have asynchronous
> | discard, this wait will be short - we only need the block device to
> | queue the discard request, and then we are good to allocate from
> | that area again
>
> That will be blocking with the AGF held, regardless of whether we
> have asynchronous discard or not. Essentially, background discard
> can be considered "asynchronous" when viewed from the context of
> allocation.
>
> I'd forgotten that we effectively do that blocking right now
> xfs_extent_busy_update_extent(), when we trip over an extent being
> discarded, so this shouldn't be a blocker for a different discard
> tracking implementation. :)
Exactly, you already do that anyways. And similarly, we will do:
lock()
lookup overlapping discard-range
if range->flags & XFS_EXTENT_BUSY_DISCARDED => unlock and sleep and retry...
...
and when discarding a discard-range, we mark it with this flag (under
lock) and leave it in the tree until discarded.

[snip]

>> - When a busy extent commits, by all means we "unbusy" the extent as
>> usual. But we also check in the second rbtree, whether we can issue a
>> discard for some discard range. Perhaps we can. Or we cannot because
>> of other busy extents, that have not committed yet (the numbering is
>> used to determine that). In that case, we will discard later, when all
>> the needed busy extent commit. Unless new allocation removed/changed
>> this discard range already. But we are not delaying the "unbusying" of
>> the busy extent, and we are not keeping the AGF locked (I think).
>> Also, we are issuing discards in the same place and context where XFS
>> does it today.
>
> This is where I think the issues lie. We don't want to have to do
> anything when a busy extent is removed at transaction commit -
> that's the reason online discard sucks right now. And we want to
> avoid having to care about transactions and ordering when it comes
> to tracking discard ranges and issuing them.
>
> The way I see it is that if we have a worker thread that
> periodically walks the discard tree to issue discards, we simply
> need to do a busy extent tree lookup on the range of each discard
> being tracked. If there are busy extents that span the discard
> range, then the free space isn't yet stable and so we can't issue
> the discard on that range. If there are no busy extents over the
> discard range then the free space is stable and we can issue the
> discard.
>
> i.e. if we completely dissociate the discard and busy extent
> tracking and just replace it with a busy extent lookup at discard
> time then we don't need any sort of reference counting or log
> sequence tracking on busy extents or discard ranges.
Nice. I like the idea of doing the busy extent lookup instead of
numbering busy extents and tracking the order of commits.
So first of all, this idea can also be applied to what I suggest,
i.e., doing the discard at its current place. But instead of tracking
busy extent numbers, we:
- when a busy extent commits and it has a discard range attached to
it, we lookup in the busy extents tree to check for other busy extents
overlapping the discard range. Anyways the original code locks the
pagb_lock in that context, so we might as well do the search.
- if we find an overlapping busy extent, we detach the discard-range
from our busy extent and attach it to the overlapping extent. When
this overlapping busy extent commits, we will retry the search.

WRT that I have questions: in xfs_extent_busy_update_extent() we can
"unbusy" part of the extent, or even rb_erase() the busy extent from
the busy extent tree (it still remains in t_busy list and will be
tracked).
Q1: why it is ok to do so? why it is ok for "metadata" to reuse part
(or all) of the busy extent before its extent-free-intent is
committed?
Q2: assume we have two busy extents on the same discard range:
+--busy1--+ +--busy2--+
+----------discard1--------+
Assume that xfs_extent_busy_update_extent() fully unbusies busy1. Now
busy2 commits, searches for overlapping busy extent, does not find one
and discards discard1. I assume it is fine, because:
xfs_extent_busy_update_extent() is called before
xfs_alloc_fixup_trees() where I intend to check for overlapping
discard range. So if we manage to discard before
xfs_alloc_fixup_trees(), it is fine, because XFS has not yet really
allocated this space. Otherwise, xfs_alloc_fixup_trees() will knock
off discard1 and we will not discard. Works?

WRT to the worker thread: we need some good strategy when to awake it.
Like use a workqueue and a work item, that tells exactly which discard
range is now a candidate for discard and needs to be checked for
overlapping busy extents?

>
> FWIW, if we do this then we can change fstrim xfs_trim_extents() to
> queue up all the work to be done in the background simply by
> populating the discard tree with all the free space ranges we wish
> to discard.  This will significantly reduce the impact of fstrim on
> filesystem runtime performance as the AGF will only be held locked
> long enough to populate the discard tree.  And if we do the work
> per-ag, then we are also parallelising it by allowing discards on
> multiple AGs to be issued at once and hence it will be significantly
> faster on devices that can queue TRIM commands (SATA 3.1, SAS and
> NVMe devices).....
If we have a huge filesystem with a lot of ranges to discard, this
will require an un-bound memory amount to populate this tree?


>
> The fact that this track and background issue mechanism would allow
> us to optimise both forms of discard the filesystem supports makes
> me optimistic that we are on the right path. :)
>
>> >> question that I have:
>> >> # xfs_free_ag_extent() has a "isfl" parameter. If it is "true", then
>> >> this extent is added as usual to the free-space btrees, but the
>> >> caller doesn't add it as a busy extent. This means that such extent
>> >> is suitable for allocation right away, without waiting for the log
>> >> commit?
>> >
>> > It means the extent is being moved from the AGFL to the free space
>> > btree. blocks on the AGFL have already gone through free space
>> > accounting and busy extent tracking to get to the AGFL, and so there
>> > is no need to repeat it when moving it to the free space btrees.
>> Ok, I realize now that this block has already gone through the busy
>> extent tracking via xfs_allocbt_free_block().
>
> Right, and note that blocks going through that path aren't discarded
> due to the XFS_EXTENT_BUSY_SKIP_DISCARD flag. This is due to the
> fact they are being freed to the AGFL and as such are likely to be
> reused immediately. ;)
Yes, and WRT that: is it true to say that the following holds:
if we have busy extent with this flag, then we know appropriate range
is not in the free-space btrees. Because when we insert such busy
extent, we don't drop it into the free-space btrees. As a result, we
should never have a discard range that overlaps a busy extent with
XFS_EXTENT_BUSY_SKIP_DISCARD. Because all our discard ranges are also
free in the free-space btrees. Therefore, busy extents with this flag
do not require any special treatment; we can ignore them fully or
simply ignore the fact that they have this special flag - they will
never have a discard range attached anyways.

Thanks! You are very responsive.
Alex.


>
>> P.S.: Just watched your AU2014 talk. Interesting.
>
> It was a little bit different. And fun. ;)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
