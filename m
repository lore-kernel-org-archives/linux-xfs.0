Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5408E7F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 11:44:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE6E5304053
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 09:44:20 -0800 (PST)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	KaggkypDF54lzLmf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 09:44:15 -0800 (PST)
Received: by mail-wi0-f174.google.com with SMTP id g10so1496400wiw.7
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 09:44:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140113030230.GF3469@dastard>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
Date: Mon, 13 Jan 2014 19:44:13 +0200
Message-ID: <CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
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
Thank you for your comments, and for pointing me at the commits.

On Mon, Jan 13, 2014 at 5:02 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jan 08, 2014 at 08:13:38PM +0200, Alex Lyakas wrote:
>> Hello Dave,
>>
>> Currently I am working on the following approach:
>>
>> Basic idea: make each xfs_extent_busy struct carry potential
>> information about a larger extent-for-discard, i.e., one that is a
>> multiple of discard_granularity.
>
> You're making a big assumption here that discard_granularity is
> useful for aggregating large extents. Discard granularity on modern
> SSDs is a single sector:
>
> $ cat /sys/block/sda/queue/discard_granularity
> 512
> $
>
> I've just checked 4 different types of SSDs I have here (from 3
> years old no-name sandforce SSDs to a brand new samsung 840 EVO),
> and htey all give the same result.
>
> IOWs, in most cases other than thin provisioning it will not be
> useful for optimising discards into larger, aligned extents.
Agree. The use case I primarily look into is, indeed, thin
provisioning. In my case, discard granularity can be, for example,
256Kb or even higher. I realize this is not the case with SSDs.

>
>> In detail this looks like this:
>> # xfs_free_ag_extent attempts to merge the freed extent into a
>> larger free-extent in the by-bno btree.  When this function
>> completes its work, we have [nbno, nlen], which is potentially a
>> larger free-extent. At this point we also know that AGF is locked.
>> # We trim [nbno, nlen] to be a multiple-of and aligned-by
>> discard_granularity (if possible), and we receive [dbno, dlen],
>> which is a very nice extent to discard.
>> # When calling xfs_extent_busy_insert(), we add these two values to
>> the xfs_extent_busy struct.
>> # When the extent-free operation is committed for this busy extent,
>> we know that we can discard this [dbno, dlen] area, unless somebody
>> have allocated an extent, which overlaps this area.
>
> This strikes me as optimisation at the wrong time i.e. optimising
> discard ranges at extent free time ignores the fact that the extent
> can be immediately reallocated, and so all the optimisation work is
> wasted.
Agree it can be reallocated. Although, based on the code, only a
metadata extent can be reallocated immediately, while user data busy
extents cannot be "unbusied" until their freeing is committed to the
log. I agree it can happen, that a non-busy part of a discard-range
can be allocated, and then the whole range cannot be discarded.

>
>> To address that, at the end of  xfs_alloc_fixup_trees() we do the following:
>> # We know that we are going to allocate [rbno, rlen] from
>> appropriate AG. So at this point, we search the busy extents tree to
>> check if there is a busy extent that holds [dbno, dlen] (this is a
>> multiple-of and aligned-by discard granularity), which overlaps
>
> How do you find that? The busy extent tree is indexed on individual
> extents that have been freed, not the discard granularity ranges
> they track.
Agree, that's why I mentioned that another rbtree is needed, that
indexes discard-ranges.

>
>> [rbno, rlen] fully or partially. If found, we shrink the [dbno,
>> dlen] area to be still a multiple-of and aligned by
>> discard-granularity, if possible. So we have a new smaller [dbno,
>> dlen] that we still can discard, attached to the same busy extent.
>> Or we discover that the new area is too small to discard, so we
>> forget about it.
>
> Forget about the discard range, right? We can't ignore the busy
> extent that covers the range being freed - it must be tracked all
> the way through to transaction commit completion.
Agree that busy extent cannot be forgotten about. I meant that we
forget only about the discard range that is related to this busy
extent. So when the transaction commit completes, we will "unbusy" the
busy extent as usual, but we will not discard anything, because there
will be no discard-range connected to this busy extent.

>
>> # The allocation flow anyways searches the busy extents tree, so we
>> should be ok WRT to locking order, but adding some extra work.
>
> There are other locking issues to be concerned about than order....
>
>> I am aware that I need to handle additional issues like:
>> # A busy extent can be "unbusyied" or shrunk by
>> xfs_extent_busy_update_extent(). We need to update [dbno, dlen]
>> accordingly or delete it fully
>> # To be able to search for [dbno, dlen], we probably need another
>> rbtree (under the same pag->pagb_lock), which tracks large extents
>> for discard. xfs_extent_busy needs additional rbnode.
>> # If during xfs_alloc_fixup_trees() we discover that extent is
>> already being discarded, we need to wait. Assuming we have
>> asynchronous discard, this wait will be short - we only need the
>> block device to queue the discard request, and then we are good to
>> allocate from that area again.
>
> * multiple busy extents can be found in the one "discard range".
> Hence there is a n:1 relationship between the busy extents and the
> related "discard extent" that might be related to it. Hence if we
> end up with:
>
>         busy1   busy2   busy3
>         +-------+-------+------+
>         +----------------------+
>              discard1
>
> and then we reuse busy2, then we have to delete discard1 and update
> busy1 and busy3 not to point at discard1. Indeed, depending on
> the discard granularity, it might ned up:
>
>         busy1           busy3
>         +-------+       +------+
>         +-------+       +------+
>         discard1        discard2
>
> And so the act of having to track optimal "discard ranges" becomes
> very, very complex.
I agree with the examples you have given. That's why I realized that
the numbering of busy extents is needed. In the first example, the
extent that was freed *last* out of busy1/busy2/busy3 will be the one
pointing at the discard range. Assume it was busy3. Continuing with
your example, even if we fully reuse busy2, we delete it from
pagb_tree, but we *never* delete it from the transaction's t_busy
list. So we can split discard1 into discard1/2 and keep them connected
to busy3. When busy3 commits, we check if busy1 and busy2 have already
committed, using the busy extents numbering. If yes, we discard. If
not, we "unbusy" busy3 as usual, and we leave discard1/2 in the second
rbtree (they have the sequence number of busy3 to know when we can
discard them).
Similar would have happened if discard1 was originally connected to
busy2. Even after full reusage of busy2, busy2 is not deleted until it
commits (it is only erased from the pagb_tree).

>
> I really don't see any advantage in tracking discard ranges like
> this, because we can do these optimisations of merging and trimming
> just before issuing the discards. And realistically, merging and
> trimming is something the block layer should be doing for us
> already.
>
Yes, I realize that XFS mindset is to do pure filesystem work, i.e.,
arrange blocks of data in files and map them to disk. The rest should
be handled by application above and by the storage system below. In
your awesome AU2012 talk, you also confirm that mindset. Trouble is
that the block layer cannot really merge small discard requests,
without the information that you have in AGF btrees.

>>
>> One thing I am unsure about, is a scenario like this:
>> # assume discard-granularity=1MB
>> # we have a 1MB almost free, except two 4K blocks, somewhere in the
>> free space
>> # Transaction t1 comes and frees 4K block A, but the 1MB extent is
>> not fully free yet, so nothing to discard
>> # Transaction t2 frees the second 4K block B, now 1MB is free and we
>> attach a [dbno, dlen] to the second busy extent
>>
>> However, I think there is no guarantee that t1 will commit before
>> t2; is that right?
>
> Correct.
>
>> But we cannot discard the 1MB extent, before both
>> transactions commit. (One approach to solve this, is to give a
>> sequence number for each xfs_extent_busy extent, and have a
>> background thread that does delayed discards, once all needed busy
>> extents are committed. The delayed discards are also considered in
>> the check that xfs_alloc_fixup_trees()  does).
>
> We used to have a log sequence number in the busy extent to prevent
> reuse of a busy extent - it would trigger a log force up to the
> given LSN before allowing the extent to be reused. It caused
> significant scalability problems for the busy extent tracking code,
> and so it was removed and replaced with the non-blocking searches we
> do now. See:
>
> ed3b4d6 xfs: Improve scalability of busy extent tracking
> e26f050 xfs: do not immediately reuse busy extent ranges
> 97d3ac7 xfs: exact busy extent tracking
>
> i.e. blocking waiting for discard or log IO completion while holding
> the AGF locked is a major problem for allocation latency
> determinism. With discards potentially taking seconds, waiting for
> them to complete while holding the AGF locked will effectively stall
> parts of the filesystem for long periods of time. That blocking is
> what the above commits prevent, and by doing this allow us to use
> the busy extent tree for issuing discard on ranges that have been
> freed....
>
>> What do you think overall about this approach? Is there something
>> fundamental that prevents it from working?
>
> I'm not convinced that re-introducing busy extent commit
> sequence tracking and blocking to optimise discard operations is a
> particularly good idea given the above.
I am not sure I am suggesting to block or lock anything (perhaps I am,
without realizing that). By and large, I suggest to have another data
structure, an rbtree, that tracks discard ranges. This rbtree is
loosely connected to the busy extent rbtree. And I suggest three
things to do with this new rbtree:
- Whenever a busy extent is added, maybe add a discard range to the
second rbtree, and attach it to the busy extent (if we got a nice
discard range)
- For each new allocation, check if something needs to be
removed/changed in this rbtree. Yes, I realize this is additional
work.
- When a busy extent commits, by all means we "unbusy" the extent as
usual. But we also check in the second rbtree, whether we can issue a
discard for some discard range. Perhaps we can. Or we cannot because
of other busy extents, that have not committed yet (the numbering is
used to determine that). In that case, we will discard later, when all
the needed busy extent commit. Unless new allocation removed/changed
this discard range already. But we are not delaying the "unbusying" of
the busy extent, and we are not keeping the AGF locked (I think).
Also, we are issuing discards in the same place and context where XFS
does it today.

>
>> Also (if you are still reading:),  can you kindly comment this
>> question that I have:
>> # xfs_free_ag_extent() has a "isfl" parameter. If it is "true", then
>> this extent is added as usual to the free-space btrees, but the
>> caller doesn't add it as a busy extent. This means that such extent
>> is suitable for allocation right away, without waiting for the log
>> commit?
>
> It means the extent is being moved from the AGFL to the free space
> btree. blocks on the AGFL have already gone through free space
> accounting and busy extent tracking to get to the AGFL, and so there
> is no need to repeat it when moving it to the free space btrees.
Ok, I realize now that this block has already gone through the busy
extent tracking via xfs_allocbt_free_block().

Thanks,
Alex.

P.S.: Just watched your AU2014 talk. Interesting.

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
