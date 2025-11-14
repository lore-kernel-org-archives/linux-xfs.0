Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE8133FE28
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139316; cv=none; b=JDEuFjii91wz2lSy2OvFA00QVTkXtQZzmkRFnG1vd3Wndol/OmL6ECz0xhGeiPpZ17djrfElY3EQr8AuLtngC9rVCyPAhKr8X94myaQnzyMdeEdToLUg3J+9K3zKCQfTwDRLCC0Q2OGekhu9mo9Qog+h+BNqnc1spZ8sgbTxhFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139316; c=relaxed/simple;
	bh=E7c1muGXPOALS9FXCCHiFeKPw3B9cYXQO2fRSAtmKXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EroSmC4byC5xrxeCzv/Z68/SHavZ8dVFsUYu/ADynvSdGppsUyr8SE5HmKZk4wHM8G2nUeAqIl/+WKGA3qpDY2RMJi5DXdUd6HvLuYjy0JPucimZpHTvMj3YvIlusiUmMFjbThtrnx0zERJNZBHsPkbiM56D0T4I3OWkeujaNxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fe2gxXyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fe2gxXyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0631C116B1;
	Fri, 14 Nov 2025 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139315;
	bh=E7c1muGXPOALS9FXCCHiFeKPw3B9cYXQO2fRSAtmKXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fe2gxXyTs3cba/XTsJZRsMQhxiRMfsreVi6NXv6HLTgBetbTjhMm/HFIWvWEGz3iz
	 h+qi8yXQoBlxtHV8MX5CNYtlSM4YDYI6AJsCLXYoov3THUl/XVxowa1mT6Qv9SM9L/
	 +Yg4at36bep+9vywjCRMpLEIfOf8+iWLgsSQftYqTyeegH1SokyeZ0EiX9LgBEeD3w
	 iGhsKplPOM+hz9tiPADlxPH7+XaiD/kBZHAJYOyguha0uuHXSeXJEvImgeUpKV0tve
	 S/Rxr2c3V9nbCe1QLPG5h9bEWjVn7fY30iKl8LOOKXtLkNJ3H0aZXxtg5M2NNOICYO
	 SIbEkXGVc4DeQ==
Date: Fri, 14 Nov 2025 08:55:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Message-ID: <20251114165514.GF196370@frogsfrogsfrogs>
References: <20251112121458.915383-1-hch@lst.de>
 <20251112121458.915383-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112121458.915383-3-hch@lst.de>

On Wed, Nov 12, 2025 at 01:14:18PM +0100, Christoph Hellwig wrote:
> lv_bytes is mostly just use by the CIL code, but has crept into the
> low-level log writing code to decide on a full or partial iclog
> write.  Ensure it is valid even for the special log writes that don't
> go through the CIL by initializing it in xlog_write_one_vec.
> 
> Note that even without this fix, the checkpoint commits would never
> trigger a partial iclog write, as they have no payload beyond the
> opheader.
> 
> The unmount record on the other hand could in theory trigger a an
> overflow of the iclog, but given that is has never been seen in
> the wild this has probably been masked by the small size of it
> and the fact that the unmount process does multiple log forces
> before writing the unmount record and we thus usually operate on
> an empty or almost empty iclog.
> 
> Fixes: 110dc24ad2ae ("xfs: log vector rounding leaks log space")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ed83a0e3578e..382c55f4d8d2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -858,14 +858,15 @@ xlog_write_one_vec(
>  	struct xfs_log_vec	lv = {
>  		.lv_niovecs	= 1,
>  		.lv_iovecp	= reg,
> +		.lv_bytes	= reg->i_len,
>  	};
>  	LIST_HEAD		(lv_chain);
>  
>  	/* account for space used by record data */
> -	ticket->t_curr_res -= reg->i_len;
> +	ticket->t_curr_res -= lv.lv_bytes;
>  
>  	list_add(&lv.lv_list, &lv_chain);
> -	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
> +	return xlog_write(log, ctx, &lv_chain, ticket, lv.lv_bytes);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
> 
