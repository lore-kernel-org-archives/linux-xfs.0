Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1934929DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 21:02:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D85D38F804B
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:02:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Fa0mTGXXdwvzjwrg for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 19:02:34 -0800 (PST)
Date: Mon, 13 Jan 2014 14:02:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Message-ID: <20140113030230.GF3469@dastard>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
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

On Wed, Jan 08, 2014 at 08:13:38PM +0200, Alex Lyakas wrote:
> Hello Dave,
> 
> Currently I am working on the following approach:
> 
> Basic idea: make each xfs_extent_busy struct carry potential
> information about a larger extent-for-discard, i.e., one that is a
> multiple of discard_granularity.

You're making a big assumption here that discard_granularity is
useful for aggregating large extents. Discard granularity on modern
SSDs is a single sector:

$ cat /sys/block/sda/queue/discard_granularity 
512
$

I've just checked 4 different types of SSDs I have here (from 3
years old no-name sandforce SSDs to a brand new samsung 840 EVO),
and htey all give the same result.

IOWs, in most cases other than thin provisioning it will not be
useful for optimising discards into larger, aligned extents.

> In detail this looks like this:
> # xfs_free_ag_extent attempts to merge the freed extent into a
> larger free-extent in the by-bno btree.  When this function
> completes its work, we have [nbno, nlen], which is potentially a
> larger free-extent. At this point we also know that AGF is locked.
> # We trim [nbno, nlen] to be a multiple-of and aligned-by
> discard_granularity (if possible), and we receive [dbno, dlen],
> which is a very nice extent to discard.
> # When calling xfs_extent_busy_insert(), we add these two values to
> the xfs_extent_busy struct.
> # When the extent-free operation is committed for this busy extent,
> we know that we can discard this [dbno, dlen] area, unless somebody
> have allocated an extent, which overlaps this area.

This strikes me as optimisation at the wrong time i.e. optimising
discard ranges at extent free time ignores the fact that the extent
can be immediately reallocated, and so all the optimisation work is
wasted.

> To address that, at the end of  xfs_alloc_fixup_trees() we do the following:
> # We know that we are going to allocate [rbno, rlen] from
> appropriate AG. So at this point, we search the busy extents tree to
> check if there is a busy extent that holds [dbno, dlen] (this is a
> multiple-of and aligned-by discard granularity), which overlaps

How do you find that? The busy extent tree is indexed on individual
extents that have been freed, not the discard granularity ranges
they track.

> [rbno, rlen] fully or partially. If found, we shrink the [dbno,
> dlen] area to be still a multiple-of and aligned by
> discard-granularity, if possible. So we have a new smaller [dbno,
> dlen] that we still can discard, attached to the same busy extent.
> Or we discover that the new area is too small to discard, so we
> forget about it.

Forget about the discard range, right? We can't ignore the busy
extent that covers the range being freed - it must be tracked all
the way through to transaction commit completion.

> # The allocation flow anyways searches the busy extents tree, so we
> should be ok WRT to locking order, but adding some extra work.

There are other locking issues to be concerned about than order....

> I am aware that I need to handle additional issues like:
> # A busy extent can be "unbusyied" or shrunk by
> xfs_extent_busy_update_extent(). We need to update [dbno, dlen]
> accordingly or delete it fully
> # To be able to search for [dbno, dlen], we probably need another
> rbtree (under the same pag->pagb_lock), which tracks large extents
> for discard. xfs_extent_busy needs additional rbnode.
> # If during xfs_alloc_fixup_trees() we discover that extent is
> already being discarded, we need to wait. Assuming we have
> asynchronous discard, this wait will be short - we only need the
> block device to queue the discard request, and then we are good to
> allocate from that area again.

* multiple busy extents can be found in the one "discard range".
Hence there is a n:1 relationship between the busy extents and the
related "discard extent" that might be related to it. Hence if we
end up with:

	busy1	busy2	busy3
	+-------+-------+------+
	+----------------------+
	     discard1

and then we reuse busy2, then we have to delete discard1 and update
busy1 and busy3 not to point at discard1. Indeed, depending on
the discard granularity, it might ned up:

	busy1		busy3
	+-------+       +------+
	+-------+       +------+
	discard1	discard2

And so the act of having to track optimal "discard ranges" becomes
very, very complex.

I really don't see any advantage in tracking discard ranges like
this, because we can do these optimisations of merging and trimming
just before issuing the discards. And realistically, merging and
trimming is something the block layer should be doing for us
already.

> 
> One thing I am unsure about, is a scenario like this:
> # assume discard-granularity=1MB
> # we have a 1MB almost free, except two 4K blocks, somewhere in the
> free space
> # Transaction t1 comes and frees 4K block A, but the 1MB extent is
> not fully free yet, so nothing to discard
> # Transaction t2 frees the second 4K block B, now 1MB is free and we
> attach a [dbno, dlen] to the second busy extent
> 
> However, I think there is no guarantee that t1 will commit before
> t2; is that right?

Correct.

> But we cannot discard the 1MB extent, before both
> transactions commit. (One approach to solve this, is to give a
> sequence number for each xfs_extent_busy extent, and have a
> background thread that does delayed discards, once all needed busy
> extents are committed. The delayed discards are also considered in
> the check that xfs_alloc_fixup_trees()  does).

We used to have a log sequence number in the busy extent to prevent
reuse of a busy extent - it would trigger a log force up to the
given LSN before allowing the extent to be reused. It caused
significant scalability problems for the busy extent tracking code,
and so it was removed and replaced with the non-blocking searches we
do now. See:

ed3b4d6 xfs: Improve scalability of busy extent tracking
e26f050 xfs: do not immediately reuse busy extent ranges
97d3ac7 xfs: exact busy extent tracking

i.e. blocking waiting for discard or log IO completion while holding
the AGF locked is a major problem for allocation latency
determinism. With discards potentially taking seconds, waiting for
them to complete while holding the AGF locked will effectively stall
parts of the filesystem for long periods of time. That blocking is
what the above commits prevent, and by doing this allow us to use
the busy extent tree for issuing discard on ranges that have been
freed....

> What do you think overall about this approach? Is there something
> fundamental that prevents it from working?

I'm not convinced that re-introducing busy extent commit
sequence tracking and blocking to optimise discard operations is a
particularly good idea given the above.

> Also (if you are still reading:),  can you kindly comment this
> question that I have:
> # xfs_free_ag_extent() has a "isfl" parameter. If it is "true", then
> this extent is added as usual to the free-space btrees, but the
> caller doesn't add it as a busy extent. This means that such extent
> is suitable for allocation right away, without waiting for the log
> commit?

It means the extent is being moved from the AGFL to the free space
btree. blocks on the AGFL have already gone through free space
accounting and busy extent tracking to get to the AGFL, and so there
is no need to repeat it when moving it to the free space btrees.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
