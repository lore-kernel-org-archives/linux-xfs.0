Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F34585962
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886927; cv=none; b=TAv/SMxE+fvkfpD8wA/uSNdUYWt0r2KdafMcK7oysAOKz+N7aA7zNFhXrElZDQOIsN/mvFsqVRRsF7fvVWCumFakAUwRIMYM/j34hxz7uNSRnKOMYjWygwjXthFQW3/QMn6uCwo9fFE7XzC9VdOu093bTW1fEsPOuwUnkqXAFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886927; c=relaxed/simple;
	bh=vrdoW0nCQr4Pjm0gDVZpH60fj6r4Bssf8vHEuEBOJ4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgKEux7GTgzAydpZhF5kjsg65mJLDibqsS6XFyO07vTnNWhNiNvi4tp/jaaLASAzP9EJGqja524gsNSXZKgChtp2vLxvUaiPJaR8NsX7CPvhM760qSNdvcMosMvSyl2i0MHMlE42t5rqUyZ72w7K/6LwYVvxA05D1aHZ5FDzxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cxv8QKYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cxv8QKYQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 587C11F00A3A;
	Tue,  8 Sep 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886926;
	bh=ZFCENvqPS122uUT854+5Exsd5oUi0LxYvbB1i7XV5t0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cxv8QKYQKekJdSwpRJBaak5UMA9Xy2MK6J1KMkZsvclOokplhOrBwp26qLQq+xS7O
	 md9vqMJcaHW090oedFpqeKPgO5oQd6fc4utvknoVjH5zMFo1YwbGXw0ZOgppzvwYYn
	 ccpLGk3urtT5Nhp2jmfjsK8K0yyEI7TSB8HBHAjbsVhlcZJB0R4x30Yc7oTWoRFsif
	 v5q6VOV/0Z6ArZRH5zKg/y+lbdQeh5tVy+HECuB8GwnMjm/bb1lgokIsdwlmr0QMut
	 cwj0PLSNgpV0NmKOAXTgpagTjEHWAmU1y+ETQAVZIewbrXge50LCkArlLn56AGkC+7
	 4KBV+BVZ6xDoQ==
Date: Tue, 8 Sep 2026 10:02:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add xfs_error_report the ability to display an
 error code
Message-ID: <20260908170205.GG2619314@frogsfrogsfrogs>
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-2-cem@kernel.org>
 <8a9d507c-f060-4f78-9035-5393b633df11@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a9d507c-f060-4f78-9035-5393b633df11@sandeen.net>

On Tue, Sep 08, 2026 at 11:53:57AM -0500, Eric Sandeen wrote:
> On 9/8/26 9:54 AM, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Users could opt to request an error code to be printed now.
> > This relies on errname() and CONFIG_SYMBOLIC_NAME without requiring it
> > to be enabled.
> > Report 'unkown error' If CONFIG_SYMBOLIC_NAME is not enabled or the
> > user passes 0 as an error.
> 
> s/SYMBOLIC_NAME/SYMBOLIC_ERRNAME/g
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_error.c         | 13 ++++++++++---
> >  fs/xfs/xfs_error.h         | 10 +++++-----
> >  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
> >  fs/xfs/xfs_inode_item.c    |  3 ++-
> >  fs/xfs/xfs_log_recover.c   |  3 ++-
> >  fs/xfs/xfs_trans.c         |  2 +-
> >  6 files changed, 26 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index dbd87e137694..3177ec58bb2e 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -14,6 +14,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_sysfs.h"
> >  #include "xfs_inode.h"
> > +#include <linux/errname.h>
> >  
> >  #ifdef DEBUG
> >  
> > @@ -377,15 +378,21 @@ void
> >  xfs_error_report(
> >  	const char		*tag,
> >  	int			level,
> > +	int			error,
> >  	struct xfs_mount	*mp,
> >  	const char		*filename,
> >  	int			linenum,
> >  	xfs_failaddr_t		failaddr)
> >  {
> > +	const char *err_str = errname(error);
> > +
> > +	if (!err_str)
> > +		err_str = "unknown error";
> > +
> >  	if (level <= xfs_error_level) {
> >  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > -		"Internal error %s at line %d of file %s.  Caller %pS",
> > -			    tag, linenum, filename, failaddr);
> > +		"Internal error %s (%s) at line %d of file %s.  Caller %pS",
> > +			    tag, err_str, linenum, filename, failaddr);
> I might suggest making the printk conditional, rather than making err_str conditional.
> 
> It might make the code messier, but the entire purpose of this change is to give
> the user more information and a clearer view of what happened. Changing
> "error 93 at line" to "error 93 (unknown error) at line" doesn't really do that,
> and IMHO adds confusion and adds no value.

Oh, something like:

	if (level <= xfs_error_level) {
		const char	*err_str = errname(error);

		if (err_str)
			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
 "Internal error %s (%s) at line...", tag, err_str, ...);
		else
			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
 "Internal error %s (%d) at line...", tag, error, ...);
	}

Hm?

I sorta like having the #define'd error name in the log message (e.g.
"Internal error frogs (ENOENT) at line..." but tbh these days I just run
errno(1) to translate an errno to a sentence fragment.

--D

> It sounds like the config is typically enabled, but I'd still rather not add
> extra words to debugging printks that add no useful info if possible. It may
> raise more questions than it answers.
> 
> overall I like the idea though :)
> 
> -Eric
> 
