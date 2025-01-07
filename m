Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C392F13B298
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 02:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215251; cv=none; b=DBd7dlRSlabZ9pAQEP888ZAYasy8iH1pkLpkzm51Pm23AutrXRoBXeXgb9IWxErOIs/chwgcXcy/drcT5AWaZzQ/vbZjSwBeEkgNsqE07BM2yjgiXTSxZwp0G4NngQGy9uGU3s7Tlu1FkwtmFI1JQZ/4+3sffvCQu9B5yFm26e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215251; c=relaxed/simple;
	bh=s4FFHkFAHATwjbQLLd0xV1G5f9+6yiZme1+0AhRLGyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AS6hT7qL39fGSfXRk1DGkyoqqmIIstcx21hmg4DFWSLDqawrhb3GUS2p7OpLliM0SYWuxY7fduav2r8OxOB0r+V1jKSCmQBapgqYUHTVAXHnIaB9AefW9/xsVyGCzHPtV2XRde7wLZOf9wDsrVqUDPbcWRoBFoVtuVlq8EUFGnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZLmKlkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZLmKlkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8D3C4CEDD;
	Tue,  7 Jan 2025 02:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736215250;
	bh=s4FFHkFAHATwjbQLLd0xV1G5f9+6yiZme1+0AhRLGyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BZLmKlkwjnN+5UTn91ssN+EgVDRYYK4Hsg6mWh5bbnPvucldZTLdxriv24SPAWE7d
	 WCNDm4L+5jI12hxRgu9FlH4DD+r40nxPBOnlMJe1XVmfRrccU/9pPI6NANNNQifAmU
	 DfGxRsy7QFbkRmBlqdwVMjiF/5VGKNMRAeqp+INlSITyBWO15jZu3yAuRVekvaRWjp
	 zsknavBjSb4hperQcgcogiGiESTsqAAgl/hdAHteghDbfv1FnUJCnSwKe1UjOR6Dwr
	 IIIvyuo/Bfq06MZgG64ZahenOng+zvJMHRGiPGI/n8nIpMpYbU3rCOMroO0WGgum54
	 MknLFc0DgLaQQ==
Date: Mon, 6 Jan 2025 18:00:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: remove the incorrect comment above
 xfs_buf_free_maps
Message-ID: <20250107020050.GT6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-3-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:39AM +0100, Christoph Hellwig wrote:
> The comment above xfs_buf_free_maps talks about fields not even used in
> the function and also doesn't add any other value.  Remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 787caf0c3254..1927655fed13 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -202,9 +202,6 @@ xfs_buf_get_maps(
>  	return 0;
>  }
>  
> -/*
> - *	Frees b_pages if it was allocated.
> - */
>  static void
>  xfs_buf_free_maps(
>  	struct xfs_buf	*bp)
> -- 
> 2.45.2
> 
> 
