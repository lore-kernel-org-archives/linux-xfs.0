Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54D7549364
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 15:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881280; cv=none; b=UD/kaPYYnmpx9TV/R86fLWxKzKFxT73+YU5O98j/VQWDomPlj8OLhf2Ik0K/Amoe+pq4n4nD4qBYOA1bQzIbFaSS3qie0ThikMgFw46aWzJI/J6UNMfAqfLPo48GMN2221J+5pouPGX8vIkxZuB3V35OViXqKaJCaJ9z3Cx8RRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881280; c=relaxed/simple;
	bh=udy+Cb+3Gjx45pbR7fgp3UU3gHABDk9AMlXOOB3GC3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFF0uUzmyKsKeH1h9QoTI2vIasGCjaju2kRuqy73IK9+Tcqi1D+lSf63Ad7x50/nXLvuDeeYuOXU+u7O0dZLYJJ3qUf7xm0/WR6aC38cTAAD4C/wPMjga9kfGqDcl+bQZKiq0caxlbkPNDGy47BwXKAMFkC70f4yLbqQZ1/kjds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H68LjAWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H68LjAWN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 166DF1F00A3A;
	Tue,  8 Sep 2026 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788881275;
	bh=WCHKklg8cEPutnKLPb1e1PfotWTbh8qpHzH7bfkKnME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H68LjAWNnsavMcul0e1HeNg/8pCNZPRljfzXonB2+m5EKYIPWC/xTUfzbRhgg/rra
	 IRzTJIwivGtn2vQVymwBaViAfMVWpz7BU6H3UoIYG+LgTjLkU4A4a9kDvzIsrF+d+K
	 MCRBoNXnrK33xWNLzuw605pWDiiTzewEl2W1Xwc4QRcaqDkL5KQ5ULUrf0xoMCjVCq
	 Ji3vH3931eXn0XAx1qjrgGYfcoDo6pFvhcso5ndPVfJHW1YOZbF8173AlnTPS/9Tdr
	 HiPwItFJjbkJYLnCUtczKTZskWChSXSSZifpo9RCOy0nEoeOB3hTFB576zwsA8slfV
	 x+hcWb5AOT7Lw==
Date: Tue, 8 Sep 2026 08:27:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: enable xfs_trans_cancel() to report and error
 code
Message-ID: <20260908152754.GF2619314@frogsfrogsfrogs>
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908145422.232985-3-cem@kernel.org>

On Tue, Sep 08, 2026 at 04:54:15PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Once in a while it's useful to know exactly what kind of error caused a
> transaction to be cancelled.
> Enable xfs_trans_cancel() to receive an error code to be reported.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_trans.c | 8 +++++---
>  fs/xfs/xfs_trans.h | 6 +++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 792a67a7ec28..5bbbb9226864 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -971,8 +971,9 @@ xfs_trans_commit(
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
> @@ -999,7 +1000,8 @@ xfs_trans_cancel(
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
> index 2b366851e9a4..30135152d043 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -213,6 +213,11 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> +void __xfs_trans_cancel(xfs_trans_t *, int);
> +
> +#define xfs_trans_cancel(tp) __xfs_trans_cancel(tp, 0)
> +#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel(tp, error)

Nitpicking: the arguments should be wrapped in parentheses so you can't
do evil things to the preprocessor.  SOrry about being sloppy about
that.

#define xfs_trans_cancel_error(tp, error) \
	__xfs_trans_cancel((tp), (error))

--D

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
> 
