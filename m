Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E95B30DEA6
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979641; cv=none; b=MznrSFqf0k7ytOM5jRl/6ccD+QxBEitIbMK8UEe/SD/HNzG1EmLCru/rjR0YqU/EIY3RQEK1P+8HZFQq2omPuPMLX4xukjE20pk23xFCdcGYEQt7GZNN3EikDUhIshIkxKTZRt5nRtpelG2eqaHPPM4Qs57zP9IhiMAFAAsI0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979641; c=relaxed/simple;
	bh=HFI3oDM6nVnKmlaqrWFCPW4oWY2lbyzdiGqg3yW08lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWypHcrM5x0v7tZAktTnzKUdcvc9OCyHDI1d+5sii+T8/iyxNLZyoqAVZMhKprS92l22IsN8usX39kNBkH3DDRypV7D7ZE4Ad8me/0WFh64Wtk3XUT2n0RbDvjc+rRDbWsZlyYmNC4AkkndTUNEQvrqF12Oe3ELpqkCQFz1qw50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CBB7868B05; Mon, 21 Sep 2026 10:33:56 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:33:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org, hch@lst.de, sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <20260921083356.GB20936@lst.de>
References: <20260917103633.14703-1-cem@kernel.org> <20260917103633.14703-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917103633.14703-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 17, 2026 at 12:35:47PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Once in a while it's useful to know exactly what kind of error caused a
> transaction to be cancelled.
> Enable xfs_trans_cancel() to receive an error code to be reported.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> V3:
> 	- Kill typedef from __xfs_trans_cancel
> 	- Remove uneeded wrap of parameter 0
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
> index eb83c5dac032..36a49622b870 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -213,6 +213,11 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> +void __xfs_trans_cancel(struct xfs_trans *, int);
> +
> +#define xfs_trans_cancel(tp) __xfs_trans_cancel((tp), 0)
> +#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel((tp), (error))

Can we turn these into inlines instead of macros?

And do away with the pointless __xfs_trans_cancel, just implement
xfs_trans_cancel_error in xfs_trans.c, and wrap xfs_trans_cancel around
it.

