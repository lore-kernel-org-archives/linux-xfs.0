Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A8A23506D
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388379; cv=none; b=dRk43SI7BTvl9qLTp8CtBKpuqnQFWjngEG4VxlRgj4JKcEF7MlVNPwW+njVjZ8Hth/2tMJIkd/gQlz/uYlYPi3Do4kbGHxr7+KzbG2cY2wjy0jUXIeujqXtuySRHyePn3zAPd+tG9YUDRqa9rX2k7kEyXdKtUuENbLp5DTHpxS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388379; c=relaxed/simple;
	bh=DwTXkRTN5fYr4/p31iRn1AgEOVGuAldz3McPkZx18Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oe9axd9gDPHz4q9hzbfdMAXfLG1n/G1pGemAl7KpzOYQHvrveCcqcKJYvHQi8EVamOXYl/eIkZIiM+1cLucwPGgh2NSRuwaMa12O51ZqQNUL16CHWjOSrkWNfu9qdUViPVcKJqOvyVItSysn5WCKNNQNQZdrMnPSbDXv5BK6iYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQDz2f9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQDz2f9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D287EC4CEEB;
	Tue,  1 Jul 2025 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751388378;
	bh=DwTXkRTN5fYr4/p31iRn1AgEOVGuAldz3McPkZx18Uk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XQDz2f9m1/cA1VVPE6/B3bAsB0K7awKiWU/QKjdF3fzK/BQhg9xSmE4TwlZ2l9U+E
	 gZ1L+B/Cvpk6i2fkzfwTP6SipEZEJ/Fq1JDhKk4HOkPGGbQcQ/89s3B1o4/9p7M6vk
	 aRjM4j1Uog/U1L8n3QAVCaU2eCRM56MOc6ynSJZxELi51mziZZ1c/YXV8tcIX5hpyh
	 +W5ZbCapPwwEIz/Ziyh0y9f+BMzAhV9R0nNx1lW7uld2XBbZCuMVGSeXe0f8/rqXWu
	 Sl1BiG6dprfmkSmVjmN3MNR3lIDiNiX3qOR2VydzG2dP6yX21Qu6oHdXZ6HauZhwOa
	 9WGb/ZN8jKw/g==
Date: Tue, 1 Jul 2025 09:46:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: remove the bt_bdev_file buftarg field
Message-ID: <20250701164618.GI10009@frogsfrogsfrogs>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-7-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:40PM +0200, Christoph Hellwig wrote:
> And use bt_file for both bdev and shmem backed buftargs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woot, that's a nice savings!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 4 ++--
>  fs/xfs/xfs_buf.h | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 661f6c70e9d0..b73da43f489c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1683,7 +1683,7 @@ xfs_free_buftarg(
>  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
>  	/* the main block device is closed by kill_block_super */
>  	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
> -		bdev_fput(btp->bt_bdev_file);
> +		bdev_fput(btp->bt_file);
>  	kfree(btp);
>  }
>  
> @@ -1802,7 +1802,7 @@ xfs_alloc_buftarg(
>  	btp = kzalloc(sizeof(*btp), GFP_KERNEL | __GFP_NOFAIL);
>  
>  	btp->bt_mount = mp;
> -	btp->bt_bdev_file = bdev_file;
> +	btp->bt_file = bdev_file;
>  	btp->bt_bdev = file_bdev(bdev_file);
>  	btp->bt_dev = btp->bt_bdev->bd_dev;
>  	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 7987a6d64874..b269e115d9ac 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -94,7 +94,6 @@ void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
>   */
>  struct xfs_buftarg {
>  	dev_t			bt_dev;
> -	struct file		*bt_bdev_file;
>  	struct block_device	*bt_bdev;
>  	struct dax_device	*bt_daxdev;
>  	struct file		*bt_file;
> -- 
> 2.47.2
> 
> 
