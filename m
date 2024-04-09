Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B81158DA9
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704672; cv=none; b=K+1ERVtFUIef4wkadSj3/rBr0+1KYbJkWtmi+Xb75qkLaG4tPFj7UU2FTvzEQfdn8GP2goW/gSndpjheHcAzyfdlW76U88pSfOQGlse4JtohLUtRhbJki+MTWH/wv4KAAe9hHkce3OxRore+3/grZOZStyZJQW9JcliQZdCuuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704672; c=relaxed/simple;
	bh=rwo3txLKHsUXqLGEt+kWOQ3vbC8Z1jodk8SwN1pPRIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYRShc6KQBIQPhjkf3cyhRfIiTHM1wQq1W+UTearMz/Ba1Cj185GLJdNAv5hNpy9IsMn85mgA+ebfMJGycFPog1/9XvA4jAauHmN6jek4FMfju4eeKpEi1rc7f6JpjfgLl8R1OCCQdjOBbgNErokElYNRR/7JIeuwldPizFD2JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFZXe+c5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFZXe+c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11667C433F1;
	Tue,  9 Apr 2024 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704672;
	bh=rwo3txLKHsUXqLGEt+kWOQ3vbC8Z1jodk8SwN1pPRIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XFZXe+c5VIBkNGIoxwIElI94hG1Y0xcEStO30B6n7b+0g+UeLbwwLW099TmyPHUlC
	 RI9awiwXAbC9UtXekt9DS6IwZTc6vQ7BvKX9sCTMCS98l3vQMN06u2Z7xQ9YavuUeM
	 0eX5rp+rhA4t9LOV1uQ45NNXs21B5FvX+bYdPzjBchcUvcdWxTQc2eYSGLEfqqAKSZ
	 PDrd9LwzG0XI7WSKKulUg3zEiKSu+Ts0BAVdel0Bx1XfVv3w0uq0fFENVLbOBKc4X+
	 ppVCOzL8hxDn0k6k/LuSzDIxgwy4i7T2cnQ8j49DB6IVfAmLQAj9e/OUWg/DMi4tq8
	 BNP1iA0UHMi6A==
Date: Tue, 9 Apr 2024 16:17:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/8] xfs: remove the unusued tmp_logflags variable in
 xfs_bmapi_allocate
Message-ID: <20240409231751.GO6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-3-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:48PM +0200, Christoph Hellwig wrote:
> tmp_logflags is initialized to 0 and then ORed into bma->logflags, which
> isn't actually doing anything.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 14196d918865ba..a847159302703a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4191,7 +4191,6 @@ xfs_bmapi_allocate(
>  	struct xfs_mount	*mp = bma->ip->i_mount;
>  	int			whichfork = xfs_bmapi_whichfork(bma->flags);
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
> -	int			tmp_logflags = 0;
>  	int			error;
>  
>  	ASSERT(bma->length > 0);
> @@ -4262,8 +4261,6 @@ xfs_bmapi_allocate(
>  		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
>  				whichfork, &bma->icur, &bma->cur, &bma->got,
>  				&bma->logflags, bma->flags);
> -
> -	bma->logflags |= tmp_logflags;
>  	if (error)
>  		return error;
>  
> -- 
> 2.39.2
> 
> 
