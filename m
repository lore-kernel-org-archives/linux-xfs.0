Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04082741A3;
	Fri, 25 Apr 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745593929; cv=none; b=n06+n4yWqebvtdu+vswIMr2pLOFpcVSPDg8LUqph6xqL3gO9jyFxv5KpnYFbta7AwuLj18bbs63cGkTmgEl+uxLZExeKd4sW46OqRHGwNoCw4tg6Ea0AkfGIUq7hT2quOPCWBsY/cAFb3ZOL6wIt7t4YHOTNHlYIVDoogAKHr7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745593929; c=relaxed/simple;
	bh=XI/Deu8LTxLa7duV848jtLmb25tqeQOUxLBukXOOhzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQlf1/uPTe75xRXUtfW2V7yeOB56vUaoH1ttbzheNkKC40XRxvEv/ZPN3ywzx8aJ2qcwVGDHmhr6p4QsnUHhoyFVZ2XtPQQd3jldqepYIDth/GcIwDG5BBMCQXB7oa73NwcA9QiCWQRP2+GGh/cmNPK2tOxvsH545BKJ5fZlw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBJJkakh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBJJkakh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36685C4CEE4;
	Fri, 25 Apr 2025 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745593929;
	bh=XI/Deu8LTxLa7duV848jtLmb25tqeQOUxLBukXOOhzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pBJJkakh/tCio3mwtHj5m9wYww+eqAKP7XnjcOIY733gx9/weGNk5mM5/DcEJ6vAG
	 9wmJbUkoZ6A4N5hv02QZMBKIPO+v1DqY2AHIJP6M0GVQnbQ70yYQ0Qz+2wwrgKgKX2
	 MTlwOCoJoiop4JZ7lTGiID4OlF01EtOQgy5ALQXfbP/MBsMa+2OBX5yRuFYJ6ThDkz
	 ekeMQHDulX+vHcAcTGtBCniD16/VwUE1m+M1Ie+cvxWbc9sPROhUynFNw0dh6D0+ux
	 mZSaKEI4a+5N7XE/2/fUU9rpsp8acEe4U5c6p3rO4ZnCFPm83nQrpq/x5nSt6BRVo9
	 ijdj9IT/+EaUg==
Date: Fri, 25 Apr 2025 08:12:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [RFC PATCH 1/2] xfs: Add i_direct_mode to indicate the IO mode
 of inode
Message-ID: <20250425151208.GN25675@frogsfrogsfrogs>
References: <20250425103841.3164087-1-chizhiling@163.com>
 <20250425103841.3164087-2-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425103841.3164087-2-chizhiling@163.com>

On Fri, Apr 25, 2025 at 06:38:40PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Direct IO already uses shared lock. If buffered write also uses
> shared lock, we need to ensure mutual exclusion between DIO and
> buffered IO. Therefore, Now introduce a flag `i_direct_mode` to
> indicate the IO mode currently used by the file. In practical
> scenarios, DIO and buffered IO are typically not used together,
> so this flag is usually not modified.
> 
> Additionally, this flag is protected by the i_rwsem lock,
> which avoids the need to introduce new lock. When reading this
> flag, we need to hold a read lock, and when writing, a write lock
> is required.
> 
> When a file that uses buffered IO starts using DIO, it needs to
> acquire a write lock to modify i_direct_mode, which will force DIO
> to wait for the previous IO to complete before starting. After
> acquiring the write lock to modify `i_direct_mode`, subsequent
> buffered IO will need to acquire the write lock again to modify
> i_direct_mode, which will force those IOs to wait for the current
> IO to complete.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>  fs/xfs/xfs_file.c  | 37 +++++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_inode.h |  6 ++++++
>  2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 84f08c976ac4..a6f214f57238 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -206,7 +206,8 @@ xfs_ilock_iocb(
>  static int
>  xfs_ilock_iocb_for_write(
>  	struct kiocb		*iocb,
> -	unsigned int		*lock_mode)
> +	unsigned int		*lock_mode,
> +	bool			is_dio)

Is an explicit flag required here, or can you determine directness from
IS_DAX() || (iocb->ki_flags & IOCB_DIRECT) ?

Hmm, I guess not, since a directio falling back to the pagecache for an
unaligned out of place write doesn't clear IOCB_DIRECT?

How does this new flag intersect with XFS_IREMAPPING?  Are we actually
modelling three states here: bufferedio <-> directio <-> remapping?

>  {
>  	ssize_t			ret;
>  	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> @@ -226,6 +227,21 @@ xfs_ilock_iocb_for_write(
>  		return xfs_ilock_iocb(iocb, *lock_mode);
>  	}
>  
> +	/*
> +	 * If the i_direct_mode need update, take the iolock exclusively to write
> +	 * it.
> +	 */
> +	if (ip->i_direct_mode != is_dio) {
> +		if (*lock_mode == XFS_IOLOCK_SHARED) {
> +			xfs_iunlock(ip, *lock_mode);
> +			*lock_mode = XFS_IOLOCK_EXCL;
> +			ret = xfs_ilock_iocb(iocb, *lock_mode);
> +			if (ret)
> +				return ret;
> +		}
> +		ip->i_direct_mode = is_dio;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -247,6 +263,19 @@ xfs_file_dio_read(
>  	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>  	if (ret)
>  		return ret;
> +
> +	if (!ip->i_direct_mode) {
> +		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +		ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_EXCL);
> +		if (ret)
> +			return ret;
> +
> +		ip->i_direct_mode = 1;
> +
> +		/* Update finished, now downgrade to shared lock */
> +		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> +	}
> +
>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, NULL, 0);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
> @@ -680,7 +709,7 @@ xfs_file_dio_write_aligned(
>  	unsigned int		iolock = XFS_IOLOCK_SHARED;
>  	ssize_t			ret;
>  
> -	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock, true);
>  	if (ret)
>  		return ret;
>  	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
> @@ -767,7 +796,7 @@ xfs_file_dio_write_unaligned(
>  		flags = IOMAP_DIO_FORCE_WAIT;
>  	}
>  
> -	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock, true);
>  	if (ret)
>  		return ret;
>  
> @@ -898,7 +927,7 @@ xfs_file_buffered_write(
>  
>  write_retry:
>  	iolock = XFS_IOLOCK_EXCL;
> -	ret = xfs_ilock_iocb(iocb, iolock);
> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock, false);
>  	if (ret)
>  		return ret;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index eae0159983ca..04f6c4174fab 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -51,6 +51,12 @@ typedef struct xfs_inode {
>  	uint16_t		i_checked;
>  	uint16_t		i_sick;
>  
> +	/*
> +	 * Indicates the current IO mode of this inode, (DIO/buffered IO)
> +	 * protected by i_rwsem lock.
> +	 */
> +	uint32_t		i_direct_mode;

Yeesh, a whole u32 to encode a single bit.  Can you use i_flags instead?

--D

> +
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
> -- 
> 2.43.0
> 
> 
