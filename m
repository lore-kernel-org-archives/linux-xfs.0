Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF032459EA
	for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2026 01:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570656; cv=none; b=lmPi9WVuWaw/udC1K20q6ivAvzRyK2Q35yr65QutWXCQW5zDnwOh4fF9ljsZ/X4s1YiuYZbhvvvWV7fX5K1k+Jht+l9Ov31FmKVZmEy8i/3FSPhpWrpa2R+SXwPlJflKw82LahEDmr+01Yw2cgv/bEvbtSNsLy/IdvCyUPrRF0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570656; c=relaxed/simple;
	bh=tzA6KIHjKDUNnraMWlCiPYQyEZezs8dTximKHMMDtDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxHfFigGfTXYqM0XPQeXMKfOe5SCbuX+9pl9X6W/dYNcod2ePq8eroKNatI6L3m7RJGMnllcNRJOmrix/tAhkqmTKzHQ4Am/GzoRAW7JlDWHwrxuhRIeGGiCRs3BaqkqFrsa6LAkbrTEpFmcJn6DQ8X7TuIUeDWPzZgJ0WfWn9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhjwZG3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhjwZG3N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E077F1F00A3D;
	Sat,  5 Sep 2026 01:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788570655;
	bh=WeAqouUDG1vKd9ZhsRwyyargjNQKc1YzNCwxgt5bswA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RhjwZG3N3uWPXlbCRCaE9y7F+2vkDdo3SzMOKYLhwsGCrfkW2Fh2UoAgGq7SIIEDx
	 WJ9UwUFUY/+YKCiYVxx53YREtMdoai7LCRDtXVxZcF8vkW1S8xWXYxLZKfHkbg8ZVi
	 hoBeFnKOgG7iIFgdeAB5hReFXp420a3wzAJVKEUsfrSdZ+4L7oulliwMy4bYEWoBZ0
	 Qa9P2qtefKHDlVv7jux17u1z49IghQpiuOIIyMuDiI6eWjZG0RswcrHKdyEsNg5HZm
	 G8NfbYvTKxwJPSiLB4AI7WLX5Z+JY9h+Y/orHQtTNjSi0VG3jGPkndXlmeUwx6KpqF
	 35alZ52k7sJgw==
Date: Fri, 4 Sep 2026 18:10:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <20260905011054.GF1933798@frogsfrogsfrogs>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904113231.1408890-3-cem@kernel.org>

On Fri, Sep 04, 2026 at 01:32:22PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Once in a while it's useful to know exactly what kind of error caused a
> transaction to be cancelled.
> Enable xfs_trans_cancel() to receive an error code to be reported.

Stylistically I think I'd rather have an explicit @error and some macros
to avoid the va_args machinery.


void __xfs_trans_cancel(struct xfs_trans *tp, int error) {...}

#define xfs_trans_cancel(tp) __xfs_trans_cancel(tp, 0)
#define xfs_trans_cancel_with(tp, error) __xfs_trans_cancel(tp, error)

--D

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  fs/xfs/xfs_trans.c | 12 +++++++++---
>  fs/xfs/xfs_trans.h |  8 +++++++-
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c6657072361a..f6004590565b 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -971,12 +971,18 @@ xfs_trans_commit(
>   * xfs_trans_commit().
>   */
>  void
> -xfs_trans_cancel(
> -	struct xfs_trans	*tp)
> +_xfs_trans_cancel(
> +	struct xfs_trans	*tp, ...)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xlog		*log = mp->m_log;
>  	bool			dirty = (tp->t_flags & XFS_TRANS_DIRTY);
> +	int			error = 0;
> +	va_list			args;
> +
> +	va_start(args, tp);
> +	error = va_arg(args, int);
> +	va_end(args);
>  
>  	trace_xfs_trans_cancel(tp, _RET_IP_);
>  
> @@ -999,7 +1005,7 @@ xfs_trans_cancel(
>  	 * here.
>  	 */
>  	if (dirty && !xfs_is_shutdown(mp)) {
> -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
> +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, error, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 2b366851e9a4..05cc7464eb3b 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -213,6 +213,13 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> +void _xfs_trans_cancel(xfs_trans_t *, ...);
> +
> +#define xfs_trans_cancel(tp, ...)		\
> +({						\
> +	_xfs_trans_cancel(tp, ##__VA_ARGS__);	\
> +})
> +
>  struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
>  struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
>  
> @@ -237,7 +244,6 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
>  int		xfs_trans_commit(struct xfs_trans *);
>  int		xfs_trans_roll(struct xfs_trans **);
>  int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> -void		xfs_trans_cancel(xfs_trans_t *);
>  int		xfs_trans_ail_init(struct xfs_mount *);
>  void		xfs_trans_ail_destroy(struct xfs_mount *);
>  
> -- 
> 2.55.0
> 
> 
