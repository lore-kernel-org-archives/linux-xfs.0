Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E5F27AC41;
	Thu,  8 May 2025 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746717144; cv=none; b=D0ZzdhoeXHCfXC7wuXh9BrLi7GNuoWJdCM8LvedoqweTT3ySEQvJVwB8d6QyGw1d6b7/TDDX5sMxPq8uTEyEpdHNvfADnLTYEHiOPG+UEsQoSxdtpRSOzHFpM5Qpnm5VynyFdX5pbV4OnTYbfrptz4squvfl5rJfnlguSUvdV9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746717144; c=relaxed/simple;
	bh=FllKGQAxhHWtuNc5mc2Ei6wdpIA+0MEAIItk+A8ICtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tcpDs0DpB5W/2htpeaFhRxKxp0gcp+KHeVWtwTN1mYFfg089jmD8MHyolpzXZwrK/TfLI7vky0LPNwHBSDPgPijExe2Zv4uwhuDak9Ij9c2U4TsNB3j7BpmYZZZZiN3xk1iSuIRpE6A/YQ/pzeuSgT86bbMlMeBL54LP+EmE8uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbRbsS3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbRbsS3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08855C4CEE7;
	Thu,  8 May 2025 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746717144;
	bh=FllKGQAxhHWtuNc5mc2Ei6wdpIA+0MEAIItk+A8ICtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XbRbsS3cyaTZzAQ/dx9q5EPz8BotakWgnkLYR1rqF2xiV4UH1NAWhzNQH2C1mWlSX
	 dKQHQMdytL5px1XQ51FAvIo8f+s1HIVIrY3VvyDnhPs+vsp7YYTMAkvs3eqEOFQx7P
	 dFhvo2f2umAdL/HDV1sRTe7FvyRVqcCQtcattGUFTZyxgEcXk5GBjBd7I2jBSBi+8q
	 ormZWpgTSWHzKpBCT1Lrlczwzj9sYLsE6I/2eYkZhSS6P6vhD4KONL+I4I8hE86N8x
	 Z1XrYddgUIx8H2B667f+4Z2dRTBCnBupSvML1bBQ3HBUjTwgoDcJMc0K+19hpJ4BXA
	 mg+7rgKnHno8w==
Date: Thu, 8 May 2025 08:12:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] common: generalize _filter_agno
Message-ID: <20250508151223.GP25667@frogsfrogsfrogs>
References: <20250508053454.13687-1-hch@lst.de>
 <20250508053454.13687-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508053454.13687-2-hch@lst.de>

On Thu, May 08, 2025 at 07:34:30AM +0200, Christoph Hellwig wrote:
> Rename and move to common/xfs so that it can be reused for rgnos in new
> zoned tests.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/filestreams | 11 +----------
>  common/xfs         | 10 ++++++++++
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/common/filestreams b/common/filestreams
> index bb8459405b3e..ace8f3b74de6 100644
> --- a/common/filestreams
> +++ b/common/filestreams
> @@ -42,19 +42,10 @@ _do_stream()
>  	done
>  }
>  
> -_filter_agno()
> -{
> -        # the ag number is in column 4 of xfs_bmap output
> -        perl -ne '
> -                $ag = (split /\s+/)[4] ;
> -		if ($ag =~ /\d+/) {print "$ag "} ;
> -        '
> -}
> -
>  _get_stream_ags()
>  {
>          local directory_name=$1
> -        local stream_ags=`xfs_bmap -vp ${directory_name}/* | _filter_agno`
> +        local stream_ags=`xfs_bmap -vp ${directory_name}/* | _filter_bmap_gno`
>          echo $stream_ags
>  }
>  
> diff --git a/common/xfs b/common/xfs
> index 39650bac6c23..061ca586c84f 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2274,3 +2274,13 @@ _scratch_find_rt_metadir_entry() {
>  
>  	return 1
>  }
> +
> +# extract the AG/RTG number from xfs_bmap output
> +_filter_bmap_gno()
> +{
> +	# The AG/RG number is in column 4 of xfs_bmap output
> +        perl -ne '
> +                $ag = (split /\s+/)[4] ;
> +		if ($ag =~ /\d+/) {print "$ag "} ;
> +        '
> +}
> -- 
> 2.47.2
> 
> 
