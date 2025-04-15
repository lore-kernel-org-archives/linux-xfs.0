Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9F4C98
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 00:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677426; cv=none; b=Xj5Zc8V9WLBvoK7/6+WDBkVi5iJ6E/bE6TjRqmlol+7gd1bTQUIaio0UGGToVAp3meg19T28cwmclPthOocmQv/27GCL4mHW49T3RRVDyPlWwjHOIuU4hatPQCBQTkXH5O++8x9UtbTvJD2josVjNvA2B5ao5PaJaJ7QaI7q528=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677426; c=relaxed/simple;
	bh=fSfl3Nr+4T+f/X0NYzf7gaMzmX3piOMTIezowTiCiMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miyq8fsX+MGU0oH7OoS3l7NEQRlXmQBf8oYWKuK9mZl0FJZQ54EetO4XLkoJmXPhXw2NqPkr8LQgzFHedUlHCxKbN2hbu1kRBded/aelFqNUsLQlapDgP/N/8YuABFlITe1UcYN1t+oysGz0TgKhrvmTyDSW86CmVrWnVHLGHtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e21QZ8WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e21QZ8WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54118C4CEE2;
	Tue, 15 Apr 2025 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677426;
	bh=fSfl3Nr+4T+f/X0NYzf7gaMzmX3piOMTIezowTiCiMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e21QZ8WSOQWqekYYDirKkTUDw9KdZ4tYKe65wPN+sNVsLX0BVgmSpnHwMdVlq4067
	 Xw1fKzVjAspJl9WQ7kLc+ArwH3hbAeZ9PzTn41s5tqYXvxnPgXTsAMpKh248HpuMjk
	 ckhtmwN5YHoQNaX3DuDZKCMqPMEhyDF9sfnQ4dDUsPslK9wczrJFk0lRX+E7Of+WED
	 1zSFQjxgY8AUT2l/EDLFAwWzwq0KQ3i+kY8PMDP/3TL60EUaCkcF3+rPhRm/+rdUey
	 U7xyAHoppWfIXk+XK0x9X1M9+Fx9S75ChSab0PxYHkjZUJbyYfsRrI+uWLriUZIjIC
	 XrbCc2tOWTmzA==
Date: Mon, 14 Apr 2025 17:37:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs_mkfs: default to rtinherit=1 for zoned file
 systems
Message-ID: <20250415003705.GJ25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-34-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-34-hch@lst.de>

On Mon, Apr 14, 2025 at 07:36:16AM +0200, Christoph Hellwig wrote:
> Zone file systems are intended to use sequential write required zones
> (or areas treated as such) for the main data store. And usually use the
> data device only for metadata that requires random writes.
> 
> rtinherit=1 is the way to achieve that, so enabled it by default, but
> still allow the user to override it if needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> inherit

  ^^ Not sure what this is, but assuming that's just paste-fingering,
the patch looks ok so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5cd100c87f43..e6adb345551e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2966,6 +2966,13 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
>  			}
>  			cli->rtextsize = 0;
>  		}
> +
> +		/*
> +		 * Set the rtinherit by default for zoned file systems as they
> +		 * usually use the data device purely as a metadata container.
> +		 */
> +		if (!cli_opt_set(&dopts, D_RTINHERIT))
> +			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
>  	} else {
>  		if (cli->rtstart) {
>  			fprintf(stderr,
> -- 
> 2.47.2
> 
> 
