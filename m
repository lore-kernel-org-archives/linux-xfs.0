Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0516A7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 17:14:18 -0600 (CST)
Date: Mon, 16 Dec 2013 17:14:14 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/6] xfs: swalloc doesn't align allocations properly
Message-ID: <20131216231414.GQ1935@sgi.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-5-git-send-email-david@fromorbit.com>
	<20131213120123.GA32749@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213120123.GA32749@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Gents,

On Fri, Dec 13, 2013 at 04:01:23AM -0800, Christoph Hellwig wrote:
> Looks good.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Two very minor nitpicks below:
> 
> > +	int		stripe_align;
> >  
> >  	ASSERT(ap->length);
> >  
> >  	mp = ap->ip->i_mount;
> > +
> > +	/* stripe alignment for allocation is determined by mount parameters */
> > +	stripe_align = 0;
> > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > +		stripe_align = mp->m_swidth;
> > +	else if (mp->m_dalign)
> > +		stripe_align = mp->m_dalign;
> 
> nipick: I'd either initialize the variable to zero at the point of the
> declaration or do if .. else if .. else here.
> 
> >  	}
> > +
> > +
> >  	nullfb = *ap->firstblock == NULLFSBLOCK;
> 
> Two newlines seem odd here.  I'd support one even if that's an unrelated
> change :)

This is probably not the right thing to do for small files.  They will all end
up in the first stripe unit.

Quoting jpk from
http://lwn.net/Articles/87526/                                                                                                                                                                                   
                                                                                                                                                                                                                 
"  o [XFS] Add support for allocating additional file space in stripe width
sized chunks. A new fstab/mount option, "swalloc" has been defined. If
specified when mounting a striped file system, allocation requests will be
rounded up to a stripe width if the file size is >= stripe width, and the data
is being appended to eof. The 'swalloc' option is "off" by default. "


This feature was likely designed with volume stripes in mind as opposed to to
raid stripes.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
