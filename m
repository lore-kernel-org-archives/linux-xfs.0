Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430124679C;
	Fri, 17 Apr 2026 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776435514; cv=none; b=gzqUMbEgJtlYsPi2h+0xFYWQsmUtJdaJv3jeRqRcuvw8A0SC5Hgex67JMw8RZQPOFcoHgHxiRBsCaK04EziHnNaWo+D3UBoXYYn1JPE5+54taUYca6oGdc5zPty4GRA+FWk9FS65Lf9dC6gVXUpBvkzl0N/6u2hR1MzT6VQRkwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776435514; c=relaxed/simple;
	bh=QRBDwehrIlUDhPTJwM4xFkKcy2A0zqfKM8V+RshiEK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcIBfYRxwNd+nIdftZSIZR51uXrN1Mji0WVMdoC4vndXlb+IK9N5WV3M3u0pSmxRr+tDLT5Ib7r/rjkfzcPxI5PXnW6G5tMy8m6o1PYyr4QkkQ4pk3WUZ5WH9zw0h04gW7geAzn40quo5HaAw8ydwuVEuLD2VCEuBI6p/xHSvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvB4pCi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvB4pCi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D298C2BCB0;
	Fri, 17 Apr 2026 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776435514;
	bh=QRBDwehrIlUDhPTJwM4xFkKcy2A0zqfKM8V+RshiEK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QvB4pCi5ETz16/ykKBepbphVG4IlJoziQ8G3RjPWqYBHcjcNyyZ2xHztwzoRflrLQ
	 oAtJaGB6Jzm7QVbyhPEY3ZR/8rnKX7OH3tqnegex9PTrsXbD1d6pByNmmVmhGsgnfO
	 ir5sXFtiDj7/ZLA6y2CGfbd0s7KTn//umoUx30xqc3F8BFp/Ctgrt2mr3imk/9ppRm
	 4dCCYtgdUPdJyuI19DbkVAS2wOsfyMfYluM0IywxwbehTqdOFSCRBd+dirD9JVrG2A
	 cptPvmqqyq6WxvsSR6q6mYCiuooz9QC6lABOn9G6EnEIU03+fPZAymkeIiy0itIdOz
	 JhzDoJB7dIkAg==
Date: Fri, 17 Apr 2026 07:18:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix memory leak for data allocated by
 xfs_zone_gc_data_alloc()
Message-ID: <20260417141833.GA7751@frogsfrogsfrogs>
References: <20260417021628.2608734-3-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417021628.2608734-3-wilfred.opensource@gmail.com>

On Fri, Apr 17, 2026 at 12:16:30PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> In xfs_zone_gc_mount(), on error, a struct xfs_zone_gc_data allocated
> with xfs_zone_gc_data_alloc() is freed with kfree(), however, this
> doesn't free the underlying folios or the rmap_irecs.
> 
> Use xfs_zone_gc_data_free() to correctly free this memory.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v6.15

[autobackport plz, I need all the help I can get]

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  fs/xfs/xfs_zone_gc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index e7b33d5a8b3d..2520e57e24a8 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -1230,7 +1230,7 @@ xfs_zone_gc_mount(
>  	if (data->oz)
>  		xfs_open_zone_put(data->oz);
>  out_free_gc_data:
> -	kfree(data);
> +	xfs_zone_gc_data_free(data);
>  	return error;
>  }
>  
> -- 
> 2.53.0
> 
> 
