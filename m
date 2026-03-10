Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261CB38AC7F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147083; cv=none; b=g2EA9RSwGzhHigjy6rGHocISQNJMRJflmwIql2PJlzOM1EwlBfnSrw2xRkVagHKA2OPodd5Sq3t5HIkflzEh1niNI6r97iJGiy/tSmoBZcGuG4vU4QXZ9+6G1tMkd2jb6abPqAGtQhkJNX/WGgIKI/BS131uIid0MZFWepoiyiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147083; c=relaxed/simple;
	bh=khgZ3Gi5OYsha79OSzoChAxZ92SilT+NYsYufOLo6kY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cxc+0gSROsN0OxJ5ggqwUtcdeSwD65Qpu+vc2JjabWMACr3sAz0NtZSQYP9MnYqWF+r5gNoXEgWrD+pPn9ISZyOsZH3MAI19bROiJfEQveOEiOt8VJry5cxb1vUHrDemh90TFMYyf4s316hlSXDxFivSsz5pVLCvSe9bONh+Npk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opyv3akX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opyv3akX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF7FC19423;
	Tue, 10 Mar 2026 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773147082;
	bh=khgZ3Gi5OYsha79OSzoChAxZ92SilT+NYsYufOLo6kY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=opyv3akXpnT1Goju3PfP0V1URwpVNWQ0v8QrSIpyXtEX1c5jEHjqMMh/Ru27sLq2y
	 VyuKMbtdgQPdtWNoDxGZoNWeYx5k3Z6c4i+nWUo2MFBVO4jW9MO1x8/gQS3cmSquss
	 +OOCJkP5cqHfKMNWw7MBj9hqZnDSgp+Xly/qsuhrks7b0B4i/6MN/E6D2HeKMZagCo
	 05fUDLmVDsCI+uonEIXJi1YDeX/O9AqmDFMKsTUg8+ZLB9bPRZCTDwJ3ut4ohLvTbo
	 bbNUdb2iqbRgxf5Al0COk/qJMnLV06bcAZCzZiB4EQ2hZV4AuLppRxX2TN5EMSDFeO
	 Lq8rdBMGZO3Uw==
Message-ID: <9127da59-fb17-4c4e-b9c5-ecb745a68693@kernel.org>
Date: Tue, 10 Mar 2026 13:51:20 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] xfs: factor out isize updates from
 xfs_dio_write_end_io
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de
References: <20260310115555.114197-1-cem@kernel.org>
 <20260310115555.114197-2-cem@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310115555.114197-2-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 12:55, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This is the only code needed for zoned inodes, so factor it out so
> we can move zoned inodes ioend to its own callback.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 59 +++++++++++++++++++++++++++++------------------
>  1 file changed, 36 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6246f34df9fd..45ecd743fa32 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -560,6 +560,41 @@ xfs_zoned_write_space_reserve(
>  			flags, ac);
>  }
>  
> +/*
> + * We need to lock the test/set EOF update as we can be racing with
> + * other IO completions here to update the EOF. Failing to serialise
> + * here can result in EOF moving backwards and Bad Things Happen when
> + * that occurs.
> + *
> + * As IO completion only ever extends EOF, we can do an unlocked check
> + * here to avoid taking the spinlock. If we land within the current EOF,
> + * then we do not need to do an extending update at all, and we don't
> + * need to take the lock to check this. If we race with an update moving
> + * EOF, then we'll either still be beyond EOF and need to take the lock,
> + * or we'll be within EOF and we don't need to take it at all.
> + */
> +static int
> +xfs_dio_endio_set_isize(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	ssize_t			size)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +
> +	if (offset + size <= i_size_read(inode))
> +		return 0;
> +
> +	spin_lock(&ip->i_flags_lock);
> +	if (offset + size > i_size_read(inode)) {
> +		i_size_write(inode, offset + size);
> +		spin_unlock(&ip->i_flags_lock);
> +	} else {
> +		spin_unlock(&ip->i_flags_lock);
> +	}

The spinlock unlock does not need to be inside the if and else:

+	spin_lock(&ip->i_flags_lock);
+	if (offset + size > i_size_read(inode))
+		i_size_write(inode, offset + size);
+	spin_unlock(&ip->i_flags_lock);

Other than this, looks OK to me.

> +
> +	return xfs_setfilesize(ip, offset, size);
> +}
> +
>  static int
>  xfs_dio_write_end_io(
>  	struct kiocb		*iocb,
> @@ -623,30 +658,8 @@ xfs_dio_write_end_io(
>  	 * with the on-disk inode size being outside the in-core inode size. We
>  	 * have no other method of updating EOF for AIO, so always do it here
>  	 * if necessary.
> -	 *
> -	 * We need to lock the test/set EOF update as we can be racing with
> -	 * other IO completions here to update the EOF. Failing to serialise
> -	 * here can result in EOF moving backwards and Bad Things Happen when
> -	 * that occurs.
> -	 *
> -	 * As IO completion only ever extends EOF, we can do an unlocked check
> -	 * here to avoid taking the spinlock. If we land within the current EOF,
> -	 * then we do not need to do an extending update at all, and we don't
> -	 * need to take the lock to check this. If we race with an update moving
> -	 * EOF, then we'll either still be beyond EOF and need to take the lock,
> -	 * or we'll be within EOF and we don't need to take it at all.
>  	 */
> -	if (offset + size <= i_size_read(inode))
> -		goto out;
> -
> -	spin_lock(&ip->i_flags_lock);
> -	if (offset + size > i_size_read(inode)) {
> -		i_size_write(inode, offset + size);
> -		spin_unlock(&ip->i_flags_lock);
> -		error = xfs_setfilesize(ip, offset, size);
> -	} else {
> -		spin_unlock(&ip->i_flags_lock);
> -	}
> +	error = xfs_dio_endio_set_isize(inode, offset, size);
>  
>  out:
>  	memalloc_nofs_restore(nofs_flag);


-- 
Damien Le Moal
Western Digital Research
