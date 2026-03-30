Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0981D3CA4A3
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873741; cv=none; b=MmfE1oEE4Mfuzrv0ykEgPo968xJ5ShlaKOO3fdAc8cm+V+OrwPpVIP9kxjy6RStN4haoqYxNpQmLy9uvS5UzbzplPCmTTOj0vI/j+WvEJqrslfNLxxx2atxgMVQGVzRU8Mx/Kr/zY8ecPsJxt4FjEL28FAz9B50b54Cjsd7qdR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873741; c=relaxed/simple;
	bh=Uv2EbVgXAOc+OzOeZ6HjCT7VuyV1CsmiyF+LEC1aEJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8wbECPi2KR+UiU3khB34ItLkor5vV1U+M6A/oEwAT/W4+gs0bY8wkcNvvjkYbcblMhL8m4xXP/vmsGtPsAHg6EUPryvhLMuBgj7hWWcFqWKXSWyMOLHBqL89IBdHdvq98P8tZkpBkcSZlz1DoS3kWPqg5yLQz9E1teGhmgt5yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1Ao55cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1Ao55cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E408C4CEF7;
	Mon, 30 Mar 2026 12:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774873740;
	bh=Uv2EbVgXAOc+OzOeZ6HjCT7VuyV1CsmiyF+LEC1aEJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J1Ao55crmn1rGhbJrc7DG+wCbIF1zy2KPfY3qS1arSBLWHFqm32ExhUWVYCHyqa12
	 v6vzm3zJm3htDDbCXmX2+sVm11ktsqfbHwv05vpyR0wXTFi1O5ruBlT5N8DgSDJkfi
	 r2uPm17dpBBpQ5g7eI5Iy3S83W4sky5lF1ZZA+dWIBklUsm+GI+amsGEw9gUftYp4X
	 9TI23Ktdes/dDCr2eC2oyU4HAWuvfFTki0x6SYIa08zcCEQAMlMkRXWseTpKMEWJRw
	 DKcUtEHQEtNhiEqYKZc1kSuO3eRyLKrHxwZ5B8hwHN2czvShV7L/VH6gz45j8LcQlY
	 DJOreAVozCPKg==
Date: Mon, 30 Mar 2026 14:28:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: refactor GC zone selection helpers
Message-ID: <acpsgY_0mG8Qs-27@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-6-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:15AM +0200, Christoph Hellwig wrote:
> Merge xfs_zone_gc_ensure_target into xfs_zone_gc_select_target
> to keep all zone selection code together.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 45 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 23 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 3723f5293a64..6ce5a0708a9b 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -552,6 +552,9 @@ xfs_zone_gc_steal_open(
>  	return 0;
>  }
>  
> +/*
> + * Ensure we have a valid open zone to write to.
> + */
>  static struct xfs_open_zone *
>  xfs_zone_gc_select_target(
>  	struct xfs_mount	*mp)
> @@ -559,12 +562,25 @@ xfs_zone_gc_select_target(
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
>  
> +	if (oz) {
> +		/*
> +		 * If we have space available, just keep using the existing
> +		 * zone.
> +		 */
> +		if (oz->oz_allocated < rtg_blocks(oz->oz_rtg))
> +			return oz;
> +
> +		/*
> +		 * Wait for all writes to the current zone to finish before
> +		 * picking a new one.
> +		 */
> +		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
> +			return NULL;
> +	}
> +
>  	/*
> -	 * We need to wait for pending writes to finish.
> +	 * Open a new zone when there is none currently in use.
>  	 */
> -	if (oz && oz->oz_written < rtg_blocks(oz->oz_rtg))
> -		return NULL;
> -
>  	ASSERT(zi->zi_nr_open_zones <=
>  		mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
>  	oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
> @@ -576,23 +592,6 @@ xfs_zone_gc_select_target(
>  	return oz;
>  }
>  
> -/*
> - * Ensure we have a valid open zone to write the GC data to.
> - *
> - * If the current target zone has space keep writing to it, else first wait for
> - * all pending writes and then pick a new one.
> - */
> -static struct xfs_open_zone *
> -xfs_zone_gc_ensure_target(
> -	struct xfs_mount	*mp)
> -{
> -	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
> -
> -	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
> -		return xfs_zone_gc_select_target(mp);
> -	return oz;
> -}
> -
>  static void
>  xfs_zone_gc_end_io(
>  	struct bio		*bio)
> @@ -615,7 +614,7 @@ xfs_zone_gc_alloc_blocks(
>  	struct xfs_mount	*mp = data->mp;
>  	struct xfs_open_zone	*oz;
>  
> -	oz = xfs_zone_gc_ensure_target(mp);
> +	oz = xfs_zone_gc_select_target(mp);
>  	if (!oz)
>  		return NULL;
>  
> @@ -1019,7 +1018,7 @@ xfs_zone_gc_should_start_new_work(
>  	if (!data->scratch_available)
>  		return false;
>  
> -	oz = xfs_zone_gc_ensure_target(data->mp);
> +	oz = xfs_zone_gc_select_target(data->mp);
>  	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
>  		return false;
>  
> -- 
> 2.47.3
> 
> 
