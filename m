Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152A51DE8A8
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041750; cv=none; b=sEwNzQsW92BzqKT4WR5qa/pnt8OK8rxySojkMM2j5g5OeFzUpJk6VEp4/ADIF92pVmfeP+wZI5J20ukyZxxYWFs0vo+0MNpqGfhtktshVGTELBx9juMFUTR9RzngxHLJ7AFHFWLQt5VMc8OVlAOL1YDnTYGVZP9f4hhuwIOA99Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041750; c=relaxed/simple;
	bh=vVT/obmR2JidaxgjiDGOmVzqSXOP31z0NV5+vKgIs/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bsd7IHwdGByKTFFkIKoa5rSV5/pXsHsu0NbmixB/HrKRAct/YGQtNP3ffiXW96gZkZefC6uJkOW68+T8RRhbxkRBOBLyQHt0k6a+3hm26npv2fSyCoFWBN2ZxCFtjVN4hlu9rDZ+R3qRiRabcx+uZ9Jls0WuXzG+ubYVXnfBqGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUKL7W5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUKL7W5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9A0C4CECE;
	Thu, 12 Dec 2024 22:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734041749;
	bh=vVT/obmR2JidaxgjiDGOmVzqSXOP31z0NV5+vKgIs/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QUKL7W5mCLzVBhlciNrvMjH3xG9axeNbmENl1D9DRdCR2op7NaQPTWesfUttEJfIQ
	 gDeqtQX0pvckppMsnGDSoWstjAud7uzODH3Rpawr8AeNv7DACdOzTx3XctQjLELlT5
	 ZthAiK3sZazPm6n5jsFrzMUFncPKzycimPAs5iF+73pgargouxmHxUfNGJbjmca+Qv
	 Y2Aygj6nT0zo7QOxCj72n39gHXvnQGk7i9OEj+QiJtWCRxHHj+56Qvr/z/zLq4z2DT
	 P7F7UBRECsu2nPImbnZzCZUL2eCDHijXSGuhHxH2aNQsHwkL2rZBUwO+TWQ9vlJ4oF
	 MlYTAwgQE2e9Q==
Date: Thu, 12 Dec 2024 14:15:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/43] xfs: skip zoned RT inodes in
 xfs_inodegc_want_queue_rt_file
Message-ID: <20241212221549.GG6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-23-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-23-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:47AM +0100, Christoph Hellwig wrote:
> The zoned allocator never performs speculative preallocations, so don't
> bother queueing up zoned inodes here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c9ded501e89b..2f53ca7e12d4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -2073,7 +2073,7 @@ xfs_inodegc_want_queue_rt_file(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	if (!XFS_IS_REALTIME_INODE(ip))
> +	if (!XFS_IS_REALTIME_INODE(ip) || xfs_has_zoned(mp))
>  		return false;
>  
>  	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
> -- 
> 2.45.2
> 
> 
