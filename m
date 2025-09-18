Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAF927B328
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 11:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758194989; cv=none; b=AUILDNJQ7t0F5f8v+8COUg/KdmpE2vmEpRNKXUIeS0bxjOkdpwitx3K9IeVF+exoT+NqlddYjU5ricdGCncUwTcquY6cgfHtInUhXTraD2X3aQgEAODihOzYtcsnlwFtR0nfgLZFwjaHIN0AI3eY7Hp3nepLWtN+nhtdMa5VBJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758194989; c=relaxed/simple;
	bh=HU4xlMwYvql9qjxkr4IeIqfYmtTBeAe2aB+0t8bdgdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuUAucDeZJU8cQDlkvXxxRP8nhvCJaLhIZ/W+uFXbSqNq1RCxLJ4C8BPEnxIsWlvFCN3/8YNe7iCHj1NnOjCTWXYGuyqp85OSGtEEtZUckNSBD8ErRX5oQKB2mNDaFhHob6+C9pM3A5rxqX/PSpwqW5b6pIwbY2O5+3SPqUbBBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8bcQKGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8bcQKGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5687C4CEE7;
	Thu, 18 Sep 2025 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758194988;
	bh=HU4xlMwYvql9qjxkr4IeIqfYmtTBeAe2aB+0t8bdgdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E8bcQKGyB36jX2DZvSZkY3zmFwq6kvflNrrpJCYxS/FdUxb0DTBDoJDUllq596+d/
	 CMYgm+Gsi7KOsAd0JWEinVz7npA7iI82mnhqRD2bus4GMfXvYGtvfcddBhMHOee/uF
	 Aus3o1XqT/R5mlWdBFEngDq8IIX3BHADBAZBc/jH8d0jXc2gLLzY8qHn6olHyxs6ch
	 nGv0s4gTWZ/CW4MzcBna26ywH6PMZD+xhSR6EJs/HClzGbRzsmt74qBsmlWdcq/dhH
	 Ys7pEcQ2FRERI0KBxmahIk2gTXdawqKXsR35y05vOgYSeir1hCUhG/egpmiZhC/i+q
	 ueON7ueYsKgmg==
Date: Thu, 18 Sep 2025 13:29:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: Improve zone statistics message
Message-ID: <3fkjo7uvrqceppgwhqpr3uupjcts4gl6ofgf5e2jlqkzqbsncl@x3pjlfd76tai>
References: <20250917124802.281686-1-dlemoal@kernel.org>
 <WES6aKbrxt_XF4K2kEvvAM_duCnIp7NL80XLpkI95kiuGuyCxuD1LAhYawZ57_bjh0PEqKn_vVy4stCwLWYNrw==@protonmail.internalid>
 <20250917124802.281686-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917124802.281686-2-dlemoal@kernel.org>

On Wed, Sep 17, 2025 at 09:48:01PM +0900, Damien Le Moal wrote:
> Reword the information message displayed in xfs_mount_zones()
> indicating the total zone count and maximum number of open zones.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 23a027387933..f152b2182004 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1244,7 +1244,7 @@ xfs_mount_zones(
>  	if (!mp->m_zone_info)
>  		return -ENOMEM;
> 
> -	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
> +	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
>  		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
>  		 mp->m_max_open_zones);
>  	trace_xfs_zones_mount(mp);

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> --
> 2.51.0
> 
