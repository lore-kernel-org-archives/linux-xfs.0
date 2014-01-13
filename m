Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 486C07F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 14:43:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06AB9304043
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:43:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QSVvKqlwu1MJ5jSD for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 12:43:19 -0800 (PST)
Date: Tue, 14 Jan 2014 07:43:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Message-ID: <20140113204314.GJ3469@dastard>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 13, 2014 at 07:44:13PM +0200, Alex Lyakas wrote:
> On Mon, Jan 13, 2014 at 5:02 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Jan 08, 2014 at 08:13:38PM +0200, Alex Lyakas wrote:
> Hi Dave,
> Thank you for your comments, and for pointing me at the commits.

[snip stuff we both understand]

> > I really don't see any advantage in tracking discard ranges like
> > this, because we can do these optimisations of merging and trimming
> > just before issuing the discards. And realistically, merging and
> > trimming is something the block layer should be doing for us
> > already.
> >
> Yes, I realize that XFS mindset is to do pure filesystem work, i.e.,
> arrange blocks of data in files and map them to disk. The rest should
> be handled by application above and by the storage system below. In
> your awesome AU2012 talk, you also confirm that mindset. Trouble is
> that the block layer cannot really merge small discard requests,
> without the information that you have in AGF btrees.

Ok, I see what you are getting at here - mounting -o discard does
not alleviate the need for occasionally running fstrim to issue
discards on large free extents that may have formed from lots of
small, disjoint extents being freed. IOWs, we cannot perfectly
optimise fine grained discards without some form of help from
tracking "overlaps" with already freed, discarded space.

[snip]

> >> What do you think overall about this approach? Is there something
> >> fundamental that prevents it from working?
> >
> > I'm not convinced that re-introducing busy extent commit
> > sequence tracking and blocking to optimise discard operations is a
> > particularly good idea given the above.
> I am not sure I am suggesting to block or lock anything (perhaps I am,
> without realizing that). By and large, I suggest to have another data
> structure, an rbtree, that tracks discard ranges.

Right, I understand this. Go back to this comment you had about
allocating a range that a discard is currently being issued on:

| If during xfs_alloc_fixup_trees() we discover that extent is already
| being discarded, we need to wait. Assuming we have asynchronous
| discard, this wait will be short - we only need the block device to
| queue the discard request, and then we are good to allocate from
| that area again

That will be blocking with the AGF held, regardless of whether we
have asynchronous discard or not. Essentially, background discard
can be considered "asynchronous" when viewed from the context of
allocation.

I'd forgotten that we effectively do that blocking right now
xfs_extent_busy_update_extent(), when we trip over an extent being
discarded, so this shouldn't be a blocker for a different discard
tracking implementation. :)

> This rbtree is
> loosely connected to the busy extent rbtree. And I suggest three
> things to do with this new rbtree:

Yes, but lets improve that "loose connection" by making them
almost not connected at all.

> - Whenever a busy extent is added, maybe add a discard range to the
> second rbtree, and attach it to the busy extent (if we got a nice
> discard range)
> - For each new allocation, check if something needs to be
> removed/changed in this rbtree. Yes, I realize this is additional
> work.

It's not a huge amount of extra work compared to the rest of the
allocation path, so I don't see this as a major issue.

> - When a busy extent commits, by all means we "unbusy" the extent as
> usual. But we also check in the second rbtree, whether we can issue a
> discard for some discard range. Perhaps we can. Or we cannot because
> of other busy extents, that have not committed yet (the numbering is
> used to determine that). In that case, we will discard later, when all
> the needed busy extent commit. Unless new allocation removed/changed
> this discard range already. But we are not delaying the "unbusying" of
> the busy extent, and we are not keeping the AGF locked (I think).
> Also, we are issuing discards in the same place and context where XFS
> does it today.

This is where I think the issues lie. We don't want to have to do
anything when a busy extent is removed at transaction commit -
that's the reason online discard sucks right now. And we want to
avoid having to care about transactions and ordering when it comes
to tracking discard ranges and issuing them.

The way I see it is that if we have a worker thread that
periodically walks the discard tree to issue discards, we simply
need to do a busy extent tree lookup on the range of each discard
being tracked. If there are busy extents that span the discard
range, then the free space isn't yet stable and so we can't issue
the discard on that range. If there are no busy extents over the
discard range then the free space is stable and we can issue the
discard.

i.e. if we completely dissociate the discard and busy extent
tracking and just replace it with a busy extent lookup at discard
time then we don't need any sort of reference counting or log
sequence tracking on busy extents or discard ranges.

FWIW, if we do this then we can change fstrim xfs_trim_extents() to
queue up all the work to be done in the background simply by
populating the discard tree with all the free space ranges we wish
to discard.  This will significantly reduce the impact of fstrim on
filesystem runtime performance as the AGF will only be held locked
long enough to populate the discard tree.  And if we do the work
per-ag, then we are also parallelising it by allowing discards on
multiple AGs to be issued at once and hence it will be significantly
faster on devices that can queue TRIM commands (SATA 3.1, SAS and
NVMe devices).....

The fact that this track and background issue mechanism would allow
us to optimise both forms of discard the filesystem supports makes
me optimistic that we are on the right path. :)

> >> question that I have:
> >> # xfs_free_ag_extent() has a "isfl" parameter. If it is "true", then
> >> this extent is added as usual to the free-space btrees, but the
> >> caller doesn't add it as a busy extent. This means that such extent
> >> is suitable for allocation right away, without waiting for the log
> >> commit?
> >
> > It means the extent is being moved from the AGFL to the free space
> > btree. blocks on the AGFL have already gone through free space
> > accounting and busy extent tracking to get to the AGFL, and so there
> > is no need to repeat it when moving it to the free space btrees.
> Ok, I realize now that this block has already gone through the busy
> extent tracking via xfs_allocbt_free_block().

Right, and note that blocks going through that path aren't discarded
due to the XFS_EXTENT_BUSY_SKIP_DISCARD flag. This is due to the
fact they are being freed to the AGFL and as such are likely to be
reused immediately. ;)

> P.S.: Just watched your AU2014 talk. Interesting.

It was a little bit different. And fun. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
