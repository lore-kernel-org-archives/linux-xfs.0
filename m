Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A901B5819
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718908880; cv=none; b=f1E5Wa8D8NN317mFzuKEfR9KV1S7S6+FZZ7YBP0vq0vcZAY8wUNY4fU1cFB1TTziBmOVxXcKDfFq4z/ogCYvHme5+4O+WFVsvHat7Z/E8lw6vNei5K3zojqpunUqmRrrIEQdFQx34Fw7D9qsKGkA8mmJzC3CJmHYWlw+8MXf+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718908880; c=relaxed/simple;
	bh=iiI5LMdlPuv/56hdS0foa3yxLO83/PBBC+ka7CqRX8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fpbyc/FfzYXlw+trXQghf64roRe/dc0htD3cfCDxLZt8gLWyvv3lfCRvZd9rAbNJ0ZseCQ86e9Vw9fUzSfUPjPnDacn4VrJ7a6Dk+bvZWkBiLNJxiSq3uzMGc+27zQNXF9oteoRArJBbwZ2PbKdWJfzW0ceaB4MJ5Teowyg99iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/bSqdkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/bSqdkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC3EC2BD10;
	Thu, 20 Jun 2024 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718908880;
	bh=iiI5LMdlPuv/56hdS0foa3yxLO83/PBBC+ka7CqRX8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h/bSqdktckzB+So8UYylQOYzNyUpMfihIbH4fH1av9Rf3OXSqYuYPzwFBdMdz/VMd
	 SScV+1W8mLoIKPMRusHUgYnLebmaPT3nkA8RBzMHa9Q3rMcwDBIYpcapwfaHgEA/xd
	 evAY7Fr0LqvyM2W7csRB+gWaZZ0Fr52AF61ArzNS2jiw8tZn+Uz3V5ZsULwl4Belqt
	 KynpiZcAVzVbjcsWsAct2KXrgbHo/i4nz/D58Kra2ax9CSIRi8QqCeq6hdHK/8imTo
	 W8XZLzBdtySb8eIdBsc2hcg60nqa2fF+WQDwjeMSb7afDXp3+QM2fqOrVah6GsxUpG
	 glU4/9MLBM6/A==
Date: Thu, 20 Jun 2024 11:41:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: cleanup xfs_ilock_iocb_for_write
Message-ID: <20240620184119.GZ103034@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619115426.332708-3-hch@lst.de>

On Wed, Jun 19, 2024 at 01:53:52PM +0200, Christoph Hellwig wrote:
> Move the relock path out of the straight line and add a comment
> explaining why it exists.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b240ea5241dc9d..74c2c8d253e69b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -213,14 +213,18 @@ xfs_ilock_iocb_for_write(
>  	if (ret)
>  		return ret;
>  
> -	if (*lock_mode == XFS_IOLOCK_EXCL)
> -		return 0;
> -	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
> -		return 0;
> +	/*
> +	 * If a reflink remap is in progress we always need to take the iolock
> +	 * exclusively to wait for it to finish.
> +	 */
> +	if (*lock_mode == XFS_IOLOCK_SHARED &&
> +	    xfs_iflags_test(ip, XFS_IREMAPPING)) {
> +		xfs_iunlock(ip, *lock_mode);
> +		*lock_mode = XFS_IOLOCK_EXCL;
> +		return xfs_ilock_iocb(iocb, *lock_mode);
> +	}
>  
> -	xfs_iunlock(ip, *lock_mode);
> -	*lock_mode = XFS_IOLOCK_EXCL;
> -	return xfs_ilock_iocb(iocb, *lock_mode);
> +	return 0;
>  }
>  
>  static unsigned int
> -- 
> 2.43.0
> 
> 
