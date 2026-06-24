Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A0A351C34;
	Wed, 24 Jun 2026 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322533; cv=none; b=qKe7WBWm/KjP7MMpjGkGHe96qWaW1MSFrQjMTlyGI6KhuIMbI7PK5p0EWh6+BF05j3+oYya/RdLxSvWngRzSe2NSKxOwfQ87l9NYQID7idZSoCZMnFiB/cJQ2iFt8w3gtmNoM064oT+95rJfjRMcVG+wNu2bDVV0KZzr5fNtovY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322533; c=relaxed/simple;
	bh=7Ef+VsGjEVFgc4Kb5oPmnN7IysInig3eEG/2dAOFhFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMKxhv4gjT+yxlClwvjiNWpSv9AOaGWdxCP4c/8Glaq4mGNy5RMZeTZLvChoR8YDlw/VPwDYsq4rkXXiZuAlHgKwc0l8nVFWykVeSIWDD8hEIdJHVzj4W0/emoWFPw+3kP28VFaLKDzhkhAl4EcuDv0EBt63xcLTpmreP2q/QqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiD/GPxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiD/GPxl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 497EA1F000E9;
	Wed, 24 Jun 2026 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782322532;
	bh=jS1aUzJc6zIMl1Wrin/GcUTD8Xk4H7arfcgVQuP3m90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PiD/GPxlr0ooeGWQs1u4VaLx14lwYDhPVW76lQourK0LD2iCnkiGZBWylpGhm3OMM
	 zzrz3a4MYcs0INQ8GAILLxU/wC+LMSE+p6fv0Cv87X6K1X86kz59XdQqPcMY2dBSxe
	 eDlfJCMM2q3aWE9w1CqP/DyXjMRv+sauwhuJk+MHuHbzkxOR/yGICEIC+y+VXco0KM
	 M9cEMbx0M6NUNvWYsayJiIrDg/Y8xZRKcpPhOEXe29NlHqksYxh2o0Xwy0lz5WszXg
	 Bt2zJnVRrlxR3fy8jaln+yimRjd6LeE+nUMt7GnO2g1GbKx0eYoPb1UkZ8JdCChoV0
	 5Q7jCmLFCKlMQ==
Date: Wed, 24 Jun 2026 10:35:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <20260624173531.GQ6078@frogsfrogsfrogs>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616053850.2188-3-aditya.ansh182@gmail.com>

On Tue, Jun 16, 2026 at 05:38:50AM +0000, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> When a file with active speculative post-EOF preallocations is closed,
> xfs_file_release() synchronously triggers xfs_free_eofblocks() to clean
> them up. This requires allocating a write transaction (xfs_trans_alloc),
> which blocks indefinitely if the filesystem is currently frozen or in the
> process of freezing, as it waits to acquire the superblock's write lock.
> 
> As a result, a close() system call on a read-write file descriptor can
> hang indefinitely in percpu_rwsem_wait() until the filesystem is thawed,
> even if the file is closed by a non-writer process or after all writing
> activity has already ceased.
> 
> To fix this properly and avoid any potential race conditions where a freeze
> might come in immediately after a writable check, pass the new
> XFS_TRANS_WRITECOUNT_TRYLOCK flag to xfs_trans_alloc() when freeing
> speculative preallocations in xfs_file_release().
> 
> If xfs_free_eofblocks() returns -EAGAIN on a trylock failure, we cleanly
> bypass setting XFS_EOFBLOCKS_RELEASED on the inode, ensuring subsequent
> releases or the background blockgc garbage collector can successfully retry
> the cleanup once the filesystem thaws.
> 
> Also, add the new trans_flags parameter to xfs_free_eofblocks() to make
> its usage stand out, and update existing callers to pass 0 to preserve
> standard blocking paths.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 10 ++++++----
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_file.c      |  8 +++++---
>  fs/xfs/xfs_icache.c    |  2 +-
>  fs/xfs/xfs_inode.c     |  2 +-
>  5 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..a99aae4a1631 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
>   */
>  int
>  xfs_free_eofblocks(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	uint			trans_flags)
>  {
>  	struct xfs_trans	*tp;
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -604,9 +605,10 @@ xfs_free_eofblocks(
>  		return 0;
>  	}
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0,
> +				trans_flags, &tp);
>  	if (error) {
> -		ASSERT(xfs_is_shutdown(mp));
> +		ASSERT(error == -EAGAIN || xfs_is_shutdown(mp));
>  		return error;
>  	}
>  
> @@ -928,7 +930,7 @@ xfs_prepare_shift(
>  	 * into the accessible region of the file.
>  	 */
>  	if (xfs_can_free_eofblocks(ip)) {
> -		error = xfs_free_eofblocks(ip);
> +		error = xfs_free_eofblocks(ip, 0);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..c13774aa0892 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -66,7 +66,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
>  
>  /* EOF block manipulation functions */
>  bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
> -int	xfs_free_eofblocks(struct xfs_inode *ip);
> +int	xfs_free_eofblocks(struct xfs_inode *ip, uint trans_flags);
>  
>  int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
>  			 struct xfs_swapext *sx);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..76c9b2fe7c51 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1806,9 +1806,11 @@ xfs_file_release(
>  	 */
>  	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> -			xfs_free_eofblocks(ip);
> +		if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> +		    xfs_can_free_eofblocks(ip) &&
> +		    !xfs_free_eofblocks(ip, XFS_TRANS_WRITECOUNT_TRYLOCK))
> +			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);

Could you prevent the close() stalls by surrounding this with
sb_start_write_trylock instead of passing transaction allocation flags
all the way down?

OFC that results in a messy if test:

		if (xfs_can_free_eofblocks(...) &&
		    !xfs_iflags_test(...RELEASED) &&
		    !sb_start_write_trylock(...)) {
			if (!xfs_iflags_test_and_set(...))
				xfs_free_eofblocks(ip);
			sb_end_write(...);
		}

<shrug> Sorry if this is noise, I've been on vacation.

--D

> +
>  		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	}
>  
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2040a9292ee6..c575b4acb24c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1259,7 +1259,7 @@ xfs_inode_free_eofblocks(
>  	*lockflags |= XFS_IOLOCK_EXCL;
>  
>  	if (xfs_can_free_eofblocks(ip))
> -		return xfs_free_eofblocks(ip);
> +		return xfs_free_eofblocks(ip, 0);
>  
>  	/* inode could be preallocated */
>  	trace_xfs_inode_free_eofblocks_invalid(ip);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ddf2707c8894..14d3cd04a79f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1423,7 +1423,7 @@ xfs_inactive(
>  		 * reference to the inode at this point anyways.
>  		 */
>  		if (xfs_can_free_eofblocks(ip))
> -			error = xfs_free_eofblocks(ip);
> +			error = xfs_free_eofblocks(ip, 0);
>  
>  		goto out;
>  	}
> -- 
> 2.47.3
> 
> 
