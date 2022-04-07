Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302ADC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 23:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiDGXlr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 19:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiDGXlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 19:41:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958DAF55E8
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 16:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31156B82993
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 23:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C443DC385A0;
        Thu,  7 Apr 2022 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649374781;
        bh=YBwJ0OYHIbmgrvH5qpY5YD+NwV8CvabXs0cKxougF/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dIPEMavrpA0kJhxt6c0bTU6xdpajFIEYAPZS0cZfwDI9Q4anAraRTsfiUIeaSnvxO
         WrTpLcpmkp4szB1dPg4FJYf4Ars7+55AtMbGHeBUtwri7F/dHoue1babeJvIADv/4B
         ZEjf5ilnEJ/lxXpk/tOZohXkRKiGfc84K0GBGXivsoChBNtkelfjE4Oh+fnUUKa1z/
         NKUNCzztI42273bcUP7wlKp1tntbGsXRSHvYsd4sgGns1U13/nMdC1oCMSPYuIASu6
         0GBssaMBk0ceb+/V46h60oUM9Fv4IUILCFG6gnCuhiriIy+20YfeZgMsM0m7fTSvDc
         8LqwaBCEjnGnw==
Date:   Thu, 7 Apr 2022 16:39:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: recalculate free rt extents after log recovery
Message-ID: <20220407233941.GC27690@magnolia>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
 <164936441684.457511.12252243723468714698.stgit@magnolia>
 <20220407215605.GL1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407215605.GL1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 08, 2022 at 07:56:05AM +1000, Dave Chinner wrote:
> On Thu, Apr 07, 2022 at 01:46:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I've been observing periodic corruption reports from xfs_scrub involving
> > the free rt extent counter (frextents) while running xfs/141.  That test
> > uses an error injection knob to induce a torn write to the log, and an
> > arbitrary number of recovery mounts, frextents will count fewer free rt
> > extents than can be found the rtbitmap.
> > 
> > The root cause of the problem is a combination of the misuse of
> > sb_frextents in the incore mount to reflect both incore reservations
> > made by running transactions as well as the actual count of free rt
> > extents on disk.  The following sequence can reproduce the undercount:
> > 
> > Thread 1			Thread 2
> > xfs_trans_alloc(rtextents=3)
> > xfs_mod_frextents(-3)
> > <blocks>
> > 				xfs_attr_set()
> > 				xfs_bmap_attr_addfork()
> > 				xfs_add_attr2()
> > 				xfs_log_sb()
> > 				xfs_sb_to_disk()
> > 				xfs_trans_commit()
> > <log flushed to disk>
> > <log goes down>
> > 
> > Note that thread 1 subtracts 3 from sb_frextents even though it never
> > commits to using that space.  Thread 2 writes the undercounted value to
> > the ondisk superblock and logs it to the xattr transaction, which is
> > then flushed to disk.  At next mount, log recovery will find the logged
> > superblock and write that back into the filesystem.  At the end of log
> > recovery, we reread the superblock and install the recovered
> > undercounted frextents value into the incore superblock.  From that
> > point on, we've effectively leaked thread 1's transaction reservation.
> > 
> > The correct fix for this is to separate the incore reservation from the
> > ondisk usage, but that's a matter for the next patch.  Because the
> > kernel has been logging superblocks with undercounted frextents for a
> > very long time and we don't demand that sysadmins run xfs_repair after a
> > crash, fix the undercount by recomputing frextents after log recovery.
> > 
> > Gating this on log recovery is a reasonable balance (I think) between
> > correcting the problem and slowing down every mount attempt.  Note that
> > xfs_repair will fix undercounted frextents.
> 
> That seems reasonable to me. I agree with the method used to fix the
> problem, but I have some concerns/questions over where/how it is
> implemented.
> 
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_rtalloc.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 64 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index b8c79ee791af..c9ab4f333472 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -19,6 +19,7 @@
> >  #include "xfs_icache.h"
> >  #include "xfs_rtalloc.h"
> >  #include "xfs_sb.h"
> > +#include "xfs_log_priv.h"
> >  
> >  /*
> >   * Read and return the summary information for a given extent size,
> > @@ -1284,6 +1285,43 @@ xfs_rtmount_init(
> >  	return 0;
> >  }
> >  
> > +static inline int
> > +xfs_rtalloc_count_frextent(
> > +	struct xfs_trans		*tp,
> > +	const struct xfs_rtalloc_rec	*rec,
> > +	void				*priv)
> > +{
> > +	uint64_t			*valp = priv;
> > +
> > +	*valp += rec->ar_extcount;
> > +	return 0;
> > +}
> > +
> > +/* Reinitialize the number of free realtime extents from the realtime bitmap. */
> > +STATIC int
> > +xfs_rtalloc_reinit_frextents(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_trans	*tp;
> > +	uint64_t		val = 0;
> > +	int			error;
> > +
> > +	error = xfs_trans_alloc_empty(mp, &tp);
> > +	if (error)
> > +		return error;
> 
> At this point in the mount, the transaction subsystem is not
> really available for use. I understand that this is an empty
> transaction and it doesn't reserve log space, but I don't like
> creating an implicit requirement that xfs_trans_alloc_empty() never
> touches log state for this code to work correctly into the future.

<nod> I'd wondered if it was really a good idea to be creating a
transaction at the "end" of log recovery.  Recovery itself does it, but
at least that's a carefully controlled box...

> That is, the log isn't in a state where we can run normal
> transactions because we can still have pending intent recovery
> queued in the AIL. These can't be moved from the tail of the AIL
> until xfs_log_mount_finish() is called to remove and process them.
> They are dependent on there being enough log space remaining for the
> transaction reservation they make to succeed and there may only be
> just enough space for the first intent to make that reservation.
> Hence if we consume any log space before we recover intents, we can
> deadlock on log space when then trying to recover the intents. And
> because the AIL can't push on intents, the same reservation deadlock
> could occur with any transaction reservation we try to run before
> xfs_log_mount_finish() has been run.
> 
> Yes, I know this is an empty transaction and so it doesn't push on
> the log or consume any space. But I think it's a bad precedent even
> to use transactions at all when we know we are in the middle of log
> recovery and the transaction subsystem is not open for general use
> yet.  Hence I think using transaction handles - even empty ones -
> before xfs_log_mount_finish() is run is a pattern we want to avoid
> if at all possible.

...yes...

> > +
> > +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> > +	error = xfs_rtalloc_query_all(tp, xfs_rtalloc_count_frextent, &val);
> 
> Looking at the code here, AFAICT the only thing the tp is absolutely
> required for here is to hold the mount pointer - all the internal
> bitmap walk operations grab and release buffers using interfaces
> that can handle a null tp being passed.
> 
> Hence it looks to me like a transaction context isn't necessary for
> this read-only bitmap walk. Is that correct?  Converting
> xfs_rtalloc_query_all() to take a mount and a trans would also make
> this code becomes a lot simpler....

...and I was about to say "Yeah, we could make xfs_rtalloc_query_all
take the mount and an optional transaction", but it occurred to me:

The rtalloc queries need to read the rtbitmap file's data fork mappings
into memory to find the blocks.  If the rtbitmap is fragmented enough
that the data fork is in btree format and the bmbt contains an upward
cycle, loading the bmbt will livelock the mount attempt.

Granted, xfs_bmapi_read doesn't take a transaction, so this means that
we'd either have to change it to take one, or we'd have to change the
rtmount code to create an empty transaction and call iread_extents to
detect a bmbt cycle.

So yeah, I think the answer to your question is "yes", but then there's
this other issue... :(

> 
> > +	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
> > +	xfs_trans_cancel(tp);
> > +	if (error)
> > +		return error;
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	mp->m_sb.sb_frextents = val;
> > +	spin_unlock(&mp->m_sb_lock);
> > +	return 0;
> > +}
> >  /*
> >   * Get the bitmap and summary inodes and the summary cache into the mount
> >   * structure at mount time.
> > @@ -1302,13 +1340,35 @@ xfs_rtmount_inodes(
> >  	ASSERT(mp->m_rbmip != NULL);
> >  
> >  	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
> > -	if (error) {
> > -		xfs_irele(mp->m_rbmip);
> > -		return error;
> > -	}
> > +	if (error)
> > +		goto out_rbm;
> 
> 		goto out_rele_bitmap;
> 
> >  	ASSERT(mp->m_rsumip != NULL);
> > +
> > +	/*
> > +	 * Older kernels misused sb_frextents to reflect both incore
> > +	 * reservations made by running transactions and the actual count of
> > +	 * free rt extents in the ondisk metadata.  Transactions committed
> > +	 * during runtime can therefore contain a superblock update that
> > +	 * undercounts the number of free rt extents tracked in the rt bitmap.
> > +	 * A clean unmount record will have the correct frextents value since
> > +	 * there can be no other transactions running at that point.
> > +	 *
> > +	 * If we're mounting the rt volume after recovering the log, recompute
> > +	 * frextents from the rtbitmap file to fix the inconsistency.
> > +	 */
> > +	if (xfs_has_realtime(mp) && xlog_recovery_needed(mp->m_log)) {
> > +		error = xfs_rtalloc_reinit_frextents(mp);
> > +		if (error)
> > +			goto out_rsum;
> 
> 			goto out_rele_summary;
> > +	}
> 
> This is pretty much doing the same thing that
> xfs_check_summary_counts() does for the data device. That is done
> before we mount the rt inodes, but it could be done after this, too.
> 
> Does it make any sense to move xfs_check_summary_counts() and then
> centralise all the summary counter reinitialisation in the one
> place under the same runtime recovery context?

Yes, that would be a nice hoist for the end of the patchset.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
