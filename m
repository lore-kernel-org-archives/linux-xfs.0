Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292CD20B810;
	Tue, 31 Mar 2026 23:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774999945; cv=none; b=B0V0FG+XZAwzbbIq/FwwfTsC82DIyKXv+f0dMb9r2EsjtjvkLBJsCyNph4eiPYblidB6VmgInXGJqH8WXYiQ69gOfwlmvSi7PxfnSDupcODyE6tPR7aecHBXDv+IFkuJftm/MtL3hfyTXfpJ9sLVcdnw27jjmCwW3W//FL/3cDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774999945; c=relaxed/simple;
	bh=BBghGICnfNmlmMhvY9XNZ0lqj1Gas1dXV2NQpfhbWXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnGJ0SKwSUGhU2Ks+fJfYky6AUd0QX++3OkP4NYzbvqdOigLX86kSco8jSFwsN93rFWwTEJd6v7rZIvAsuUDMXE546pP0j5g7oDmacsYMFOUdEcuakIWvL9meYgcnCRiiwd0ox+jpx/6RnMJ4fJLaKS8BIyT/+x+LLgiMwJ7QiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyU7VG+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyU7VG+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026CAC19423;
	Tue, 31 Mar 2026 23:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774999945;
	bh=BBghGICnfNmlmMhvY9XNZ0lqj1Gas1dXV2NQpfhbWXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dyU7VG+8pp/TRzJHW1sOemsoPPVstO/KtSSpQlCHL3Ym+1Z0S+edNsMBdfgJdjCqX
	 1RVrJ+1yTvcgwr2WD8jzZjzEfx3hq6a6rONa610NkvUkjU9dqUqXHMZZLj8PcMZBNM
	 WQigfKeZaVVzS6DMr9VvAoHs0G3HwAWskDhC9MeaBuGJEcFLlCw0Ah37g2D5zKoNVj
	 LxALVPsPJzM7qYYX5s8JEQDfF+gEB3zEP0WpokF+ADIjKafSAVDRvk8YOSKzPEkkE9
	 9ElxsQQaVh206dOXf8ayr1BtZYc0bVGSsHMAFlB3zwnsKuPpJIkcDA6uQa4f3ZqGt6
	 WvU2MUjmcmEUg==
Date: Tue, 31 Mar 2026 16:32:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 08/22] iomap: introduce iomap_fsverity_write() for
 writing fsverity metadata
Message-ID: <20260331233224.GG6223@frogsfrogsfrogs>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-9-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-9-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:09PM +0200, Andrey Albershteyn wrote:
> This is just a wrapper around iomap_file_buffered_write() to create
> necessary iterator over metadata.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 25 +++++++++++++++++++++++++
>  include/linux/iomap.h  |  3 +++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 7ac319618f8e..0f89225dc3d7 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1287,6 +1287,31 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
>  
> +int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
> +		const void *buf, const struct iomap_ops *ops,
> +		const struct iomap_write_ops *write_ops)
> +{
> +	int			ret;
> +	struct iov_iter		iiter;
> +	struct kvec		kvec = {
> +		.iov_base	= (void *)buf,
> +		.iov_len	= length,
> +	};
> +	struct kiocb		iocb = {
> +		.ki_filp	= file,
> +		.ki_ioprio	= get_current_ioprio(),
> +		.ki_pos		= pos,
> +	};
> +
> +	iov_iter_kvec(&iiter, WRITE, &kvec, 1, length);
> +
> +	ret = iomap_file_buffered_write(&iocb, &iiter, ops, write_ops, NULL);
> +	if (ret < 0)
> +		return ret;
> +	return ret == length ? 0 : -EIO;
> +}
> +EXPORT_SYMBOL_GPL(iomap_fsverity_write);
> +
>  static void iomap_write_delalloc_ifs_punch(struct inode *inode,
>  		struct folio *folio, loff_t start_byte, loff_t end_byte,
>  		struct iomap *iomap, iomap_punch_t punch)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 4d9202cae29f..83586f09f365 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -359,6 +359,9 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops,
>  		const struct iomap_write_ops *write_ops, void *private);
> +int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
> +		const void *buf, const struct iomap_ops *ops,
> +		const struct iomap_write_ops *write_ops);
>  void iomap_read_folio(const struct iomap_ops *ops,
>  		struct iomap_read_folio_ctx *ctx, void *private);
>  void iomap_readahead(const struct iomap_ops *ops,
> -- 
> 2.51.2
> 
> 
