Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9531BE251
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038674; cv=none; b=iIfdEmuLYUNkL8H5zCB7LUd+yCVyBF6sANExEmrWZMRJuE1/l0EKavmNycCG9lpSkAVn3I9W3UU/PRWRlJrYrK9NwMttHhlb+SMOI8xE4gCYEsQaVW4rUoyaZMfe1QR0xLDlYxpsOG+2MOkJmX44iUhuVLIqCRWmqz4q+bAGgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038674; c=relaxed/simple;
	bh=sekJ0eF4M4RvQUagGSqLkgyU+yc5cDAXLRruQies0qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRIgWciOy3/gSsLKDYlTVIOzsppa2I9MBwLQunHkQl4iiWK03BUcRyP/nyKC8cnDJ6SB7UjDjdO/dNmFPGhDVP/ZECBOuWwDrIMJI7jzOSnKwFNeCJ6b3KCvYMGFs4t/pGEcPJFgw85QMFBM5SiTh+b7eTra4dLSvcajh+yZtzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1U0isau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1U0isau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8748C4CECE;
	Thu, 12 Dec 2024 21:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038673;
	bh=sekJ0eF4M4RvQUagGSqLkgyU+yc5cDAXLRruQies0qQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t1U0isaupdWd6xIBdmyuHQFsb9PGe5Ky6uxbbdj+9TnlxaHyAqBzAvC/vCB3oxkqx
	 L/bg2gtlZuWjOg5whh7jkDG/QgyOiHvwHqQtE9bdonghytIeH4rRSHZvHF3RCKnN2L
	 LsASPiaWy5XLjehlxcwadgm1UGdNvjxZ4Pw1jjdcnmIXxlScLeXh7MfnEl+VFbSjdv
	 Drzhz/sLQSrEmtefrKuN7fcLf5VvIvI5bhldoPlci+nKvDlvr7k9eEFWPi2iLudf0a
	 yFpV0ax8s86kt6dXRLPkZ2Fqop29w7/ZBUUCBsX01AjgSwGvuiCSUpyEZhtyJarrzG
	 FgVUH5I6kMwaw==
Date: Thu, 12 Dec 2024 13:24:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/43] xfs: cleanup xfs_vn_getattr
Message-ID: <20241212212433.GS6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-8-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:32AM +0100, Christoph Hellwig wrote:
> Split the two bits of optional statx reporting into their own helpers
> so that they are self-contained instead of deeply indented in the main
> getattr handler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iops.c | 47 +++++++++++++++++++++++------------------------
>  1 file changed, 23 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 207e0dadffc3..6b0228a21617 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -573,17 +573,28 @@ xfs_stat_blksize(
>  }
>  
>  static void
> -xfs_get_atomic_write_attr(
> +xfs_report_dioalign(
>  	struct xfs_inode	*ip,
> -	unsigned int		*unit_min,
> -	unsigned int		*unit_max)
> +	struct kstat		*stat)
>  {
> -	if (!xfs_inode_can_atomicwrite(ip)) {
> -		*unit_min = *unit_max = 0;
> -		return;
> -	}
> +	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +	struct block_device	*bdev = target->bt_bdev;
>  
> -	*unit_min = *unit_max = ip->i_mount->m_sb.sb_blocksize;
> +	stat->result_mask |= STATX_DIOALIGN;
> +	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
> +	stat->dio_offset_align = bdev_logical_block_size(bdev);
> +}
> +
> +static void
> +xfs_report_atomic_write(
> +	struct xfs_inode	*ip,
> +	struct kstat		*stat)
> +{
> +	unsigned int		unit_min = 0, unit_max = 0;
> +
> +	if (xfs_inode_can_atomicwrite(ip))
> +		unit_min = unit_max = ip->i_mount->m_sb.sb_blocksize;
> +	generic_fill_statx_atomic_writes(stat, unit_min, unit_max);
>  }
>  
>  STATIC int
> @@ -647,22 +658,10 @@ xfs_vn_getattr(
>  		stat->rdev = inode->i_rdev;
>  		break;
>  	case S_IFREG:
> -		if (request_mask & STATX_DIOALIGN) {
> -			struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> -			struct block_device	*bdev = target->bt_bdev;
> -
> -			stat->result_mask |= STATX_DIOALIGN;
> -			stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
> -			stat->dio_offset_align = bdev_logical_block_size(bdev);
> -		}
> -		if (request_mask & STATX_WRITE_ATOMIC) {
> -			unsigned int	unit_min, unit_max;
> -
> -			xfs_get_atomic_write_attr(ip, &unit_min,
> -					&unit_max);
> -			generic_fill_statx_atomic_writes(stat,
> -					unit_min, unit_max);
> -		}
> +		if (request_mask & STATX_DIOALIGN)
> +			xfs_report_dioalign(ip, stat);
> +		if (request_mask & STATX_WRITE_ATOMIC)
> +			xfs_report_atomic_write(ip, stat);
>  		fallthrough;
>  	default:
>  		stat->blksize = xfs_stat_blksize(ip);
> -- 
> 2.45.2
> 
> 
