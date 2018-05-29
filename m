Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935813AbeE2Wng (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 18:43:36 -0400
Date: Tue, 29 May 2018 15:43:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 06/22] xfs: add a repair helper to reset superblock
 counters
Message-ID: <20180529224332.GL30110@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365674.1556.6776151224606075985.stgit@magnolia>
 <20180518035623.GD23858@magnolia>
 <20180529032810.GM10363@dastard>
 <20180529220716.GK30110@magnolia>
 <20180529222428.GR10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529222428.GR10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 30, 2018 at 08:24:28AM +1000, Dave Chinner wrote:
> On Tue, May 29, 2018 at 03:07:16PM -0700, Darrick J. Wong wrote:
> > On Tue, May 29, 2018 at 01:28:10PM +1000, Dave Chinner wrote:
> > > On Thu, May 17, 2018 at 08:56:23PM -0700, Darrick J. Wong wrote:
> > > > +	/*
> > > > +	 * Reinitialize the counters.  The on-disk and in-core counters differ
> > > > +	 * by the number of inodes/blocks reserved by the admin, the per-AG
> > > > +	 * reservation, and any transactions in progress, so we have to
> > > > +	 * account for that.  First we take the sb lock and update its
> > > > +	 * counters...
> > > > +	 */
> > > > +	spin_lock(&mp->m_sb_lock);
> > > > +	delta_icount = (int64_t)mp->m_sb.sb_icount - icount;
> > > > +	delta_ifree = (int64_t)mp->m_sb.sb_ifree - ifree;
> > > > +	delta_fdblocks = (int64_t)mp->m_sb.sb_fdblocks - fdblocks;
> > > > +	mp->m_sb.sb_icount = icount;
> > > > +	mp->m_sb.sb_ifree = ifree;
> > > > +	mp->m_sb.sb_fdblocks = fdblocks;
> > > > +	spin_unlock(&mp->m_sb_lock);
> > > 
> > > This seems racy to me ? i.e. the per-ag counters can change while
> > > we are summing them, and once we've summed them then sb counters
> > > can change while we are waiting for the m_sb_lock. It's looks to me
> > > like the summed per-ag counters are not in any way coherent
> > > wit the superblock or the in-core per-CPU counters, so I'm
> > > struggling to understand why this is safe?
> > 
> > Hmm, yes, I think this is racy too.  The purpose of this code is to
> > recompute the global counters from the AG counters after any operation
> > that modifies anything that would affect the icount/ifreecount/fdblocks
> > counters...
> 
> *nod*
> 
> > > We can do this sort of summation at mount time (in
> > > xfs_initialize_perag_data()) because the filesystem is running
> > > single threaded while the summation is taking place and so nothing
> > > is changing during th summation. The filesystem is active in this
> > > case, so I don't think we can do the same thing here.
> > 
> > ...however, you're correct to point out that the fs must be quiesced
> > before we can actually do this.  In other words, I think the filesystem
> > has to be completely frozen before we can do this.  Perhaps it's better
> > to have the per-ag rebuilders fix only the per-ag counters and leave the
> > global counters alone.  Then add a new scrubber that checks the summary
> > counters and fixes them if necessary.
> 
> So the question here is whether we actually need to accurately
> correct the global superblock counters?

I think so, because what happens if the superblock counter is
artificially high but the AGs do not actually have the free space?
xfs_trans_reserve won't ENOSPC like it should, so we could end up
blowing out of transactions and shutting down because some allocation
that has to succeed ("because trans_reserve said there was space!")
fails...

> We know that if we have a dirty unmount, the counters will we
> re-initialised on mount from the AG header information, so perhaps
> what we need here is a flag to tell unmount to dirty the log again
> after it has written the unmount record (like we currently do for
> quiesce).

...but now that we've repaired the filesystem, it could potentially run
for a very long time until the next unmount.  During that run, we'd be
misleading users about the real amount of free space and risking a hard
shutdown.  I prefer that online repair try not to leave any weird state
around after xfs_scrub exits.

> That was we can do a racy "near enough" update here to get us out of
> the worst of the space accounting mismatches, knowing that on the
> next mount it will be accurately rebuilt.
>
> Thoughts?

Well, I think the best solution is to have the AGF/AGI/inobt rebuilders
adjust the global counters by the same amount that they're adjusting the
counters in the AGF/AGI, then add a new scrubber that runs at the end to
freeze the fs and check/repair the global counter state. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
