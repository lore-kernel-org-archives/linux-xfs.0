Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E6C363C46
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 12:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778155422; cv=none; b=qbhhhpgreVsmATV8tWh6TSE2L386EUX9kW316gZvVYK26Ny6nd2XtRI0Aeox2cbN3tkdnXZvqYuy4FjOMZvoW7xVtatdBcYT/h8nt4QHyz6vfAVqZ/pDGrZcivxSnGL5c2iofp4NiGCzLHnj4O1GrwaL9rTCH7nkdQLdB+ZV4OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778155422; c=relaxed/simple;
	bh=wfqPW2LGbLENEXpy8LuNb+M/QLyhLRXPCpzLkVHqOgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VH1lnv9KEaBzpcq+L/bsuYEw6fRR8299slkv/7926r/xKFNIcankLoMfjbUG3d5bc9mMYH4lO3WvcOiQpIy8ODJCJQIpYDjXeUAITbHKx0Or0F19YtHnTabo7FkV2AsOqa7zgER4ISPLSMG6E2rL1MeFmaiAXEY/436M8s0MxD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cu7uoz/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cu7uoz/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEEFC2BCB2;
	Thu,  7 May 2026 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778155422;
	bh=wfqPW2LGbLENEXpy8LuNb+M/QLyhLRXPCpzLkVHqOgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cu7uoz/Gs015aasusO1spkSGtK/jAj06n3UVxypLYy1BFk0yJ9fvI6r7MuYdHfTFD
	 2vbZJpRozsQNB+E7uDKXdEkaGm4YTqTxwVZ1JjmvULGqSJImq5OIxo4I/XqGArf9tu
	 wUhgTec6+SHjkr3BwAWh3RnnerOADBSh2N7iBVaA5mlnPD9SCNFbSexsUhv7dkcolX
	 wIpUqT7+IWsU5Ud5e0RyyLCB7fUx+wwpucfkK2Gl5WATQ9wLG8BU5g8w9eN8xlptw9
	 lKA8J6Ha8276X1IU0qy8qw6PXgqEvIv7yX9gGk99EDBbZEIoZnOr8NPLs/Ka77dlxO
	 qCh2Txhpv4cCg==
Date: Thu, 7 May 2026 14:03:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix the "limiting open zones" message
Message-ID: <afx_kMVF9ceuLSpO@andromeda.toxiclabs.cc>
References: <HYHgM8Lvj3Ce71h7t3w8IoIbd82x5Hgpe8yCYLOtiTr3DyHzlP6eD94oePbrGzgBwSdU-nw8XgrQ5ZATUn3WVg==@protonmail.internalid>
 <20260507052457.1305016-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507052457.1305016-1-hch@lst.de>

On Thu, May 07, 2026 at 07:24:57AM +0200, Christoph Hellwig wrote:
> The xfs logging macros include a newline, remove the \n, which adds an
> extra one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index a851b98143c0..e79f9e652dbb 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1170,7 +1170,7 @@ xfs_calc_open_zones(
> 
>  	if (bdev_open_zones && bdev_open_zones < mp->m_max_open_zones) {
>  		mp->m_max_open_zones = bdev_open_zones;
> -		xfs_info(mp, "limiting open zones to %u due to hardware limit.\n",
> +		xfs_info(mp, "limiting open zones to %u due to hardware limit.",
>  			bdev_open_zones);
>  	}

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --
> 2.53.0
> 
