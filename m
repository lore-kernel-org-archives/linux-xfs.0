Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8BBoM7c189402 for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 06:50:22 -0500
Date: Sun, 11 Sep 2011 07:50:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/25] xfs: factor extent allocation out of xfs_bmapi
Message-ID: <20110911115016.GA1226@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060642.429315933@bombadil.infradead.org>
	<1315599804.1999.54.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315599804.1999.54.camel@doink>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 03:23:24PM -0500, Alex Elder wrote:
> On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> > To further improve the readability of xfs_bmapi(), factor the extent
> > allocation out into a separate function. This removes a large block
> > of logic from the xfs_bmapi() code loop and makes it easier to see
> > the operational logic flow for xfs_bmapi().
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> OK, this looks very good.  I have a spot that I chased
> for a while to verify it produced the same functionality
> as before, but I just gave up because it was just taking
> much too much time.  I'll point it out below, just for
> the record, but I'm not too concerned about it.  Everything
> else looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 

> > +			bma.minleft = minleft;
> > +
> > +			error = xfs_bmapi_allocate(&bma, &lastx, &cur,
> > +					firstblock, flist, flags, &nallocs,
> > +					&tmp_logflags);
> 
> > +			if (error == ENOSPC || error == EDQUOT) {
> > +				if (n == 0) {
> > +					*nmap = 0;
> > +					ASSERT(cur == NULL);
> > +					return error;
> >  				}
> 
> Here is the spot I mentioned above.  I was trying to find out
> the circumstances under which ENOSPC or EDQUOT could get returned
> by xfs_bmapi_allocate() in order to confirm that this in fact
> produces the same effect as before.

It shouldn't be there, and never hit.  This is a leftover from Dave's
earlier version where we did the delalloc reservation from
xfs_bmapi_allocate.  I have removed it.

> I also had a little trouble because there were spots--such
> as calling xfs_bmap_isaeof()--that are now encapsulated within
> xfs_bmapi_allocate() that previously jumped to error0, but now
> will produce an error return from that function.  So now this
> doesn't execute the code at error0 in this case.  I didn't
> work through it but I trust that the code there would end
> up being a series of no-ops anyway.

We still got to error0 in that case, it's just below the code you
quoted:

			logflags |= tmp_logflags;
			if (error)
				goto error0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
