Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBCB37F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 21:39:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 777F8AC003
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 19:39:47 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dgKlh2dChFFStCrY for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 19:39:45 -0800 (PST)
Date: Tue, 17 Dec 2013 14:39:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: swalloc doesn't align allocations properly
Message-ID: <20131217033941.GC31386@dastard>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-5-git-send-email-david@fromorbit.com>
	<20131213120123.GA32749@infradead.org>
	<20131216231414.GQ1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131216231414.GQ1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 16, 2013 at 05:14:14PM -0600, Ben Myers wrote:
> Hi Gents,
> 
> On Fri, Dec 13, 2013 at 04:01:23AM -0800, Christoph Hellwig wrote:
> > Looks good.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Two very minor nitpicks below:
> > 
> > > +	int		stripe_align;
> > >  
> > >  	ASSERT(ap->length);
> > >  
> > >  	mp = ap->ip->i_mount;
> > > +
> > > +	/* stripe alignment for allocation is determined by mount parameters */
> > > +	stripe_align = 0;
> > > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > > +		stripe_align = mp->m_swidth;
> > > +	else if (mp->m_dalign)
> > > +		stripe_align = mp->m_dalign;
> > 
> > nipick: I'd either initialize the variable to zero at the point of the
> > declaration or do if .. else if .. else here.
> > 
> > >  	}
> > > +
> > > +
> > >  	nullfb = *ap->firstblock == NULLFSBLOCK;
> > 
> > Two newlines seem odd here.  I'd support one even if that's an unrelated
> > change :)
> 
> This is probably not the right thing to do for small files.  They will all end
> up in the first stripe unit.

You're right, it's not the right thing to do for small files. And we
don't, because the ap->aeof that triggers aligned allocation only
when:

	/*
	 * Only want to do the alignment at the eof if it is userdata and
	 * allocation length is larger than a stripe unit.
	 */
	if (mp->m_dalign && bma->length >= mp->m_dalign &&
	    !(bma->flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
		error = xfs_bmap_isaeof(bma, whichfork);
		if (error)
			return error;
	}

The requested allocation length is greater than the stripe unit that
is configured.

So, we never align small files, regardless of the mount option....

> Quoting jpk from
> http://lwn.net/Articles/87526/
> "  o [XFS] Add support for allocating additional file space in stripe width
> sized chunks. A new fstab/mount option, "swalloc" has been defined. If
> specified when mounting a striped file system, allocation requests will be
> rounded up to a stripe width if the file size is >= stripe width, and the data
> is being appended to eof. The 'swalloc' option is "off" by default. "

You can find the actual commit in the oss archive tree:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=2da28d20c986a1a16e266f9c3e90dd967267f2bd

> This feature was likely designed with volume stripes in mind as
> opposed to to raid stripes.

I'd say go look up PV783527 and see what the problem it was solving
was... ;)

But regardless, if someone has askked for swalloc, it's because they
have an application doing large sequential IO, and when that happens
there's no reason not to stripe width align the allocation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
