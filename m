Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ABC281530;
	Fri, 16 Oct 2026 09:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142941; cv=none; b=FOYM4ckAyEKXc2rd8Wo5Tl83gXQJzCA+0KsVJ6FndERqeTPQ6Nx/kXXdjIrnhXsB1hg++WvhFHYOkERtmdMD1LaxfIuode66TE/SLgEywJ3qTqhD6RqMQogW00pRsxvQzs6KxEGZD1dQ4VG/Sx+HyPcKajmqQ/H2h8ruelEz2BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142941; c=relaxed/simple;
	bh=BZL5k94hKqd74dnzVNiMRObHpvkcU63gNu4z3/640zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDN37cUjN1ZTZGXrHodSvl6LiA6K/zZfjkI/Z6vLdT4S/VqFkmkOefRGXXMHq4BJecdKxM8wb6Pbaib0hpZL1xy1+dE0Dl+viH5Cx37LoZujhmCVSMKMqKMGU7StptKQkTB71eAgz1Pa1XDZ+aEBVPTplIBEKreqqNm2TB5drrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9FC8668BFE; Fri, 16 Oct 2026 11:28:55 +0200 (CEST)
Date: Fri, 16 Oct 2026 11:28:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: asml.silence@gmail.com, hch@lst.de, djwong@kernel.org, cem@kernel.org,
	brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, anuj20.g@samsung.com, nj.shetty@samsung.com
Subject: Re: [RFC 4/4] xfs: support dma-buf registered buffers for direct
 I/O
Message-ID: <20261016092855.GD23141@lst.de>
References: <20261016091919.971295-1-anuj1072538@gmail.com> <20261016091919.971295-5-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016091919.971295-5-anuj1072538@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 16, 2026 at 02:49:14PM +0530, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Add the init_dma_buf_io_ctx fop for XFS files.
> XFS picks the device and calls the iomap layer with
> the relevant device.
> 
> Refuse the iterator from every CPU-copy path: DAX, buffered
> fallback from a -ENOTBLK direct write, and read/writes
> without O_DIRECT.
> 
> If a file is switched between the data and realtime devices
> after registration, the block layer cross-device check refuses
> the I/O.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  fs/xfs/xfs_file.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 426a67b813a7..f97d5acfaf68 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -340,6 +340,11 @@ xfs_file_read_iter(
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
> +	/* a device mapping can only be read by a direct I/O bio */
> +	if (iov_iter_is_dmabuf_map(to) &&
> +	    (IS_DAX(inode) || !(iocb->ki_flags & IOCB_DIRECT)))
> +		return -EOPNOTSUPP;

Maybe move this into the actual methods for dax/buffered instead
to avoid extra conditionals?  Same for the write side.

>  
> @@ -1209,6 +1219,9 @@ xfs_file_write_iter(
>  		ret = xfs_file_dio_write(iocb, from);
>  		if (ret != -ENOTBLK)
>  			return ret;
> +		/* the page cache cannot copy from a device mapping */
> +		if (iov_iter_is_dmabuf_map(from))
> +			return -EOPNOTSUPP;

I suspect these random fallbacks are going to cause trouble, but
I'm not really sure what to do about it either.

> +/*
> + * A realtime file's data lives on the realtime device, anything else on the
> + * data device. If a file is switched between them after registration, the
> + * block layer cross-device check refuses the I/O.
> + */
> +static int
> +xfs_file_init_dma_buf_io_ctx(
> +	struct file		*file,
> +	struct dma_buf_io_ctx	*ctx)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(file));
> +
> +	return iomap_file_init_dma_buf_io_ctx(file,
> +			xfs_inode_buftarg(ip)->bt_bdev, ctx);
> +}

Ah, this is where the previous cross check comes from.  What about
simply disallowing toggling the RT flag with outstanding reservations
instead?

