Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274EF188733;
	Mon, 14 Apr 2025 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744668961; cv=none; b=hGFAqiLwZcdl3wiP9s01rwHnLMxVdnq2IGzN1XYtq4SshOKQCOTY0X0R7roUdTv/zvuUo2UlWqyTZJ5NlQ6dMnl+8MHzD1pTJ3BJiAWuA2apdug1ooyHIjfC35vdh2hGn393tO+ajZzlsQGadGyHVXrAkiEc4ov644WFzZCvFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744668961; c=relaxed/simple;
	bh=HEu9OtF4BtaBMlr0OFBUyUbeTpsXoNaLSVmNNaDy42c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYWEldhHG5NswAG88tTQpygxiMgJfOK7Z52ukYlhcmjPiLHgzkCQxsE3jl2nRwplyep6Zw9dwB/QjkKbYkoJXdqY7lVHULYYwEaD0rm3PonCknDk6bfw0Rl8hxmau2W5cWnAY8e1yGIi1u575N0PUJg7c7kcepkFTdclB+54uqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oR5KFMl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oR5KFMl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764D4C4CEE2;
	Mon, 14 Apr 2025 22:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744668960;
	bh=HEu9OtF4BtaBMlr0OFBUyUbeTpsXoNaLSVmNNaDy42c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oR5KFMl/UgO5dphG0vdfLbeo84Bpz6MW4BoXPoDo1PgUpSLioz3XvpOSY/IGQvx2h
	 jL1bk7S6F1BNcxkG5E/Qczchley5OkvcAm0GwqVo0jeIwSydxbYuXLVyZ7IBn+CFV4
	 Idr4TNZT8RuQdJNOAUM0xudqdCzVU9sCryu9zJR8597OPgCtkpXyX1tWT7lECocWCl
	 72lfe7H/XAi0Iz2PPDubW7mk0yXkCD9GNqW91PgulYvNOTvicpFYFWN6Ep2Kl5bJuu
	 bTueuD53hyAIv3QpKLqkhtsTDAyRdfK5+wWbO9PY5K68bO68hXWxiD5QgOv6pDSndg
	 M2QtJ6lToeB+w==
Date: Mon, 14 Apr 2025 15:15:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Charalampos Mitrodimas <charmitro@posteo.net>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Verify DA node btree hash order
Message-ID: <20250414221559.GC25675@frogsfrogsfrogs>
References: <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>

On Sat, Apr 12, 2025 at 08:03:57PM +0000, Charalampos Mitrodimas wrote:
> The xfs_da3_node_verify() function checks the integrity of directory
> and attribute B-tree node blocks. However, it was missing a check to
> ensure that the hash values of the btree entries within the node are
> strictly increasing, as required by the B-tree structure.
> 
> Add a loop to iterate through the btree entries and verify that each
> entry's hash value is greater than the previous one. If an
> out-of-order hash value is detected, return failure to indicate
> corruption.
> 
> This addresses the "XXX: hash order check?" comment and improves
> corruption detection for DA node blocks.
> 
> Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -247,7 +247,16 @@ xfs_da3_node_verify(
>  	    ichdr.count > mp->m_attr_geo->node_ents)
>  		return __this_address;
>  
> -	/* XXX: hash order check? */
> +	/* Check hash order */
> +	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
> +
> +	for (int i = 1; i < ichdr.count; i++) {
> +		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
> +
> +		if (curr_hash <= prev_hash)

Does XFS support a directory with two names that hash to the same value?

--D

> +			return __this_address;
> +		prev_hash = curr_hash;
> +	}
>  
>  	return NULL;
>  }
> 
> ---
> base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
> change-id: 20250412-xfs-hash-check-be7397881a2c
> 
> Best regards,
> -- 
> Charalampos Mitrodimas <charmitro@posteo.net>
> 
> 
