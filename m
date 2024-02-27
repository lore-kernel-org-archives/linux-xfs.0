Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088A4136A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 00:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708994829; cv=none; b=erxmsYgwuE7n5I6tAAx154f8DIYngPJyZqRkPrqyzULMBDLN9EQumw4Xhn6/ClViKlpIO8SWtY3YTZVn8iMVOFFHOCPVXpEmt5IhOYhJhXe6U99pYNv8l+3c3hoRiRRBSth7Sf3E5S1IBaxNv9TyuOCsS2lNs1N8ShEvaStOUyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708994829; c=relaxed/simple;
	bh=1M1lBxYfO+jiSE2C3EppQLtVENwjlC1ixdU/nl8wreI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TUKrOfiQT2eCSdw1ZKUtY9sUhrR08QPCxz1/8Z/ndCx2OzAI2xbGGKY0xq1Z5Q+0IlgcyoTF7ZO2cLB+lzmcI1IJkirQZ4L/mAgxnaP+ZqI4E6xBF7kPINVScPg2rmyElDZcLq2b090TJ6JOC7u9MthlKjPSBSfjZByCyi9Y1Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSShDmyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSShDmyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CF2C433F1;
	Tue, 27 Feb 2024 00:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708994828;
	bh=1M1lBxYfO+jiSE2C3EppQLtVENwjlC1ixdU/nl8wreI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nSShDmyHJaKU6D+vA+nCHFsskO+7hY6vzCzmF5QSUm4/8YJSe+0wf8LWy/hNCXbWc
	 /tFv6vecNEJw4psZiiQXaBoBCBQcGc1e7TFGlWzS7Tog3QC98YBaDEoRzIEmL9GEv7
	 v+ux7MHHysNp1cMpxTMpstV5Y6rLTceF07hxp/Uu5wE5BQmKXJIj5hLiNVTXM1dgdx
	 IFlwCkABubV8J+mVtUC1mwgsRul8gn8i3E3pcB8VGOGfxl43gmt3koihvVKBcM5ijC
	 fG7jzIRVwS9I5m+vYyC9QLJ8x3GXcFEdBTBJ2ztwco3pU0WbXZc5KZdY3rBv+icNPp
	 6BLWYcGmWzyhQ==
Date: Mon, 26 Feb 2024 16:47:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 1/2] xfs: xfs_btree_bload_prep_block() should use
 __GFP_NOFAIL
Message-ID: <20240227004708.GO616564@frogsfrogsfrogs>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227001135.718165-2-david@fromorbit.com>

On Tue, Feb 27, 2024 at 11:05:31AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This was missed in the conversion from KM* flags.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks correct to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_btree_staging.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index f0c69f9bb169..e6ec01f25d90 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -406,7 +406,7 @@ xfs_btree_bload_prep_block(
>  
>  		/* Allocate a new incore btree root block. */
>  		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
> -		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
> +		ifp->if_broot = kzalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
>  		ifp->if_broot_bytes = (int)new_size;
>  
>  		/* Initialize it and send it out. */
> -- 
> 2.43.0
> 
> 
