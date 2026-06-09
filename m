Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D689732E126;
	Tue,  9 Jun 2026 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781015955; cv=none; b=oh03vrtNJkorv0Uwly7G8raHnn7Wa7BTmup1RI7CpCcb4CRAGi+xfYapSPCCfndycue6j0Wyvr+6Mc0cUn++ZFKax2DSB8eDgRHptYuIyuI1P/Ec+OR52GoPTzhbLFfoBXxmIQb5HQvsCn/vR0FRo3URzKTDXT7O/0QPBqEE6ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781015955; c=relaxed/simple;
	bh=wjbn/q+w8dBEo97ovFYWRuxBXs5HrV80/bRBhGNL0FY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvqQjvJzUFaWDnfkK7tjHnogBp4J8vMXgBKJelE2VPrDdMIkVL1jqkFNhezhEbqEZ6LZm9o8Tt3nFs6nPmthJnhNINLqdpuc4GY/yGWXEm3IZQ8HVCWj3mp+LzEqiSfHLQa5Ie2cyH7S6jVANtKYbQVkkDIStxcAArgTiq1riBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIKbgctO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIKbgctO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 73F851F00893;
	Tue,  9 Jun 2026 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015954;
	bh=wHELhKC4yoZS8U2qcS/BtFTHi8gefYRToMeR0pd2Sdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iIKbgctOHAOlnbj9wv2STIp4rEJfaONR8hJogwXbZNa5a+nnEXh2caFhYo1y8nzl8
	 penyf8deVuz1zvyFenVkPNzaFzX3+psBO70c+lCkU1dVw1OP0ErzT9oj0qrp1tgLwL
	 T0l32LD91cY9Mktmv0T+r3tX31mVsosp9yWRknDm03x1oH6Qg9fLkO24/96ePzmyOa
	 1v6ZAEOG3/uNltfNZtlVf/ALEy6fjfdY5oZekjbBC/Ch1lcG+hTvTWcQWkqPdw96mw
	 V6UW1G7xU17pFy7boiZyL60yXPkl6zjg79FbzwQVgKTR9R+z0/mcLwSlLTEsMFGVIV
	 goagxq8g25lvw==
Date: Tue, 9 Jun 2026 07:39:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common: add a _require_external_realtime_device
 helper
Message-ID: <20260609143914.GM6070@frogsfrogsfrogs>
References: <20260609080051.1712103-1-hch@lst.de>
 <20260609080051.1712103-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609080051.1712103-2-hch@lst.de>

On Tue, Jun 09, 2026 at 10:00:43AM +0200, Christoph Hellwig wrote:
> Factor out the check for an RT device on an external section.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/rc | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 71d872881610..336441c7a522 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2405,6 +2405,17 @@ _require_no_large_scratch_dev()
>  	_notrun "Large filesystem testing in progress, skipped this test"
>  }
>  
> +# require an external realtime device (excludes the internal RT device)
> +_require_external_realtime_device()
> +{
> +	if [ "$USE_EXTERNAL" != "yes" ]; then
> +		_notrun "External volumes not in use, skipped this test"
> +	fi
> +	if [ "$SCRATCH_RTDEV" = "" ]; then
> +		_notrun "Realtime device required, skipped this test"
> +	fi
> +}
> +
>  # this test requires that a realtime subvolume is in use, and
>  # that the kernel supports realtime as well.
>  #
> @@ -2412,12 +2423,7 @@ _require_realtime()
>  {
>  	local zone_type=`_zone_type $SCRATCH_DEV`
>  	if [ "${zone_type}" = "none" ]; then
> -		if [ "$USE_EXTERNAL" != "yes" ]; then
> -			_notrun "External volumes not in use, skipped this test"
> -		fi
> -		if [ "$SCRATCH_RTDEV" = "" ]; then
> -			_notrun "Realtime device required, skipped this test"
> -		fi
> +		_require_external_realtime_device
>  	fi
>  }
>  
> -- 
> 2.53.0
> 
> 
