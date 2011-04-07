Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p370F8SB063203 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 19:15:09 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91DE8B90B03
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 17:18:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	e4F5UBIrVHZeYdVg for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 17:18:24 -0700 (PDT)
Date: Thu, 7 Apr 2011 10:18:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: catch bad block numbers freeing extents.
Message-ID: <20110407001822.GR31057@dastard>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-9-git-send-email-david@fromorbit.com>
	<20110406135951.GA24618@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110406135951.GA24618@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2011 at 09:59:51AM -0400, Christoph Hellwig wrote:
> > +	/* validate the extent size is legal now we have the agf locked */
> > +	if (!args.agbp) {
> > +		error = EFSCORRUPTED;
> > +		goto error0;
> > +	}
> 
> This is not a corruption case, but would require someone changing
> xfs_fix_freelist and messing up.  I think the check can be removed
> given that the potentially added bug would trivially trip up as
> a NULL pointer dereference.

Well, I figured the only way we wouldn't get the agbp is if it was
corrupted somehow (e.g. it gets re-read from disk), but that should
return an error from xfs_alloc_fix_freelist() anyway. So i think you
are right - the check can be dropped.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
