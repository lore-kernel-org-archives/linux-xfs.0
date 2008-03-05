Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 13:00:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m25L0H1u001139
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 13:00:22 -0800
Date: Thu, 6 Mar 2008 08:00:35 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 977545 - xfsaild causing too many wakeups
Message-ID: <20080305210035.GA155407@sgi.com>
References: <20080222041525.37EA858C4C0F@chook.melbourne.sgi.com> <47CF05E5.90409@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF05E5.90409@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

On Wed, Mar 05, 2008 at 02:43:17PM -0600, Eric Sandeen wrote:
> David Chinner wrote:
> > xfsaild causing too many wakeups
> > 
> > Idle state is not being detected properly by the xfsaild push code.
> > The current idle state is detected by an empty list which may never
> > happen with mostly idle filesystem or one using lazy superblock
> > counters. A single dirty item in the list that exists beyond the
> > push target can result repeated looping attempting to push
> > up to the target because it fails to check if the push target
> > has been acheived or not.
> > 
> > Fix by considering a dirty list with everything past the target
> > as an idle state and set the timeout appropriately.
> 
> Will this go to 2.6.25?

Yes, it certainly should.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
