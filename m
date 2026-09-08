Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5D2E7623
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 05:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788845800; cv=none; b=s0af/woQqG662EcjAkZ8jl7BNVFTyt9UH/lCYi3PmoAstqr05Hyy6juwXIOHcGqyaGH0r1Hq3m1lWJezDjG6g8Jlt5WdeHRwwlHHHZphLCPJcgYM7u2lDC19t2XrBCtT3hquzvfJdf/TqfRZu1GT3cVsY8/iMXwuDv86qpxIYOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788845800; c=relaxed/simple;
	bh=N9wcsWcF8qLO+IJg4j4AACP2jbh1KnvqAh8KJiEUIew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZ4d8v/QrrXlpHsVCrVqQnxgxP1QI5aRW8KtDFPRSkf8ZfscnZT85KbOPlK4593FOvmSciNmXgc1GOsY4iPd+zILpuBcDVq+akh0bRcCRWo2qIOHKJRE44a2wOHxvWCbFc0JAFOlYmSWADiwvyMUfjq4SkFBYLvQmIVy+KJW7Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2R7z2OV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2R7z2OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADBD1F00A3D;
	Tue,  8 Sep 2026 05:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788845798;
	bh=64zMClA8X3WFyQnV4wlqZmOtodIznFVgHb3QSN6vvZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I2R7z2OV9XKutqRgGU1hYODbRuxZz7rtbuF/1CrMGuaKdRHpQD3/ZUC2nQ+SEpIKg
	 nR015FPqg8pWDR6e3uhFcec4nEesv1L8EenCFA7eMFv5sghCOrMbzQ7BOGqIqeN8fQ
	 L8P8YBA6yYH/EcPxH0gQCw0gJ12vF6P7TdBB0OKWec9/PJhdw+YFFKk8IemynDDp6U
	 lEA0ntvNCJKkEtySXbqk6Xo79Sp8iY/zakmCCDU80QOjobQUQ2KNMuTZbciczTkOJP
	 QCt2qwko6puz9Xy3nuA6YR9HLl1gZTD57oRjiGIJXKgzeDJ8nBvvhG/QntM0fmZfwi
	 nkQEYhW0jj4iw==
Date: Tue, 8 Sep 2026 07:36:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] xfs: add xfs_error_report the ability to display
 an error code
Message-ID: <ap-ecIJjpOrN5jsZ@andromeda.toxiclabs.cc>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-2-cem@kernel.org>
 <20260905010851.GE1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905010851.GE1933798@frogsfrogsfrogs>

On Fri, Sep 04, 2026 at 06:08:51PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 04, 2026 at 01:32:21PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Users could opt to request an error code to be printed
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > ---
> >  fs/xfs/xfs_error.c         |  7 ++++++-
> >  fs/xfs/xfs_error.h         | 10 +++++-----
> >  fs/xfs/xfs_exchmaps_item.c |  6 +++---
> >  fs/xfs/xfs_inode_item.c    |  2 +-
> >  fs/xfs/xfs_log_recover.c   |  2 +-
> >  5 files changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index dbd87e137694..1c882b910ffd 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -377,6 +377,7 @@ void
> >  xfs_error_report(
> >  	const char		*tag,
> >  	int			level,
> > +	int			error,
> >  	struct xfs_mount	*mp,
> >  	const char		*filename,
> >  	int			linenum,
> > @@ -387,6 +388,10 @@ xfs_error_report(
> >  		"Internal error %s at line %d of file %s.  Caller %pS",
> >  			    tag, linenum, filename, failaddr);
> >  
> > +		if (error)
> > +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > +				      "Error Code: %d", error);
> 
> /me wonders, should the error erport just go in the "Internal error..."
> message above?
> 
> "Internal error $tag ($error) at line..."

Sure, I initially didn't want a longer line, but I'd rather have a
single line here too.

> 
> > +
> >  		xfs_stack_trace();
> >  	}
> >  }
> > @@ -404,7 +409,7 @@ xfs_corruption_error(
> >  {
> >  	if (buf && level <= xfs_error_level)
> >  		xfs_hex_dump(buf, bufsize);
> > -	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
> > +	xfs_error_report(tag, level, 0, mp, filename, linenum, failaddr);
> >  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
> >  }
> >  
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index 0b9c5ba8a598..1a1aa60e92f2 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -8,9 +8,9 @@
> >  
> >  struct xfs_mount;
> >  
> > -extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> > -			const char *filename, int linenum,
> > -			xfs_failaddr_t failaddr);
> > +extern void xfs_error_report(const char *tag, int level, int error,
> > +			     struct xfs_mount *mp, const char *filename,
> > +			     int linenum, xfs_failaddr_t failaddr);
> >  extern void xfs_corruption_error(const char *tag, int level,
> >  			struct xfs_mount *mp, const void *buf, size_t bufsize,
> >  			const char *filename, int linenum,
> > @@ -25,8 +25,8 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
> >  			const char *name, const void *buf, size_t bufsz,
> >  			xfs_failaddr_t failaddr);
> >  
> > -#define	XFS_ERROR_REPORT(e, lvl, mp)	\
> > -	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> > +#define	XFS_ERROR_REPORT(e, lvl, error, mp)	\
> > +	xfs_error_report(e, lvl, error, mp, __FILE__, __LINE__, __return_address)
> >  #define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
> >  	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
> >  			     __FILE__, __LINE__, __return_address)
> > diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> > index 264a121c5e16..b94c5e5e6549 100644
> > --- a/fs/xfs/xfs_exchmaps_item.c
> > +++ b/fs/xfs/xfs_exchmaps_item.c
> > @@ -559,13 +559,13 @@ xlog_recover_xmi_commit_pass2(
> >  
> >  	len = sizeof(struct xfs_xmi_log_format);
> >  	if (item->ri_buf[0].i_len != len) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
> 
> These should be -EFSCORRUPTED, not 0, right?

This was a RFC and my goal here was just leave the messages unchanged by
now, I'll change it for a formal patch.

> 
> --D
> 
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> >  	xmi_formatp = item->ri_buf[0].i_addr;
> >  	if (xmi_formatp->__pad != 0) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -600,7 +600,7 @@ xlog_recover_xmd_commit_pass2(
> >  
> >  	xmd_formatp = item->ri_buf[0].i_addr;
> >  	if (item->ri_buf[0].i_len != sizeof(struct xfs_xmd_log_format)) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index c6cb0b6b9e46..862b7d7d3ce4 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -1185,7 +1185,7 @@ xfs_inode_item_format_convert(
> >  	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
> >  
> >  	if (buf->i_len != sizeof(*in_f32)) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, NULL);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 2f76531842f8..083e4bf61e2b 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2932,7 +2932,7 @@ xlog_recover_process(
> >  		 * fatal log corruption failure.
> >  		 */
> >  		if (xfs_has_crc(log->l_mp)) {
> > -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
> >  			return -EFSCORRUPTED;
> >  		}
> >  	}
> > -- 
> > 2.55.0
> > 
> > 
> 
