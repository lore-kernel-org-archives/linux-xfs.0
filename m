Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D136A1D5147;
	Wed, 12 Mar 2025 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810695; cv=none; b=Z8G4GGVOXQUxVGynOHzYzWTz9cqEL9FJxxn5oLvjks3Tm9OjR9SFL8yTwXlHmBqwFNkUbEFuzULcqC8Xd8MDCjegScG1Kqdpr4Kob8LRCk3psDhIAAuwp7/XzNjaHqC3lgp5zXFsa3e2qM81qeapnenqJ4g+RLf2cHS7EwuEDlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810695; c=relaxed/simple;
	bh=SgtQAr8vqYNNlxopH+HlE2TS4NYr+NCsPdW8zavP1Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n51ALFqritslT7E4ne4myctVLoYETN3EYQxNIoe2HXTyM5SachaK59BISLh3BFjtxVsKF12tqMSDXpx/QVugZlZVzz60reaSriaxIQXxcoJU+civJFQr49DoOdmq7A+FSac7W38BqUHaHh6uEWmUOf6WyZGgKQpeV2ATy+4uP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZlicvuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZlicvuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440B6C4CEE3;
	Wed, 12 Mar 2025 20:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810695;
	bh=SgtQAr8vqYNNlxopH+HlE2TS4NYr+NCsPdW8zavP1Uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BZlicvuVvnx9UIFyUkO8WdeoJYKXM6pg4DvJzzuTvQXxMyw94pnbINq7SX3wFEtRD
	 fTGDSOE8x67zy7TpexkPX3vCeRWyQHG7l/KN4G7eD1tb2ScP4H+2NVFRE44nFwV/Ih
	 5TaHPiv4OBY/oLwXHzS0ITOZeOpBnVV8Slfg0T+F/gJoCKw3OD6fZiE7gr7/p+S4St
	 jh226PD+5Z4B83m0bqpl9TVOis/GSVDsliZiI/WtJl4afXLXN0iNdwRJRLILOCJ8UJ
	 ZtC5Rt9Va/OLa77pUCqn8v1YQ8o0Ipp2pojlBwxqqM2COrY1zyXq7krQ+KiIDqnLpg
	 Wp8NYfEXjH80w==
Date: Wed, 12 Mar 2025 13:18:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] common: notrun in mkfs_dev for too small zoned
 file systems
Message-ID: <20250312201814.GI2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-10-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:01AM +0100, Christoph Hellwig wrote:
> Similar to the regular scratch_mkfs, skip the test if the file system
> would be so small that there's not enough zones.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/rc | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5e56d90e5931..e664f3b81a6b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -910,6 +910,10 @@ _mkfs_dev()
>  {
>      local tmp=`mktemp -u`
>      if ! _try_mkfs_dev "$@" 2>$tmp.mkfserr 1>$tmp.mkfsstd; then
> +	grep -q "must be greater than the minimum" $tmp.mkfserr && \

/methinks this also should look for the word "zone" somewhere so that it
doesn't trip on some other validation message for which we might want to
emit a different error.

--D

> +		_notrun "Zone count too small"
> +	grep -q "too small for zoned allocator" $tmp.mkfserr && \
> +		_notrun "Zone count too small"
>  	# output stored mkfs output
>  	cat $tmp.mkfserr >&2
>  	cat $tmp.mkfsstd
> -- 
> 2.45.2
> 
> 
