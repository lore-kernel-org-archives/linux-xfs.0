Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1641509BD
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695582; cv=none; b=TA1icF284F1S6N2VXgPIoMrKSXpw7r64A9xwp4L9b01gru2t5l1F7bT94Fbxz3bkPdSr3hIVhxGIcUOAJVBR6Lh9A7hLS4tu9Rj5LzcE6CtQwKou5jlvnTbus5liGdF3jTEnZ9r1fu8Yxelth7C4UUvrRE9DLPN9zJxB+Usq+OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695582; c=relaxed/simple;
	bh=PaQhTMmHeDAz6kNHz6SAJMoFlyceOL8u2zNkRp4e9qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5OoR0Jcc9Rj2jLvZqkxwbhzXFAa/83PR43W7beis+RMqhefTsZJiwc2zVkax8MWz1vAouibzexWVmzJ9GgCt+bYE0xKLaFLF+Chgol+ycKTROrBYhOKRAY6NP9JfBrz4xl9FM0cugUGMWuNG6B3PnIAXTTc2Mn+NO764omHYts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fjby4qGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fjby4qGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5A8C4CEE2;
	Tue,  4 Feb 2025 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695581;
	bh=PaQhTMmHeDAz6kNHz6SAJMoFlyceOL8u2zNkRp4e9qQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fjby4qGFSl6X6tNyHXTXi3Fiiy8LXVzop2BhlaejDznVnOapaceX9GcLaTViyG5A2
	 LapG8NvzMX/ylAlG6DPirjRi1FYPj9fwF2SFZETmQ+u20kHFgTfS8alEIsAvYJg0k/
	 SSDylBYPAR2tXfqor+f/NKuQKUOUHqSH3yJ9twrOGTu0T1pWLqoMGZaBx1ITkEaa6Q
	 EcI5YEvuIq/ZUpAqv0CSJ7O4s+pNin+rXPEKyC6xcjTSiDGdHx9eJ1OfE0vS0nsnS1
	 2Wx3pdy1KpuOl7JqTqxDWSDvGIZBl5h94K+uKOQrpDeJVlfz4mdtjoUpJZj4ZBQ+Bv
	 gEatlGzyNuRbg==
Date: Tue, 4 Feb 2025 10:59:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: flag as supporting FOP_DONTCACHE
Message-ID: <20250204185941.GB21808@frogsfrogsfrogs>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <20250204184047.356762-3-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204184047.356762-3-axboe@kernel.dk>

On Tue, Feb 04, 2025 at 11:40:00AM -0700, Jens Axboe wrote:
> Read side was already fully supported, and with the write side
> appropriately punted to the worker queue, all that's needed now is
> setting FOP_DONTCACHE in the file_operations structure to enable full
> support for read and write uncached IO.
> 
> This provides similar benefits to using RWF_DONTCACHE with reads. Testing
> buffered writes on 32 files:
> 
> writing bs 65536, uncached 0
>   1s: 196035MB/sec
>   2s: 132308MB/sec
>   3s: 132438MB/sec
>   4s: 116528MB/sec
>   5s: 103898MB/sec
>   6s: 108893MB/sec
>   7s: 99678MB/sec
>   8s: 106545MB/sec
>   9s: 106826MB/sec
>  10s: 101544MB/sec
>  11s: 111044MB/sec
>  12s: 124257MB/sec
>  13s: 116031MB/sec
>  14s: 114540MB/sec
>  15s: 115011MB/sec
>  16s: 115260MB/sec
>  17s: 116068MB/sec
>  18s: 116096MB/sec
> 
> where it's quite obvious where the page cache filled, and performance
> dropped from to about half of where it started, settling in at around
> 115GB/sec. Meanwhile, 32 kswapds were running full steam trying to
> reclaim pages.
> 
> Running the same test with uncached buffered writes:
> 
> writing bs 65536, uncached 1
>   1s: 198974MB/sec
>   2s: 189618MB/sec
>   3s: 193601MB/sec
>   4s: 188582MB/sec
>   5s: 193487MB/sec
>   6s: 188341MB/sec
>   7s: 194325MB/sec
>   8s: 188114MB/sec
>   9s: 192740MB/sec
>  10s: 189206MB/sec
>  11s: 193442MB/sec
>  12s: 189659MB/sec
>  13s: 191732MB/sec
>  14s: 190701MB/sec
>  15s: 191789MB/sec
>  16s: 191259MB/sec
>  17s: 190613MB/sec
>  18s: 191951MB/sec
> 
> and the behavior is fully predictable, performing the same throughout
> even after the page cache would otherwise have fully filled with dirty
> data. It's also about 65% faster, and using half the CPU of the system
> compared to the normal buffered write.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f7a7d89c345e..358987b6e2f8 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1626,7 +1626,8 @@ const struct file_operations xfs_file_operations = {
>  	.fadvise	= xfs_file_fadvise,
>  	.remap_file_range = xfs_file_remap_range,
>  	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
> -			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE,
> +			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
> +			  FOP_DONTCACHE,
>  };
>  
>  const struct file_operations xfs_dir_file_operations = {
> -- 
> 2.47.2
> 
> 
