Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696A11E9B36;
	Wed, 12 Mar 2025 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810365; cv=none; b=W2ii5llTDPKSVHBeb/KhmJMNo1s56B0pSWnxOceawFnGrOvMKJHcOIEXMnq2Bjq+LH2VeHRk0/VUSN+7XmQzCKW7kRwceB4lSc5phJ7cmsGY7TxXpmmW9dzLxEDLgUe/U7jXWHWJ6DBS/s9BmoP/3PCUZlnCsDZCCz4yvTTij0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810365; c=relaxed/simple;
	bh=8IFZCihqM/fLQU8qlLF0fmYL4YT+rEiO9fcitnAjJlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjjYgYiKkYBGKXzmcjS82+jZEZKvk6Ssrlu4FAoDfzysxljpV5uD9ri/sGffOaJQtxj/YnD4KzPZDCKSdkZPoN9KKz1Rsx89wUAxFCr+PWttQFn1kpnvOIT+3tT5lD6Nm3HpbGVvKyV8CF1qK6mqVeSjioPqZL/7hiZoizMgbNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPhgCosz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPhgCosz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D953BC4CEDD;
	Wed, 12 Mar 2025 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810362;
	bh=8IFZCihqM/fLQU8qlLF0fmYL4YT+rEiO9fcitnAjJlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MPhgCoszwkP/qpuXCcq04Rb0sPR+GptPjvjcMiR2s3gUNc/hoPmoaJfkqQulNTEcV
	 I2LWKljBMCRhWgjsKnhWEjw/lv1R04GZZpb2CsmJDjzaXJ6sY8ScL693c9/JY8mjzf
	 sKkCPAcvAWmg46mPKf3FqRAN2bEwTaZ+UYYrvDRb85U7MhU1fd6zZ7JHpKE2NjrFAz
	 11Yp1faIY9UQK9ncgRj7M4BssSdPRvMGKoPTcS+7D+wo6qHx5KO9MKu+PEk8VBvmyq
	 YvS08WjWT115p4KHr5yrQViVS7j5EfID2Pol5R3z6HqI8+OBpSbhF0GhqofLIkiJTn
	 YdsVk1n5knSGw==
Date: Wed, 12 Mar 2025 13:12:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/17] common: support internal RT device in
 _require_realtime
Message-ID: <20250312201242.GF2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-7-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:58AM +0100, Christoph Hellwig wrote:
> If SCRATCH_DEV is a zoned device it implies an internal zoned RT device
> and should not be skipped in _require_realtime.

/methinks that should be a comment in the code itself.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that changed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/rc | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index b0131526380a..00a315db0fe7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2354,10 +2354,15 @@ _require_no_large_scratch_dev()
>  #
>  _require_realtime()
>  {
> -    [ "$USE_EXTERNAL" = yes ] || \
> -	_notrun "External volumes not in use, skipped this test"
> -    [ "$SCRATCH_RTDEV" = "" ] && \
> -	_notrun "Realtime device required, skipped this test"
> +	local zone_type=`_zone_type $SCRATCH_DEV`
> +	if [ "${zone_type}" = "none" ]; then
> +		if [ "$USE_EXTERNAL" != "yes" ]; then
> +			_notrun "External volumes not in use, skipped this test"
> +		fi
> +		if [ "$SCRATCH_RTDEV" = "" ]; then
> +			_notrun "Realtime device required, skipped this test"
> +		fi
> +	fi
>  }
>  
>  # This test requires that a realtime subvolume is not in use
> -- 
> 2.45.2
> 
> 
