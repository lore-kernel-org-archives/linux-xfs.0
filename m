Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B5B30EF9F
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 19:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826107; cv=none; b=ES23NAG3fVN6qgNhLx9RdPhPT6FjHYKNjCSGHtz4XK9jcAH6MJ75d0C2pAv53ZZWOAQZEHjB1S4MoGYHIpCsxdnI4WtU1uyqW/gd/wP95Bbt8WS8wnzYgKzN9ak3mhJm1Jmg5pSVdFyxjbg7fDyszB4O438eHDOIVtARMktsr7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826107; c=relaxed/simple;
	bh=a+MjSgL1rAG12cW7XJLJVk6YDGPrxPudSLXFn8s48Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXeyPll8VK1mNTYValX/T5K/pavT4iueivi2Sewu9BnxbpBatQTm2C5GzC+wUdXuHtuAxdYiH+FUsWw1o/23Q5Oe32BlEHrlQPkeaq85ixCCV1eLZ39FH0Z0bbg2PuKnz7vy3ZYb4PomD2p5DSUcoH4G4A91qxXHCAbU7Ocy/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWQVu/zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWQVu/zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3A6C4CEF5;
	Mon, 15 Dec 2025 19:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765826106;
	bh=a+MjSgL1rAG12cW7XJLJVk6YDGPrxPudSLXFn8s48Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TWQVu/zJ10R+gyw9jhARh3Y+oHIboQ7VfgOStVamaeZYtt8hdd4cHxyY3/5Vlj7xB
	 ok3lkgABoCKPqSRE1n82gblCFttM4urlA+c2mJv7FxZE2ONFZEX1zF99bxJuhQKupP
	 YOVybRyKC6AUfAs1bffVdnrGwAAqFhcESNNWyMn60bysbC3TU6Sc7H0GZKOUh9xj7I
	 ejYr1NHxiiRCrHdHf/MVLcuBL1L/QllgUid4RXudzOvvqvr/cTRidtxOHTAkcJnL0N
	 AGBTJJtKut34kPa2v97Wd7Mehzu5bQPK5VyOqhvsPIVNkNPG7QjuyQi+SHR7z2Zb5g
	 uScAvW1OkmpyQ==
Date: Mon, 15 Dec 2025 11:15:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: validate that zoned RT devices are zone aligned
Message-ID: <20251215191506.GI7725@frogsfrogsfrogs>
References: <20251215094843.537721-1-hch@lst.de>
 <20251215094843.537721-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215094843.537721-2-hch@lst.de>

On Mon, Dec 15, 2025 at 10:48:36AM +0100, Christoph Hellwig wrote:
> Garbage collection assumes all zones contain the full amount of blocks.
> Mkfs already ensures this happens, but make the kernel check it as well
> to avoid getting into trouble due to fuzzers or mkfs bugs.
> 

If this gets merged, please add this so the new requirements are
autobackported to stable:
Cc: <stable@vger.kernel.org> # v6.15

> Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index cdd16dd805d7..db5231f846ea 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -301,6 +301,19 @@ xfs_validate_rt_geometry(
>  	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
>  		return false;
>  
> +	if (xfs_sb_is_v5(sbp) &&
> +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> +		uint32_t		mod;
> +
> +		/*
> +		 * Zoned RT devices must be aligned to the rtgroup size, because
> +		 * garbage collection can't deal with rump RT groups.

I've decided that I'm ok with imposing this new restriction after the
fact, but only because actual zoned hardware will never expose a runt
group, so the only way you could end up with one now is if you formatted
with zoned=1 without a hardware-zoned storage device.

Could this comment be expanded to say that explicitly?

		/*
		 * Zoned RT devices must be aligned to the rtgroup size,
		 * because garbage collection can't deal with rump RT
		 * groups.  Hardware-zoned storage will never expose a
		 * runt group, so this is only possible with soft-zoned
		 * filesystems, which are not created by default.
		 */

With that change (and a corresponding mkfs enforcement patch),
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> +		 */
> +		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
> +		if (mod)
> +			return false;
> +	}
> +
>  	return true;
>  }
>  
> -- 
> 2.47.3
> 
> 
