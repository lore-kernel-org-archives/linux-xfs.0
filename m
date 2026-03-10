Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3E43A543D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147268; cv=none; b=Bxq1kbMM4PMSb1ru6F4M5eR5qxkHr6Ra6TRoObD2WGeHpgoyCZJwprcZTirYNM0zc/eleflP7JeMMp3s7192QT1mxoMhV6aJVihoeX8TSxXfK5CHA5xJdIpLm3SIHVUf0FCeos7wfymXmz7q3NbG3qZTr/lAL9PNpLpdgyo/4xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147268; c=relaxed/simple;
	bh=ryqN/2pm23g6qhTpAxw6sKcOfkL8e4N6WrL8xz+YbeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4Fn+ssIzfUl1vjquOi2Yg+I6pQiNB2+aEOFEixd1wdpJW0JN9RYTHZ1gYtvnFNCT32HA19bKUpgkBaBFi+KpOQ/iGEG0F6ubf91v0M2zKdp8PLP03/KCXaVA0Ef8Dg7q9rPcoYvq8Jra0y8Xz+j6BYXcl2tAULjQFfHL9oLNE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4F8ZKGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4F8ZKGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E30C19425;
	Tue, 10 Mar 2026 12:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773147268;
	bh=ryqN/2pm23g6qhTpAxw6sKcOfkL8e4N6WrL8xz+YbeI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q4F8ZKGovJvTN1z8Mrqt0K1twMneOTOZ5sfCD5zxKlVtAGtxESm/WxEzDrRKR96w4
	 PI/NhXezx8V6SM2fqNV28ZFxUiJSDvC7yFUt8oR5wq4g5DZYOSZxG9MLYxI54Fog2A
	 tj0F+a59VSdHBVWSWss0NggB+7rph6ZiyNOn9mAFJ5e4rD2N4eMTvnWG2BoTvVun/2
	 FKuwp7rdSwAjGRZqqL/R6dFT+mxo4yfMa+Op57c4HIr8GIxJHEQxfwEOK2KK1aS3ec
	 FqVtrkGViUqpWJyCzWqm3ru+u8PoTo4XPCFDMzEEi+lQTFPmDicCzb1oBC94qi182T
	 faE6NMaSc4kvA==
Message-ID: <024f90cd-2bfc-4ef7-aa4f-8808bd601e89@kernel.org>
Date: Tue, 10 Mar 2026 13:54:26 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] xfs: move zoned dio ioend to its own function
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de
References: <20260310115555.114197-1-cem@kernel.org>
 <20260310115555.114197-3-cem@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310115555.114197-3-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 12:55, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> All zoned dio needs during endio is set the file size, so move it
> out of the generic function.

"move" is unclear here since this patch is adding code but not deleting
anything. Maye be rephrase this ?

> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 45ecd743fa32..29b02673111b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -595,6 +595,36 @@ xfs_dio_endio_set_isize(
>  	return xfs_setfilesize(ip, offset, size);
>  }
>  
> +static int
> +xfs_zoned_dio_write_end_io(
> +	struct kiocb		*iocb,
> +	ssize_t			size,
> +	int			error,
> +	unsigned		flags)
> +{
> +	struct inode		*inode = file_inode(iocb->ki_filp);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	unsigned int		nofs_flag;
> +
> +	ASSERT(!(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
> +
> +	trace_xfs_end_io_direct_write(ip, iocb->ki_pos, size);
> +
> +	if (xfs_is_shutdown(ip->i_mount))
> +		return -EIO;
> +
> +	if (error || !size)
> +		return error;
> +
> +	XFS_STATS_ADD(ip->i_mount, xs_write_bytes, size);
> +
> +	nofs_flag = memalloc_nofs_save();
> +	error = xfs_dio_endio_set_isize(inode, iocb->ki_pos, size);
> +	memalloc_nofs_restore(nofs_flag);
> +
> +	return error;
> +}
> +
>  static int
>  xfs_dio_write_end_io(
>  	struct kiocb		*iocb,
> @@ -607,8 +637,7 @@ xfs_dio_write_end_io(
>  	loff_t			offset = iocb->ki_pos;
>  	unsigned int		nofs_flag;
>  
> -	ASSERT(!xfs_is_zoned_inode(ip) ||
> -	       !(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
> +	ASSERT(!xfs_is_zoned_inode(ip));
>  
>  	trace_xfs_end_io_direct_write(ip, offset, size);
>  
> @@ -701,7 +730,7 @@ xfs_dio_zoned_submit_io(
>  static const struct iomap_dio_ops xfs_dio_zoned_write_ops = {
>  	.bio_set	= &iomap_ioend_bioset,
>  	.submit_io	= xfs_dio_zoned_submit_io,
> -	.end_io		= xfs_dio_write_end_io,
> +	.end_io		= xfs_zoned_dio_write_end_io,
>  };
>  
>  /*


-- 
Damien Le Moal
Western Digital Research
