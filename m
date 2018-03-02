Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:31095 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932131AbeCBVtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 16:49:23 -0500
Date: Sat, 3 Mar 2018 08:49:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: fix operation time reporting
Message-ID: <20180302214919.GP30854@dastard>
References: <20180301035645.32633-1-david@fromorbit.com>
 <f401cfc2-fdcd-15e7-4c1a-254bbe00c2fa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f401cfc2-fdcd-15e7-4c1a-254bbe00c2fa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 01, 2018 at 10:00:52PM -0600, Eric Sandeen wrote:
> On 2/28/18 9:56 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > CUrrently the 100th/sec units always report zero, such as:
> > 
> > 32 MiB, 8192 ops; 0:00:21.00 (1.476 MiB/sec and 377.9260 ops/sec)
> >                           ^^
> > 
> > This is incorrect. Fix the maths that is wrong by removing all the
> > unnecesary floating point maths and just using basic integer
> > division...
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  libxcmd/input.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/libxcmd/input.c b/libxcmd/input.c
> > index 441bb2fbbf34..6e7a8c9822ee 100644
> > --- a/libxcmd/input.c
> > +++ b/libxcmd/input.c
> > @@ -154,9 +154,10 @@ tdiv(double value, struct timeval tv)
> >  	return value / ((double)tv.tv_sec + ((double)tv.tv_usec / 1000000.0));
> >  }
> >  
> > -#define HOURS(sec)	((sec) / (60 * 60))
> > -#define MINUTES(sec)	(((sec) % (60 * 60)) / 60)
> > -#define SECONDS(sec)	((sec) % 60)
> > +#define HOURS(sec)		((sec) / (60 * 60))
> > +#define MINUTES(sec)		(((sec) % (60 * 60)) / 60)
> > +#define SECONDS(sec)		((sec) % 60)
> > +#define USEC_TO_100THS(usec)	((usec) / 1000 / 10)
> 
> I guess this works but I expected to convert "microseconds to 100ths"
> via a conversion like:
> 
> usec * 1sec/1000000usec * 100 hundredths/1sec

That's what the old code tried to do with floating point math and
casts, but that didn't work.

> so just for readability I'd have expected:
> 
> #define USEC_TO_100THS(usec)	((usec) / 1000000 * 100)

Welcome to Integer Math 101: Integer Division. You'll always get
zero, because N / M = 0 when N < M.

> or possibly just
> #define USEC_TO_100THS(usec)	((usec) / 10000)
> 
> ... I'm confused by your choice of orders of magnitude above even
> though it works - it seems a bit random to divide it that way,
> unless I'm missing something?
>
> (I had a physics teacher who drilled THINK UNITS BEFORE YOU THINK
> NUMBERS" into my head an I still do) :)

Yeah, I did. I did us->ms first, then ms->100ths. i.e.:

	milliseconds = usec / 1000
	hundreths = ms / 10.

This should be obvious to anyone who uses the metric system for
units of measurement. I guess I should have used "centisecs". :P

> >  void
> >  timestr(
> > @@ -165,14 +166,12 @@ timestr(
> >  	size_t		size,
> >  	int		format)
> >  {
> > -	double		usec = (double)tv->tv_usec / 1000000.0;
> > -
> >  	if (format & TERSE_FIXED_TIME) {
> >  		if (!HOURS(tv->tv_sec)) {
> >  			snprintf(ts, size, "%u:%02u.%02u",
> >  				(unsigned int) MINUTES(tv->tv_sec),
> >  				(unsigned int) SECONDS(tv->tv_sec),
> > -				(unsigned int) usec * 100);
> > +				(unsigned int) USEC_TO_100THS(tv->tv_usec));
> >  			return;
> >  		}
> >  		format |= VERBOSE_FIXED_TIME;	/* fallback if hours needed */
> > @@ -183,9 +182,10 @@ timestr(
> >  			(unsigned int) HOURS(tv->tv_sec),
> >  			(unsigned int) MINUTES(tv->tv_sec),
> >  			(unsigned int) SECONDS(tv->tv_sec),
> > -			(unsigned int) usec * 100);
> > +			(unsigned int) USEC_TO_100THS(tv->tv_usec));
> >  	} else {
> > -		snprintf(ts, size, "0.%04u sec", (unsigned int) usec * 10000);
> > +		snprintf(ts, size, "0.%04u sec",
> > +			(unsigned int) tv->tv_usec / 100);
> 
> USEC_TO_10000THS() for consistency ?

Too many bloody zeros. I'm just going to convert them all ti
milliseconds and be done with it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
