Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5994DF59
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 18:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410944; cv=none; b=MBrQ66/mjp+qDAE1oUUuasULBNRBa2QBo3JYhpmnSZ4WL6iTS7Vdr4fu/iIfb73i49Y03zwRykce3psyruwbxyMpnJM/YuTUUhtrKyWN03mF9pobUlIPzflN08C/GsKyJuXW43hK3/A5yTRz1eEodRe2nB5ErJsCoyyF7y8WtGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410944; c=relaxed/simple;
	bh=BFarKdqrNXKwhmJIIcJ5NaW+n3mSf5FFYfDGYDrfbws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNIrNaWFZW6T5eUX523RmqWtBJR/fOmmCwyZ3GqnVbiZDH925EzNyVnLJcrlKjoukyQo6X1PdEbMp3GItn4krsRsOAuXlPLNREMZP3CdhyrOmMuOKMKuShljjIU/zFdQFjgbSxBeWNGQCacPah2YvLO6YNR5k3I2f54LgGQqZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnK1g5I3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnK1g5I3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8FF0A1F000E9;
	Thu, 25 Jun 2026 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410943;
	bh=H0mzTJEFGUg2dM2IdxB6yPqrouJzgGRP5i19HUIbncc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LnK1g5I3cxSNfo5d8T584KlRKBbdjrJEqOPGWYPnaIgPSp8a9r2wPu8amL6dFVDBD
	 94b2wCu4vFM1ljm6XwFa/xJ53pPddWr3nTKQDng20XavCHz1BFEzkLdpG3lN+5jtxm
	 zL839gbbfM1EH6dEY7Ex5larLrmBryuVGDh687dGo/HLEgvx34nUlXF2k4gmbDvZ40
	 g6375xQtb1fQFFh24dOw1nY9JT6eOhapIvW+MH0uiZu9afqdB1IU47C5/mn0Uk2nwh
	 sNLJ06gAfANX5cbdV8D1YeYLQqRP6RUXUXaSkN4saJ4FUuarQg4QdWyymvgR5ifzIJ
	 lOF8ZuBO83/Yg==
Date: Thu, 25 Jun 2026 11:09:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/6] xfs: remove xfs_buf_ioend
Message-ID: <20260625180903.GI6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625135849.2494779-5-hch@lst.de>

On Thu, Jun 25, 2026 at 03:58:34PM +0200, Christoph Hellwig wrote:
> There are two callers of xfs_buf_ioend, one of which always has the
> XBF_ASYNC flag set.  Open code the logic in both callers to prepare for a
> bug fix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Seems fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 83c74b5b7e8e..3eea9d9ea829 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1146,18 +1146,6 @@ __xfs_buf_ioend(
>  	return true;
>  }
>  
> -static void
> -xfs_buf_ioend(
> -	struct xfs_buf	*bp)
> -{
> -	if (!__xfs_buf_ioend(bp))
> -		return;
> -	if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> -		complete(&bp->b_iowait);
> -}
> -
>  static void
>  xfs_buf_ioend_work(
>  	struct work_struct	*work)
> @@ -1207,7 +1195,8 @@ xfs_buf_fail(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  	xfs_buf_ioerror(bp, -EIO);
> -	xfs_buf_ioend(bp);
> +	if (__xfs_buf_ioend(bp))
> +		xfs_buf_relse(bp);
>  }
>  
>  int
> @@ -1414,7 +1403,12 @@ xfs_buf_submit(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  end_io:
> -	xfs_buf_ioend(bp);
> +	if (!__xfs_buf_ioend(bp))
> +		return;
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_relse(bp);
> +	else
> +		complete(&bp->b_iowait);
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
