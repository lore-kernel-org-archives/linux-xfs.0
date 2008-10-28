Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 14:51:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SLpZ5D002401
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:51:35 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D62CAFE1E9
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:51:34 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id L5Z89KQjznYqFH2i for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:51:34 -0700 (PDT)
Date: Wed, 29 Oct 2008 08:51:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] split up xlog_recover_process_iunlinks
Message-ID: <20081028215133.GA4985@disturbed>
References: <20081027133938.GH1109@infradead.org> <20081028071750.GV4985@disturbed> <20081028091446.GB1662@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028091446.GB1662@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 05:14:46AM -0400, Christoph Hellwig wrote:
> > > +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip, 0);
> > > +	if (error)
> > > +		goto fail;
> > > +
> > > +	/*
> > > +	 * Get the on disk inode to find the next inode in the bucket.
> > > +	 */
> > > +	ASSERT(ip != NULL);
> > > +	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
> > > +	if (error)
> > > +		goto fail;
> > 
> > Jumping to 'fail' at this point leaks the xfs_inode returned from
> > xfs_iget(). Hmmmm - it appears the original code leaked too....
> > 
> > Also, I don't think we need the assert for ip, either.  If it's NULL
> > then we'll panic immediately on entering xfs_itobp().
> 
> Yeah.  I'll fix this in a separate patch as this one is just suposed to
> be purely refactoring.

Ok, sounds fair.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
