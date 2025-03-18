Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F496207665
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742301836; cv=none; b=mVdjE4kN1b9Q79/rAyrURRXYDqXqKLcbd/TpF3z6pOPG0kxHsJY8DhaM2nFlnzdnBI5SylO3Wf/KV7vDtHVL1Br+440spywROlb9ZGAVJeLTIO1oiRGkbasSY+T+KtzWppUUVWEbhKDQ/m/VTpQT5urb9nmV3vFNfwcxi71GAYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742301836; c=relaxed/simple;
	bh=VZzt/GSY4TIi9Cu66+x4myp5zk54JHpjJEXKLVI01x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zu6PzFXCH7mLBqGjZBS7V3ttcx+9WfSua/FBY/3rlGq6XMpz1EvOO6lYMQ3SjQy9KBb9Xt3zj1ZDwbW1pRdaT1co5GMtNaAEwNzK8FllbKc1fBdJvHJdsFHV7Lc5PM6qAo3gxa0JSsV688xtVDkBDSRFgkcEimCySSaU73wBgBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHHhK1l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHHhK1l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE31C4CEDD;
	Tue, 18 Mar 2025 12:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742301835;
	bh=VZzt/GSY4TIi9Cu66+x4myp5zk54JHpjJEXKLVI01x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MHHhK1l2bwpwWLQMbpSCB063EruyLHcA2pvkAhhDlYGPCzGjH7QoEZZjpqHXr5/vJ
	 yBBKGqaYxKIV0AGb2lMKqgwqcweS5wfF05flICYsBodfYEWRDzEi3KWgfaIJpLrhT/
	 JGelSdMiLrOB7xWqRxuEx7/RvUR4qHpwYCDWF7DJUEbF2JdDPXsYMDVmynsS/3Q1T0
	 sY1h4J2JQfC4Pm8DSxipX/I39W4mZ+OLbEfF7VkbbcoWqYKjHboIvFQDCUyDROsNel
	 Slws2pxatsKDBQHGn3hNc+9yoSga1rur5BPdP6a9DAObnugO5hr5ItnI3mzgqXlFAD
	 Ejjr15EwtYc1Q==
Date: Tue, 18 Mar 2025 13:43:52 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove xfs_buf_free_maps
Message-ID: <2fefbi3a3tppb63xhpuuvk4szgcwgjpyhxpazcmfblvlcvvar6@n5padwe6umtc>
References: <20250317054850.1132557-1-hch@lst.de>
 <m3Yzz_LjeA7tTU1TMqVl2lyQdoHUV4Vq3016hBTArPcZWNzlEtQCwmej4-pkPwdkBnDNRaJfoJ2h9vNxl7hDSg==@protonmail.internalid>
 <20250317054850.1132557-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054850.1132557-4-hch@lst.de>

On Mon, Mar 17, 2025 at 06:48:34AM +0100, Christoph Hellwig wrote:
> xfs_buf_free_maps only has a single caller, so open code it there.  Stop
> zeroing the b_maps pointer as the buffer is freed in the next line.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sounds good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 878dc0f108d1..bf75964bbfe8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -88,23 +88,14 @@ xfs_buf_stale(
>  	spin_unlock(&bp->b_lock);
>  }
> 
> -static void
> -xfs_buf_free_maps(
> -	struct xfs_buf	*bp)
> -{
> -	if (bp->b_maps != &bp->__b_map) {
> -		kfree(bp->b_maps);
> -		bp->b_maps = NULL;
> -	}
> -}
> -
>  static void
>  xfs_buf_free_callback(
>  	struct callback_head	*cb)
>  {
>  	struct xfs_buf		*bp = container_of(cb, struct xfs_buf, b_rcu);
> 
> -	xfs_buf_free_maps(bp);
> +	if (bp->b_maps != &bp->__b_map)
> +		kfree(bp->b_maps);
>  	kmem_cache_free(xfs_buf_cache, bp);
>  }
> 
> --
> 2.45.2
> 
