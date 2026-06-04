Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970E2FFDFC;
	Thu,  4 Jun 2026 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584800; cv=none; b=OJ8L2E3EEsk8ANjg3aPf81aJzmkLJpea8hlXbC/kFPPmhqNYQn0/8lVcyDzXEdZ2FdyDJycZY7vPZEdE50bb5/aqHXVRVLCowiER0Bvr5U2ejKosGqM2e5AJ204X0foH6otGG58m3TVmigZVYyrKbzsTS+JKNorhw+Ne5BGX+jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584800; c=relaxed/simple;
	bh=bYe4HmE5H615cthAjeHmIlmbair1QiZ3ZvGqA8YW13g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bykpT2gB7rEtGIs1+AUEVvFvvarAtvkML3ALakgzXgwZr7mZfJjzia7+b0L7UOOMKHGcu2xQbZi4nnrnUfJqobvddtRcUivbNYVy9d6sgB7/E6jAghVw6QeSN4eAgN452yaj3eqEkvNvCcqLKya0uu5kalmOLtgxRxkLvrNqjnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evxtNGcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evxtNGcr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EAB111F00893;
	Thu,  4 Jun 2026 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780584799;
	bh=b+xFkY4vkE+eV91AOFhATehRInnQqRWH7emWjxhRhu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=evxtNGcrRkbiCqEzeGstAjsw+fTdlkacTWFyVdDerg4QBzScAc0BXo+xgImHXJLOs
	 vm+bHXW/P9ePkAt/JH6biJ7y/BkWCSUemm2B41gE36isB/PVODK7DygpsR+hfbjA/I
	 Ui7IxT5Zw6zd3hZxaXGUoQJhQPL5P7Z8CrQ1IaCaSoAmOS/b6cqdGY6DXzjrj8lcNN
	 2umb//PIsRixn5bXaUXWSxt0SBkkNZNJ9vOFSJsqs4Xf2OfU3LWCLbilA7e8bmh/DI
	 V7d4Z3IP1YJDZVI/PGFapq2U6y9Xu5RUgNmLSFp1FtXZ1fudQkorzbIIdiPVEs8svA
	 gWpDOEoQzLerQ==
Date: Thu, 4 Jun 2026 07:53:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix exchmaps reservation limit check
Message-ID: <20260604145318.GF6095@frogsfrogsfrogs>
References: <20260604120317.930273-1-gaoyingjie@uniontech.com>
 <20260604120317.930273-2-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604120317.930273-2-gaoyingjie@uniontech.com>

On Thu, Jun 04, 2026 at 08:03:17PM +0800, Yingjie Gao wrote:
> xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
> overhead to a local resblks variable, but the final UINT_MAX
> check still tests req->resblks.  That is the reservation value
> from before the overhead was added.
> 
> The computed value is stored back in req->resblks and later passed
> to xfs_trans_alloc(), whose block reservation argument is unsigned
> int.  Check the computed reservation so the existing limit applies
> to the value that will be used.
> 
> Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
> Cc: <stable@vger.kernel.org> # v6.10
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>

Oops.  That's a good catch!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_exchmaps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 5d28f4eac527..541e33f33167 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -711,7 +711,7 @@ xfs_exchmaps_estimate_overhead(
>  		return -ENOSPC;
>  
>  	/* Can't actually reserve more than UINT_MAX blocks. */
> -	if (req->resblks > UINT_MAX)
> +	if (resblks > UINT_MAX)
>  		return -ENOSPC;
>  
>  	req->resblks = resblks;
> -- 
> 2.20.1
> 
