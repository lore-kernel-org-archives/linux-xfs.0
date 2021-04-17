Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DB2C43460
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 01:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B90611AB
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 01:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhDQB5d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 21:57:33 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55764 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhDQB5c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 21:57:32 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3B4A210428D5;
        Sat, 17 Apr 2021 11:57:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lXaCk-00BZfR-Ov; Sat, 17 Apr 2021 11:57:02 +1000
Date:   Sat, 17 Apr 2021 11:57:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210417015702.GT63242@dread.disaster.area>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
 <20210417001941.GC3122276@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417001941.GC3122276@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ye_JUFJUjT06L0fGW2QA:9 a=TQuDGcd8xqRuBanA:21 a=PGy9DwexgjBsZ3iH:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 16, 2021 at 05:19:41PM -0700, Darrick J. Wong wrote:
> On Sat, Apr 17, 2021 at 05:13:20AM +0800, Gao Xiang wrote:
> > Hi Darrick,
> > 
> > On Fri, Apr 16, 2021 at 09:00:13AM -0700, Darrick J. Wong wrote:
> > > On Fri, Apr 16, 2021 at 05:10:23PM +0800, Gao Xiang wrote:
.....
> > > Are you saying that because the f46e commit removed the xfs_sync_sb
> > > calls from unmountfs for !lazysb filesystems, we no longer log the
> > > summary counters at unmount?  Which means that we no longer write the
> > > incore percpu fdblocks count to disk at unmount after we've torn down
> > > all the incore space reservations (when sb_fdblocks == m_fdblocks)?
> > 
> > Er.. I think that is by reverse, before commit f46e, we no longer logged
> > the summary counters at unmount, due to 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_mount.c?h=v5.11#n1177
> >   xfs_unmountfs
> >     -> xfs_log_sbcount
> >       -> !xfs_sb_version_haslazysbcount
> >         -> return 0 (xfs_sync_sb bypassed).
> > 
> > So the only time we update the ondisk fdblocks was during transactions,
> > but xfs_log_sb() corrupted this (due to no summary counters logging at
> > unmount).
> 
> *OH* ok, so this isn't a fix for a regression in Brian's log covering
> refactoring series that went into 5.12; this is a fix for a years old
> bug that may very well have been there since the introduction of ...
> delayed allocation?  I guess?

No, xfs_trans_apply_sb_deltas() modifies the counters in the on disk
superblock buffer directly. These counters don't contain the
in-memory reservations for things like delalloc that are held in the
counters in the xfs_mount (either percpu or mp->m_sb.sb_*).

The whole point of lazy superblock counters was avoiding this disk
buffer update, because it required taking the superblock buffer lock
and that serialised every transaction commit that did
allocation/freeing. This serialised the entire transaction system,
and effectively globally limited XFS to around 20,000 commits/sec....

The original code was this:

/*
 * xfs_log_sbcount
 *
 * Called either periodically to keep the on disk superblock values
 * roughly up to date or from unmount to make sure the values are
 * correct on a clean unmount.
 *
 * Note this code can be called during the process of freezing, so
 * we may need to use the transaction allocator which does not not
 * block when the transaction subsystem is in its frozen state.
 */
int
xfs_log_sbcount(
       xfs_mount_t     *mp,
       uint            sync)
{
       xfs_trans_t     *tp;
       int             error;

       if (!xfs_fs_writable(mp))
               return 0;

       xfs_icsb_sync_counters(mp);

       /*
        * we don't need to do this if we are updating the superblock
        * counters on every modification.
        */
       if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
               return 0;

       tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
       error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
                                       XFS_DEFAULT_LOG_COUNT);
       if (error) {
               xfs_trans_cancel(tp, 0);
               return error;
       }

       xfs_mod_sb(tp, XFS_SB_IFREE | XFS_SB_ICOUNT | XFS_SB_FDBLOCKS);
       if (sync)
               xfs_trans_set_sync(tp);
       xfs_trans_commit(tp, 0);

       return 0;
}

And that slowly ended up being modified and merged into
xfs_log_sb()/xfs_sync_sb() and xfs_log_sb() gained more callers that
didn't have the lazysbcount check. i.e. we lost the original reason
for doing this counter update, and so we end up using it
incorrectly.  Brian's log covering rework got rid of the explicit
xfs_log_sbcount() call in the unmount path and replaced it with this
"log covering is not needed sometimes when lazysbcounters are not in
use". So now there isn't any of the original "counter updates are
only necessary for lazysbcount filesystems" code left...

Going back further, we always used to write the superblock at
unmount, and this always used to happen after all the reservations
had been released. Hence it didn't matter whether lazy-sb was
enabled or not, the unmount always wrote out the correct value to
the superblock.

This explicit superblock write was removed from xfs_unmountfs() back
in 2012 by commit 211e4d434bd7 ("xfs: implement freezing by emptying
the AIL") where is was replaced in the unmount path by a call to
xfs_ail_push_all_sync(mp->m_ail). With an explicit call to
xfs_log_sbcount() in the unmountfs path, it was clear that this
would result in the superblock getting written if counters needed
syncing.

IOWs, these changes in 2012 meant that if the superblock is not
dirty, we don't actually write it at unmount. Which means that, for
a non-lazy sb counter filesyste, if the last thing to modify the
superblock was a call to xfs_log_sbcount(), there's every chance
that the superblock that is written back contains the in-memory
values in it from the percpu counters, not the value from
mp->m_sb.sb_fdblocks....

It's only taken ~10 years of testing to find an escape on a clean
unmount.... :/

So, yeah, this seems like a combination of changes over a period of
years adding up to incorrectly logging the superblock counts and not
noticing because unmount on lazycount filesystems rewrites them to
be correct on a clean unmount. BUt with lazysbcount == 0, we've
ended up with an escape because we don't actually update and write
the superblock at unmount anymore.

> > But I have no idea xfs_log_need_covered(mp) is always true at that time,
> > and the patchset seems a bit large and (possibly) hard to backport...
> 
> I wouldn't backport that to a stable series. :)

Nor is it necessary to fix the problem.

> > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > index 60e6d255e5e2..423dada3f64c 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > > >  
> > > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > > +
> > > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> 
> Hmm... is this really needed?  I thought in !lazysbcount mode,
> xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
> So aren't all three of these updates unnecessary?

Yup, now I understand the issue, the fix is simply to avoid these
updates for !lazysb. i.e. it should just be:

	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
	}
	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
