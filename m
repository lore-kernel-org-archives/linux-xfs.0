Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAF61E25F2
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744227380; cv=none; b=OWCSFMApfxnAbfnqEe6ehexi3zECKsyZeYvyNFgi2SLKdA4rRqHRRSnapJ0Uzwakj2NhmrFdV5+nfsFxFzfFKAlC2lyBennWWRkgl3Ifcl5fSHYXNcTSBoTqmR2MePqBLMXb75NtyqtnTaMSVN9/nZibmGAL8J5jdVtrtLyLYw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744227380; c=relaxed/simple;
	bh=JIx/fTtkl15ZHnZdxsjLusz6+nd4S1MAaRQnSZUL71c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=leI8ffcDmXDYZHS3gRaCPICP/nVtqgku1db91b3c8XAIO+ZXHcXEueFm2tXkBjUFf+z3MgcYcuyN3/IkKDxrbPirdV1YwgWXxHwPHX4hn4hDlTJUbvtTYsc6g+Neiiac4afdt37NzhPdFpilsJ1fixZ2DYUuWT9L9UT3BjUDbV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIy/zFHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIy/zFHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A9DC4CEE2;
	Wed,  9 Apr 2025 19:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744227380;
	bh=JIx/fTtkl15ZHnZdxsjLusz6+nd4S1MAaRQnSZUL71c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIy/zFHVIpWzmIsura32W/EIu+Vsbe6NknZtWr6v6NdVZpaCv4CJRVheoP7F/M2wW
	 0qWprtAKyfKG5T18ECCcdrZZEUWgkzM+KmZ1fRnPM6jCIEzHJ0qdAn/N4efwaRUAoq
	 YVbAQ/c6vWqFXaufR7acgruPbXvJsNWikoaoGdB+xeDjlCNZ2s1dYcig0ICp/DKw9s
	 /53UppZq4FNEnXvO0cFwSjj5ekJo9Fhi8lE2iDeFeQnC8Gic0Ed3oSFMScP1av8OpY
	 J8jgncoXycyXtrCjIm/Kb5cGEVqKqaUdSafTbuVelUkwcCGFdm5hJWX48BbPwsqOqU
	 wulrimerY7Xvw==
Date: Wed, 9 Apr 2025 12:36:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/45] xfs_mdrestore: support internal RT devices
Message-ID: <20250409193620.GQ6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-45-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-45-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:47AM +0200, Christoph Hellwig wrote:
> Calculate the size properly for internal RT devices and skip restoring
> to the external one for this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index d5014981b15a..95b01a99a154 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -183,6 +183,20 @@ verify_device_size(
>  	}
>  }
>  
> +static void
> +verify_main_device_size(
> +	const struct mdrestore_dev	*dev,
> +	struct xfs_sb			*sb)
> +{
> +	xfs_rfsblock_t			nr_blocks = sb->sb_dblocks;
> +
> +	/* internal RT device */
> +	if (sb->sb_rtstart)
> +		nr_blocks = sb->sb_rtstart + sb->sb_rblocks;
> +
> +	verify_device_size(dev, nr_blocks, sb->sb_blocksize);
> +}
> +
>  static void
>  read_header_v1(
>  	union mdrestore_headers	*h,
> @@ -269,7 +283,7 @@ restore_v1(
>  
>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
> +	verify_main_device_size(ddev, &sb);
>  
>  	bytes_read = 0;
>  
> @@ -432,14 +446,14 @@ restore_v2(
>  
>  	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
> +	verify_main_device_size(ddev, &sb);
>  
>  	if (sb.sb_logstart == 0) {
>  		ASSERT(mdrestore.external_log == true);
>  		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
>  	}
>  
> -	if (sb.sb_rblocks > 0) {
> +	if (sb.sb_rblocks > 0 && !sb.sb_rtstart) {
>  		ASSERT(mdrestore.realtime_data == true);
>  		verify_device_size(rtdev, sb.sb_rblocks, sb.sb_blocksize);
>  	}
> -- 
> 2.47.2
> 
> 
