Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED62C21CF;
	Fri, 14 Nov 2025 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139843; cv=none; b=COjMKBiAk4aGDSnSI2qrFFYY2P0oFlo5deir60+U/kV4i2lQOEUuQmuLHieTx77GZC9egC1I1vT3K+mQalqBjLcJi7aQ1DBFRMU31SFsXfEF2dkwJanfUJvOpBy98frqrWzf5cB3DFFK51i9EthtZf8u7ilzvHiOYErdCSDS2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139843; c=relaxed/simple;
	bh=zHnzkeAXG8r0TS4i51hfqGo5aCCLom/pjYdhEKjIo3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z04WDJIsw45s/iPMHBG5aJ2GPu15MkrcXDopmtwpM+MY7Ojr/2QnVQNbdSJgxG2FF5NcIAtxKSoXV3BB0nkHfIqu9lfsyo1H2FC9tqvmBIlUx6TIleDLfAuO0O+DaonlZMn2XFR0nvRwu6Vw/M8MmJKkJcWfTpuaw0Q6z9Jt8mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SF4FdfPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SF4FdfPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8898C4CEF1;
	Fri, 14 Nov 2025 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139843;
	bh=zHnzkeAXG8r0TS4i51hfqGo5aCCLom/pjYdhEKjIo3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SF4FdfPBAeMJGDK5nHE+TX9Sqn5teUpBH0eDnHcfs8MTGp18QoHx+3dVCiqaz9uTl
	 nG5uoTbYHmHDP/0KKfm+cG47bamDdDIV++iXKaB2ASakuaqxJmuz+IfzQtJJOBKT4Y
	 PjkIAQRrzw+h0LYSK7RbrmIQ8Rc9EidqLQJFZCEMQqyEyT7COyKo7lCHPE5pIqFO+x
	 frQk1C9OChiVl1vbMuLzEZSoqZBfS2GEl6JqneZcg2IbNG7uZ2lQUdMgHBqMMMlGZT
	 6s7Qb4eYb9TI1FjveCfyYbCv/VjAogznMCb2Hfdv2SZOxFl2F2STydsYizxZ8IzW/U
	 GeGMvasQwHCYQ==
Date: Fri, 14 Nov 2025 09:04:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: move some code out of xfs_iget_recycle
Message-ID: <20251114170402.GJ196370@frogsfrogsfrogs>
References: <20251114055249.1517520-1-hch@lst.de>
 <20251114055249.1517520-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114055249.1517520-3-hch@lst.de>

On Fri, Nov 14, 2025 at 06:52:24AM +0100, Christoph Hellwig wrote:
> Having a function drop locks, reacquire them and release them again
> seems to confuse the clang lock analysis even more than it confuses
> humans.  Keep the humans and machines sanity by moving a chunk of
> code into the caller to simplify the lock tracking.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e44040206851..546efa6cec72 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -358,7 +358,7 @@ xfs_reinit_inode(
>  static int
>  xfs_iget_recycle(
>  	struct xfs_perag	*pag,
> -	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> @@ -366,20 +366,6 @@ xfs_iget_recycle(
>  
>  	trace_xfs_iget_recycle(ip);
>  
> -	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> -		return -EAGAIN;
> -
> -	/*
> -	 * We need to make it look like the inode is being reclaimed to prevent
> -	 * the actual reclaim workers from stomping over us while we recycle
> -	 * the inode.  We can't clear the radix tree tag yet as it requires
> -	 * pag_ici_lock to be held exclusive.
> -	 */
> -	ip->i_flags |= XFS_IRECLAIM;
> -
> -	spin_unlock(&ip->i_flags_lock);
> -	rcu_read_unlock();
> -
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	error = xfs_reinit_inode(mp, inode);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -576,10 +562,19 @@ xfs_iget_cache_hit(
>  
>  	/* The inode fits the selection criteria; process it. */
>  	if (ip->i_flags & XFS_IRECLAIMABLE) {
> -		/* Drops i_flags_lock and RCU read lock. */
> -		error = xfs_iget_recycle(pag, ip);
> -		if (error == -EAGAIN)
> +		/*
> +		 * We need to make it look like the inode is being reclaimed to
> +		 * prevent the actual reclaim workers from stomping over us
> +		 * while we recycle the inode.  We can't clear the radix tree
> +		 * tag yet as it requires pag_ici_lock to be held exclusive.
> +		 */
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  			goto out_skip;
> +		ip->i_flags |= XFS_IRECLAIM;
> +		spin_unlock(&ip->i_flags_lock);
> +		rcu_read_unlock();

I wonder, does sparse get confused by rcu_read_lock having been taken by
the caller but unlocked here?

The code move looks correct though.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> +
> +		error = xfs_iget_recycle(pag, ip);
>  		if (error)
>  			return error;
>  	} else {
> -- 
> 2.47.3
> 
> 
