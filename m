Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 16:20:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3NNK6fB027382
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 16:20:07 -0700
Date: Tue, 24 Apr 2007 09:20:02 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review [1 of 3]: lazy superblock counters - core kernel
Message-ID: <20070423232002.GP32602149@melbourne.sgi.com>
References: <20070419231459.GX48531920@melbourne.sgi.com> <20070423220010.GA18325@infradead.org> <20070423221622.GL32602149@melbourne.sgi.com> <20070423222340.GA23870@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423222340.GA23870@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 11:23:40PM +0100, Christoph Hellwig wrote:
> On Tue, Apr 24, 2007 at 08:16:23AM +1000, David Chinner wrote:
> > > > +			INT_SET(sb->sb_fdblocks, ARCH_CONVERT, mp->m_sb.sb_fdblocks);
> > > > +			XFS_SB_UNLOCK(mp, s);
> > > 
> > > This is really quite nasty.  Should we at least force a cache flush here?
> > 
> > Well, that is what it's doing - xfs_log_sbcount() flushes the counters and
> > logs the changes to the superblock. If that fails (very rare) we've already
> > got the current values in mp->m_sb and so all we need to do is push them
> > into the disk superblock and write it.
> 
> Sorry, should have been more detailed.  I meant the disk cache, as in
> blkdev_issue_flush, to make sure the data hits the disk, even if it doesn't
> go through a transaction which would normally do that. (in the barriers case)

Ah, gotcha. Hmmm - if this is necessary, I may as well add the flush to
the closing of the buftargs - that way we will always be certain that
an unmount leaves everything on disk and not in disk caches. That sounds
like a better approach to me than putting an explicit flush in this
particular case. Sound fair?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
