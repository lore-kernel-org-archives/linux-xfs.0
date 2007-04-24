Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 07:16:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3OEGXfB029223
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 07:16:35 -0700
Date: Wed, 25 Apr 2007 00:16:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review [1 of 3]: lazy superblock counters - core kernel
Message-ID: <20070424141624.GU32602149@melbourne.sgi.com>
References: <20070419231459.GX48531920@melbourne.sgi.com> <20070423220010.GA18325@infradead.org> <20070424012808.GD48531920@melbourne.sgi.com> <20070424085147.GA28820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424085147.GA28820@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 24, 2007 at 09:51:47AM +0100, Christoph Hellwig wrote:
> On Tue, Apr 24, 2007 at 11:28:08AM +1000, David Chinner wrote:
> > > This is really quite nasty.  Should we at least force a cache flush here?
> > 
> > Ok, so the patch I sent out was an older version that had a very similar
> > name to the current patch in my series (xfs-lazy-sb vs xfs_lazy_sb).
> > This code doesn't exist in the version I should have sent out.
> > 
> > The latest version, plus the changes suggested here and with the
> > second patch folded back into it is attached.
> 
> Looks like in the new code we simply ignore log reservation
> failures in xfs_log_sbcount?

AFAICT, the only way we can get that error is a fileystem shutdown,
which means we've got an unclean shutdown and so there's no not much
point in syncing the superblock counters because we'll have to
recover them anyway....

> Otherwise this looks good to me.

Thanks for the reviews, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
