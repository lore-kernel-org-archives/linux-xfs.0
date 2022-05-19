Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5A3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 23:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiESXFX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 19:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiESXFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 19:05:22 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38C7724F3C
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 16:05:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 140EA10E6895;
        Fri, 20 May 2022 09:05:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrpCn-00E1nY-Eb; Fri, 20 May 2022 09:05:17 +1000
Date:   Fri, 20 May 2022 09:05:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220519230517.GZ1098723@dread.disaster.area>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
 <20220510190212.GC27195@magnolia>
 <20220510220523.GU1098723@dread.disaster.area>
 <YnvaT4TGUhb+94bI@bfoster>
 <20220511222401.GK1098723@dread.disaster.area>
 <YoJTEgS939eM1OgN@bfoster>
 <20220517093041.GP1098723@dread.disaster.area>
 <YoZrOYIkip5fTncN@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoZrOYIkip5fTncN@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6286cd30
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=3IqzvCCdJH4w8G7TvW0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 12:07:21PM -0400, Brian Foster wrote:
> On Tue, May 17, 2022 at 07:30:41PM +1000, Dave Chinner wrote:
> > On Mon, May 16, 2022 at 09:35:14AM -0400, Brian Foster wrote:
> > We can - and IMO should - run the physical location swap the
> > entirely within the log code itself without involving transactions,
> > log items, the CIL, AIL, etc. The log is capable of writing it's own
> > records (example: log unmount records), hence we can implement the
> > physical swap in a recoverable manner at that level without
> > involving an high level transactions or log items at all.
> > 
> > If we separate the transactional allocation/freeing of extents from
> > the exchange of the log location, then we don't have to try to work
> > out how to run a recoverable transaction that creates a
> > discontinuity in the mechanism that provides transaction recovery
> > and is completely recoverable itself.
> > 
> > The high level filesystem operation can provide the log with a new
> > extent that is already owned by the log and will remain that way
> > through the quiesce process. With that, the log location swap
> > doesn't need any other interactions with the transaction subsystem -
> > We just need to be able to write to the old log directly, to
> > initialise the new log with the same information, and to write the
> > superblock directly. The log already writes the superblock directly
> > as part of log recovery, so doing it as part of a log swap isn't an
> > issue.
> > 
> 
> I think I follow the approach you're describing of burying extent
> ownership into the log itself with a custom/open-coded log record. I
> conceptualize this as sort of an xfs_log_remount() mechanism from an old
> range to a new one. It sounds sensible enough, but I'm not sure I follow
> what the low level switchover sequence looks like, particularly how
> crash recovery is handled. Could you run through the key steps that
> provide the basic atomicity of the operation?
> 
> For example, I'll just take a stab and assume it goes something like:
> 
> 1. Allocate the new log extent and commit it in a transaction with a
> LOGCHANGE record that refers to the old range and new log range.
>
> 2. Do some sort of (partial?) quiesce/freeze that drains the AIL but
> doesn't lose the opencoded LOGCHANGE intent record (and ensures it isn't
> lost by covering etc.)..?? Tear down old log subsystem and init new one.
> 
> 3. Format the new log appropriately (cycle, etc.) with a copy
> (essentially a relog) of the LOGCHANGE intent. 
> 
> 4. Sync update the superblock to point at the new log.
> 
> 5. Free the old log extent via transaction that also includes a
> LOGCHANGE intent done (to the new log).


> So essentially a crash after step 2 recovers the original log and
> restarts the log change op at the new log format step (since recovery
> can't confirm whether it occurred) or a crash after step 4 recovers the
> new log and frees the old based on whether the intent done record exists
> or not.

Yup, that's pretty much the idea.

> Is that the right idea? If not, can you swizzle it into something that
> is? If so, the part that is not so clear to me is what the magic looks
> like to commit the extent alloc/frees with the open-coded log record(s)
> without conflicting with quiesce (i.e. managing consistency with the
> transactional part vs. the open coded record write part), or otherwise
> managing consistency between the extent alloc and existence of the
> custom record.

I was thinking of using CIL pinning to handle building the atomic
log change transactions that contain the necessary alloc/free
modifications.

In doing so, it means we can implement the LOG CHANGE record as a
different type of checkpoint transaction. The CIL flush just
includes more information in the struct xfs_trans_header it writes
at the start of the transaction to point at the old/new logs, and we
call that a XFS_TRANS_LOG_CHANGE_CHECKPOINT type instead of
XFS_TRANS_CHECKPOINT. Then we can recover the allocation
modifications in the checkpoint transaction using the existing code,
then perform the correct next recovery steps based on the current
superblock state.

With this trans header size change, old kernels will see a trans
header that is too long, so will refuse to recover at this point as
they think the log has been corrupted as they don't understand what
is in it. If we want to make the process more complex, we can
set a log incompat flag after the initial quiesce and clear it after
the final unmount record is written on completion.

Hence I think the overall process I think would be:

1. freeze the filesystem, quiesce the log. Write an unmount record
to place a hard recovery barrier in the log.

2. pin the CIL so it can't flush.

3. allocate an anonymous extent like we do in xfs_ag_shrink_space().
Then update the rmap to say it's owned by the log. These are
in-memory transactions at this point.

4. hand the extent to the log.

5. log formats the new extent.

6. log creates a new xlog instance pointing at the new log. This
completely duplicates all the log infrastructure (iclogs, etc).

7. log flushes the pinned CIL to current iclog with a LOG CHANGE
header record. iclog contents are duplicated into an iclog for the
new log, and modified for new log's cycle/block. New log iclog is
written first, then on completion the original iclog is written to
the old log.

8. update and write the superblock.

9. tear down the old xlog structure but don't free it.

10. memcpy() the new xlog over the top of the old one so we don't
have to update ever pointer to the log in the filesytem (e.g. every
log item attached to inodes that were once dirty, etc). This also
updates grant heads, log head/tail, etc to match the new log.

11. free the new xlog stucture without tearing it down.

12. push the CIL log items into the AIL with commit LSNs from the
new log.

13. hand the old log extent back to the caller that provided the new
log extent.

14. run transactions to free the old extent and run all the
associated deferops (e.g. rmap updates) that are needed.

15. Unpin the CIL and return to quiesced log state. This forces the
CIL to disk with a LOG CHANGE header record indicating completion of
the log change. Quiesce then writes all the metadata and updates the
tail with an unmount record, providing a hard recovery barrier in
the log.

16. unfreeze the filesystem with the new log active.

I suspect that some of the ordering in and around the setup and
changeover of the two logs will be needed - it's just a rough design
at this point, but that should give you an idea of what I was
thinking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
