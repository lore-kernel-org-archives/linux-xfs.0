Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920D157476
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704618; cv=none; b=g08ynfBYa70D6DF22H8vmJRVAMhPFv7RJr0/p/behDLvrkqfRQYPfbxCtrE8xdyUquegqBZ5iLMg0Z96MSPtG5hJtA38iTUR6cK3UwbMXzFJKhMaIY8w5xCu8w6mtnHp9Jo379RKgK2wDkwmQFgfYtfEG4g/Y6PXzUE+brkP/xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704618; c=relaxed/simple;
	bh=4Gf8V87KUSqHCr92pVjZHCudJZhIF7EFns2V8Vk74pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CiPZ/dzrj2ylS+hv7vpvLnd5Pi3sahhLNWCnacUKOV0yynHprykL92ULKQBy5jRuVbqKKWAamPyOOtRw1qtHNng58c9309ffySCxmoSOAS0v0Au1HQDdObtjbFUTJFrzIBKYAYhjFFLIdRVAy7BH21Zc763jM52/EPr1mdRKdYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXnkVMM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXnkVMM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164D4C433F1;
	Tue,  9 Apr 2024 23:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704618;
	bh=4Gf8V87KUSqHCr92pVjZHCudJZhIF7EFns2V8Vk74pU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fXnkVMM30i5hGPnYp9ktdRN05oZmIRfdHiy+7SWrdy5C0y+qQYj66gsBfT61m3xuk
	 xfsLM8068avymHiZUqhlIOuw6K1ToSuzzcOo2HYp+OxJPiftfLBJz66JeWWgVI+G1P
	 B23W5eOgv0pzHBk+99ZnIcNR4sNxXqaqzIl8DaBqIUxtG/ratCb5GkbGZug14weXv/
	 +SFIlAjtvPqHXLyKL+gXw0QhK6C/+FwgMEz0V+xWXQPy5ZewSymazCY2e8mkl7tRhs
	 KhG9W4uP52KHflcXMx2LF84LMuZahsl+75jr/MxAjD+ON3M4IHZF3oUtK7tP7i63sl
	 I9srPa12TERWA==
Date: Tue, 9 Apr 2024 16:16:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6/8] xfs: remove the xfs_iext_peek_prev_extent call in
 xfs_bmapi_allocate
Message-ID: <20240409231657.GL6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-7-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:52PM +0200, Christoph Hellwig wrote:
> Both callers of xfs_bmapi_allocate already initialize bma->prev, don't
> redo that in xfs_bmapi_allocate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aa182937de4641..08e13ebdee1b53 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4196,11 +4196,6 @@ xfs_bmapi_allocate(
>  	ASSERT(bma->length > 0);
>  	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
>  
> -	if (bma->wasdel) {
> -		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
> -			bma->prev.br_startoff = NULLFILEOFF;
> -	}
> -
>  	if (bma->flags & XFS_BMAPI_CONTIG)
>  		bma->minlen = bma->length;
>  	else
> -- 
> 2.39.2
> 
> 
