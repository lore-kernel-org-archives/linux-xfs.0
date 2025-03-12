Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B73F1ADC6C;
	Wed, 12 Mar 2025 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810238; cv=none; b=NRb8d6nSfQ3uHlDyqdDIS50CMq/qHY3i3gCU+fTQ3s7oVzLvhFFsH1gY7f3n3o5p9bfJxO1t66fzXF427piTALTEddclV5X+370rfSFx9/4zfQ7O13Ce8PvkHhC4jLFhADM6i6ZY2UZrW7K2duwNp2UmwIiTfB8eZuZ04+VBnBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810238; c=relaxed/simple;
	bh=Gh55bBymZroP0geT3Tp4ktvhLHFgQuOtUxTxIG15Brc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMaIakKDrVJHmNwaKuYC4Vhuq9kB5mCrd2qzopkXAd8pnLsELSactWpIzPh3wsxsoHAntsMGrow0MlBiMdDXeKzkm7NGbjpSUBZrT0KLdK6e/dbbMpr2wqSi5AiChdU8VlDljztpaSCMvyiQiJlzYnCfLejmknkgWoxVy67Dsp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3tsLB+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3tsLB+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87222C4CEDD;
	Wed, 12 Mar 2025 20:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810237;
	bh=Gh55bBymZroP0geT3Tp4ktvhLHFgQuOtUxTxIG15Brc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m3tsLB+nxf7yEGmuNGrRGfZnJFtEHzquiB46+7ySCJ79aD72Du6BHjJYGhDkJAtEt
	 yqjLD6mvt4K7mimg5myPTjljHeSATWC1O73tzF4HA8tvbqI9EyywmhW3aBE8NChHAN
	 4Y495gLTXVy/CRsUwJEJEjOtKW8IHqDnL5DL40HTpoDSjOdSUo0koxslGYFm/L5Rvu
	 j2D38glC9kMfvFSIpHKlbZmS2uXRfAj7EvVFik2J5GadE5PuaQLi+H+V2biKVgpD+h
	 3G+RJen14/3dq8Qsa6PRO8uA/94tJCvfRigZwnCj+pnY5lJexLisG8Za7juLsf+WRc
	 BQtM2VwRB8sgQ==
Date: Wed, 12 Mar 2025 13:10:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] common: allow _require_non_zoned_device without an
 argument
Message-ID: <20250312201036.GE2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-6-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:57AM +0100, Christoph Hellwig wrote:
> That way it can also be used for RT and log devices.

Do you mean "That way callers can pass SCRATCH_RTDEV directly without
needing to check for zero-length themselves"?

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/rc | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 753e86f91a04..b0131526380a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2545,8 +2545,7 @@ _require_non_zoned_device()
>  {
>  	local target=$1
>  	if [ -z $target ]; then
> -		echo "Usage: _require_non_zoned_device <device>"
> -		exit 1
> +		return
>  	fi
>  
>  	local type=`_zone_type ${target}`
> -- 
> 2.45.2
> 
> 
