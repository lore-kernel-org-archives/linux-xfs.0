Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA901DFEF
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243592; cv=none; b=nNbpuusXjYD3SsauL2XTW/3VQIFRLYkoSsNLiC4FNUA64+6hFWgDz+ysqdryVrFQLM4jbVyA9DVv0pJT1EdZvZ2YXCzejhkxk1NpIX5WB2wXRVdElUwEYKYa4BtyNQO0fDwWPLas0mLvILfTDDFzq3welyx18ZPa6jPxR5fJO20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243592; c=relaxed/simple;
	bh=eHqzoJ1Le7XMEipoLlqRxSZmbftIRlusCXgfuRnAj5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QugzqZgzOKeTw60Iu50yljtEeiUSvDhEf9fytmCAZBkcmbcG2FTLy6unVbndUKZHFm398zfNKZFhAx73pPq7dzCSal+qOt030UqV4LXe3en7Lws99dvdTjDetRAnYASuXL/8fEkgZR5UD84dRPaxQ5WSA/UIKrZtZRsTkUKeRqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6+lEls2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6+lEls2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D12C2BBFC;
	Mon, 24 Jun 2024 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243591;
	bh=eHqzoJ1Le7XMEipoLlqRxSZmbftIRlusCXgfuRnAj5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q6+lEls2Vukk4TAXJNzX4qnwU9s0nuIcWcnysi1BaUQyXg9BRwGBG/1PBInErtc9X
	 9nysA/yEdMjmp8Mzc5OWku+ZfGRa+6E6RknxDuTNvChhCfVmaPBQ18LFQJ3STwb5FU
	 V6MYlHAC8LsnzWC9UeCRLTtk94d/2pJzO0J58QqaqiISvAU97eqLUm/rs9Xa4LHzoq
	 h99I8IF+KgXPF7h/CoWupMZzdy8mkypmnuDz6iAfpXW1rrYHpszZa5e8ZUJiI3I6hd
	 JpvRewFYXl/5blDhU90Zu3y3N9YJiuqfJHs6+nv10UntLEaRdaieelC+l6WdbkXVDx
	 EihGkQIDSn9tg==
Date: Mon, 24 Jun 2024 08:39:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: don't bother returning errors from
 xfs_file_release
Message-ID: <20240624153951.GH3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-5-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:49AM +0200, Christoph Hellwig wrote:
> While ->release returns int, the only caller ignores the return value.
> As we're only doing cleanup work there isn't much of a point in
> return a value to start with, so just document the situation instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d39d0ea522d1c2..7b91cbab80da55 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1186,6 +1186,10 @@ xfs_dir_open(
>  	return error;
>  }
>  
> +/*
> + * Don't bother propagating errors.  We're just doing cleanup, and the caller
> + * ignores the return value anyway.

Shouldn't we drop the int return from the function declaration, then?

(Is that also a cleanup that's you're working on?)

--D

> + */
>  STATIC int
>  xfs_file_release(
>  	struct inode		*inode,
> @@ -1193,7 +1197,6 @@ xfs_file_release(
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	int			error;
>  
>  	/* If this is a read-only mount, don't generate I/O */
>  	if (xfs_is_readonly(mp))
> @@ -1211,11 +1214,8 @@ xfs_file_release(
>  	if (!xfs_is_shutdown(mp) &&
>  	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
>  		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> -		if (ip->i_delayed_blks > 0) {
> -			error = filemap_flush(inode->i_mapping);
> -			if (error)
> -				return error;
> -		}
> +		if (ip->i_delayed_blks > 0)
> +			filemap_flush(inode->i_mapping);
>  	}
>  
>  	/*
> @@ -1249,14 +1249,14 @@ xfs_file_release(
>  			 * dirty close we will still remove the speculative
>  			 * allocation, but after that we will leave it in place.
>  			 */
> -			error = xfs_free_eofblocks(ip);
> -			if (!error && ip->i_delayed_blks)
> +			xfs_free_eofblocks(ip);
> +			if (ip->i_delayed_blks)
>  				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
>  		}
>  		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	}
>  
> -	return error;
> +	return 0;
>  }
>  
>  STATIC int
> -- 
> 2.43.0
> 
> 
