Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FB1FBE87
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984542; cv=none; b=BesO/EbwpnFEF7sZDK7EZkPnwtBuLN1M9RCFEvRaDGgeszTQvB3ng43UuVv9loKAHD0I5fzmT5Scj70xACNxP9uvXERKhDIGuE3tOa4XB9qOCM6RgGbNSQpgDezwkZxsnU+C2TdKtPZOUPzJP/OEm1RH/95QZ6xXITyStl+njBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984542; c=relaxed/simple;
	bh=P90TSzcDDpfFc1isNmUxz7VkiiPeJl4SJZNEs0wzNQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUi9/48cwYodPrwpHnWGKhGey7oHy6OEBDcm1ykqGVTamCWnP9PEPNkEYLeFW/KUOck1Ol2kgjg1pCykFnWaDSaVIdEyHjHpgGX/BmGY20s7fhWrqybk4S1v05P0yULbwej68IDBjYR/XOa43in95EeiW/zcUdJUYRMQrqQjaS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zha9+ag5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zha9+ag5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB4EC4CEF0;
	Tue, 12 Aug 2025 07:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754984541;
	bh=P90TSzcDDpfFc1isNmUxz7VkiiPeJl4SJZNEs0wzNQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zha9+ag5LldvsvnXJP1xzf2DE2UHe7CH6BqtxgNvgLd0fTd2YA7a74skOtfpCoStZ
	 mLOxk5cc4MeAfBHh+jWygr2nYiZrLovswvzgNnvwD6KUuVo4onUfNtgzI4cAollmt9
	 oWhvm12JLRBVD0qr7sYBMJKMjKE3HEGe1Ys7jYhQp+OwiOSuQtaf3zXEEKvutzQ6m0
	 HmnrP3/Q/1jpfFs9bj+2VT20twwlQRmev6XwZ/TGC67DwnVh6qpxsBx7uHXApleGWP
	 rDo4QYBddfDF9xRAP5vcNuGxkWk5CDvFozxqPoC7kOMQbyX353rwEjMu82qqvprL6h
	 teXTL0Rqinulg==
Date: Tue, 12 Aug 2025 09:42:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Default XFS_RT to Y if CONFIG_BLK_DEV_ZONED is
 enabled
Message-ID: <onnifc3onccbvgy5ddwvfnf2ddmfgsskiweppafd3nadwzaxta@ka7w7rqzqpm3>
References: <7hiMOJZATLYgHbQYIoT4OdW2dzyJjPDOkOD-RgRwvftGN2A2K30y_c-13YQKqUTXVF0P369P3fzB1jYPMGhIRQ==@protonmail.internalid>
 <20250812025519.141486-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812025519.141486-1-dlemoal@kernel.org>

On Tue, Aug 12, 2025 at 11:55:19AM +0900, Damien Le Moal wrote:
> XFS support for zoned block devices requires the realtime subvolume
> support (XFS_RT) to be enabled. Change the default configuration value
> of XFS_RT from N to CONFIG_BLK_DEV_ZONED to align with this requirement.
> This change still allows the user to disable XFS_RT if this feature is
> not desired for the user use case.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 68724dec3d19..9367f60718dd 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -105,6 +105,7 @@ config XFS_POSIX_ACL
>  config XFS_RT
>  	bool "XFS Realtime subvolume support"
>  	depends on XFS_FS
> +	default BLK_DEV_ZONED
>  	help
>  	  If you say Y here you will be able to mount and use XFS filesystems
>  	  which contain a realtime subvolume.  The realtime subvolume is a

This looks as a good compromise to me as it still allows distributions
to disable it if they don't want to have XFS_RT enabled even if zoned
devices are supported.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> --
> 2.50.1
> 
> 
