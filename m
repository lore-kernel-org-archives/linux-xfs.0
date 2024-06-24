Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94D71EB48
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243326; cv=none; b=PhIMV42LCsff9v1N9OkK17aeC9aeeZ8j9oOnaIYMMd3Xg/WSY3L4hhAMRaiZAt21YXkHwm+QayKh11nCeiflm0QtTc301V+xkVRqwYaxOts83VtcJ40O9mCrAYW4gStTRn0YI4cvGkWF54lJEJZMjgeOb1bp4eVVi/z7RxB4bEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243326; c=relaxed/simple;
	bh=Gv4w0ty2lhvvfy5zU9vDqlL091Uzl5VY6N2V4w/M7RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PifbOb8oXmU3HBhN23GmIIAxwsRWrrozkSkrSby5cCtBPGREe+UAZe0n3IYVLc4yJHH+DacvhsHE1yR4dGFeAJVLe2HjSxYhLxjeWORolEMUoC3bOjonChy34X7q1DUvqD5JggocF9Bn59vyxwZIDPTQfs+wtbf/clARFoeoQgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTJ5mEdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTJ5mEdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57638C2BBFC;
	Mon, 24 Jun 2024 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243326;
	bh=Gv4w0ty2lhvvfy5zU9vDqlL091Uzl5VY6N2V4w/M7RI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UTJ5mEdZJt8C69lZyaVuIMx4iwvQRiUUkf2XWRADjE6/cTei7pVxtG5qaq4rjiQv2
	 zzYeCqMXe6kKrjw/FjTk9uH/5wiLTwHqKKI5G8fJXcZKWK1VC2JFEtWJm/PLY985Ah
	 Wv5bBwsz7tghdw2Lzhl1rHY53lGgtZf6X+aHemFJpYTmd2BTJbPdQGwgLV1CmtAxaM
	 rOoZ2Ssou73a1iBuFSZXdoXjZyuDwyWxIEHH6ruIcQGdV3MbSSJZOEWS2o7xksvxSi
	 E5s6g1FucOJs2Vf0As+QGMR5Y1/l7Lwq6Q6b7FBwz1ZLryZ6Z51WaEHkSkoOa+Rq9H
	 AMkr3eO7Q9dHQ==
Date: Mon, 24 Jun 2024 08:35:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: refactor f_op->release handling
Message-ID: <20240624153525.GG3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-4-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:48AM +0200, Christoph Hellwig wrote:
> Currently f_op->release is split in not very obvious ways.  Fix that by
> folding xfs_release into xfs_file_release.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward hoist, looks like
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  | 71 +++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_inode.c | 79 ----------------------------------------------
>  fs/xfs/xfs_inode.h |  1 -
>  3 files changed, 68 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b240ea5241dc9d..d39d0ea522d1c2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1188,10 +1188,75 @@ xfs_dir_open(
>  
>  STATIC int
>  xfs_file_release(
> -	struct inode	*inode,
> -	struct file	*filp)
> +	struct inode		*inode,
> +	struct file		*file)
>  {
> -	return xfs_release(XFS_I(inode));
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
> +
> +	/* If this is a read-only mount, don't generate I/O */
> +	if (xfs_is_readonly(mp))
> +		return 0;
> +
> +	/*
> +	 * If we previously truncated this file and removed old data in the
> +	 * process, we want to initiate "early" writeout on the last close.
> +	 * This is an attempt to combat the notorious NULL files problem which
> +	 * is particularly noticeable from a truncate down, buffered (re-)write
> +	 * (delalloc), followed by a crash.  What we are effectively doing here
> +	 * is significantly reducing the time window where we'd otherwise be
> +	 * exposed to that problem.
> +	 */
> +	if (!xfs_is_shutdown(mp) &&
> +	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
> +		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> +		if (ip->i_delayed_blks > 0) {
> +			error = filemap_flush(inode->i_mapping);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	/*
> +	 * XFS aggressively preallocates post-EOF space to generate contiguous
> +	 * allocations for writers that append to the end of the file and we
> +	 * try to free these when an open file context is released.
> +	 *
> +	 * There is no point in freeing blocks here for open but unlinked files
> +	 * as they will be taken care of by the inactivation path soon.
> +	 *
> +	 * If we can't get the iolock just skip truncating the blocks past EOF
> +	 * because we could deadlock with the mmap_lock otherwise. We'll get
> +	 * another chance to drop them once the last reference to the inode is
> +	 * dropped, so we'll never leak blocks permanently.
> +	 */
> +	if (inode->i_nlink && xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +		if (xfs_can_free_eofblocks(ip) &&
> +		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
> +			/*
> +			 * Check if the inode is being opened, written and
> +			 * closed frequently and we have delayed allocation
> +			 * blocks outstanding (e.g. streaming writes from the
> +			 * NFS server), truncating the blocks past EOF will
> +			 * cause fragmentation to occur.
> +			 *
> +			 * In this case don't do the truncation, but we have to
> +			 * be careful how we detect this case. Blocks beyond EOF
> +			 * show up as i_delayed_blks even when the inode is
> +			 * clean, so we need to truncate them away first before
> +			 * checking for a dirty release. Hence on the first
> +			 * dirty close we will still remove the speculative
> +			 * allocation, but after that we will leave it in place.
> +			 */
> +			error = xfs_free_eofblocks(ip);
> +			if (!error && ip->i_delayed_blks)
> +				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> +		}
> +		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	}
> +
> +	return error;
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9a9340aebe9d8a..fe4906a08665ee 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1545,85 +1545,6 @@ xfs_itruncate_extents_flags(
>  	return error;
>  }
>  
> -int
> -xfs_release(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_mount_t	*mp = ip->i_mount;
> -	int		error = 0;
> -
> -	/* If this is a read-only mount, don't do this (would generate I/O) */
> -	if (xfs_is_readonly(mp))
> -		return 0;
> -
> -	if (!xfs_is_shutdown(mp)) {
> -		int truncated;
> -
> -		/*
> -		 * If we previously truncated this file and removed old data
> -		 * in the process, we want to initiate "early" writeout on
> -		 * the last close.  This is an attempt to combat the notorious
> -		 * NULL files problem which is particularly noticeable from a
> -		 * truncate down, buffered (re-)write (delalloc), followed by
> -		 * a crash.  What we are effectively doing here is
> -		 * significantly reducing the time window where we'd otherwise
> -		 * be exposed to that problem.
> -		 */
> -		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
> -		if (truncated) {
> -			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> -			if (ip->i_delayed_blks > 0) {
> -				error = filemap_flush(VFS_I(ip)->i_mapping);
> -				if (error)
> -					return error;
> -			}
> -		}
> -	}
> -
> -	if (VFS_I(ip)->i_nlink == 0)
> -		return 0;
> -
> -	/*
> -	 * If we can't get the iolock just skip truncating the blocks past EOF
> -	 * because we could deadlock with the mmap_lock otherwise. We'll get
> -	 * another chance to drop them once the last reference to the inode is
> -	 * dropped, so we'll never leak blocks permanently.
> -	 */
> -	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
> -		return 0;
> -
> -	if (xfs_can_free_eofblocks(ip)) {
> -		/*
> -		 * Check if the inode is being opened, written and closed
> -		 * frequently and we have delayed allocation blocks outstanding
> -		 * (e.g. streaming writes from the NFS server), truncating the
> -		 * blocks past EOF will cause fragmentation to occur.
> -		 *
> -		 * In this case don't do the truncation, but we have to be
> -		 * careful how we detect this case. Blocks beyond EOF show up as
> -		 * i_delayed_blks even when the inode is clean, so we need to
> -		 * truncate them away first before checking for a dirty release.
> -		 * Hence on the first dirty close we will still remove the
> -		 * speculative allocation, but after that we will leave it in
> -		 * place.
> -		 */
> -		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
> -			goto out_unlock;
> -
> -		error = xfs_free_eofblocks(ip);
> -		if (error)
> -			goto out_unlock;
> -
> -		/* delalloc blocks after truncation means it really is dirty */
> -		if (ip->i_delayed_blks)
> -			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> -	}
> -
> -out_unlock:
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> -	return error;
> -}
> -
>  /*
>   * Mark all the buffers attached to this directory stale.  In theory we should
>   * never be freeing a directory with any blocks at all, but this covers the
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 292b90b5f2ac84..ae9851226f9913 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -513,7 +513,6 @@ enum layout_break_reason {
>  #define XFS_INHERIT_GID(pip)	\
>  	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
>  
> -int		xfs_release(struct xfs_inode *ip);
>  int		xfs_inactive(struct xfs_inode *ip);
>  int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
>  			   struct xfs_inode **ipp, struct xfs_name *ci_name);
> -- 
> 2.43.0
> 
> 
