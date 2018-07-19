Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727401AbeGSVSZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 17:18:25 -0400
Date: Thu, 19 Jul 2018 16:33:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/14] xfs: reset dfops to initial state after finish
Message-ID: <20180719203338.GH29404@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-7-bfoster@redhat.com>
 <20180719195441.GG6558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719195441.GG6558@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 12:54:41PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 19, 2018 at 09:49:11AM -0400, Brian Foster wrote:
> > xfs_defer_init() is currently used in two particular situations. The
> > first and most obvious case is raw initialization of an
> > xfs_defer_ops struct. The other case is partial reinit of
> > xfs_defer_ops on reuse due to iteration.
> > 
> > Most instances of the first case will be replaced by a single init
> > of a dfops embedded in the transaction. Init calls are still
> > technically required for the second case because the dfops may have
> > low space mode enabled or have joined items that need to be reset
> > before the dfops should be reused.
> > 
> > Since the current dfops usage expects either a final transaction
> > commit after xfs_defer_finish() or xfs_defer_init() if dfops is to
> > be reused, we can shift some of the init logic into
> > xfs_defer_finish() such that the latter returns with a reinitialized
> > dfops. This eliminates the second dependency noted above such that a
> > dfops is immediately ready for reuse after an xfs_defer_finish()
> > without the need to change any calling code.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 30 ++++++++++++++++++++++++++++--
> >  1 file changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index d3466087db16..e6baa27a690b 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -319,6 +319,29 @@ xfs_defer_bjoin(
> >  	return -EFSCORRUPTED;
> >  }
> >  
> > +/*
> > + * Reset an already used dfops after finish.
> > + */
> > +static void
> > +xfs_defer_reset(
> > +	struct xfs_defer_ops	*dop)
> > +{
> > +	int 			i;
> > +
> > +	ASSERT(!xfs_defer_has_unfinished_work(dop));
> > +	dop->dop_low = false;
> > +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
> > +		if (!dop->dop_inodes[i])
> > +			break;
> > +		dop->dop_inodes[i] = NULL;
> > +	}
> > +	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
> > +		if (!dop->dop_bufs[i])
> > +			break;
> > +		dop->dop_bufs[i] = NULL;
> > +	}
> > +}
> 
> Are these loops really more efficient than just doing memsets
> of dop_inodes and dop_bufs?
> 

Not sure, I suppose we could just check dop_bufs[0] and memset() if !=
NULL..? I can do that as well if we don't otherwise lose these pointers.

Brian

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
