Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0C84A5EC3
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365241; cv=none; b=im1uuYuBhTHqP+Xcmk1BhYEaZDmgLX54DBx/+4meFQwBANgB5Lm1/Mv4nqGwzyhQzg3NbwhMtvPAjQg6hK51KGbr5vAzD/6PYDxDSCivsJ1ZoJjB7h1iFeKM1JjGeN55auaug8Zoy5NnS3jyhechnmRBVIVL9mSa8L6H5yn2L9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365241; c=relaxed/simple;
	bh=dVzq7jQ0hmqgWDworxmkww5KnImxPhoiSZA9WDFT1M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=esqTV5Y+jWHxYDXt1ZWaP7sJ18rB4BQVbCuW0ZE4Oa1xnDCceWwSOOVAk8iSIdXLKkclNyKWQJcjqjyGgrtQ1ZgsTpw7GWjc6e0wSnVHlQh/9VmbVByIW+0XQmGNNQMKa2N7+dt4ZSuI0u3dCIYPo/46KLvWSuuUa4yeFLtZVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BfufLpSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BfufLpSg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D75611F000E9;
	Wed,  2 Sep 2026 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365239;
	bh=Vyh8Y+SwaMWkbb9k/mW7xIKNei1k5g6q7y12FYjuemE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BfufLpSgWXoZkoKRe+8BILRKzbNXq78lJSrnyY9xjVVsyN9s9vkIpZvZJCC5ZlHM/
	 5vhOFFJb8txBReSrwDEH+uwWDZgnwwRLiL6WL0aOYaG5ZnpCHFRwP3tcSoVmaE2YpI
	 RCC1VEQIG2u8S/TdhazbmVaRW3PvyDP8yis+pyUisuKm7DUgb7VgJXgZKMX1abjbo1
	 lYiZ/sCV+8czkkCkrQl5rUkIvuZsJPC2Ek/KsaOvCVRuG9jZRW3EFXBvDpVbiKX0Qd
	 90dU9WL5SKR/nxwgH4t5IqBtWjgCQb3Usjv6E6icQigvbTl8hnGyTlZ1SphXk96u7j
	 ZKGHMPPjdEzNg==
Date: Wed, 2 Sep 2026 09:07:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't continue on error in xfs_fsync
Message-ID: <20260902160719.GP1933798@frogsfrogsfrogs>
References: <20260902054942.111988-1-hch@lst.de>
 <20260902054942.111988-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902054942.111988-3-hch@lst.de>

On Wed, Sep 02, 2026 at 08:49:16AM +0300, Christoph Hellwig wrote:
> As soon as we get an error from cache flushing or log forcing, there
> is no point in continuing as the data integrity is already impacted.
> Return the error instead of continuing to do more work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 426a67b813a7..0d31fea67a2c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -130,8 +130,8 @@ xfs_file_fsync(
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	int			error, err2;
>  	int			log_flushed = 0;
> +	int			error;
>  
>  	trace_xfs_file_fsync(ip);
>  
> @@ -154,15 +154,17 @@ xfs_file_fsync(
>  		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> +	if (error)
> +		return error;

Hmm so at this point dirty writeback was pushed out and failed, so now
already we've lost data.  No point in continuing, agreed...

>  
>  	/*
>  	 * If the inode has a inode log item attached, it may need the journal
>  	 * flushed to persist any changes the log item might be tracking.
>  	 */
>  	if (ip->i_itemp) {
> -		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> -		if (err2 && !error)
> -			error = err2;
> +		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> +		if (error)
> +			return error;

...so at this point we failed to push the log to disk and possibly
lost file metadata.  Agreed that we might as well give up...

>  	}
>  
>  	/*
> @@ -178,14 +180,11 @@ xfs_file_fsync(
>  	if (!log_flushed) {
>  		struct xfs_buftarg *file_targp = xfs_inode_buftarg(ip);
>  
> -		if (mp->m_logdev_targp == file_targp) {
> -			err2 = blkdev_issue_flush(file_targp->bt_bdev);
> -			if (err2 && !error)
> -				error = err2;
> -		}
> +		if (mp->m_logdev_targp == file_targp)
> +			return blkdev_issue_flush(file_targp->bt_bdev);

...and same here if the bdev flush fails.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	}
>  
> -	return error;
> +	return 0;
>  }
>  
>  static int
> -- 
> 2.53.0
> 
> 
