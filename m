Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:60911 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756404AbcINWXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 18:23:01 -0400
Date: Thu, 15 Sep 2016 08:22:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfs: Document error handlers behavior
Message-ID: <20160914222255.GQ30497@dastard>
References: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
 <20160914012334.GK30497@dastard>
 <77fcc1da-9c74-da3e-5bcd-3df420a3bfbb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77fcc1da-9c74-da3e-5bcd-3df420a3bfbb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 14, 2016 at 10:10:05AM -0500, Eric Sandeen wrote:
> On 9/13/16 8:23 PM, Dave Chinner wrote:
....
> > +  max_retries			(Min: -1  Default: Varies  Max: INTMAX)
> > +	Defines the allowed number of retries of a specific error before
> > +	the filesystem will propagate the error. The retry count for a given
> > +	error context (e.g. a specific metadata buffer) is reset ever time there
> 
> every time there ...
> 
> > +	is a successful completion of the operation.
> > +
> > +	Setting the value to "-1" will cause XFS to retry forever for this
> > +	specific error.
> > +
> > +	Setting the value to "0" will cause XFS to fail immediately when the
> > +	specific error is reported.
> > +
> > +	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
> > +	operation "N" times before propagating the error.
> > +
> > +  retry_timeout_seconds		(Min:  -1  Default:  Varies  Max: 1 day)
> > +	Define the amount of time (in seconds) that the filesystem is
> > +	allowed to retry its operations when the specific error is
> > +	found.
> > +
> > +	Setting the value to "-1" will set an infinite timeout, causing
> > +	error propagation behaviour to be determined solely by the "max_retries"
> > +	parameter.
> 
> This is asymmetric; if you want this, then max_retries should probably say that
> -1 will cause the behavior to be determined solely by retry_timeout_seconds...

I could, but...

> Could also say "removing any time limits on retries."  (and above, "removing any
> count limits on retries.)
> 
> But that's already covered by "the first condition met by ..., " really.

this covers it so I can probably just remove it.
> 
> > +
> > +	Setting the value to "0" will cause XFS to fail immediately when the
> > +	specific error is reported.
> > +
> > +	Setting the value to  "N" (where 0 < N < Max) will propagate the error
> > +	on the first retry that fails at least "N" seconds after the first error
> > +	was detected, unless the number of retries defined by max_retries
> > +	expires first.
> 
> Same issue here, really; they are symmetric, right?  First condition met for
> propagation propagates the error, period.  This sounds overly complex, unless
> I'm missing something. Seems like:
> 
> +	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
> +	operation for "N" seconds before propagating the error.
> 
> would suffice, no?

No, because that's not what the implementation does:

	if (retries expired)
		fail
	if (retry timer expired)
		fail

IOWs, the retry count has precedence over the retry timer. if you
set both retry_timeout and max_retries, the timeout only takes
effect if max retries is set high enough that they aren't exhausted
before the timeout fires.

This is for the case where an failure might take a variable time to
report.  (Think interactions with errors that TLER would address).
Normally you might say 10 retries, but if it is taking 5 minutes to
then fail when this specific error condition is hit, you might set a retry
timeout of 1 minute. In that case, we might get an immediate IO
error and retry several times before failing. However, if we hit the
"slow to report" error, we still get failure in the same time frame
as the immediate failures that have been retried many times before
giving up.

It's hard to explain complex stuff like with a simple, concise
description. I'll try again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
