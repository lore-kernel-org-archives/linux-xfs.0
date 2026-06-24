Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440141A9FB0;
	Wed, 24 Jun 2026 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324707; cv=none; b=hq0LyhkV0Il77yoYs0+Cd1qtSVdlwVzyfZlrRgvNDO0Xhp2K8hg0r4jUe4sIKLeH2KbMYcungGYY6wumFmaGnBMV0EqT6jrP3YaN0rhjEvcaRSfD3/JrZQdcePn+0OdfUVctL8ZytyphzA6pPV00M131UAFnOIKQ64TgJoCLWHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324707; c=relaxed/simple;
	bh=9WsC6VkrZ1/6cwlgfzxm80rjSKiikg2FaR15kQ87rYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4vKbsyd6fA1j+rx6hcuJMFN0NEfnBxe2mhiPg52XBRLjDjwT6U58tJYCBQ0tkcw7JfRncefxJq9RMXbrwhSPuFNll+sac4JkNHvIPWJj9RWSaL/lsDWNcuABgbIcDQqTllxGjrHhHZ88ZdxtVLGJNAHG355iNcMPzGWa1oll7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbJBPmLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbJBPmLT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BDC8F1F000E9;
	Wed, 24 Jun 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324705;
	bh=ECMNAZAMzJcDt8+yr8M51jjQcJJDOORHX8rwjejYpvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NbJBPmLTlrhw1GarDc0ssRNGZqS4fgYzjVew2DJNNtN/w8lNgw5QttqWO0fO0Cuk2
	 vMEmOXwo3Nkgi6nwKZnWtMFwVpgWvvSHJbbeFIEjBB1rXQchBgRU99tKP/Z7RU4AsR
	 yTHuSQDOhu7Nq7xaeNInCVhq4Z8OaxwcSNHCqTGq/sJmPPv6kg95pJJVo/T1JU9VsC
	 EADIwL8V6a7nre3QXRLsu3RJOZAr8o3kVcNDG5DfxPljus/PfStqlmLclSAs8Hc5YW
	 mp4VeIwZVcaKCkJOlTkcp15bQh0/rBESlH8hIR4mxmo+GQ2S243toRQuS5Nu79cptq
	 B3Sm53uwQnS0w==
Date: Wed, 24 Jun 2026 11:11:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v3 3/6] xfs: implement write-stream management support
Message-ID: <20260624181145.GX6078@frogsfrogsfrogs>
References: <20260616180555.33338-1-joshi.k@samsung.com>
 <CGME20260616181246epcas5p30fc85b12b67452b5af39525e4ea966a9@epcas5p3.samsung.com>
 <20260616180555.33338-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616180555.33338-4-joshi.k@samsung.com>

On Tue, Jun 16, 2026 at 11:35:52PM +0530, Kanchan Joshi wrote:
> Implement support for FS_IOC_WRITE_STREAM ioctl.
> 
> For FS_WRITE_STREAM_OP_GET_MAX, available write streams are reported
> based on the capability of the underlying block device.
> For FS_WRITE_STREAM_OP_{SET/GET}, add a new i_write_stream field in xfs
> inode. This value is propagated to the iomap during block mapping.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  fs/xfs/xfs_icache.c |  1 +
>  fs/xfs/xfs_inode.c  | 46 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h  |  6 ++++++
>  fs/xfs/xfs_ioctl.c  | 38 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.c  |  1 +
>  5 files changed, 92 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2040a9292ee6..d5f880f5b810 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -130,6 +130,7 @@ xfs_inode_alloc(
>  	spin_lock_init(&ip->i_ioend_lock);
>  	ip->i_next_unlinked = NULLAGINO;
>  	ip->i_prev_unlinked = 0;
> +	ip->i_write_stream = 0;
>  
>  	return ip;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index beaa26ec62da..2e7c61d71b48 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -47,6 +47,52 @@
>  
>  struct kmem_cache *xfs_inode_cache;
>  
> +int
> +xfs_inode_max_write_streams(
> +	struct xfs_inode	*ip)
> +{
> +	struct block_device	*bdev;
> +
> +	bdev = xfs_inode_buftarg(ip)->bt_bdev;
> +	if (!bdev)
> +		return 0;
> +
> +	return bdev_max_write_streams(bdev);
> +}
> +
> +uint16_t
> +xfs_inode_get_write_stream(
> +	struct xfs_inode	*ip)
> +{
> +	uint16_t	stream_id;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	stream_id = ip->i_write_stream;
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	return stream_id;
> +}
> +
> +int
> +xfs_inode_set_write_stream(
> +	struct xfs_inode	*ip,
> +	uint16_t		stream_id)
> +{
> +	int ret = 0;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	if (stream_id > xfs_inode_max_write_streams(ip)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	ip->i_write_stream =  stream_id;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return ret;
> +}
> +
>  /*
>   * These two are wrapper routines around the xfs_ilock() routine used to
>   * centralize some grungy code.  They are used in places that wish to lock the
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index bd6d33557194..768c4195306c 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -38,6 +38,9 @@ typedef struct xfs_inode {
>  	struct xfs_ifork	i_df;		/* data fork */
>  	struct xfs_ifork	i_af;		/* attribute fork */
>  
> +	/* Write stream information */
> +	uint16_t		i_write_stream;
> +
>  	/* Transaction and locking information. */
>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
>  	struct rw_semaphore	i_lock;		/* inode lock */
> @@ -676,4 +679,7 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
>  		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
>  		struct xfs_dquot **pdqpp);
>  
> +int xfs_inode_max_write_streams(struct xfs_inode *ip);
> +uint16_t xfs_inode_get_write_stream(struct xfs_inode *ip);
> +int xfs_inode_set_write_stream(struct xfs_inode *ip, uint16_t stream_id);
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 46e234863644..3f82a4884b81 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1179,6 +1179,42 @@ xfs_ioctl_fs_counts(
>  	return 0;
>  }
>  
> +static int
> +xfs_ioc_write_stream(
> +	struct file		*filp,
> +	void __user		*arg)
> +{
> +	struct inode		*inode = file_inode(filp);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct fs_write_stream	ws = { };
> +
> +	if (copy_from_user(&ws, arg, sizeof(ws)))
> +		return -EFAULT;
> +	if (ws.rsvd != 0)
> +		return -EINVAL;
> +
> +	switch (ws.op_flags) {
> +	case FS_WRITE_STREAM_OP_GET_MAX:
> +		ws.max_streams = xfs_inode_max_write_streams(ip);

Shouldn't you hold ILOCK when you look at the REALTIME bit?

--D

> +		goto copy_out;
> +	case FS_WRITE_STREAM_OP_GET:
> +		ws.stream_id = xfs_inode_get_write_stream(ip);
> +		goto copy_out;
> +	case FS_WRITE_STREAM_OP_SET:
> +		if (!(filp->f_mode & FMODE_WRITE))
> +			return -EBADF;
> +		return xfs_inode_set_write_stream(ip, ws.stream_id);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +
> +copy_out:
> +	if (copy_to_user(arg, &ws, sizeof(ws)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  /*
>   * These long-unused ioctls were removed from the official ioctl API in 5.17,
>   * but retain these definitions so that we can log warnings about them.
> @@ -1444,6 +1480,8 @@ xfs_file_ioctl(
>  		return xfs_ioc_health_monitor(filp, arg);
>  	case XFS_IOC_VERIFY_MEDIA:
>  		return xfs_ioc_verify_media(filp, arg);
> +	case FS_IOC_WRITE_STREAM:
> +		return xfs_ioc_write_stream(filp, arg);
>  
>  	default:
>  		return -ENOTTY;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f20a02f49ed9..ccbf7dcf1ad5 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -144,6 +144,7 @@ xfs_bmbt_to_iomap(
>  	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
>  	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
>  	iomap->flags = iomap_flags;
> +	iomap->write_stream = ip->i_write_stream;
>  	if (mapping_flags & IOMAP_DAX) {
>  		iomap->dax_dev = target->bt_daxdev;
>  	} else {
> -- 
> 2.25.1
> 
> 
