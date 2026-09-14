Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F42480DF5
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396688; cv=none; b=YY/jKTMpr/Pc7xMT464Lem+OR8UKdoPNrKhZOaK+NufpRZ7/M1ZmpWlIFY+gXQ4MgGYgFcj6g9ksc18orF8NwNiuFCCoWhxSj6EExiQ6eBVxMtvgrz6D0qSswM/YOBmyAUX2HDS+qsP6NBDZNp3dJ7RN6AF8DLOi6blaNOPUxlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396688; c=relaxed/simple;
	bh=JbWBAQJQIOSfDMHCAuPX8HeMm9RIqbH47xZkUc4z9VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWVcTXnWgVu1UyhCB8xpgOa8d6CcMKderkzjClOYeZgNMKZRhTNdqjAz9eu8Bjkv1uH6/1O2A43+Ut4mCFtVKdQGocTqiU9fdoX1AquKMlYWxJfy2C2LgP8Mqxnlvr92od7tSP7oTrh828OfYluXZnLG5wtLLGyfq2mPpOySX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkMWmx/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkMWmx/w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 675D51F000FF;
	Mon, 14 Sep 2026 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789396686;
	bh=6QvwP4AMqTDhB9E3huPlcwXHQYVwmEUyiE7GKI9RuUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TkMWmx/wpIT2vuIjWFNY4+Fwshrd7o9K/UIaYiZfv47jIJvcfGSDhzoVTd0E3bOWS
	 YuOmpVcN64X/2cGygrzJpgaYeLqiaq+KGAdwZxIayqpkT0uGLj5pk5vERIlaYWbqs5
	 FzebWJHFYGqrB04O8FCgBX74WoNRewfGc/xeneaBmlVOaomorS9s0PSs/ggYh+Wxdf
	 IxfMKe6rBDSL+SfN/1noSyQZrxFH2EFQ0eo+KjKBGM1ahmt0D1vFXBpYLPlwPoHXF9
	 KNRGryi3w4rgnC5d6Q6bgNhOvWUZb1SFPIr+lVI8i6HqsS0w5K6IYgxfLdB78smtBV
	 LWMV/UfSUxQOg==
Date: Mon, 14 Sep 2026 07:38:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: hchc@last.de, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <20260914143805.GF6283@frogsfrogsfrogs>
References: <20260914115746.82122-1-cem@kernel.org>
 <20260914115746.82122-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914115746.82122-3-cem@kernel.org>

On Mon, Sep 14, 2026 at 01:57:40PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Once in a while it's useful to know exactly what kind of error caused a
> transaction to be cancelled.
> Enable xfs_trans_cancel() to receive an error code to be reported.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> ---
> V2:
> 	- Parenthesize macro parameters
> 
>  fs/xfs/xfs_trans.c | 8 +++++---
>  fs/xfs/xfs_trans.h | 6 +++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 5c522790e5be..395c896673fe 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -943,8 +943,9 @@ xfs_trans_commit(
>   * xfs_trans_commit().
>   */
>  void
> -xfs_trans_cancel(
> -	struct xfs_trans	*tp)
> +__xfs_trans_cancel(
> +	struct xfs_trans	*tp,
> +	int			error)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xlog		*log = mp->m_log;
> @@ -971,7 +972,8 @@ xfs_trans_cancel(
>  	 * here.
>  	 */
>  	if (dirty && !xfs_is_shutdown(mp)) {
> -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
> +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
> +				 error, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index eb83c5dac032..855a46433154 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -213,6 +213,11 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> +void __xfs_trans_cancel(xfs_trans_t *, int);

Nitpicking: struct xfs_trans, not xfs_trans_t (kill the typedef usage
since you're modifying the line anyway).

> +#define xfs_trans_cancel(tp) __xfs_trans_cancel((tp), (0))

Moar nitpicking: No need for parentheses around the 0.

With those two changes,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> +#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel((tp), (error))
> +
>  struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
>  struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
>  
> @@ -237,7 +242,6 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
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
