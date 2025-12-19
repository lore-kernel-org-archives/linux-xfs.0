Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C660224677B
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 02:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766110205; cv=none; b=aG5OCV+TjkXE7gE1OfrbP3cs5c7rZ0xBRX4tsyy/SJu6krEWE/Bo2ahw7u4S6hEnNWgbvda2UsCnJ5W5AMeiYnX9l4VbebCQwSbNCKHps36g8AAvDzcmIrZJvL9melAFV01BElAyln0OCyn82bkogN3IKxv0tURZXqxZJctudkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766110205; c=relaxed/simple;
	bh=CTjJ0mtQuUn8WafNeDRT9gdB6AlgdfYaiYO7ewItQQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHv0wshJ1ZqkxdLuuP4Qb6qFk/h0QKqOJoJSLeXzHjI5SGG2HBbQPB2LHLmZNv1AToRiqdN+nXQwDfmnzZp8kKaFeh/Rz+jE7Qe8WmW0QTo76oio9URjHjbUOANWqsF+7uvdQz1fywy4sTKFo/TSALDaj2d2hZ28vd418PNdnzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlIqAIVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlIqAIVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA2EC4CEFB;
	Fri, 19 Dec 2025 02:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766110202;
	bh=CTjJ0mtQuUn8WafNeDRT9gdB6AlgdfYaiYO7ewItQQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SlIqAIVCgBI/lyRjbzCj2TvgjJIzsn58PXssqnhyx7DQK8qAHBawYy3n+TUzvHFvJ
	 SVIwJLc8h39yNCGu2r1MAajli6PKrjB4sj5rwzEjOKjPHEcz4EP1gR2gzEGpj5bqZF
	 pBWPp6QK7DGdYVvAVT/FUCSGjgBe7f7Q8/OPc0F9+qf/R5BWq6vVX2MD4L3h3WwymL
	 gU/RJ0hwakf8O6pewPQAQUF2/0Xhl14n2/cr1/p/G0GaSnKhdRfBcPSL8rasFr6HjB
	 gKA2mn1gT9vhtYIxv/FUpA54wFd5+LqTT0vM6MlfgaasLppWEkEygl3HUccnza46Zo
	 p6dvP3+oLFktg==
Date: Thu, 18 Dec 2025 18:10:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: adjust_nr_zones for zoned file system on
 conventional devices
Message-ID: <20251219021001.GA7725@frogsfrogsfrogs>
References: <20251218160932.1652588-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218160932.1652588-1-hch@lst.de>

On Thu, Dec 18, 2025 at 05:09:32PM +0100, Christoph Hellwig wrote:
> When creating zoned file systems on conventional devices, mkfs doesn't
> currently align the RT device size to the zone size, which can create
> unmountable file systems.  Fix this by moving the rgcount modification
> to account for reserved zoned and then calling adjust_nr_zones
> unconditionally, and thus ensuring that the rtblocks and rtextents values
> are guaranteed to always be a multiple of the zone size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mkfs/xfs_mkfs.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8db51217016e..b34407725f76 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4558,8 +4558,6 @@ adjust_nr_zones(
>  		max_zones = DTOBT(cli->xi->rt.size, cfg->blocklog) /
>  				cfg->rgsize;
>  
> -	if (!cli->rgcount)
> -		cfg->rgcount += XFS_RESERVED_ZONES;
>  	if (cfg->rgcount > max_zones) {
>  		fprintf(stderr,
>  _("Warning: not enough zones (%lu/%u) for backing requested rt size due to\n"
> @@ -4652,9 +4650,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
>  		}
>  	}
>  
> -	if (cli->rtsize || cli->rgcount)
> -		adjust_nr_zones(cfg, cli, zt);
> -
> +	if (cli->rtsize)
> +		cfg->rgcount += XFS_RESERVED_ZONES;

Hrm.  So we're moving the XFS_RESERVED_ZONES addition code out of
adjust_nr_zones to here.  The conditional changes to rtsize because
previously the only way we'd do the addition is if !rgcount, which means
we were really only doing it if rtsize != 0.

And now that we always call adjust_nr_zones that part needed to be moved
up.

I think I understand what's going on here, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> +	adjust_nr_zones(cfg, cli, zt);
>  	if (cfg->rgcount < XFS_MIN_ZONES)  {
>  		fprintf(stderr,
>  _("realtime group count (%llu) must be greater than the minimum zone count (%u)\n"),
> -- 
> 2.47.3
> 
> 
