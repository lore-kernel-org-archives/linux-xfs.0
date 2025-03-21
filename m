Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096481993B9;
	Fri, 21 Mar 2025 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570230; cv=none; b=KjSu3Jl9OyNeZDa/Wx99wyuY8oVwB75AFvlM6BGH6hFDAibi8j5UjZrRAcjouXKa5HmVaAvyXKEU69RSKqGGcYKxu4xPTz28o/Ndre1r2WxQCoLtu/LrljomoeaKarL0BLtLS17SySzv7sB+xo6t+1sK4SxlEGnovjmLNaNvz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570230; c=relaxed/simple;
	bh=yOIe6GmSPOUxn9v+yNLE97KxRKMENEfP01ZH5QYTa3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bY6qy7N+ahn9U9YieBOobfWpXtGnnKZsLoi7NcWV7thzSP/fcx3jJVoKu4DkxexzGhpITT08kyZMKcENyV34N2XzP/meM1Qzp4Bu1338TkbS/B/8+sqkNkB0YItbk0OKkLpc0oFZOVyE+NJI7l4KrAeZW0e9goQTmTuo2GjZ/Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkfWYNGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkfWYNGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65665C4CEE3;
	Fri, 21 Mar 2025 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742570229;
	bh=yOIe6GmSPOUxn9v+yNLE97KxRKMENEfP01ZH5QYTa3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkfWYNGBZ7b8XyZo2TiQEtoVB+csuTMyWxOucukXMSwK6RkWN+RVLsT7rz1Bp6CJ1
	 3jN0xBvvTB5FxudJUSvAcQCJZjtw37myuCtYca2LjKSmABrCup0Qg6URNUtMPw5sXx
	 pkf5aO+c2TX3OpdiCrzdM3yhj5rZL30+FjWSPwgbuv3WES0pyTzLClPkHvWPXWHLbO
	 NP391jGjI1jAzajv/9jOLnt2EoinmIUYy0s8ja4rN9x8xU2s4YgX8qwatdcM6oZNfP
	 /76ZnupHwMhW8FSJtWruUOJtxEcIgGbkB5vHwSqCp26DEqqTrUQyTy3Ubj5EK1lxPN
	 QZPgQuNlqcbcA==
Date: Fri, 21 Mar 2025 08:17:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] common: allow _require_non_zoned_device without an
 argument
Message-ID: <20250321151708.GF2803749@frogsfrogsfrogs>
References: <20250321072145.1675257-1-hch@lst.de>
 <20250321072145.1675257-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321072145.1675257-6-hch@lst.de>

On Fri, Mar 21, 2025 at 08:21:34AM +0100, Christoph Hellwig wrote:
> So that callers can pass $SCRATCH_RTDEV directly without needing to check
> that it actually is set.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/rc | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 7cd8d5ffd2e8..dc6d4ce01e05 100644
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
