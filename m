Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6243785C
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 18:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786385630; cv=none; b=iLv4/hR0gH21+OWoLEk7J2fUZUWTeKqFN9tkIoUiNIsifmhuu3xpb2uSuRziV8YJQgh0BBAV2bGdF16Ro1VBOgRb9ZRhDcNaQ1ydAVnTv93wyLOOm2rCFttmFusm6YVRev/jKEUrU8VO0jGwehNORcXgQi8PsYMlnAjvLOD1mn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786385630; c=relaxed/simple;
	bh=5kvTFyR3rqD46p75KlVPXFpvzpbv0r4P+6Vt0/UIaMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5UCvYc0mDfmhIU7a4QLR+999Vf18cS2TnO1KilxGRybAXSI1vF6wtKXuWMbpcsyKhRzegmjFKZKfOh43Ws6hzY+04n7uYnl63i7ZfplOs2YnFc4N19AvRtPzWv2vulsCM9OXWSkqLc1NB5vHU+FvgBamhUER6tOHZV3aZowt5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5teae3+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5teae3+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D5F01F000E9;
	Mon, 10 Aug 2026 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786385629;
	bh=uM/VFBYTAfJTrgrM7JpOWtlxIId8oryQ/pgTt59f9Dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c5teae3+rJLRgf0HjtakyCZ53HR46G7s3rKMVp5cSGzYKCiFFWZDyUOx7WPk8T/XK
	 nLp1YeoyVoOGow9BtT2v+ZswAEYIMw7CaA3eRCNIGDTldOATzUtXZGWpQDU+eqhBGk
	 84t01s/b3GC3K+gdD5fnZv6gzGknFG3NgVlLxBB/izUIF+pMlqABHB6urNsz0hXNC1
	 nbR5AO+d/FkEZMXZ1eGCHvDEHwZxPFGZHXkFnJyEZAKBXXm7I5/igoGhNebKBDIsAB
	 jpz8C9dYwG5LOWpuv7J3CQLRxCeRetpScllheCnIQ7/w+v5+vv31IkF45CjcT6e2FM
	 dYI3iJHgINnZQ==
Date: Mon, 10 Aug 2026 11:13:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: factor out a xfs_iomap_set_anon_write helper
Message-ID: <20260810181348.GV3556460@frogsfrogsfrogs>
References: <20260810153759.466417-1-hch@lst.de>
 <20260810153759.466417-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810153759.466417-5-hch@lst.de>

On Mon, Aug 10, 2026 at 08:37:45AM -0700, Christoph Hellwig wrote:
> De-duplicate the iomap setup for zoned writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  |  8 ++------
>  fs/xfs/xfs_iomap.c |  6 +-----
>  fs/xfs/xfs_iomap.h | 14 ++++++++++++++
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9506cd8d15e6..d46b089f006a 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -633,12 +633,8 @@ xfs_zoned_map_blocks(
>  			XFS_BMAPI_REMAP);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
> -	wpc->iomap.type = IOMAP_MAPPED;
> -	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
> -	wpc->iomap.offset = offset;
> -	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
> -	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
> -
> +	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
> +			XFS_FSB_TO_B(mp, count_fsb));
>  	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 9fa9aa33745f..e87c26c3e03b 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1080,11 +1080,7 @@ xfs_zoned_direct_write_iomap_begin(
>  			return error;
>  	}
>  
> -	iomap->type = IOMAP_MAPPED;
> -	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
> -	iomap->offset = offset;
> -	iomap->length = length;
> -	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
> +	xfs_iomap_set_anon_write(ip, iomap, offset, length);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index ebcce7d49446..f697d7e73ab6 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -29,6 +29,20 @@ int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
>  int xfs_truncate_page(struct xfs_inode *ip, loff_t pos,
>  		struct xfs_zone_alloc_ctx *ac, bool *did_zero);
>  
> +static inline void
> +xfs_iomap_set_anon_write(
> +	struct xfs_inode		*ip,
> +	struct iomap			*iomap,
> +	loff_t				offset,
> +	loff_t				length)
> +{
> +	iomap->type = IOMAP_MAPPED;
> +	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;

/me wonders if this should use xfs_inode_buftarg() to avoid some logic
bomb, but that's sorta overkill since we can't ever do anonymous writes
to the data device.

As a straight hoist this is 100% correct so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	iomap->offset = offset;
> +	iomap->length = length;
> +	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
> +}
> +
>  static inline xfs_filblks_t
>  xfs_aligned_fsb_count(
>  	xfs_fileoff_t		offset_fsb,
> -- 
> 2.53.0
> 
> 
