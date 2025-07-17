Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCCA2F8C28
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752768177; cv=none; b=KGwkIbYlzfO3Ach0fzyic+KBphSZCIRNnpeGMc6trokaSzIfIJhdpg0bVfj+2z6WhA9EdFQOp/6oq/6Mk05ie72aeZE8z87159Utjg8yOdiCM6frNx540dUXuNp3ZtYNxvIYV0e5NFleFrpFk3CYzO3V6e2793WY5UcfYbTK638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752768177; c=relaxed/simple;
	bh=oCl6qenrAaatXqzQUUnAHOP/pICE85dKwvjVx+41xxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGQWjjZYa1Zh3f3TM+JMnxpAiXvyRjyCNQaZrkjFl/L4u3Yak5j5kXiELmYlMwq01Qt5phcO2DG06uII4mTF2zhu+vaJHIFDDxyti/d4PeYv2RxjBInDJ7qHs9z0ZGoD2072vFqQ/JXTtGBUhrIyZVUXJ74InHFCN4HIrzzSDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRjCSyGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRjCSyGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7135DC4CEE3;
	Thu, 17 Jul 2025 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752768176;
	bh=oCl6qenrAaatXqzQUUnAHOP/pICE85dKwvjVx+41xxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IRjCSyGPe5lj5FpdmWFh2jyIVntUiNx9SGdRp1IacOE4dwreWx+tdEXqKZ07b2OzT
	 TmcWuYsGaL6akiE0f9YTPuyeiLpjH+q3bRIk+7TZtUkfaAd9UKMZT8hkLnLG/lcxfF
	 aV0VaLOKgCpYNjWaHO6im+Wt7x3ZB55yJgJoXELIbDjc0bHZ/BqmDNAD0EtCt7PlrS
	 aM7JP+ThEoKL8ocGTfgfExDzvLHsa3eMURQntdTEBMlUZPX6uMwxoGA2RfZ8Wq34b2
	 pH2MwKeMGrnKVYk2qHT3HR7pDc0edoRm2JGYH+A2+Gb7fH5km0QaMBqPBOMz2FHrQR
	 nYmCroggLeBGw==
Date: Thu, 17 Jul 2025 09:02:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: disallow atomic writes on DAX
Message-ID: <20250717160255.GP2672049@frogsfrogsfrogs>
References: <20250717151900.1362655-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717151900.1362655-1-john.g.garry@oracle.com>

On Thu, Jul 17, 2025 at 03:19:00PM +0000, John Garry wrote:
> Atomic writes are not currently supported for DAX, but two problems exist:
> - we may go down DAX write path for IOCB_ATOMIC, which does not handle
>   IOCB_ATOMIC properly
> - we report non-zero atomic write limits in statx (for DAX inodes)
> 
> We may want atomic writes support on DAX in future, but just disallow for
> now.
> 
> For this, ensure when IOCB_ATOMIC is set that we check the write size
> versus the atomic write min and max before branching off to the DAX write
> path. This is not strictly required for DAX, as we should not get this far
> in the write path as FMODE_CAN_ATOMIC_WRITE should not be set.
> 
> In addition, due to reflink being supported for DAX, we automatically get
> CoW-based atomic writes support being advertised. Remedy this by
> disallowing atomic writes for a DAX inode for both sw and hw modes.

...because it's fsdax and who's really going to test/use software atomic
writes there ?

> Finally make atomic write size and DAX mount always mutually exclusive.

Why?  You could have a rt-on-pmem filesystem with S_DAX files, and still
want to do atomic writes to files on the data device.

> Reported-by: "Darrick J. Wong" <djwong@kernel.org>
> Fixes: 9dffc58f2384 ("xfs: update atomic write limits")
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index db21b5a4b881..84876f41da93 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1102,9 +1102,6 @@ xfs_file_write_iter(
>  	if (xfs_is_shutdown(ip->i_mount))
>  		return -EIO;
>  
> -	if (IS_DAX(inode))
> -		return xfs_file_dax_write(iocb, from);
> -
>  	if (iocb->ki_flags & IOCB_ATOMIC) {
>  		if (ocount < xfs_get_atomic_write_min(ip))
>  			return -EINVAL;
> @@ -1117,6 +1114,9 @@ xfs_file_write_iter(
>  			return ret;
>  	}
>  
> +	if (IS_DAX(inode))
> +		return xfs_file_dax_write(iocb, from);
> +
>  	if (iocb->ki_flags & IOCB_DIRECT) {
>  		/*
>  		 * Allow a directio write to fall back to a buffered
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 07fbdcc4cbf5..b142cd4f446a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -356,11 +356,22 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
>  	(XFS_IS_REALTIME_INODE(ip) ? \
>  		(ip)->i_mount->m_rtdev_targp : (ip)->i_mount->m_ddev_targp)
>  
> -static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
> +static inline bool xfs_inode_can_hw_atomic_write(struct xfs_inode *ip)

Why drop const here?  VFS_IC() should be sufficient, I think.

--D

>  {
> +	if (IS_DAX(VFS_I(ip)))
> +		return false;
> +
>  	return xfs_inode_buftarg(ip)->bt_awu_max > 0;
>  }
>  
> +static inline bool xfs_inode_can_sw_atomic_write(struct xfs_inode *ip)
> +{
> +	if (IS_DAX(VFS_I(ip)))
> +		return false;
> +
> +	return xfs_can_sw_atomic_write(ip->i_mount);
> +}
> +
>  /*
>   * In-core inode flags.
>   */
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 01e597290eb5..b39a19dbc386 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -616,7 +616,8 @@ xfs_get_atomic_write_min(
>  	 * write of exactly one single fsblock if the bdev will make that
>  	 * guarantee for us.
>  	 */
> -	if (xfs_inode_can_hw_atomic_write(ip) || xfs_can_sw_atomic_write(mp))
> +	if (xfs_inode_can_hw_atomic_write(ip) ||
> +	    xfs_inode_can_sw_atomic_write(ip))
>  		return mp->m_sb.sb_blocksize;
>  
>  	return 0;
> @@ -633,7 +634,7 @@ xfs_get_atomic_write_max(
>  	 * write of exactly one single fsblock if the bdev will make that
>  	 * guarantee for us.
>  	 */
> -	if (!xfs_can_sw_atomic_write(mp)) {
> +	if (!xfs_inode_can_sw_atomic_write(ip)) {
>  		if (xfs_inode_can_hw_atomic_write(ip))
>  			return mp->m_sb.sb_blocksize;
>  		return 0;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0b690bc119d7..6a5543e08198 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -745,6 +745,12 @@ xfs_set_max_atomic_write_opt(
>  
>  	ASSERT(max_write <= U32_MAX);
>  
> +	if (xfs_has_dax_always(mp)) {
> +		xfs_warn(mp,
> + "atomic writes not supported for DAX");
> +		return -EINVAL;
> +	}
> +
>  	/* generic_atomic_write_valid enforces power of two length */
>  	if (!is_power_of_2(new_max_bytes)) {
>  		xfs_warn(mp,
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 97de44c32272..3c858b42a54a 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -474,11 +474,6 @@ static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
>  	return !xfs_has_zoned(mp);
>  }
>  
> -static inline bool xfs_can_sw_atomic_write(struct xfs_mount *mp)
> -{
> -	return xfs_has_reflink(mp);
> -}
> -
>  /*
>   * Some features are always on for v5 file systems, allow the compiler to
>   * eliminiate dead code when building without v4 support.
> @@ -534,6 +529,14 @@ __XFS_HAS_FEAT(dax_never, DAX_NEVER)
>  __XFS_HAS_FEAT(norecovery, NORECOVERY)
>  __XFS_HAS_FEAT(nouuid, NOUUID)
>  
> +static inline bool xfs_can_sw_atomic_write(struct xfs_mount *mp)
> +{
> +	if (xfs_has_dax_always(mp))
> +		return false;
> +
> +	return xfs_has_reflink(mp);
> +}
> +
>  /*
>   * Operational mount state flags
>   *
> -- 
> 2.43.5
> 
> 
