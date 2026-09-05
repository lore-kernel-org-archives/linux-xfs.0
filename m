Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E776238166
	for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2026 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570534; cv=none; b=bc9ndZqi6lRXw4lm6Hf7NXf0wxbsOVX/xBlief7EA+LziGHVPgdubWBEwI0KltMW7ZAWKiy/B4e42T9XtaApsdcRzIHugCTvoH2ScRm0kBGCzf/pxZ1V3t1JU/DqtR5L+pMWOUEYh9UnM3b/wvgyKpwCgyZ5CXdmpmgW0usT+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570534; c=relaxed/simple;
	bh=CZd+JpmvhTdeVY4Du0/ldPfqWzeCv4D86Hs3FQBLTAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIE46zokKtaXUysvb3insnj3B01bfTorRHj3gD0MclJ5E9iMLJrO+R+DXSQ+GpUBFM1dU66UNdgNvfqqnj4YkP4Q75KTWR7UNT4Q/VNwTLTUUSmBTxPOI5Ia80w+hLR+yZEQpTts30nykUw5MDEr9Bc7GdpQq/yoBMN3xi1PVLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHNC7+pZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHNC7+pZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 91C491F00A3D;
	Sat,  5 Sep 2026 01:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788570532;
	bh=r1+3CKMrYI1RhwlLH5mJqHee2sy7R7V0TSNZbQaf+kE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kHNC7+pZt9XVqly1M1GvnVCTmkkRGldZTXF0e4rop+//XLCgl+MCf+f2Rsx/5HsBH
	 6ix12iu13DflBCD03RTSVDeEsJ7ljqLXvUTZqUWMZ9ZGmDDP1VXKgxfOstX2xXzBp7
	 HIaxqUErZS4U6T4r9eYj1PUG0uFza/I+8Ib8Jpgbkb1tGqzrIGTvLN6/kAE4pnkE6u
	 bwFdzDGvAwtq8Klw1HC30ECUOw73dXP4xrrqS//RsGs8qYyLW51i27WnETt6SchbTh
	 uO6LzDQPD3IzUkSzvvGvHeReqWJT9NHbtnFdECcBxGQ/OdX2Kqu0/LSvUH9ASApRVJ
	 stsazwpP2lnGA==
Date: Fri, 4 Sep 2026 18:08:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] xfs: add xfs_error_report the ability to display
 an error code
Message-ID: <20260905010851.GE1933798@frogsfrogsfrogs>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904113231.1408890-2-cem@kernel.org>

On Fri, Sep 04, 2026 at 01:32:21PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Users could opt to request an error code to be printed
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  fs/xfs/xfs_error.c         |  7 ++++++-
>  fs/xfs/xfs_error.h         | 10 +++++-----
>  fs/xfs/xfs_exchmaps_item.c |  6 +++---
>  fs/xfs/xfs_inode_item.c    |  2 +-
>  fs/xfs/xfs_log_recover.c   |  2 +-
>  5 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index dbd87e137694..1c882b910ffd 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -377,6 +377,7 @@ void
>  xfs_error_report(
>  	const char		*tag,
>  	int			level,
> +	int			error,
>  	struct xfs_mount	*mp,
>  	const char		*filename,
>  	int			linenum,
> @@ -387,6 +388,10 @@ xfs_error_report(
>  		"Internal error %s at line %d of file %s.  Caller %pS",
>  			    tag, linenum, filename, failaddr);
>  
> +		if (error)
> +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> +				      "Error Code: %d", error);

/me wonders, should the error erport just go in the "Internal error..."
message above?

"Internal error $tag ($error) at line..."

> +
>  		xfs_stack_trace();
>  	}
>  }
> @@ -404,7 +409,7 @@ xfs_corruption_error(
>  {
>  	if (buf && level <= xfs_error_level)
>  		xfs_hex_dump(buf, bufsize);
> -	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
> +	xfs_error_report(tag, level, 0, mp, filename, linenum, failaddr);
>  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
>  }
>  
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 0b9c5ba8a598..1a1aa60e92f2 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -8,9 +8,9 @@
>  
>  struct xfs_mount;
>  
> -extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> -			const char *filename, int linenum,
> -			xfs_failaddr_t failaddr);
> +extern void xfs_error_report(const char *tag, int level, int error,
> +			     struct xfs_mount *mp, const char *filename,
> +			     int linenum, xfs_failaddr_t failaddr);
>  extern void xfs_corruption_error(const char *tag, int level,
>  			struct xfs_mount *mp, const void *buf, size_t bufsize,
>  			const char *filename, int linenum,
> @@ -25,8 +25,8 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
>  			const char *name, const void *buf, size_t bufsz,
>  			xfs_failaddr_t failaddr);
>  
> -#define	XFS_ERROR_REPORT(e, lvl, mp)	\
> -	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> +#define	XFS_ERROR_REPORT(e, lvl, error, mp)	\
> +	xfs_error_report(e, lvl, error, mp, __FILE__, __LINE__, __return_address)
>  #define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
>  	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
>  			     __FILE__, __LINE__, __return_address)
> diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> index 264a121c5e16..b94c5e5e6549 100644
> --- a/fs/xfs/xfs_exchmaps_item.c
> +++ b/fs/xfs/xfs_exchmaps_item.c
> @@ -559,13 +559,13 @@ xlog_recover_xmi_commit_pass2(
>  
>  	len = sizeof(struct xfs_xmi_log_format);
>  	if (item->ri_buf[0].i_len != len) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);

These should be -EFSCORRUPTED, not 0, right?

--D

>  		return -EFSCORRUPTED;
>  	}
>  
>  	xmi_formatp = item->ri_buf[0].i_addr;
>  	if (xmi_formatp->__pad != 0) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -600,7 +600,7 @@ xlog_recover_xmd_commit_pass2(
>  
>  	xmd_formatp = item->ri_buf[0].i_addr;
>  	if (item->ri_buf[0].i_len != sizeof(struct xfs_xmd_log_format)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index c6cb0b6b9e46..862b7d7d3ce4 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -1185,7 +1185,7 @@ xfs_inode_item_format_convert(
>  	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
>  
>  	if (buf->i_len != sizeof(*in_f32)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, NULL);
>  		return -EFSCORRUPTED;
>  	}
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 2f76531842f8..083e4bf61e2b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2932,7 +2932,7 @@ xlog_recover_process(
>  		 * fatal log corruption failure.
>  		 */
>  		if (xfs_has_crc(log->l_mp)) {
> -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
>  			return -EFSCORRUPTED;
>  		}
>  	}
> -- 
> 2.55.0
> 
> 
