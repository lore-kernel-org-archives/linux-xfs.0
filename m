Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 15:16:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3NMGSfB027455
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 15:16:31 -0700
Date: Tue, 24 Apr 2007 08:16:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review [1 of 3]: lazy superblock counters - core kernel
Message-ID: <20070423221622.GL32602149@melbourne.sgi.com>
References: <20070419231459.GX48531920@melbourne.sgi.com> <20070423220010.GA18325@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423220010.GA18325@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 11:00:10PM +0100, Christoph Hellwig wrote:
> > -		if ((error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno)))
> > +		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
> > +		if (error)
> 
> Nice cleanup here.
> 
> > -		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno)))
> > +		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno, 0)))
> 
> but not here.  Any chance you could use the linux kernel prefered style in the first
> hunk everywhere?  Especially in new code where the patch uses the second style aswell.

Yeah, I can convert them - the first would have been done because the
line would have been > 80 chars....

> > +#define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
> 
> The flag seems a bit misnamed to me.  It's really about counting the freelist
> blocks, not the lazy counters that require it.  But given that it's been in
> IRIX for a while that's probably not something we could change.

Though in the places where it is checked in the transaction code,
it does actually make sense to call it that (i.e. if lazysb don't
mark the sb dirty) which is where it came from. The need to count
freelist blocks came up after that code was done and working.
So yes, it doesn't describe the on disk format change closely,
just the functionality that uses it....


> > +#define XFS_SB_VERSION_LAZYSBCOUNT(sbp)	xfs_sb_version_haslazysbcount(sbp)
> > +static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
> 
> Please just use the inline version everywhere and don't introduce the
> uppercase superflous macro.

Will do.

> > +		 * Write into superblock the fields that we haven't
> > +		 * been logging - allocated/free inode and free block
> > +		 * counts - from the incore superblock.
> > + 		 */
> > +		error = xfs_log_sbcount(mp, (XFS_LOG_FORCE|XFS_LOG_SYNC));
> >  
> > -		xfs_icsb_sync_counters(mp);
> > +		sbp = xfs_getsb(mp, 0);
> > + 		sb = XFS_BUF_TO_SBP(sbp);
> > +		if (error) {
> > +			/*
> > +			 * Hmmm - failed to get log reservations so just
> > +			 * do the mod without a transaction. Whine about
> > +			 * it, too.
> > +			 */
> > +			ASSERT(XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb));
> > +			xfs_fs_cmn_err(CE_NOTE, mp,
> > +				"Unmounting, non-transactional sb update");
> > +			s = XFS_SB_LOCK(mp);
> > +			INT_SET(sb->sb_icount, ARCH_CONVERT, mp->m_sb.sb_icount);
> > +			INT_SET(sb->sb_ifree, ARCH_CONVERT, mp->m_sb.sb_ifree);
> > +			INT_SET(sb->sb_fdblocks, ARCH_CONVERT, mp->m_sb.sb_fdblocks);
> > +			XFS_SB_UNLOCK(mp, s);
> 
> This is really quite nasty.  Should we at least force a cache flush here?

Well, that is what it's doing - xfs_log_sbcount() flushes the counters and
logs the changes to the superblock. If that fails (very rare) we've already
got the current values in mp->m_sb and so all we need to do is push them
into the disk superblock and write it.

> > +	 *
> > +	 * We also update the disk superblock with incore counter
> > +	 * values if we are using non-persistent counters so that
> > +	 * they don't get too far out of sync if we crash or get a
> > +	 * forced shutdown. We don't want to force this to disk,
> > +	 * just get a transaction into the iclogs....
> >  	 */
> >  	if (flags & SYNC_REFCACHE) {
> >  		if (flags & SYNC_WAIT)
> >  			xfs_refcache_purge_mp(mp);
> >  		else
> >  			xfs_refcache_purge_some(mp);
> > +		xfs_log_sbcount(mp, 0);
> 
> Can you please give this a SYNC_ flag of it's own?  SYNC_REFCACHE is
> misnamed for this, and I hope it will go away once we stop pretending
> to support 2.4 builds.

Will do.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
