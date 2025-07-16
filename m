Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCBE2550D0
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681079; cv=none; b=u8R8zrsA5eYuYGKbVAOAoznDg5SXwNiExlZ1/vkt3aoiIrrrU7cZP2/qKi+xqtBJzwZfTk7vfe8klAyK4+8+WW00XTtMpbF+P6z2o8nTXmaSqradIl56E72doyeM8I7UF5BT+Xt8c0n++VWf2kGne0lLRBFm5XdPm8x5LU+OGTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681079; c=relaxed/simple;
	bh=E3GmlJ+8YFEeMeTOcQ0xigjtjG+UDMM48ZyNR8Au77E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrjvfkCizCUpfp3CSNBtX8DKskB/1WJAC6/9z8/Xe2Kjwc4gPdfHc5Qv2r63C97crOuHhCLjiig2G6luViZmNj7EdG0FSsgf9AuqgyX+O2ZeKgHO4tveJbOOm+hCg2ncKkPOAFJ2RFD7Y585at8QjcD1Ie0SBbkZVt/imaB7dT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSC2zNNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSC2zNNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAB1C4CEE7;
	Wed, 16 Jul 2025 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681077;
	bh=E3GmlJ+8YFEeMeTOcQ0xigjtjG+UDMM48ZyNR8Au77E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSC2zNNaq0z4eJlyPorv46Vs9beVISiIYpQ97UuI1YyfudabcodWV6QyEjTYnGIkZ
	 eC0DVCA92taAQSWBsysHClEasb/jbig+Zhvt5Z9AhccnKBzrMpWsGu4VbMIM9tJhqc
	 SP4OcG6I1HxQZed7lxlH2DnCAH1pwU2H07uc5/oLHILw+LpCbFZhhgL7bhTYsr79dw
	 LQ9OlnMGtXU3jIFtxiZd3FE/7hGv2BvIbvIriQ8O8eP5E8pw0bEqcpEHNfCj5+8RW0
	 1xiFzcxvftHyY5hwVxOV1qhndA1xwzYk+zim2Gk/CyhMkBmIJvF9Fq7KltmKv7VqLH
	 iBKX/d1kMFHGA==
Date: Wed, 16 Jul 2025 08:51:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: use a uint32_t to cache i_used_blocks in
 xfs_init_zone
Message-ID: <20250716155117.GI2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-3-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:02PM +0200, Christoph Hellwig wrote:
> i_used_blocks is a uint32_t, so use the same value for the local variable
> caching it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 01315ed75502..867465b5b5fe 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1017,7 +1017,7 @@ xfs_init_zone(
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
> -	uint64_t		used = rtg_rmap(rtg)->i_used_blocks;
> +	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
>  	xfs_rgblock_t		write_pointer, highest_rgbno;
>  	int			error;
>  
> -- 
> 2.47.2
> 
> 
