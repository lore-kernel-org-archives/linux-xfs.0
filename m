Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 14:46:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1LMkeEE003279
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 14:46:43 -0800
Date: Fri, 22 Feb 2008 09:47:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Prevent excessive xfsaild wakeups
Message-ID: <20080221224700.GD155407@sgi.com>
References: <20080218225906.GS155407@sgi.com> <20080220191000.GA24257@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220191000.GA24257@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 20, 2008 at 02:10:00PM -0500, Christoph Hellwig wrote:
> On Tue, Feb 19, 2008 at 09:59:06AM +1100, David Chinner wrote:
> > +	if (count && (XFS_LSN_CMP(lsn, target) >= 0)) {
> > +		/*
> > +		 * We reached the target so wait a bit longer for I/O to
> > +		 * complete and remove pushed items from the AIL before we
> > +		 * start the next scan from the start of the AIL.
> > +		 */
> >  		tout += 20;
> >  		last_pushed_lsn = 0;
> > +	} else if (!count) {
> > +		/* We're past our target or empty, so idle */
> > +		tout = 1000;
> >  	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
> >  		   (count && ((stuck * 100) / count > 90))) {
> >  		/*
> 
> When looking at this conditions it confuses the hell out of me.  Having
> count checked in each of three nested conditionals simply isn't readable
> :)

Yeah, I noticed that when posting it. Got to keep you busy, Christoph. ;)

> Also some checks seem to be superflous, so how about:

Yup, fixed to be like this. I'll run it through a qa run
and go from there...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
