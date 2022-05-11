Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB59CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 22:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241939AbiEKWYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 May 2022 18:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiEKWYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 18:24:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78E2FEAD09
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 15:24:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4B82053459D;
        Thu, 12 May 2022 08:24:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noukT-00Aqvg-F9; Thu, 12 May 2022 08:24:01 +1000
Date:   Thu, 12 May 2022 08:24:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220511222401.GK1098723@dread.disaster.area>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
 <20220510190212.GC27195@magnolia>
 <20220510220523.GU1098723@dread.disaster.area>
 <YnvaT4TGUhb+94bI@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnvaT4TGUhb+94bI@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627c3783
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=uRUiof3Ezerb3iH2wbMA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 11:46:23AM -0400, Brian Foster wrote:
> On Wed, May 11, 2022 at 08:05:23AM +1000, Dave Chinner wrote:
> > On Tue, May 10, 2022 at 12:02:12PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 10, 2022 at 09:21:03AM +0300, Amir Goldstein wrote:
> > > > On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > I think the upcoming nrext64 xfsprogs patches took in the first patch in
> > > > > that series.
> > > > >
> > > > > Question: Now that mkfs has a min logsize of 64MB, should we refuse
> > > > > upgrades for any filesystem with logsize < 64MB?
> > > > 
> > > > I think that would make a lot of sense. We do need to reduce the upgrade
> > > > test matrix as much as we can, at least as a starting point.
> > > > Our customers would have started with at least 1TB fs, so should not
> > > > have a problem with minimum logsize on upgrade.
> > > > 
> > > > BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
> > > > practice of users to start with a small fs and grow it, which is encouraged by
> > > > Cloud providers pricing model.
> > > > 
> > > > I had asked Ted about the option to resize the ext4 journal and he replied
> > > > that in theory it could be done, because the ext4 journal does not need to be
> > > > contiguous. He thought that it was not the case for XFS though.
> > > 
> > > It's theoretically possible, but I'd bet that making it work reliably
> > > will be difficult for an infrequent operation.  The old log would probably
> > > have to clean itself, and then write a single transaction containing
> > > both the bnobt update to allocate the new log as well as an EFI to erase
> > > it.  Then you write to the new log a single transaction containing the
> > > superblock and an EFI to free the old log.  Then you update the primary
> > > super and force it out to disk, un-quiesce the log, and finish that EFI
> > > so that the old log gets freed.
> > > 
> > > And then you have to go back and find the necessary parts that I missed.
> > 
> > The new log transaction to say "the new log is over there" so log
> > recovery knows that the old log is being replaced and can go find
> > the new log and recover it to free the old log.
> > 
> > IOWs, there's a heap of log recovery work needed, a new
> > intent/transaction type, futzing with feature bits because old
> > kernels won't be able to recovery such a operation, etc.
> > 
> > Then there's interesting issues that haven't ever been considered,
> > like having a discontiguity in the LSN as we physically switch logs.
> > What cycle number does the new log start at? What happens to all the
> > head and tail tracking fields when we switch to the new log? What
> > about all the log items in the AIL which is ordered by LSN? What
> > about all the active log items that track a specific LSN for
> > recovery integrity purposes (e.g. inode allocation buffers)? What
> > about updating the reservation grant heads that track log space
> > usage? Updating all the static size calculations used by the log
> > code which has to be done before the new log can be written to via
> > iclogs.
> > 
> 
> If XFS were going to support an online switchover of the physical log,
> why not do so across a quiesce? To try and do such a thing with active
> records, log items, etc. that are unrelated to the operation seems
> unnecessarily complex to me.

queisce state doesn't solve those problems. The old log has to have
committed active items in it when we switch (e.g. intent items for
the location of the new log, alloc records for the new log, etc) and
the new log has to have active items after the switch (EFI for the
old log, etc).  Just because the log is empty when we start the log
switch it doesn't mean it remains empty as we do the switchover
work.

If we want to avoid active items while writing stuff to the log,
then we going to need a custom path building lv chains to pass to
xlog_write(), like how we write unmount records.

i.e. what we probably need is a pair of custom log record that isn't
an transaction or unmount record that contains all the information
for telling the log where the new log is, and another at the start
of the new log that records where the old log was.

That way we only need to care about LSN, head/tail, start
offset, length, any changes to transaction reservations for
different physical log characteristics, etc

> TBH, if one were to go through the trouble of making the log resizeable,
> I start to wonder whether it's worth starting with a format change that
> better accommodates future flexibility. For example, the internal log is
> already AG allocated space.. why not do something like assign it to an
> internal log inode attached to the sb?  Then the log inode has the
> obvious capability to allocate or free (non-active log) extents at
> runtime through all the usual codepaths without disruption because the
> log itself only cares about a target device, block offset and size. We
> already know a bump of the log cycle count is sufficient for consistency
> across a clean mount cycle because repair has been zapping clean logs by
> default as such since pretty much forever.

Putting the log in an inode isn't needed for allocate/free of raw
extents - we already do that with grow/shrink for the tail of an AG.
Hence I'm not sure what virtually mapping the log actually gains us
over just a raw extent pointed to by the superblock?

> That potentially reduces log reallocation to a switchover algorithm that
> could run at mount time. I.e., a new prospective log extent is allocated
> at runtime (and maybe flagged with an xattr or something). The next
> mount identifies a new/prospective log, requires/verifies that the old
> log is clean, selects the new log extent (based on some currently
> undefined selection algorithm) and seeds it with the appropriate cycle
> count via synchronous transactions that release any currently inactive
> extent(s) from the log inode. Any failure along the way sticks with the
> old log and releases the still inactive new extent, if it happens to
> exist. We already do this sort of stale resource clean up for other
> things like unlinked inodes and stale COW blocks, so the general premise
> exists.. hm?

That seems like just as much special case infrastructure as a custom
log record type to run it online, and overall the algorithm isn't
much different. And the online change doesn't require an on-disk
format change...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
