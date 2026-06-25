Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F22A28B4FA
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408008; cv=none; b=jwNuhvzor0AZZCq4WC1LcH0DMPe9+2hoVyHK4LmuIEP6/Kq35Qs/+Cfqq237xiOwdIUsAGzDf5OVg6tYAuXcoFJGAHX8JXLbrP7JkA14VK1K7fzVd4SJZqdhh8Jzna8x/ctzXZAc7Mxq4iQ4HMVVVdLDT7nCA1hRSN4p7UpAiBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408008; c=relaxed/simple;
	bh=vix9C27NYHmvnnV20UdlhZy8VJ2HhVbXxJdBBW5d1vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8EMJ4fWuzm82h6e0fIP2jx4hnNsXXvJEtIk+X5D+Jp4s9vGgXaAJyWqNn/cROgACK5Ztc8wEdFH890GiXTumpK97AOIpz4UxcEY+9fLqGu6ELZ6iKfzeRjdwvP828ZUbmFv12qJeZUhs9CVB2l3QQc6oTJfcPoRmVIblsMJx2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBiVXPLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBiVXPLG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 933031F000E9;
	Thu, 25 Jun 2026 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782408006;
	bh=Zh1WabjSFuCRgWfQ4rVpfHGNYtzxuG+yeBUgpcsd+xI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WBiVXPLGi9xcms7n4ZbCrKxzQy97WhCsxwUeRDF4bqDroChr2ZxcigjEREJHHDR1G
	 3DfBP4h/pRFXjRe6MET9FzTAmPxIVq37hX+pmfQRrsJKuLMRhIN/zTroeXa/moEWPl
	 iUFzPoFkFNPdV0f7jDyP9joD/Ybs3LIMgFCfIo6N4knSlpfJ9Rl+emDPr3wlE7CIJc
	 JrJSQKcmIZ2lMtKS2mJLBC/AaNzIMIwgAuRZH+YHAIVqFrMWkRbcMCmK3PRZF8t1TD
	 SjzglQC8sBb65ELDgVRnyAsfBh6wNeb+xP87HNGxaWr6BydN6i5S1nc9m7Nf1OnZfw
	 d2mMOBcX5Uyzg==
Date: Thu, 25 Jun 2026 10:20:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	dgc@kernel.org, gost.dev@samsung.com,
	Zhang Yi <yi.zhang@huaweicloud.com>, pankaj.raghav@linux.dev,
	andres@anarazel.de, kundan.kumar@samsung.com, hch@lst.de,
	cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v8 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <20260625172006.GC6078@frogsfrogsfrogs>
References: <20260625114550.4109104-1-p.raghav@samsung.com>
 <20260625114550.4109104-3-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625114550.4109104-3-p.raghav@samsung.com>

On Thu, Jun 25, 2026 at 01:45:50PM +0200, Pankaj Raghav wrote:
> If the underlying block device supports the unmap write zeroes
> operation, this flag allows users to quickly preallocate a file with
> written extents that contain zeroes. This is beneficial for subsequent
> overwrites as it prevents the need for unwritten-to-written extent
> conversions, thereby significantly reducing metadata updates and journal
> I/O overhead, improving overwrite performance.
> 
> Punch the range first so it becomes a hole, update the size via
> xfs_falloc_setsize() while it is still a hole (so its xfs_zero_range()
> skips it and avoids rezeroing), then convert it to written
> zeroed extents. A crash between the size update and the conversion is
> safe, as a hole within i_size reads back as zeroes.
> 
> Co-developed-by: Lukas Herbolt <lukas@herbolt.com>
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 19 ++++++++--
>  fs/xfs/xfs_bmap_util.h |  1 +
>  fs/xfs/xfs_file.c      | 78 +++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 94 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e5424d010a69..855602cb35e8 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -643,11 +643,18 @@ xfs_free_eofblocks(
>  }
>  
>  /*
> - * Allocate space for a file according to @mode:
> + * Allocate space or convert extents for a file according to @mode:
>   *
>   * XFS_ALLOC_FILE_SPACE_PREALLOC:
>   * Preallocate unwritten extents over holes across the range and mark the inode
>   * as preallocated.
> + *
> + * XFS_ALLOC_FILE_SPACE_WRITE_ZEROES:
> + * Allocate written extents over holes and convert unwritten extents in the
> + * range to written extents, initialising both to contain zeroes.
> + *
> + * This function does not update the file size; callers that extend the file
> + * are responsible for updating it once the extents are allocated.
>   */
>  int
>  xfs_alloc_file_space(
> @@ -688,6 +695,10 @@ xfs_alloc_file_space(
>  		bmapi_flags = XFS_BMAPI_PREALLOC;
>  		nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
>  		break;
> +	case XFS_ALLOC_FILE_SPACE_WRITE_ZEROES:
> +		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
> +		nr_exts = XFS_IEXT_WRITE_UNWRITTEN_CNT;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -776,8 +787,10 @@ xfs_alloc_file_space(
>  			allocatesize_fsb -= imapp->br_blockcount;
>  		}
>  
> -		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> -		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +		if (mode == XFS_ALLOC_FILE_SPACE_PREALLOC) {
> +			ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> +			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +		}
>  
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 232b4c48247e..e3d506ca9610 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -57,6 +57,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  /* preallocation and hole punch interface */
>  enum xfs_alloc_file_space_mode {
>  	XFS_ALLOC_FILE_SPACE_PREALLOC,
> +	XFS_ALLOC_FILE_SPACE_WRITE_ZEROES,
>  };
>  
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e90ea6ebdc8e..5dcb03e6de12 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1368,6 +1368,79 @@ xfs_falloc_force_zero(
>  	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
>  }
>  
> +static int
> +xfs_falloc_write_zeroes(
> +	struct file		*file,
> +	int			mode,
> +	loff_t			offset,
> +	loff_t			len,
> +	struct xfs_zone_alloc_ctx *ac)
> +{
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	loff_t			new_size = 0;
> +	int			error;
> +
> +	if (xfs_is_always_cow_inode(ip) ||
> +	    !bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 *
> +	 *    |----------|----------|----------|----------|----------|
> +	 *    ^     ^    ^                     ^     ^    ^
> +	 *    |     |    |                     |     |    |
> +	 *    |   offset |                     |    end   |
> +	 *    |          |                     |          |
> +	 * offset_rd   offset_ru              end_rd    end_ru

Do "_rd" and "_ru" mean "round down" and "round up"?  And is that to the
fsblock size, or the allocation unit size?

> +	 *
> +	 * xfs_free_file_space() punches the aligned interior offset_ru -> end_rd
> +	 * to holes and byte-zeroes the in-range parts of the partial edge blocks,

xfs_free_file_space rounds inward to allocation unit granularity and
punches out that range; and then it writes zeroes to non-hole space
that doesn't get unmapped.

> +	 * offset -> offset_ru and end_rd -> end.  xfs_zero_range() only touches
> +	 * already-written blocks here; it skips holes and unwritten extents, so
> +	 * unallocated/unwritten edge blocks are left for the allocation below.
> +	 */
> +	error = xfs_free_file_space(ip, offset, len, ac);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Publish the new size while the punched range is still a hole, then
> +	 * fill it with written zeroes.  Like the other fallocate modes we use
> +	 * xfs_falloc_setsize(), but it must run *before* we convert the range
> +	 * to written extents: xfs_setattr_size() zeroes [old EOF, new size) via
> +	 * xfs_zero_range(), which skips holes, so there is nothing to re-zero.
> +	 * It will also writeback partial EOF block before the on-disk size is
> +	 * logged.
> +	 * Note: extending the size before allocating means a failure below
> +	 * leaves the file larger with unallocated holes in the new range.
> +	 * That is safe as holes within i_size read back as zeroes and expose
> +	 * no stale data while the error is propagated to the caller.
> +	 */
> +	error = xfs_falloc_setsize(file, new_size);
> +	if (error)
> +		return error;

Hrm ok so now that we've punched out some blocks and zeroed the rest,
now we adjust the file size, which should only entail committing the new
file size to disk...

> +
> +	/*
> +	 * Allocate written, zeroed extents across the range.  xfs_alloc_file_space()
> +	 * rounds outward to block granularity:
> +	 *  - holes (the punched interior and any unallocated edge block) are
> +	 *    allocated and zeroed;
> +	 *  - unwritten extents (including unwritten edge blocks) are converted to
> +	 *    written and zeroed;
> +	 *  - Already written edge blocks are skipped. The out-of-range bytes of
> +	 *    a written edge block keep their data (offset_rd -> offset and
> +	 *    end -> end_rd); their in-range bytes (offset -> offset_ru and
> +	 *    end_ru -> end were already zeroed by xfs_free_file_space().
> +	 */
> +	return xfs_alloc_file_space(ip, offset, len,
> +			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);

...and now we can just do an accelerated "write zeroes to disk" which is
conveniently always within EOF now.  I /think/ this looks ok to me now,
though I'm curious how extensively the new fallocate mode has been
tested with fsx and unaligned file ranges?  And rt volumes with rt
extent size > 1 fsblock.

--D

> +}
> +
>  /*
>   * Punch a hole and prealloc the range.  We use a hole punch rather than
>   * unwritten extent conversion for two reasons:
> @@ -1473,7 +1546,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1525,6 +1598,9 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_ALLOCATE_RANGE:
>  		error = xfs_falloc_allocate_range(file, mode, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
> +		error = xfs_falloc_write_zeroes(file, mode, offset, len, ac);
> +		break;
>  	default:
>  		error = -EOPNOTSUPP;
>  		break;
> -- 
> 2.51.2
> 
> 
