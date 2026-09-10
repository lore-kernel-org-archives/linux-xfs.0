Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D736B357D19
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032808; cv=none; b=s69Sb+7yqLZL2TAUYn8FPm8xW3ezN71xqpHZLYAbvIsu4mRxDxOgv7l64PO/uYRBAfaWiSsk6VhxTWS8rjvZel8DGBWUFiwZaEYsE+KFvrH+1x6j4Z+fAcSoNTI89mMOSNYA5edOf18GqlYnr5zgVmgQGfM4sSw5+v1g8/K7HTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032808; c=relaxed/simple;
	bh=VDGrKsFcQgHt1YQN+MMA7YjfDQctnvBnWTV/gIht6PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXc7EZffKSjGx40jW6wIkoBhX5Lan1RwniOulpq8Hu/TETah+UCK969rekudQLp+P3cgvXXqGRNHWsnNuxDprlP2VI6z5xOpyoZT8jta6DUKhPZgIoag4YBQOATS2VOIsJIbwVVj/C9tn0QXGCWrtWKCO1vvzDRW7yrBBx2LswQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dI+OU20d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dI+OU20d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521291F00898;
	Thu, 10 Sep 2026 09:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032806;
	bh=AR2QLlddtTrv3piaqdQNSejKi3166Re68yVOXDI0JKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dI+OU20dzznDUnGfSvAxSTnfHcLGnErEWFPKb/twFv1FCWQulRTwYkKFdquJw7ZOj
	 l4TzGulSEYO0ONY2wP2wXAa1Hc5UN2KW5wLRTlZTfX0Q9WdvEa6I2G2TMvuwA/wFqM
	 iz1wmos+js2VwQbpL25URTO5WNmyoIzyX3gwTdVXKY9umlY6puTcomn58hIZ5o84NC
	 l6aDlVaLDgZr5Jobs66caIThywX6x2s5k5jNcwcJOjx7l+UDytlfLgYcojPRiiOiBI
	 fV0oMkCQ4cgezNSWowLZLDZ1PkiLgo7HaShXMJOl7NU/iSuAqsoNQmLm60WlPJ4z+j
	 3KllfOyaML4ww==
Date: Thu, 10 Sep 2026 11:33:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add xfs_error_report the ability to display an
 error code
Message-ID: <aqJ4G3UGB1K-zXXG@andromeda.toxiclabs.cc>
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-2-cem@kernel.org>
 <8a9d507c-f060-4f78-9035-5393b633df11@sandeen.net>
 <20260908170205.GG2619314@frogsfrogsfrogs>
 <3493be44-7f0a-479e-84d4-381b97a4d050@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3493be44-7f0a-479e-84d4-381b97a4d050@sandeen.net>

/me takes a mental not to never look at patch replies in an out-of-order
fashion....

On Tue, Sep 08, 2026 at 03:40:57PM -0500, Eric Sandeen wrote:
> On 9/8/26 12:02 PM, Darrick J. Wong wrote:
> > On Tue, Sep 08, 2026 at 11:53:57AM -0500, Eric Sandeen wrote:
> >> On 9/8/26 9:54 AM, cem@kernel.org wrote:
> >>> From: Carlos Maiolino <cem@kernel.org>
> >>>
> >>> Users could opt to request an error code to be printed now.
> >>> This relies on errname() and CONFIG_SYMBOLIC_NAME without requiring it
> >>> to be enabled.
> >>> Report 'unkown error' If CONFIG_SYMBOLIC_NAME is not enabled or the
> >>> user passes 0 as an error.
> >>
> >> s/SYMBOLIC_NAME/SYMBOLIC_ERRNAME/g
> >>
> >>> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> >>> ---
> >>>  fs/xfs/xfs_error.c         | 13 ++++++++++---
> >>>  fs/xfs/xfs_error.h         | 10 +++++-----
> >>>  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
> >>>  fs/xfs/xfs_inode_item.c    |  3 ++-
> >>>  fs/xfs/xfs_log_recover.c   |  3 ++-
> >>>  fs/xfs/xfs_trans.c         |  2 +-
> >>>  6 files changed, 26 insertions(+), 14 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> >>> index dbd87e137694..3177ec58bb2e 100644
> >>> --- a/fs/xfs/xfs_error.c
> >>> +++ b/fs/xfs/xfs_error.c
> >>> @@ -14,6 +14,7 @@
> >>>  #include "xfs_error.h"
> >>>  #include "xfs_sysfs.h"
> >>>  #include "xfs_inode.h"
> >>> +#include <linux/errname.h>
> >>>  
> >>>  #ifdef DEBUG
> >>>  
> >>> @@ -377,15 +378,21 @@ void
> >>>  xfs_error_report(
> >>>  	const char		*tag,
> >>>  	int			level,
> >>> +	int			error,
> >>>  	struct xfs_mount	*mp,
> >>>  	const char		*filename,
> >>>  	int			linenum,
> >>>  	xfs_failaddr_t		failaddr)
> >>>  {
> >>> +	const char *err_str = errname(error);
> >>> +
> >>> +	if (!err_str)
> >>> +		err_str = "unknown error";
> >>> +
> >>>  	if (level <= xfs_error_level) {
> >>>  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> >>> -		"Internal error %s at line %d of file %s.  Caller %pS",
> >>> -			    tag, linenum, filename, failaddr);
> >>> +		"Internal error %s (%s) at line %d of file %s.  Caller %pS",
> >>> +			    tag, err_str, linenum, filename, failaddr);
> >> I might suggest making the printk conditional, rather than making err_str conditional.
> >>
> >> It might make the code messier, but the entire purpose of this change is to give
> >> the user more information and a clearer view of what happened. Changing
> >> "error 93 at line" to "error 93 (unknown error) at line" doesn't really do that,
> >> and IMHO adds confusion and adds no value.
> > 
> > Oh, something like:
> > 
> > 	if (level <= xfs_error_level) {
> > 		const char	*err_str = errname(error);
> > 
> > 		if (err_str)
> > 			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> >  "Internal error %s (%s) at line...", tag, err_str, ...);
> > 		else
> > 			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> >  "Internal error %s (%d) at line...", tag, error, ...);
> > 	}
> > 
> > Hm?
> 
> Yeah I think so. Messy code but better dmesg IMHO.
> 
> > I sorta like having the #define'd error name in the log message (e.g.
> > "Internal error frogs (ENOENT) at line..." but tbh these days I just run
> > errno(1) to translate an errno to a sentence fragment.
> TBH I've lost track of what a tag vs an errno vs a string is, but I stand
> by my observation that emitting "unknown error" when errname() returns null
> seems like a net negative change. :)
> 

Thanks for the reviews. My plan was to not add more strings and too much
extra logic, but those are all points against this :)
I'll craft something along these lines.
