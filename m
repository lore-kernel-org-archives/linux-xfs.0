Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 15:02:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l08N2Iqw018556
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 15:02:20 -0800
Date: Tue, 9 Jan 2007 10:01:19 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: make growing by >2TB work
Message-ID: <20070108230119.GA33919298@melbourne.sgi.com>
References: <20070108044414.GC44411608@melbourne.sgi.com> <20070108091218.GB17121@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108091218.GB17121@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 09:12:18AM +0000, Christoph Hellwig wrote:
> On Mon, Jan 08, 2007 at 03:44:14PM +1100, David Chinner wrote:
> > Growing a filesystem by > 2TB currently causes an overflow
> > in the transaction subsystem. Make transaction deltas and associated
> > elements explicitly 64 bit types so that we don't get overflows.
> > 
> > Comments?
> 
> Looks good.
> 
> >  
> > -	AIL_LOCKINIT(&mp->m_ail_lock, "xfs_ail");
> >  	spinlock_init(&mp->m_sb_lock, "xfs_sb");
> >  	mutex_init(&mp->m_ilock);
> >  	initnsema(&mp->m_growlock, 1, "xfs_grow");
> > -	/*
> > -	 * Initialize the AIL.
> > -	 */
> > -	xfs_trans_ail_init(mp);
> 
> This seems unrelated (?)

Ahhh - leakage from a recent patch series reordering....

> > -xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int delta, int rsvd)
> > +xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int64_t delta, int rsvd)
> 
> This seems to be over 80 chars linelength with your patch, just break
> the line.

Will do.

Thanks, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
