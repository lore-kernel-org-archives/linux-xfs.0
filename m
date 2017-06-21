Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40566 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdFUUii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 16:38:38 -0400
Date: Wed, 21 Jun 2017 13:38:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/12] libxcmd: add cvt{int, long} to convert strings to
 int and long
Message-ID: <20170621203830.GO4733@birch.djwong.org>
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755896133.3625.13813626356334626083.stgit@birch.djwong.org>
 <6c0086a3-d1db-baa0-f0a4-be1c6d2cebe7@sandeen.net>
 <20170621202951.GM4733@birch.djwong.org>
 <9309853e-b9c0-e9a3-7821-78803d33f0d6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9309853e-b9c0-e9a3-7821-78803d33f0d6@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 21, 2017 at 03:33:16PM -0500, Eric Sandeen wrote:
> On 6/21/17 3:29 PM, Darrick J. Wong wrote:
> > On Wed, Jun 21, 2017 at 03:16:37PM -0500, Eric Sandeen wrote:
> 
> ...
> 
> >>> --- a/libxcmd/input.c
> >>> +++ b/libxcmd/input.c
> >>> @@ -149,6 +149,140 @@ numlen(
> >>>  	return len == 0 ? 1 : len;
> >>>  }
> >>>  
> >>> +/*
> >>> + * Convert string to int64_t, set errno if the conversion fails or
> >>> + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> >>> + * prior to conversion.
> >>> + */
> >>> +int64_t
> >>> +cvt_s64(
> >>> +	char		*s,
> >>> +	int		base)
> >>> +{
> >>> +	long long	i;
> >>> +	char		*sp;
> >>> +	int		c;
> >>
> >> unused var c
> >>
> >>> +
> >>> +	errno = 0;
> >>> +	i = strtoll(s, &sp, base);
> >>> +	if (*sp == '\0' && sp != s)
> >>> +		return i;
> >>> +bad:
> >>
> >> label bad: defined but not used
> > 
> > Fixed.  Sorry about the stupidity. :(
> 
> no problem, things like this make me feel better :D
> 
> > 
> >>> +	errno = -ERANGE;
> >>> +	return INT64_MIN;
> >>
> >> Hm, doesn't strtoll return LLONG_MIN or LLONG_MAX for underflows
> >> and overflows?  Do you really want to return MIN even if this /overflowed/?
> >> (Maybe it doesn't matter, gut its a bit of a departure from strtoll semantics)
> > 
> > True, it's a departure from the usual semantics.  The intent is to call
> > the function this way:
> > 
> > long foo = cvt_s64(...);
> > if (errno) {
> > 	fprintf(stderr, "N|_|MB3Rz ARE HARDZ!!1!\n");
> > 	exit(5);
> > }
> > 
> > So at least in theory it wouldn't matter what we actually set foo to.
> 
> well, that was my next question.  ;)
> 
> But setting it to one extreme value leaves me wondering why you'd not set it
> to the other extreme.  *shrug*  Not that big a deal, just a thing that made me
> go "hmmmm"

I'll just change it to:

errno = 0;
i = strtoll(s, &sp, base);
if (*sp == '\0' && sp != s)
	return i;
else if (errno)
	return i;
errno = -ERANGE;
return INT64_MAX;

That way if strtoll /did/ have something to complain about, we'll
just pass it straight back to the caller.  The last two lines will
handle the case that someone feeds us junk at the end of the number
string (e.g. "359urgh") in which case we also want to spit back
an error condition.

--D

> >>> +bad:
> >>
> >> label bad: defined but not used
> > 
> > Fixed.  Sorry about the stupidity. :(
> 
> no problem, things like this make me feel better :D
> 
> > 
> >>> +	errno = -ERANGE;

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
