Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8993B6354;
	Fri, 15 May 2026 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861018; cv=none; b=lv3mKZJRWG7woo28zOkSYYT8j5DQpwMqHR7OvY82iHXp3nEmvxYsn6EcEZQ2inhxuwjlTv1KJtejO8IeV4RM3Bi3w2WLXO0RS9tg1q6N057Qi8jOB7/AKQRG0kwNhT2wSOBE8I2zUlnvk3FCb5yr6rvs8TzDDSJTL67EldCiZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861018; c=relaxed/simple;
	bh=JdmmwjOmsLou2sX3Xuv7ik4E+I6Mhl4Y8WHWht/GW9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FT+/BDH6A0qBqEatPJoyVePjOh1mA+mJatsv4ci0CR2OTIvsSNsYnvZ/moR53loHRbepv4RewtT8Vo2Vbz0b3IOxzCO3GAUEO0gFIu/tYMxkiWJtWEJFLxbbbrgxZ5HQw2YdLlQbDydLgr9lcAFsMH48WAAeW0BfF0tn1dqqVb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtBqf9kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtBqf9kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD6DC2BCB0;
	Fri, 15 May 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778861017;
	bh=JdmmwjOmsLou2sX3Xuv7ik4E+I6Mhl4Y8WHWht/GW9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RtBqf9kVtGx4XsvkKH3t45oaznfkl4cAPPGs9jgU8RUGkKlH5q8LS635V9TZKlNcv
	 dXsigztusv/hqFaqnHQsT22t8bGi840Pdz5FB8rq2/iFesEDYN4bhLvJL1rSCNRg7L
	 XnwRWWuanwnK1jY5FF4C6E5NwPA4DtKjoDLGCJE1/5h/Y1pVjQr/RAcNGghO17cmiI
	 9k6V9QQgNDzS3uLJ593FXnEoCZk13GAB8DrYQax4LbXtH8Uho0W0LZNR5GJntwPOsA
	 /Nzi8Nc/sBaSC/YNc3uw4bhjGWN/mzqp39jWQPN/Hv57AvRHZK9awrFpPHVsx7/QcO
	 WeH/VHc9TY1xQ==
Date: Sat, 16 May 2026 00:03:31 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, fstests@vger.kernel.org, 
	xfs-list <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] common/xfs: helper function to check if -l/-d/-r
 concurrecy flags.
Message-ID: <agdC-BpP076q-RWb@zlang-mailbox>
Mail-Followup-To: Lukas Herbolt <lukas@herbolt.com>, djwong@kernel.org, 
	fstests@vger.kernel.org, xfs-list <linux-xfs@vger.kernel.org>
References: <20260514113910.866888-2-lukas@herbolt.com>
 <20260514113910.866888-6-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113910.866888-6-lukas@herbolt.com>

On Thu, May 14, 2026 at 01:39:11PM +0200, Lukas Herbolt wrote:
> Check if the requested flag is supported by the mkfs.xfs on scratch
> device.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
> ---
>  changes v2:
> 	-l/-d were introduced at same release no need to check both
>  common/xfs | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index f7a6d2f2f03a..c48b043faf80 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2399,3 +2399,12 @@ _require_xfs_healer()
>  	_xfs_healer --supported "$@" &>/dev/null || \
>  		_notrun "health monitoring not supported on this kernel"
>  }
> +
> +# -l/-d concurrency came in same xfsprogs release v6.7
> + _scratch_mkfs_xfs_supports_concurrency()
> +{
> +    local arg="${1:-d}"
> +
> +    test "$arg" = "-l" && arg="-d"
> +    _scratch_mkfs_xfs_supported "$arg" concurrency=0

Fair enough. It seems this 'compromise' is a workaround to avoid
passing a log device to _scratch_mkfs_xfs_supported.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> +}
> -- 
> 2.54.0
> 
