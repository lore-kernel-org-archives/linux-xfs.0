Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A4A253B46
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225575; cv=none; b=cfa1tn/e/sLD53mO9Z7jhiIhE8DTW27JuWReHwUYaBlH9pUExF2/b8Cy9qSvLfzqOO14x0z6XEX1zDJKjwetUS9NGmZwsbMeAIz5JBvqM3ZxzHBQrvZYG8jwE5N81ywFMjFkN9jJ1nubgZK+YeKs3lmBB2rVGZgKH2DKQE9JZIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225575; c=relaxed/simple;
	bh=YsILtTW80u/MhWFXa8MZVxR5OmRe9gDmXPeU7jmL0ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofGenTcc/Lom5AToDtuI1H21UAWba53zKHAoXJAuy2cbrLdSsd+zPLalP8kYFaxZA3/XiH7NO9gMQGwty+gadKwr7dNdShSaYmicMaGi0vrAStbjyXBWOMfqS6F4n8OQ0+lKylTgAiCg/9vK4M3fbraWOWrMzgttOIlTMtTtQlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/o6SVyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/o6SVyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E7FC4CEE8;
	Wed,  9 Apr 2025 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744225574;
	bh=YsILtTW80u/MhWFXa8MZVxR5OmRe9gDmXPeU7jmL0ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h/o6SVyTKkF40GYzxRmAe65EbixD1OccNzTM42r8pn9TRrFyMxws7GubiueJZ97WB
	 ek8XXlhoEQyKM4tn0luPWAbfp6JoAA2aPx476YArkIDSIyIyactyolVHbnmcdZUfmb
	 jvxl9BxkMT1g1SD23X4WRkMdBkua2HPY7OXoNpL3GZW4rbIQaQWANUFoAfMcU1TiE6
	 cnbmst5wp7gU7EX4j065/HpJyR7RQ32MllqZ7bCQoTCdbxXai64fsnb+H2fvikk2Kd
	 3Zz6dk3LpqfgLLORg5AtgINl234w9zze/+z5/Khh6lSKQ1PVrTwDMupdLJQI3ofLeC
	 8H6+CJ1Gmlhmw==
Date: Wed, 9 Apr 2025 12:06:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/45] xfs_mkfs: calculate zone overprovisioning when
 specifying size
Message-ID: <20250409190614.GK6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-32-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-32-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:34AM +0200, Christoph Hellwig wrote:
> When size is specified for zoned file systems, calculate the required
> over provisioning to back the requested capacity.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mkfs/xfs_mkfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 133ede8d8483..6b5eb9eb140a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4413,6 +4413,49 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
>  			NBBY * (cfg->blocksize - sizeof(struct xfs_rtbuf_blkinfo)));
>  }
>  
> +/*
> + * If we're creating a zoned filesystem and the user specified a size, add
> + * enough over-provisioning to be able to back the requested amount of
> + * writable space.
> + */
> +static void
> +adjust_nr_zones(
> +	struct mkfs_params	*cfg,
> +	struct cli_params	*cli,
> +	struct libxfs_init	*xi,
> +	struct zone_topology	*zt)
> +{
> +	uint64_t		new_rtblocks, slack;
> +	unsigned int		max_zones;
> +
> +	if (zt->rt.nr_zones)
> +		max_zones = zt->rt.nr_zones;
> +	else
> +		max_zones = DTOBT(xi->rt.size, cfg->blocklog) / cfg->rgsize;
> +
> +	if (!cli->rgcount)
> +		cfg->rgcount += XFS_RESERVED_ZONES;
> +	if (cfg->rgcount > max_zones) {
> +		cfg->rgcount = max_zones;
> +		fprintf(stderr,
> +_("Warning: not enough zones for backing requested rt size due to\n"
> +  "over-provisioning needs, writeable size will be less than %s\n"),

Nit: "writable", not "writeable"

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +			cli->rtsize);
> +	}
> +	new_rtblocks = (cfg->rgcount * cfg->rgsize);
> +	slack = (new_rtblocks - cfg->rtblocks) % cfg->rgsize;
> +
> +	cfg->rtblocks = new_rtblocks;
> +	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
> +
> +	/*
> +	 * Add the slack to the end of the last zone to the reserved blocks.
> +	 * This ensures the visible user capacity is exactly the one that the
> +	 * user asked for.
> +	 */
> +	cfg->rtreserved += (slack * cfg->blocksize);
> +}
> +
>  static void
>  calculate_zone_geometry(
>  	struct mkfs_params	*cfg,
> @@ -4485,6 +4528,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
>  		}
>  	}
>  
> +	if (cli->rtsize || cli->rgcount)
> +		adjust_nr_zones(cfg, cli, xi, zt);
> +
>  	if (cfg->rgcount < XFS_MIN_ZONES)  {
>  		fprintf(stderr,
>  _("realtime group count (%llu) must be greater than the minimum zone count (%u)\n"),
> -- 
> 2.47.2
> 
> 
