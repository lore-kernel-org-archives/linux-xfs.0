Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5521E5724
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767708532; cv=none; b=ZcCAaTgUr+J/CaIqfmT64LoB+/qkL2PFcR+6MzGd1w5uAj6MSfiEsCE7gWERdYRDkLkobx05S18iM0iakwNBMuC56NVrsNWB7YwX1KTj6c5eA8ClLdBT/60pOPrh0I3GqZAx/x2C5185+Oev5pf1SUOZ5Dp/57IVBeJoE2/5yI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767708532; c=relaxed/simple;
	bh=Qs1x48BlNh6IqSiAxBvmOFVOSefYqe6x68PMgVJ8ZgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lo0GuduBk08qbTsm4me62pKmhNaA2PoQnMSN+ghrOu8qwOcV8P/mJdhSpa7zGKMVBxXVF9XCtC3mnYnaDg6DxFF8Ae99MbmynhN7gF9Yp9yiRsCay9YVb+jRbzvyQZvnro6+Z7w4V68xfWUNiC9l4czr2vaVkvR1QihuoppZ+Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/ad+KSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/ad+KSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95588C116C6;
	Tue,  6 Jan 2026 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767708532;
	bh=Qs1x48BlNh6IqSiAxBvmOFVOSefYqe6x68PMgVJ8ZgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L/ad+KSinPiWK0WznIhL+A2iiv3c6vPToaIlICu/UIgqW94B3EUaK4okF215fI32I
	 ncV9G4kqymteZv6Q+KLDEP2+mZtbw6sGy8wvm62DvcS2+weI51WsvjtpVOAHjRWoby
	 7zbAc01prJgIFU3dGPSCIHWDV+jdOOIb1nNYEsmshe7F7UB31iHI/v1gG9IwlpIfNI
	 R5U8K41xfUk2y8soMtb+0Y4dm9xNmRFptURfVwZ5dxbeq52Asl5lPRd+QgLsj5H4ZW
	 PtLgAhxs2ZuAj7kKgKyK2hjCfzS2YueenZuzDubJV3hlgUDh1kZow1JMvsNF7LcwIr
	 2yfzbklM802CQ==
Date: Tue, 6 Jan 2026 15:08:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use memparse() when parsing mount options
Message-ID: <aV0UcoXBKMwpt1Ea@nidhogg.toxiclabs.cc>
References: <20251225144138.150882-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225144138.150882-1-dmantipov@yandex.ru>

On Thu, Dec 25, 2025 at 05:41:37PM +0300, Dmitry Antipov wrote:
> In 'xfs_fs_parse_param()', prefer convenient 'memparse()' over
> 'suffix_kstrtoint()' and 'suffix_kstrtoull()' (and remove both
> of them since they're not used anywhere else).
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/xfs/xfs_super.c | 93 ++++++++--------------------------------------
>  1 file changed, 15 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bc71aa9dcee8..433c27721b95 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1319,77 +1319,6 @@ static const struct super_operations xfs_super_operations = {
>  	.show_stats		= xfs_fs_show_stats,
>  };
>  
> -static int
> -suffix_kstrtoint(
> -	const char	*s,
> -	unsigned int	base,
> -	int		*res)
> -{
> -	int		last, shift_left_factor = 0, _res;
> -	char		*value;
> -	int		ret = 0;
> -
> -	value = kstrdup(s, GFP_KERNEL);
> -	if (!value)
> -		return -ENOMEM;
> -
> -	last = strlen(value) - 1;
> -	if (value[last] == 'K' || value[last] == 'k') {
> -		shift_left_factor = 10;
> -		value[last] = '\0';
> -	}
> -	if (value[last] == 'M' || value[last] == 'm') {
> -		shift_left_factor = 20;
> -		value[last] = '\0';
> -	}
> -	if (value[last] == 'G' || value[last] == 'g') {
> -		shift_left_factor = 30;
> -		value[last] = '\0';
> -	}
> -
> -	if (kstrtoint(value, base, &_res))
> -		ret = -EINVAL;
> -	kfree(value);
> -	*res = _res << shift_left_factor;
> -	return ret;
> -}
> -
> -static int
> -suffix_kstrtoull(
> -	const char		*s,
> -	unsigned int		base,
> -	unsigned long long	*res)
> -{
> -	int			last, shift_left_factor = 0;
> -	unsigned long long	_res;
> -	char			*value;
> -	int			ret = 0;
> -
> -	value = kstrdup(s, GFP_KERNEL);
> -	if (!value)
> -		return -ENOMEM;
> -
> -	last = strlen(value) - 1;
> -	if (value[last] == 'K' || value[last] == 'k') {
> -		shift_left_factor = 10;
> -		value[last] = '\0';
> -	}
> -	if (value[last] == 'M' || value[last] == 'm') {
> -		shift_left_factor = 20;
> -		value[last] = '\0';
> -	}
> -	if (value[last] == 'G' || value[last] == 'g') {
> -		shift_left_factor = 30;
> -		value[last] = '\0';
> -	}
> -
> -	if (kstrtoull(value, base, &_res))
> -		ret = -EINVAL;
> -	kfree(value);
> -	*res = _res << shift_left_factor;
> -	return ret;
> -}
> -
>  static inline void
>  xfs_fs_warn_deprecated(
>  	struct fs_context	*fc,
> @@ -1429,6 +1358,8 @@ xfs_fs_parse_param(
>  	struct fs_parse_result	result;
>  	int			size = 0;
>  	int			opt;
> +	char			*end;
> +	unsigned long long	v;
>  
>  	BUILD_BUG_ON(XFS_QFLAGS_MNTOPTS & XFS_MOUNT_QUOTA_ALL);
>  
> @@ -1444,8 +1375,12 @@ xfs_fs_parse_param(
>  		parsing_mp->m_logbufs = result.uint_32;
>  		return 0;
>  	case Opt_logbsize:
> -		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
> +		v = memparse(param->string, &end);
> +		if (*end != 0)
>  			return -EINVAL;
> +		if (v > INT_MAX)
> +			return -ERANGE;
> +		parsing_mp->m_logbsize = v;
>  		return 0;
>  	case Opt_logdev:
>  		kfree(parsing_mp->m_logname);
> @@ -1460,8 +1395,12 @@ xfs_fs_parse_param(
>  			return -ENOMEM;
>  		return 0;
>  	case Opt_allocsize:
> -		if (suffix_kstrtoint(param->string, 10, &size))
> +		v = memparse(param->string, &end);
> +		if (*end != 0)
>  			return -EINVAL;
> +		if (v > INT_MAX)
> +			return -ERANGE;
> +		size = v;
>  		parsing_mp->m_allocsize_log = ffs(size) - 1;
>  		parsing_mp->m_features |= XFS_FEAT_ALLOCSIZE;
>  		return 0;
> @@ -1570,12 +1509,10 @@ xfs_fs_parse_param(
>  		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
>  		return 0;
>  	case Opt_max_atomic_write:
> -		if (suffix_kstrtoull(param->string, 10,
> -				     &parsing_mp->m_awu_max_bytes)) {
> -			xfs_warn(parsing_mp,
> - "max atomic write size must be positive integer");
> +		v = memparse(param->string, &end);
> +		if (*end != 0 || v == 0)
>  			return -EINVAL;


The patch looks mostly fine, but it changes max_atomic_write semantics.
So far the option accepts 0 as a valid value, and this patch forbids it.

I'm not sure how useful setting it to 0 would be, but I *think* perhaps
it can be used to explicitly prevent atomic writes. Anyway, if we opt to
change the semantics, that should be done in a different patch, not one
that is updating API usage.

Cheers,
Carlos

> -		}
> +		parsing_mp->m_awu_max_bytes = v;
>  		return 0;
>  	default:
>  		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
> -- 
> 2.52.0
> 
> 
