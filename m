Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671F720B81D
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 12:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754914068; cv=none; b=IOrC75dsNj/KyfeJjOsDJafLYY3dJJozrxBNKqd2zeZcw3uGJspJTSuQm366ISUTDU08b0QMGgQkGCAX7goFmmSeSfrEO9dANo3dv/RBpleVIFdZTsFmb2IMpdqZvP143owR9ET3rc87pUW0mXoUdINUqb8juIzX5Pl9fJgPbuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754914068; c=relaxed/simple;
	bh=LyCvZyUCcIUf8f01o3EQhOnrVwbaZj6Gey4w4TEKO50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sr+CR4WQzAdmmAJkK9P645hA0WOUYxoJznbww2WCbwbvFYBvwhAPpud7bDSnqefQ47j3t6Zb4VtM12tKC/esfB78b+iAbKKeeuCPLMGJJjiH+Om+tE6CICy2iURp9uWCGuRdI201rRF/u1JXWwvsTnQKcpc5AuBv92bCr0U17Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSZM8S8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSZM8S8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F3FC4CEED;
	Mon, 11 Aug 2025 12:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754914067;
	bh=LyCvZyUCcIUf8f01o3EQhOnrVwbaZj6Gey4w4TEKO50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSZM8S8XucKdAM+p0vWv1S88YH9BD0yAyQc9Bj8O0QhIYeksT+CUYS1ASI6Col5gT
	 QpiT/pMMLaTQrbPZDgImcn+U5wb2GDnZPx6QK2sqUOIAg7pJFyypKBXZ/WHOOC/Cci
	 HLQxyf4ll7csIWW2ZUp+3POqHV9tecQnkz03cSd5h6PkMYO2FAaa5mnMUq0TB5zT/I
	 zqf2y1d3eN1vFPo4w9hvg3HBI2RBWD2chb7vC3oxAIT1ToPRTfDywQzho0++jQ/iez
	 ixVkXPZeG+1/baTLcGIrDaGV6AX6y/qMvwnQyYWpFf7SbAgcmPX7V+MeF6LgOmolTY
	 nY5zfJ7OU+71w==
Date: Mon, 11 Aug 2025 14:07:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Improve CONFIG_XFS_RT Kconfig help
Message-ID: <qvvtpcj2lnvblecqfcstxbm4hsrgu6jrqyzqrlporriek5nwa4@7rs5hn523eku>
References: <kKXUIiXOoMsPMpRsmYCR1_l18oSyQGIV5yApvbbZS23U9u_Tz1D3npu22B_aOWZplsFFJ_Bl_UmoTmTLGm90Fg==@protonmail.internalid>
 <20250807055630.841381-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807055630.841381-1-dlemoal@kernel.org>

On Thu, Aug 07, 2025 at 02:56:30PM +0900, Damien Le Moal wrote:
> Improve the description of the XFS_RT configuration option to document
> that this option is required for zoned block devices.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/Kconfig | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index ae0ca6858496..68724dec3d19 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -118,6 +118,15 @@ config XFS_RT
> 
>  	  See the xfs man page in section 5 for additional information.
> 
> +	  This option is mandatory to support zoned block devices. For these
> +	  devices, the realtime subvolume must be backed by a zoned block
> +	  device and a regular block device used as the main device (for
> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
> +	  containing conventional zones at the beginning of its address space,
> +	  XFS will use the disk conventional zones as the main device and the
> +	  remaining sequential write required zones as the backing storage for
> +	  the realtime subvolume.
> +
>  	  If unsure, say N.

Looks good!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
>  config XFS_DRAIN_INTENTS
> --
> 2.50.1
> 
> 
