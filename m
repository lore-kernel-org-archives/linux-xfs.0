Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 21:02:47 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M52gJ4013886
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 21:02:44 -0800
Date: Fri, 22 Feb 2008 16:03:01 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC, patch 1/2] Allow up to 1GB logs in mkfs.xfs
Message-ID: <20080222050301.GP155407@sgi.com>
References: <20080221230833.GG155407@sgi.com> <ncctzk11zhl.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncctzk11zhl.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 22, 2008 at 01:44:38PM +1100, Niv Sardi wrote:
> David Chinner <dgc@sgi.com> writes:
> > Increase the maximum log size supported by mkfs.
....
> > Hence logs larger than 2^30 will not work without kernel
> > modifications.  Therefore this change is limited to increasing the
> > log size to what we can currently support in kernel space with
> > needing kernel modifications.
> 
> I'm glad you got time to get around this, I didn't include it in the
> first batch as I was told it 'broke things'.

Right. There's all sorts of nasties lurking if we go over 1GB in
size, but AFAICT up to 1GB is OK. There's still lots of validation
needing to be done - that's why this is an "RFC" and not something
ready for checkin yet. That's where more eye's and testers are
handy...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
