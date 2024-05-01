Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD943D52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598321; cv=none; b=F+eUK2Pl+A4HE+sGVcm+ky1Mhef0uA0J2o/mMMkz2AjaMPxYrZab2tD4Tms38ARm1sbylXjK9ad7WuVGYjD/M3gvepNZ7jCH7ol5Gq0smwe0o4x6Y8tU0k/jevITTEsuWnjZuSLZf5LWm/2fMNpbsDxwsMQmVdIgg3aYOV4iCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598321; c=relaxed/simple;
	bh=RozOVsrXjqNC48ObYKNNzeqG1yAX96o7JVY+BC6CWLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/ZUxWd8bbG3GH+uyZUlbQgTC7mXPToA5Ev0ZBT7Ynja4IgleKiipOi3KgwkXUtQ2uKqdOFJBnmO2TrdEn3Fi7dSq4qUNWA9H4rExyElZaEUiruNSuOERLhEJQ1sNm1sevog4754nS8lFMQV7lfdDmIse+M6aM8qclfNtTnzBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSR32bsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSR32bsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3103C072AA;
	Wed,  1 May 2024 21:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598321;
	bh=RozOVsrXjqNC48ObYKNNzeqG1yAX96o7JVY+BC6CWLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dSR32bsZvrQFGj1LNoJQiASHc1G9N+XY96e9LeT0WG6Jl4G61FKF1RV1i7+S+ZcBB
	 WaatXOZC9zvrvwgK1BrmMPbcNvX6/WYFozxP/VObUUnq1rWpVru+R2ZYwND/ZScr6b
	 uqdNbL2fOE2aXx1aLf5/i+VkOSuzOfnqjAgvtG7neflhuTHwUEr/LhuHdFzrCIy/DK
	 jbKUwxVH0ZLxFakA5on0Dgg3465GkEeZ2wV1j86GE0n1GXImIPBv/Cv6yal+dsqhmX
	 m9IkkqHFTIu5Z5mWfiigIFlh3r2HbP36vXSbilmcY3ULDuMxhLqUQ0KSkTaUafYvqE
	 eNyvldGpca7lQ==
Date: Wed, 1 May 2024 14:18:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/16] xfs: remove a superfluous memory allocation in
 xfs_dir2_block_to_sf
Message-ID: <20240501211841.GV360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-8-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:17PM +0200, Christoph Hellwig wrote:
> Transfer the temporary buffer allocation to the inode fork instead of
> copying to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index d02f1ddb1da92c..164ae1684816b6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -281,9 +281,8 @@ xfs_dir2_try_block_to_sf(
>  	trace_xfs_dir2_block_to_sf(args);
>  
>  	/*
> -	 * Allocate a temporary destination buffer to format the data into.
> -	 * Once we have formatted the data, we can free the block and copy the
> -	 * formatted data into the inode literal area.
> +	 * Allocate the shortform buffer now.  It will be transferred to the
> +	 * inode fork once we are done.
>  	 */
>  	sfp = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, &sfh, xfs_dir2_sf_hdr_size(sfh.i8count));
> @@ -341,25 +340,23 @@ xfs_dir2_try_block_to_sf(
>  	error = xfs_dir2_shrink_inode(args, args->geo->datablk, bp);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
> +		kfree(sfp);
>  		goto out;
>  	}
>  
>  	/*
> -	 * The buffer is now unconditionally gone, whether
> -	 * xfs_dir2_shrink_inode worked or not.
> -	 *
> -	 * Convert the inode to local format and copy the data in.
> +	 * Update the data fork format and transfer buffer ownership to the
> +	 * inode fork.
>  	 */
> -	ASSERT(dp->i_df.if_bytes == 0);
> -	xfs_init_local_fork(dp, XFS_DATA_FORK, sfp, size);
>  	dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
> +	dp->i_df.if_data = sfp;
> +	dp->i_df.if_bytes = size;
>  	dp->i_disk_size = size;
>  
>  	logflags |= XFS_ILOG_DDATA;
>  	xfs_dir2_sf_check(args);
>  out:
>  	xfs_trans_log_inode(args->trans, dp, logflags);
> -	kfree(sfp);
>  	return error;
>  }
>  
> -- 
> 2.39.2
> 
> 
