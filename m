Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2144A272816;
	Tue, 10 Mar 2026 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104578; cv=none; b=LGsa4unt2RmoV6yjQ2+cZ4otwIZNy7s32FIi0gUb7k9sgNKTqgct6ozUag5PdGE/LR3fIpUNy3JybEUHdyYs6qIT6np//TxXWwu7DcMWLu6S4nPnSJLTbE5Z0qeGuUqzoI5aF/eN+tOF8HmpREmWT4l763HqVcpPo3p+Yz7/8AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104578; c=relaxed/simple;
	bh=RVuB7nL5vj0XzNceaDtFQbkVjrVe5Wkilj7bEZBUmyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJZFsO1QhADw8diHw/JeJU2PftkVRSVhERkYPziSwQIrDC3c7MKwcHm6e0fwUhqKxno0ysQoeBQPkztbEmkbKS1FSi/IXVi5vKJpC5X3u0n9J4DtV/i5+j4Qagtwyr8UQ/FqmxJrIj2o5zOnU7yXbq5VcD7yhWH6lhgGRz01wSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWmzXTk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWmzXTk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67613C4CEF7;
	Tue, 10 Mar 2026 01:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104577;
	bh=RVuB7nL5vj0XzNceaDtFQbkVjrVe5Wkilj7bEZBUmyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWmzXTk+6L3q58RyT+GHE41CHeJTsbgAe/+dNUeEwFjNs9jN8MjJVYSZdQTThvJMj
	 DFpGf/XWW40M2u6nklyGk0UDhDZr3tIcfw8FRISggJCkfPzbEyoxM4buDPBDS6ke+N
	 Jejt1Vzzk/k7PL7d7h28QF8ymTmRjSwDQIo2mHMgVGhCsQyh9qiTd7P4/6eKkXEj4N
	 R3AmSSjy6qPwN4yhRvVJR1BqAA0kXWTpn5Bfox4k5rMP9/7EmNckrGttO+EhzBHjDo
	 QDRNKO0G3CFPJyhj5VaYaatnvvbQtKo8x2R5tcBZmiKYmgbIuw/An8PWE2HE7B7QLJ
	 Csx3ELQ4lAbCw==
Date: Mon, 9 Mar 2026 18:02:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 11/25] iomap: introduce iomap_fsverity_write() for
 writing fsverity metadata
Message-ID: <20260310010256.GA1105363@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-12-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-12-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:26PM +0100, Andrey Albershteyn wrote:
> This is just a wrapper around iomap_file_buffered_write() to create
> necessary iterator over metadata.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/iomap/buffered-io.c | 25 +++++++++++++++++++++++++
>  include/linux/iomap.h  |  3 +++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 31e39ab93a2e..88fe4723bb22 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1259,6 +1259,31 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
>  
> +ssize_t iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
> +		const void *buf, const struct iomap_ops *ops,
> +		const struct iomap_write_ops *write_ops)
> +{
> +	int			ret;

ret should be ssize_t.

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

Nit: If we're not returning the number of bytes written, then the return
type of this function ought to be int, not ssize_t.

Also ... if there's a short write, shouldn't we return some sort of
error instead of zero for success?

	ssize_t written = iomap_file_buffered_write(...);
	if (written < 0)
		return written;
	return ret == length ? 0 : -EIO;

--D

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iomap_fsverity_write);
> +
>  static void iomap_write_delalloc_ifs_punch(struct inode *inode,
>  		struct folio *folio, loff_t start_byte, loff_t end_byte,
>  		struct iomap *iomap, iomap_punch_t punch)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 89e5a7abc012..844fc8414363 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -356,6 +356,9 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops,
>  		const struct iomap_write_ops *write_ops, void *private);
> +ssize_t iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
> +		const void *buf, const struct iomap_ops *ops,
> +		const struct iomap_write_ops *write_ops);
>  void iomap_read_folio(const struct iomap_ops *ops,
>  		struct iomap_read_folio_ctx *ctx, void *private);
>  void iomap_readahead(const struct iomap_ops *ops,
> -- 
> 2.51.2
> 
> 
