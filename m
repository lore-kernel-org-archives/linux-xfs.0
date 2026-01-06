Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBCA247280
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 14:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767709861; cv=none; b=aQ0des16Q2ghcA7DFBfPfdmH2nAHbPbaB+Jvd96F1/p/plep1w9q2YxAkb2T/waqXQW45yKg+wxXSP41P7N0yALiiR2wEmUeOAcKJYG2skTioq5vDWBDTY3OpcisibL3rgPjEtFILoS6zjYOMVSo4es7bcELUhLhOyKP1Ku3Hg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767709861; c=relaxed/simple;
	bh=nLZM6d3aQnvu3oMoq/JtCsUdfyJUsxHul+AnMG/iFt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiHXj64HNOAGplp7Pnm2WovKLkvJ0IC7ZpYrufAWUbMP1aW8SCuQT8I+OJB+emoH7iIR4W96eIs3j3z+iq9cy8pttW+p/clku1Rq9MYt2BQiZ+LFQpOkz3T/E8xpTrCuDEcaWYLPVoh+tSijCX3o6pA6dSdftA+terBLBWIVY/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVUOe27p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVUOe27p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF93C116C6;
	Tue,  6 Jan 2026 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767709860;
	bh=nLZM6d3aQnvu3oMoq/JtCsUdfyJUsxHul+AnMG/iFt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVUOe27putZSkx3yYacc6yNeiaGaUx/XqYkMXfz4/PQ5dSMJfaKI3XwOLqKSlBmc7
	 EJkABPv27IujX7p/yld5/4BwSUsIo9ffQEOYuhMhU+ZVKwy4mAzR2KC6fwD5+WRjWK
	 FToYrPdbh2YLDepqI15M20C1W7NP+naE6elLL2xnF24GmEXqL/aM1tFzxCBIpHujMs
	 p2FbgyE+tO8XGf8FBf1y0/6iHyHZ/v6WJmQi7DxcWsEcY8CMoIkMHsmw77JLHuUtAi
	 feY70jFaUPbwj0owNQv+BRBT8l0BcusJZiSvkrNB0uNDcMgsczJ7EkmpuFc2bA0ILb
	 TNIekYGm2nOdw==
Date: Tue, 6 Jan 2026 15:30:57 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use memparse() when parsing mount options
Message-ID: <aV0bA8uiVR2Zxn6g@nidhogg.toxiclabs.cc>
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

This will force the allocsize to be set to the lowest power of two set.
If we pass a bogus number to allocsize, it will round down to the lowest
power of two.

While I agree with adding an explicit check, currently we print out an
error message when something other than a power of two is set:

E.g. XFS (vdb1): invalid log iosize: 11 [not 12-30]

With this patch we lose such information and nothing is printed back to
the user. I think we should still inform the user a bogus value has been
passed.

FWIW, we silently truncate down bogus value, so the current behavior
ain't the best either.


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
> -		}
> +		parsing_mp->m_awu_max_bytes = v;
>  		return 0;
>  	default:
>  		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
> -- 
> 2.52.0
> 
> 
