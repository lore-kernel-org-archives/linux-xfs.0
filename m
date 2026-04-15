Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6122353EE5;
	Wed, 15 Apr 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776266186; cv=none; b=EiP39AyJgcYn8y32oH4hMRDlGqPWmNFZF2XYH/w167Sln0f31xDONLQfa9G2EAAICveiGg7q+npv6sruC+By9vkweck2y/MDMoR5WHN4Pwbn2DpM04+WNn3eaHk4ES8uCu1IDH5GGknvvjZ9ZuGk2eHY/SGEXwLzBnTFxybZQE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776266186; c=relaxed/simple;
	bh=T14uRROyTVyX6BnFhc48gEcOz4WSOnm2aK7ODj5iWTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fb+hct3snl83XkDaHBUQdbkVZznp3cz+IU/ssvbtpmwVfdMMuCtw7UhDbLrvRM0eIRXt3ReK1vqByX0m1pgfmZHbKbkgD5BNh754xCq+YF1C29skermkO9GYDZ1y0ugySYqEvgYMSYyWwNfsdVREIUOG8Ayt67+vQlsDBXZLmYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y44qDz6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y44qDz6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5690AC19424;
	Wed, 15 Apr 2026 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266186;
	bh=T14uRROyTVyX6BnFhc48gEcOz4WSOnm2aK7ODj5iWTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y44qDz6p1ZC6AZqU3ZjVcmbniDQwapAScRjdYnYVp176UOr8MUR/+7o+/2cWmKhKy
	 0BFEhMiZLRPEP/aPvJUa8D3Y2cWZDwJYKFZTFdHqOq/u7nZYiLE/ze/SZpf7B4xb3E
	 6FWXMZQnIH2m4EEulC4Z3jPnZ1W0gWmrBAeBbssPMT5Cd2NFl3bIC6IXJoIFtln+uP
	 Nwedj3gn0WD8C6fEHCmyVK/+k1K+rOTOg4lE02eYlcI5EuMBNE6A+2y+uxAI3iGPTX
	 3Zm2UXHBWmXIXhmIcc6e9V37tQM0fQYLWZIdJc/vB5N86i3mWkWKamIxOWK98jMoRI
	 7en4SnXhy0mpw==
Date: Wed, 15 Apr 2026 08:16:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: check hash ordering in xfs_da3_node_verify
Message-ID: <20260415151625.GB114209@frogsfrogsfrogs>
References: <20260415071223.48609-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415071223.48609-2-ytohnuki@amazon.com>

On Wed, Apr 15, 2026 at 08:12:24AM +0100, Yuto Ohnuki wrote:
> The DA node verifier checks header fields such as level and count, but
> it does not verify that the btree hash values are in non-decreasing
> order.
> 
> DA node blocks are traversed by searching the btree array for the first
> hash value that exceeds the lookup hash, which requires the hash values
> to be ordered correctly.
> 
> Add a hash order check to xfs_da3_node_verify, similar to the existing
> validation in xfs_dir3_leaf_check_int, so that misordered node
> blocks are detected as metadata corruption.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index ad801b7bd2dd..ef49df22899e 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -225,6 +225,7 @@ xfs_da3_node_verify(
>  	struct xfs_da_intnode	*hdr = bp->b_addr;
>  	struct xfs_da3_icnode_hdr ichdr;
>  	xfs_failaddr_t		fa;
> +	int			i;
>  
>  	xfs_da3_node_hdr_from_disk(mp, &ichdr, hdr);
>  
> @@ -247,7 +248,12 @@ xfs_da3_node_verify(
>  	    ichdr.count > mp->m_attr_geo->node_ents)
>  		return __this_address;
>  
> -	/* XXX: hash order check? */
> +	/* Check hash value order. */
> +	for (i = 0; i + 1 < ichdr.count; i++) {

I guess that works, though I'd have iterated from i to ichdr.count and
done the test on the previous element (like scrub/dir.c does).

> +		if (be32_to_cpu(ichdr.btree[i].hashval) >
> +				be32_to_cpu(ichdr.btree[i + 1].hashval))

I think this might be one of the few places where doing kernel style
indentation of the if test flows better:

	for (i = 1; i < ichdr.count; i++) {
		if (be32_to_cpu(ichdr.btree[i - 1].hashval) >
		    be32_to_cpu(ichdr.btree[i].hashval))

The logic is solid though.

--D

> +			return __this_address;
> +	}
>  
>  	return NULL;
>  }
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
