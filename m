Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52279 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932488AbcJUMs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 08:48:27 -0400
Date: Fri, 21 Oct 2016 14:48:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] xfs: fix the AG loop in xfs_alloc_vextent for busy
        extents
Message-ID: <20161021124824.GA17667@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de> <1476735753-5861-2-git-send-email-hch@lst.de> <20161019134806.GB28993@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161019134806.GB28993@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Wed, Oct 19, 2016 at 09:48:08AM -0400, Brian Foster wrote:
> >  			if (args->agbp) {
> > -				if ((error = xfs_alloc_ag_vextent(args)))
> > +				error = xfs_alloc_ag_vextent(args);
> > +				if (error)
> >  					goto error0;
> > -				break;
> > +				if (args->agbno != NULLAGBLOCK)
> > +					break;
> > +				xfs_trans_brelse(args->tp, args->agbp);
> 
> How is this safe with respect to xfs_alloc_fix_freelist() potentially
> dirtying the agf? Haven't we had deadlock and/or other problems due to
> xfs_alloc_fix_freelist() succeeding when an allocation ultimately fails,
> and subsequently rotating to a potentially lower agno?

We've had the case where the allocation would fail despite
xfs_alloc_fix_freelist succeeding forever, it's just that with
discard in general and async discard in particular we can hit it
much more easily.

The only way to make the allocation no fail if xfs_alloc_fix_freelist
succeeded would be to force out any busy extents at the low level
if we are tigh on space, I'll have to see how doable that would be.

The other option would be to roll around the transaction when switching
to a different AG so that we can release the locks.  That sounds a lot
easier, and also less fragile in the long run.
