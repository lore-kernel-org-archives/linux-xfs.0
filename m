Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C4D481252;
	Mon, 14 Sep 2026 14:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397995; cv=none; b=KO4gB70nMZltFtlvoTpxHkVdEZ+fezHaSg+vnb/06qeeJ7IGoWNTPjdYIJSUdy/kTkLT39Ooq7JoxI0FKGtspndeCCRQRJxB8Xo89WsF82mGFfS9DeNhNwbqvn+N92yle/pEGyAi6RRCmFNnw7Z95vPSvHf5HEVb/L4fcU5Bvro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397995; c=relaxed/simple;
	bh=pomLZpXYjbZV9ElQXD4mMIOKN1blqI2XXO6ECHpit7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hB933iZsTjn4zDqLZH+wUBdUrleNr0fBMQR1WsmmRF2xIG/qxCq/8t6OQCe563icG8FhT1mWqHbo4+G5IM1+loKfOeMqoGQ4MiPVaKIIgYWPCS5wxArO1CiAWhIT/XqzSxhJ9H5wzUh3EedLZW8bv7pXaQKm0gZXp7SUbGT2CTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uk59BdKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uk59BdKU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED0811F00893;
	Mon, 14 Sep 2026 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397993;
	bh=rBZYkr8kF0+qFvB8Qh3LQcWRtjyHCb+IZdMwvL2J5I8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uk59BdKUZKGOAuE+Jfm14ffclvcLsCE+vdIl0sw4M510CvxAZA4ALn6p/fsV4xamL
	 6vYk/uaoi8a+ScLw4nrqeigIidyshcPmO9ljDXcyCH+nq6pZX3Qrb8EKabvEiM5wbH
	 H3/YNACf5V7iX7HmgiU4TkfNauPY343uQA0cRf1R3O67pGlw9xqpAXJa3+lUcCsobB
	 S7/iQylBW41Qff01hXGVHUpDM4iCMRIhAcXwxkPcsrVW+2koXT4hmdzzn7m2ofo237
	 gtfNgubiJ7DwIxo4wWCLV6ykmC4UG4Hw7+9LhfJP5GJefcrtgGadf9Q11qo/9CCUic
	 gTgxYf+wn1wOg==
Date: Mon, 14 Sep 2026 07:59:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/1] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <20260914145952.GN6265@frogsfrogsfrogs>
References: <20260914093152.1698-1-aditya.ansh182@gmail.com>
 <20260914093152.1698-2-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914093152.1698-2-aditya.ansh182@gmail.com>

On Mon, Sep 14, 2026 at 09:31:51AM +0000, Aditya Prakash Srivastava wrote:
> When a file is closed, xfs_file_release() attempts to trim speculative
> post-EOF blocks. This requires allocating a transaction, which blocks
> indefinitely if the filesystem is frozen.
> 
> Fix the hang by wrapping the preallocation cleanup block with
> sb_start_write_trylock() and xfs_ilock_nowait() to bypass the trim
> best-effort when the filesystem is frozen or locking fails.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Looks great, can't wait to see how the integration testing goes ;)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d8202da15aca..dd6d2e08faff 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1872,17 +1872,21 @@ xfs_file_release(
>  		return 0;
>  
>  	/*
> -	 * If we can't get the iolock just skip truncating the blocks past EOF
> -	 * because we could deadlock with the mmap_lock otherwise. We'll get
> -	 * another chance to drop them once the last reference to the inode is
> -	 * dropped, so we'll never leak blocks permanently.
> +	 * If we can't get the iolock or if the filesystem is frozen, just skip
> +	 * truncating the blocks past EOF because we could deadlock with the
> +	 * mmap_lock or hang the close() call. We'll get another chance to drop
> +	 * them once the last reference to the inode is dropped, so we'll never
> +	 * leak blocks permanently.
>  	 */
>  	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> -	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> -			xfs_free_eofblocks(ip);
> -		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	    sb_start_write_trylock(mp->m_super)) {
> +		if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +			if (xfs_can_free_eofblocks(ip) &&
> +			    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> +				xfs_free_eofblocks(ip);
> +			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +		}
> +		sb_end_write(mp->m_super);
>  	}
>  
>  	return 0;
> -- 
> 2.47.3
> 
> 
