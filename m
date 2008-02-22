Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 22:53:34 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M6rOxc023213
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 22:53:28 -0800
Date: Fri, 22 Feb 2008 17:53:38 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC, patch 1/2] Allow up to 1GB logs in mkfs.xfs
Message-ID: <20080222065338.GQ155407@sgi.com>
References: <20080221230833.GG155407@sgi.com> <ncctzk11zhl.fsf@sgi.com> <20080222050301.GP155407@sgi.com> <47BE6122.5040007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE6122.5040007@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 22, 2008 at 04:44:02PM +1100, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Fri, Feb 22, 2008 at 01:44:38PM +1100, Niv Sardi wrote:
> >>David Chinner <dgc@sgi.com> writes:
> >>>Increase the maximum log size supported by mkfs.
> >....
> >>>Hence logs larger than 2^30 will not work without kernel
> >>>modifications.  Therefore this change is limited to increasing the
> >>>log size to what we can currently support in kernel space with
> >>>needing kernel modifications.
> >>I'm glad you got time to get around this, I didn't include it in the
> >>first batch as I was told it 'broke things'.
> >
> >Right. There's all sorts of nasties lurking if we go over 1GB in
> >size, but AFAICT up to 1GB is OK. There's still lots of validation
> >needing to be done - that's why this is an "RFC" and not something
> >ready for checkin yet. That's where more eye's and testers are
> >handy...
> 
> Dave, have you run any tests to see if we get any speed-ups with
> this change?

Not yet - I've been running it through QA with different log sizes
first to see if there's anything obviously broken with the kernel
w.r.t. larger log sizes (nothing wrong so far).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
