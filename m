Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9472158DBD
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704663; cv=none; b=Bp30u3ttsdMUsFtkMVr2JTHjoV+BZTvpfR8m0h378c6rxWo3YQ8CV6azFwcoXtCvVjwqYtspvF+dnl4JTFcYwHjSNIhqpIf9uiZQuat4NA4odi2gIczWTKExA5Lxxsdll3BkF06TcNKUI/EJqw3dKIhpCPX8HbD8R1fqsYtUh8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704663; c=relaxed/simple;
	bh=G7cdSdDpOb3A53wElrogGx+A9QF3VakCCv8hcSaRFXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/rFjbHebiAXKFk9tRH3Fo38XSg+K2bEQyZDVQdZJ6hGbaF/wekBOWeEDEmNDjcLggqMiTtNxtxvUSkslMBtkEfla6TeE5ELYSPuH9ZbtKbzDX9dAkBZ4m+4NhAk5IEMeddtqn7gFrwZNTjXNU/8LIM+stI0atKpj6jtyHxvJKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwMVzrrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwMVzrrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481C9C433F1;
	Tue,  9 Apr 2024 23:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704663;
	bh=G7cdSdDpOb3A53wElrogGx+A9QF3VakCCv8hcSaRFXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LwMVzrrBZ7BxMP6CXBZ0tde+bP+W+w0V1YPhXrujnAoT3SGiLi5rUqj0C6SM7VGhO
	 zt33LBIbjKTFbWPqNYKXyuLCKIal7EeBsDD6Et7b0kvMjNHM36jwfeuzIarPGo9dvB
	 whGi1Azyt5y4rbiOev8mSNSyAxSGzIH9/bJ87xVIG4VmnBRnTSG72QXJ2Rv6x+XL/a
	 gtQiojU7aihq6WrBmSIjIxDzoBPNv8TYMPoeKbCqii3ocMZdQlvQUPZ2HNtcdqXlcP
	 YSFLAa5ekJyg5S3dz3qpkAJwJ5KVf0jV0iwYcUOwrkOXSurx0lJG8jJy6cd9cGjxij
	 aFHUnXU2TSVNg==
Date: Tue, 9 Apr 2024 16:17:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/8] xfs: lifr a xfs_valid_startblock into
 xfs_bmapi_allocate
Message-ID: <20240409231742.GN6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-4-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:49PM +0200, Christoph Hellwig wrote:
> Subject: [PATCH 3/8] xfs: lifr a xfs_valid_startblock into xfs_bmapi_allocate

                            lift

> xfs_bmapi_convert_delalloc has a xfs_valid_startblock check on the block
> allocated by xfs_bmapi_allocate.  Lift it into xfs_bmapi_allocate as
> we should assert the same for xfs_bmapi_write.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With the typo fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a847159302703a..3b5816de4af2a1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4230,6 +4230,11 @@ xfs_bmapi_allocate(
>  	if (bma->blkno == NULLFSBLOCK)
>  		return -ENOSPC;
>  
> +	if (WARN_ON_ONCE(!xfs_valid_startblock(bma->ip, bma->blkno))) {
> +		xfs_bmap_mark_sick(bma->ip, whichfork);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	if (bma->flags & XFS_BMAPI_ZERO) {
>  		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
>  		if (error)
> @@ -4721,12 +4726,6 @@ xfs_bmapi_convert_delalloc(
>  	if (error)
>  		goto out_finish;
>  
> -	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
> -		xfs_bmap_mark_sick(ip, whichfork);
> -		error = -EFSCORRUPTED;
> -		goto out_finish;
> -	}
> -
>  	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
>  	XFS_STATS_INC(mp, xs_xstrat_quick);
>  
> -- 
> 2.39.2
> 
> 
