Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C4C3C1984;
	Wed, 23 Sep 2026 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182655; cv=none; b=vDqXpndEinKlcYD6amh0gyjryxHbGcMmt5bMMo1UafdYvo4YKvWOVwJ6ODygSfjndT0OoV7Lp2f7aZIYCyOQhx8KGWWjgBbbq83wleEFlcgF/z0gYUo/XCSYJ77+2Lv6hexZXwpFgi9GHQARZSg04f5tk7uEimI3RXweaMxpKXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182655; c=relaxed/simple;
	bh=kSlwMVmGiWcOLHDyL51FrWTuoUOKdxw/7+Ml/GAuE4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwfcHJQaAXc5APs0QgQokeObDbgKFAlvQesTmL/2bLIsL4qE5ZQ00KzjORQL/8BvkTFlNBga1zqgMYWwWNjY3L6P3y2oGMyCHlOJ4YHhH2rGOam/gBEgXEon+hK4bqRtUECiH7GjgwT1eArT0JebnmxB1CzemR5+lN+1w2XK1Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qo9GkNE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qo9GkNE0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 60E8C1F000FF;
	Wed, 23 Sep 2026 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790182654;
	bh=xqiBb1CVJvGDuNkaA1v7TntapFVwjpxeOmWZZ5xu164=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qo9GkNE0Fm8AoDxE0XxFL2CsiIdT+/dhP0PsXbgFl5SohrDKDvD9Vysu3QLm6U9BJ
	 O3gzzUn02jS0RWIbymT84gQBJQI387PTrn3endvL/B1zyTON7107pLkZuD7TuycmYH
	 8Qygt/i14UXDihsD28VMr+tTI7g996+hBA/f6ZsTYJjQ0syBLimpcA9m4PrfgxzDvC
	 ZZvKOxQxCPgDQcDR9T7M236AJJ6M7uatgpesOToR++o59JzzVQbjSSKy9cJWQbbcm3
	 zbm6iAVSiL2/hBTU6/q9+gFXvlBxvZ+QtZR5xpU21fXnw3hQIHwBsSvufSWn5Gc/1z
	 Fx18bXqU6QiDw==
Date: Wed, 23 Sep 2026 09:57:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/2] xfs: reject remote xattr entries with an
 out-of-range value length
Message-ID: <20260923165734.GE2705364@frogsfrogsfrogs>
References: <20260923115823.3305596-1-qwe.aldo@gmail.com>
 <20260923115823.3305596-3-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923115823.3305596-3-qwe.aldo@gmail.com>

On Wed, Sep 23, 2026 at 08:58:23AM -0300, Aldo Ariel Panzardo wrote:
> xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
> but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
> valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
> the verifier and the CRC.
> 
> That length is later assigned into the signed int args->rmtvaluelen
> (xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
> -ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
> then memcpy()s a full remote block into the small kvalue buffer
> (xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
> attacker-controlled content, from an unprivileged getxattr(2) on a
> mounted crafted image.
> 
> Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
> the leaf verifier, so the malicious block is rejected at read time.
> 
> Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

Still looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v2: cc stable (per Darrick).  Now 2/2 of a series: 1/2 fixes the signed
>     value-length check in xfs_attr_copy_value(); this read-time verifier
>     fix is otherwise unchanged from v1.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d0f7753659c9..948dc8b26fe6 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -339,6 +339,8 @@ xfs_attr3_leaf_verify_entry(
>  		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
>  		    rentry->valueblk == 0)
>  			return __this_address;
> +		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
> +			return __this_address;
>  	}
>  
>  	if (name_end > buf_end)
> -- 
> 2.53.0
> 
> 
