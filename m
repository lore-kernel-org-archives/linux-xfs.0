Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B741E4A2
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706089; cv=none; b=uEJj9vLq72QCRQR5FRLjZ5Lx2dpTE1rHf4mIo7Nl7HFcWJlqwERc3jSxG6EXr4kCmKCZX7oNi0wpxsT+9llS9Si96jQXaaCtcY4yZ+XKTmxjTCEF6enRLAZgwxRW1OtwDYv4YTmUi+6PHNKlQaxCf6uP+s9o0g8Tcq/XwNSfz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706089; c=relaxed/simple;
	bh=yC2FzPQjkMwQ/Kks2y2GHOLa8zTxmPnCnUhPyp3ol/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DN31oR96GKIM7XNZ6JNagwu8LBfSR40BlnCw2M+pirRGdIoadFoGcD3ibitqEW+LjviIMGpVPs1S1UAoQ3qetn9FBO61wW5LK//GHZVyIGwXT9tQMGwnM0XLY3ejMUFp8zHvP/VwOBEkXbXnGEz5xI05Rp0dsBigpbtiNwOXxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSDQSTHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSDQSTHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3F9C433F1;
	Fri, 23 Feb 2024 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708706088;
	bh=yC2FzPQjkMwQ/Kks2y2GHOLa8zTxmPnCnUhPyp3ol/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSDQSTHgUkN0+I6hUtJ6QiAfgWh3AO93SnrDa4Y9CGGAlWAm4bKW51BjMHhqgq3qz
	 VHSIMlS3OyfLgYzRCd/uTulcAyIb08bojbETK/+2d5VQWBi0hoEz/TSqpZ90sI+ojV
	 LgYdKcic8kJ0uX8qe9dPPnbkLMRmyKO9w4r7xpGBjuOAE+zcE7ggeO53q8DErVPOG3
	 CdG1WXJJOWatgVDmffZA9wPzMV85LzrghYBbAQiB/s+a6iUd7/qIHLKNqR+v/GB3B3
	 UHMjXAiHyPLZPh769MicRdw+vy+exXjry3FwVKpR6mlxMvV9EC++Pxmrgq/LVPisex
	 Uu0IGaXYe8MHQ==
Date: Fri, 23 Feb 2024 08:34:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240223163448.GN616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-3-hch@lst.de>

On Fri, Feb 23, 2024 at 08:14:58AM +0100, Christoph Hellwig wrote:
> __xfs_bunmapi is a bit of an odd place to lock the rtbitmap and rtsummary
> inodes given that it is very high level code.  While this only looks ugly
> right now, it will become a problem when supporting delayed allocations
> for RT inodes as __xfs_bunmapi might end up deleting only delalloc extents
> and thus never unlock the rt inodes.
> 
> Move the locking into xfs_rtfree_blocks instead (where it will also be
> helpful once we support extfree items for RT allocations), and use a new
> flag in the transaction to ensure they aren't locked twice.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c     | 10 ----------
>  fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
>  fs/xfs/libxfs/xfs_shared.h   |  3 +++
>  3 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b525524a2da4ef..f8cc7c510d7bd5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5321,16 +5321,6 @@ __xfs_bunmapi(
>  	} else
>  		cur = NULL;
>  
> -	if (isrt) {
> -		/*
> -		 * Synchronize by locking the bitmap inode.
> -		 */
> -		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> -		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> -		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> -		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> -	}
> -
>  	extno = 0;
>  	while (end != (xfs_fileoff_t)-1 && end >= start &&
>  	       (nexts == 0 || extno < nexts)) {
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index e31663cb7b4349..2759c48390241d 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1001,6 +1001,20 @@ xfs_rtfree_blocks(
>  		return -EIO;
>  	}
>  
> +	/*
> +	 * Ensure the bitmap and summary inodes are locked before modifying
> +	 * them.  We can get called multiples times per transaction, so record
> +	 * the fact that they are locked in the transaction.
> +	 */
> +	if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
> +		tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;

I don't really like using transaction flags to record lock state.

Would this be cleaner if we tracked this in struct xfs_rtalloc_args, and
had an xfs_rtalloc_acquire(mp, &args, XFS_ILOCK_{SHARED,EXCL}) method
that would set that up for us?

--D

> +
> +		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> +		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> +		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> +	}
> +
>  	return xfs_rtfree_extent(tp, start, len);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 6f1cedb850eb39..1598ff00f6805f 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -83,6 +83,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   */
>  #define XFS_TRANS_LOWMODE		(1u << 8)
>  
> +/* Transaction has locked the rtbitmap and rtsum inodes */
> +#define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
> +
>  /*
>   * Field values for xfs_trans_mod_sb.
>   */
> -- 
> 2.39.2
> 
> 
