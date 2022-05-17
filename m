Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126E9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 09:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiEQJbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 05:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243315AbiEQJaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 05:30:52 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCA29B73
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 02:30:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 89F7D10E69A5;
        Tue, 17 May 2022 19:30:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nqtXN-00D0ft-Ij; Tue, 17 May 2022 19:30:41 +1000
Date:   Tue, 17 May 2022 19:30:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220517093041.GP1098723@dread.disaster.area>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
 <20220510190212.GC27195@magnolia>
 <20220510220523.GU1098723@dread.disaster.area>
 <YnvaT4TGUhb+94bI@bfoster>
 <20220511222401.GK1098723@dread.disaster.area>
 <YoJTEgS939eM1OgN@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoJTEgS939eM1OgN@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62836b44
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=CNp1C4ou9zpPS-V2Or8A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 16, 2022 at 09:35:14AM -0400, Brian Foster wrote:
> On Thu, May 12, 2022 at 08:24:01AM +1000, Dave Chinner wrote:
> > On Wed, May 11, 2022 at 11:46:23AM -0400, Brian Foster wrote:
> > > On Wed, May 11, 2022 at 08:05:23AM +1000, Dave Chinner wrote:
> > > > On Tue, May 10, 2022 at 12:02:12PM -0700, Darrick J. Wong wrote:
> > > > > On Tue, May 10, 2022 at 09:21:03AM +0300, Amir Goldstein wrote:
> > > > > > On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > > > I think the upcoming nrext64 xfsprogs patches took in the first patch in
> > > > > > > that series.
> > > > > > >
> > > > > > > Question: Now that mkfs has a min logsize of 64MB, should we refuse
> > > > > > > upgrades for any filesystem with logsize < 64MB?
> > > > > > 
> > > > > > I think that would make a lot of sense. We do need to reduce the upgrade
> > > > > > test matrix as much as we can, at least as a starting point.
> > > > > > Our customers would have started with at least 1TB fs, so should not
> > > > > > have a problem with minimum logsize on upgrade.
> > > > > > 
> > > > > > BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
> > > > > > practice of users to start with a small fs and grow it, which is encouraged by
> > > > > > Cloud providers pricing model.
> > > > > > 
> > > > > > I had asked Ted about the option to resize the ext4 journal and he replied
> > > > > > that in theory it could be done, because the ext4 journal does not need to be
> > > > > > contiguous. He thought that it was not the case for XFS though.
> > > > > 
> > > > > It's theoretically possible, but I'd bet that making it work reliably
> > > > > will be difficult for an infrequent operation.  The old log would probably
> > > > > have to clean itself, and then write a single transaction containing
> > > > > both the bnobt update to allocate the new log as well as an EFI to erase
> > > > > it.  Then you write to the new log a single transaction containing the
> > > > > superblock and an EFI to free the old log.  Then you update the primary
> > > > > super and force it out to disk, un-quiesce the log, and finish that EFI
> > > > > so that the old log gets freed.
> > > > > 
> > > > > And then you have to go back and find the necessary parts that I missed.
> > > > 
> > > > The new log transaction to say "the new log is over there" so log
> > > > recovery knows that the old log is being replaced and can go find
> > > > the new log and recover it to free the old log.
> > > > 
> > > > IOWs, there's a heap of log recovery work needed, a new
> > > > intent/transaction type, futzing with feature bits because old
> > > > kernels won't be able to recovery such a operation, etc.
> > > > 
> > > > Then there's interesting issues that haven't ever been considered,
> > > > like having a discontiguity in the LSN as we physically switch logs.
> > > > What cycle number does the new log start at? What happens to all the
> > > > head and tail tracking fields when we switch to the new log? What
> > > > about all the log items in the AIL which is ordered by LSN? What
> > > > about all the active log items that track a specific LSN for
> > > > recovery integrity purposes (e.g. inode allocation buffers)? What
> > > > about updating the reservation grant heads that track log space
> > > > usage? Updating all the static size calculations used by the log
> > > > code which has to be done before the new log can be written to via
> > > > iclogs.
> > > > 
> ...
> > 
> > > TBH, if one were to go through the trouble of making the log resizeable,
> > > I start to wonder whether it's worth starting with a format change that
> > > better accommodates future flexibility. For example, the internal log is
> > > already AG allocated space.. why not do something like assign it to an
> > > internal log inode attached to the sb?  Then the log inode has the
> > > obvious capability to allocate or free (non-active log) extents at
> > > runtime through all the usual codepaths without disruption because the
> > > log itself only cares about a target device, block offset and size. We
> > > already know a bump of the log cycle count is sufficient for consistency
> > > across a clean mount cycle because repair has been zapping clean logs by
> > > default as such since pretty much forever.
> > 
> > Putting the log in an inode isn't needed for allocate/free of raw
> > extents - we already do that with grow/shrink for the tail of an AG.
> > Hence I'm not sure what virtually mapping the log actually gains us
> > over just a raw extent pointed to by the superblock?
> > 
> 
> I'm not sure what virtually mapping the log has to do with anything..?

That's what adding the inode BMBT indirection to point at the log
blocks is - it's virtually mapping the physical block location.

> That seems like something to consider for the future if there's value to
> it..

Virtual mapping as in "memory mapping the log" is a different
problem altogether. We've talked about that several times in the
context of DAX to avoid at least one level of memcpy() that the log
writes currently do on PMEM systems.

> > > That potentially reduces log reallocation to a switchover algorithm that
> > > could run at mount time. I.e., a new prospective log extent is allocated
> > > at runtime (and maybe flagged with an xattr or something). The next
> > > mount identifies a new/prospective log, requires/verifies that the old
> > > log is clean, selects the new log extent (based on some currently
> > > undefined selection algorithm) and seeds it with the appropriate cycle
> > > count via synchronous transactions that release any currently inactive
> > > extent(s) from the log inode. Any failure along the way sticks with the
> > > old log and releases the still inactive new extent, if it happens to
> > > exist. We already do this sort of stale resource clean up for other
> > > things like unlinked inodes and stale COW blocks, so the general premise
> > > exists.. hm?
> > 
> > That seems like just as much special case infrastructure as a custom
> > log record type to run it online, and overall the algorithm isn't
> > much different. And the online change doesn't require an on-disk
> > format change...
> > 
> 
> It seems a lot more simple to me, assuming it's viable, but then again I
> don't see a clear enough description of what you're comparing against to
> reason about it with certainty. I also don't think it necessarily
> depends on a format change. I.e., perhaps an online variant could look
> something like the following (pseudo algorithm):
> 
> 1. Userspace growfs feeds in a tmpfile or some such donor inode via
> ioctl() that maps the new/prospective log as a data extent. Assume the
> extent is ideally sized/allocated and disk content is properly formatted
> as a valid log with an elevated cycle count for the purpose of this
> sequence.

It would have to be a single contiguous extent and correctly
aligned to sunit/swidth as the original log would have been.
Otherwise stuff like log stripe unit IO optimisations get broken.

> 2. Quiesce the log, freeze the fs, xfs_log_unmount() the active log and
> xfs_log_mount() the new range based on the extent mapped by the donor
> inode.
> 
> 3. Commit changes to the new log range to unmap the current extent (i.e.
> the new log) from the donor inode and map the old log range, keeping the
> in-core inode pinned/locked so it cannot be written back.

So a specialised swap extent operation? Currently we can swap
individual extents between inodes (the rmap extent swap code), but I
don't think we can't swap an inode extent with a bare, unreferenced
"free space" extent right now.

> At this point
> the only changes on disk are to the donor's data extent (still mapped by
> the inode).

And potentially rmap btree updates because the type and owner of
both extents change. There's also the need to mark the old log
extent as unwritten, because if we crash iand recovery doesn't free
the donor inode, we don't want to risk exposing the old contents of
the log to userspace.

Also, Because rmap updates are deferred, the changes will span
multiple transactions via intents, so this will make use of the CIL
and, potentially, commit to the log and insert items into the AIL.

If we get items in the AIL, we are open to metadata writeback
starting while we are still doing the log changeover.  e.g. memory
pressure occurs, direct reclaim causes xfs_reclaim_inodes_nr() to
run which calls xfs_ail_push_all(mp->m_ail)....

Hence if we end up with new metadata changes in place, we can't go
back to the old log - we've got changes that are only sequenced in
the new log, so we can only recover at this point from the new log.

Yes, we can fix all these things, but we'll end up touching lots of
high level code in subtle ways to make this all work, and I can't
help but think this will end up being a bit fragile as a result.

> The superblock has not been updated, so any crash/recovery
> will see the original log in the quiesced state, recover as normal and
> process the donor file as an unlinked inode.
> 
> (The filesystem at this point has two recoverable logs. The original log
> is unmodified since the quiesce and still referenced by the superblock.
> It can be recovered in the event of a log switch failure. The new log
> still resides in an inode extent mapping, but contains valid log records
> to exchange its own extent mapping with the old log range).

Noted, but as per above, the potential for metadata writeback to
occur before we've switch logs means we can't just go back to the
old log. hence to make sure this works, we'll need new interlocks to
ensure operations like metadata writeback can't occur while the log
swap transactions are being performed.

> 4. Sync update the superblock to point at the new log range and unpin
> the donor inode.
> A crash after this point sees the new log in the sb and
> recovers the changes to map the old log into the donor inode. The old
> log range is returned to free space upon unlinked inode processing of
> the donor inode.

Yeah, the moment we write the superblock, we have to be prepared to
recover from the new log. That's why I think that both the old
log and the new log should just have an identical "log change"
record written to them after the unmount record. That simply records
the location/size of both the old log and the new log and we can
recover from that no matter which side of the superblock write we
crash on.

i.e. we have the same change record information in both logs and the
recovery action we need to perform only differs by the old log
having to first:

- update the superblock to point at the new log
- switch to the new log
- restart log recovery on the new log.

> I'm not totally sure that works without prototyping some basic form of
> it, but it seems generally sane to me.

I think we could make it work, but it my gut tells me it is the
wrong approach.

> There are a lot of implementation
> details to work through as well of course, such as whether the kernel
> allocates the prospective log extent before the quiesce (and seeds it),
> whether to support the ability to allocate the new in-core log subsystem
> before tearing down the old (for more reliable failure handling and so
> it can be activated atomically), how to format changes into the new log,
> etc. etc., but that's far more detail than this is intended to cover...

*nod*

I'm not doubting it could be done, but I feel that it requires
far more high level filesystem structures to be manipulated in
intricate ways than I'm comfortable with.

My main reservation is that using inodes, BMBT and RMAP updates for
physically swapping the location of the log involves layers of the
filesystem that the log itself should not be interacting with. I'm
just not comfortable to tying low level physical log layout
manipulations to high level transactional filesystem metadata
modifications that rely on writing to the log for recovery.

We can - and IMO should - run the physical location swap the
entirely within the log code itself without involving transactions,
log items, the CIL, AIL, etc. The log is capable of writing it's own
records (example: log unmount records), hence we can implement the
physical swap in a recoverable manner at that level without
involving an high level transactions or log items at all.

If we separate the transactional allocation/freeing of extents from
the exchange of the log location, then we don't have to try to work
out how to run a recoverable transaction that creates a
discontinuity in the mechanism that provides transaction recovery
and is completely recoverable itself.

The high level filesystem operation can provide the log with a new
extent that is already owned by the log and will remain that way
through the quiesce process. With that, the log location swap
doesn't need any other interactions with the transaction subsystem -
We just need to be able to write to the old log directly, to
initialise the new log with the same information, and to write the
superblock directly. The log already writes the superblock directly
as part of log recovery, so doing it as part of a log swap isn't an
issue.

Then we can hand the old extent back to the high level code and it
can free it. Once it is freed, we can queisce the log again and the
new unmount record effectively cancels the log swap record at the
start of the log as it is no longer between the head and tail.

Job done, and at that point the filesystem can be resumed on the new
log.

If you want to work out the high level transactional allocation,
quiesce and freeing side of things, I can write the low level "log
change" record and recovery code taht swaps the location of the log.
I think if we separate the two sets of operations and isolate them
within the appropriate layers, everything becomes a lot easier and
it doesn't need to fall on just one person to do everything...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
