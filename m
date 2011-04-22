Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3M4AC4C194208 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 23:10:14 -0500
Date: Fri, 22 Apr 2011 00:13:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: exact busy extent tracking
Message-ID: <20110422041339.GB22034@infradead.org>
References: <20110418065936.355024592@bombadil.infradead.org>
	<20110418070043.915023373@bombadil.infradead.org>
	<1303416500.2581.519.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303416500.2581.519.camel@doink>
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

> In xfs_alloc_busy_trim():
> > @@ -2894,6 +2959,11 @@ fail:
> >  	 * re-check if the trimmed extent satisfies the minlen requirement.
> >  	 */
> >  	spin_unlock(&args->pag->pagb_lock);
> > +	if (fbno != bno || flen != len) {
> > +		trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len,
> > +					  fbno, flen);
> > +	}
> > +	trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
> >  	*rbno = fbno;
> >  	*rlen = 0;
> >  }
> 
> I don't see why you do two trace calls here, the second
> with 0 for the value of flen.

It's a merge error.  The first trace should be for the regular exit,
but managed to sneak down into the fail case, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
