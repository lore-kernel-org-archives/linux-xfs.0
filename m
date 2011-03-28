Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SC7ktp165530 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:07:46 -0500
Date: Mon, 28 Mar 2011 08:10:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: exact busy extent tracking
Message-ID: <20110328121054.GC18346@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.657110761@bombadil.infradead.org>
	<1301087060.2537.689.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301087060.2537.689.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 25, 2011 at 04:04:20PM -0500, Alex Elder wrote:
> > - * Insert a new extent into the busy tree.
> 
> OK, to be honest I haven't re-read this entire block of
> comment text to identify what might be of value.  But
> is there really *nothing* worth saving?  Is the busy
> extent tree documented adequately elsewhere?

The old text doesn't really apply to the new code anymore.  I'll see
if there's a place I can insert some more documentaion, but it already
has quite a lot of comments.

> >  		if (new->bno < busyp->bno) {
> >  			/* may overlap, but exact start block is lower */
>
> This comment isn't really right any more (BUG_ON that condition).

> >  		} else if (new->bno > busyp->bno) {
> >  			/* may overlap, but exact start block is higher */
> 
> This one too.

Removed.

> > +			continue;
> > +		} else if (fbno >= bend) {
> > +			rbp = rbp->rb_right;
> > +			continue;
> > +		}
> > +
> 
> I was going to suggest:
> 		/* Extent overlaps busy extent */
> 
> here, but I think that may not be the case any more if
> busyp->length is zero.  Or rather, the extent may
> surround the zero-length busy extent (which I suppose
> could be considered overlap).
> 
> If busyp->length is zero, I think the call to
> xfs_alloc_busy_try_reuse() is not needed; in fact,
> if it is already 0, that function will call
> rb_erase() on the entry again.

We will never see zero-length busy extents here.  While they have
to remain on the per-transaction/cil_context list they are properly
removed from the rbtree.

> ...therefore this branch is always taken, and the code
> below this block to the end of the loop is not reached.
> 
> Since this is the only place it's used, xfs_alloc_busy_try_reuse()
> might as well be defined as a void function.
> 
> (Ahh, but now that I've looked at the later patches
> I see it gets used again later.  I'm leaving my
> comments here nevertheless.)

Yes, it's changing in the next patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
