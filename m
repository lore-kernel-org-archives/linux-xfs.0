Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U7Z1ES190018 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 02:35:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A36A84C2C26
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:34:59 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FGE0NYReXRZoPx7K for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 00:34:59 -0700 (PDT)
Date: Thu, 30 Jun 2011 03:34:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/27] xfs: factor out xfs_dir2_leaf_find_entry
Message-ID: <20110630073459.GA31334@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140339.086201354@bombadil.infradead.org>
	<20110630061102.GG561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630061102.GG561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 04:11:02PM +1000, Dave Chinner wrote:
> You could probably just return here, and that would remove the:

Indeed.  We can do the same near the end, too.  It means duplicating
the be16_add_cpu, but allows to directly return the expression that
lead to lep, so I did it.

> > +				continue;
> > +		}
> > +		/*
> > +		 * If the low one is better, use it.
> > +		 */
> 
> Line of whitespace before the comment.

Fixed.

> > +		/*
> > +		 * The high one is better, so use that one.
> > +		 */
> > +		} else {
> 
> I prefer comments inside the else branch...

The else is completely gone now, fixing that issue.

> > -		be16_add_cpu(&leaf->hdr.stale, -1);
> > -	}
> > +
> > +
> > +	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
> > +				       highstale, &lfloglow, &lfloghigh);
> > +
> 
> Only need one line of whitespace before the function call.

Fixed.

> > +
> > +
> >  	/*
> >  	 * Insert the new entry, log everything.
> >  	 */
> > +	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
> > +				       highstale, &lfloglow, &lfloghigh);
> > +
> 
> Same for the whitespace before the comment.

Fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
