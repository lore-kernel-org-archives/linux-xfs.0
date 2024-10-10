Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BE91CDFD1;
	Thu, 10 Oct 2024 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728585288; cv=none; b=n1kyX3h+CEZaNd6VdKSANikQmnqmfJky5Lu5Ej93etQNAipBzrppjQMGvuEwRUCdxp2EwRgZWoMHxPvTqH8aAMbmvzNa0SXLS9ul3j/xXYp3F/OBBDiy+ft1l1fO/CdojT7c6VoNy2IhI1AWsKIT+NyL0WNrZl6KEbuHO0a3jjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728585288; c=relaxed/simple;
	bh=O58ekROBdmY/vq3y4FFQCY46xDbcUzaQxRhSDfTEe80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDFPAdBbU6TkayAWk8Thm07V++na9m2kMmVgoidnY8SeKSz2fHwX8fk0aG/1t3ZBu+6PaUnpxlNyzwvDZcC2XOuRAYMzfho3H+LVAFM/j/mSp/CYvECYZsYQrXOvfSK8RfMXnWDHqKQKUKoxOrF8mai6KsU73d1MgzXAp/Vh4O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6MAJpbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6MAJpbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B408FC4CEC5;
	Thu, 10 Oct 2024 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728585287;
	bh=O58ekROBdmY/vq3y4FFQCY46xDbcUzaQxRhSDfTEe80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6MAJpbXJ/juYrXizFel7RzMYghxOCR6haXiKl++BBL1PkhuXaOfzOR7BkaJswYdL
	 2cNw6BlM+mRikySaqUIUY+o0st+xaVp2FPLbnmhI08tnjLIeiSHZZpO82w/MCDOSPR
	 nYiqlV6gOti9GQ7S4CKfOB/zGiqEXDMGCnpHt5Qz90DlHQcDOdSnhwH9qWMG8rU6/Q
	 cxnN4Wj0XaEykjCEuEFcvwYo1czGYM2uU7k9z17youb0vmHW89ljp+cw6B0ekFLCVC
	 +qNy4Pne4u51covv7UHDyL6Ji6WRVsnJNUrXg7RrG1pFp5QNgU2FDbHxBDIFDOuHiK
	 qmCcCAd6Yk/GA==
Date: Thu, 10 Oct 2024 11:34:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org, dchinner@redhat.com,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <20241010183447.GZ21877@frogsfrogsfrogs>
References: <20241010063617.563365-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010063617.563365-1-ojaswin@linux.ibm.com>

On Thu, Oct 10, 2024 at 12:06:17PM +0530, Ojaswin Mujoo wrote:
> Extsize is allowed to be set on files with no data in it. For this,
> we were checking if the files have extents but missed to check if
> delayed extents were present. This patch adds that check.
> 
> While we are at it, also refactor this check into a helper since
> its used in some other places as well like xfs_inactive() or
> xfs_ioctl_setattr_xflags()
> 
> **Without the patch (SUCCEEDS)**
> 
> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> 
> wrote 1024/1024 bytes at offset 0
> 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> 
> **With the patch (FAILS as expected)**
> 
> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> 
> wrote 1024/1024 bytes at offset 0
> 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
> 
> * Changes since v1 *
> 
>  - RVB by Christoph
>  - Added a helper to check if inode has data instead of
>    open coding.
> 	
> v1:
> https://lore.kernel.org/linux-xfs/Zv_cTc6cgxszKGy3@infradead.org/T/#mf949dafb2b2f63bea1f7c0ce5265a2527aaf22a9
> 
>  fs/xfs/xfs_inode.c | 2 +-
>  fs/xfs/xfs_inode.h | 5 +++++
>  fs/xfs/xfs_ioctl.c | 5 +++--
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bcc277fc0a83..3d083a8fd8ed 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1409,7 +1409,7 @@ xfs_inactive(
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) &&
>  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
> -	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> +	     xfs_inode_has_data(ip)))
>  		truncate = 1;
>  
>  	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 97ed912306fd..ae1ccf2a3c8b 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
>  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
>  }
>  
> +static inline bool xfs_inode_has_data(struct xfs_inode *ip)

Can you please change this to "const struct xfs_inode *ip"?
This predicate function doesn't change @ip.

I might've called it xfs_inode_has_filedata fwiw, but the current name
is fine with me.

--D

> +{
> +	return (ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0);
> +}
> +
>  /*
>   * Check if an inode has any data in the COW fork.  This might be often false
>   * even for inodes with the reflink flag when there is no pending COW operation.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a20d426ef021..88b9c8cf0272 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
>  
>  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
>  		/* Can't change realtime flag if any extents are allocated. */
> -		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> +		if (xfs_inode_has_data(ip))
>  			return -EINVAL;
>  
>  		/*
> @@ -602,7 +602,8 @@ xfs_ioctl_setattr_check_extsize(
>  	if (!fa->fsx_valid)
>  		return 0;
>  
> -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> +	    xfs_inode_has_data(ip) &&
>  	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
>  		return -EINVAL;
>  
> -- 
> 2.43.5
> 
