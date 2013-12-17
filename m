Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF2EA7F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 08:59:22 -0600 (CST)
Date: Tue, 17 Dec 2013 08:59:22 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/6] xfs: swalloc doesn't align allocations properly
Message-ID: <20131217145922.GS1935@sgi.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-5-git-send-email-david@fromorbit.com>
	<20131213120123.GA32749@infradead.org>
	<20131216231414.GQ1935@sgi.com> <20131217033941.GC31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131217033941.GC31386@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 17, 2013 at 02:39:41PM +1100, Dave Chinner wrote:
> On Mon, Dec 16, 2013 at 05:14:14PM -0600, Ben Myers wrote:
> > On Fri, Dec 13, 2013 at 04:01:23AM -0800, Christoph Hellwig wrote:
> > > Looks good.
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Two very minor nitpicks below:
> > > 
> > > > +	int		stripe_align;
> > > >  
> > > >  	ASSERT(ap->length);
> > > >  
> > > >  	mp = ap->ip->i_mount;
> > > > +
> > > > +	/* stripe alignment for allocation is determined by mount parameters */
> > > > +	stripe_align = 0;
> > > > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > > > +		stripe_align = mp->m_swidth;
> > > > +	else if (mp->m_dalign)
> > > > +		stripe_align = mp->m_dalign;
> > > 
> > > nipick: I'd either initialize the variable to zero at the point of the
> > > declaration or do if .. else if .. else here.
> > > 
> > > >  	}
> > > > +
> > > > +
> > > >  	nullfb = *ap->firstblock == NULLFSBLOCK;
> > > 
> > > Two newlines seem odd here.  I'd support one even if that's an unrelated
> > > change :)
> > 
> > This is probably not the right thing to do for small files.  They will all end
> > up in the first stripe unit.
> 
> You're right, it's not the right thing to do for small files. And we
> don't, because the ap->aeof that triggers aligned allocation only
> when:
> 
> 	/*
> 	 * Only want to do the alignment at the eof if it is userdata and
> 	 * allocation length is larger than a stripe unit.
> 	 */
> 	if (mp->m_dalign && bma->length >= mp->m_dalign &&
> 	    !(bma->flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
> 		error = xfs_bmap_isaeof(bma, whichfork);
> 		if (error)
> 			return error;
> 	}
> 
> The requested allocation length is greater than the stripe unit that
> is configured.
> 
> So, we never align small files, regardless of the mount option....

That addresses my concerns, thanks.  ;)

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
