Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC512F381
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704562; cv=none; b=fRn9NPS8E/MfKmBsWsheqarJ0WUf55XoxuVPMMt3+FMjR4ANtEjCeTLn09hsiePpuDnqsmc2Aistp89xuBoHAyR1tUYgrWiaaBUk9j56K9OZRMPYZesUuBAtAjuc6+jKl78h58EtA6hKzNLGo34qx4G63SJChA1yA+e1pwPKwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704562; c=relaxed/simple;
	bh=a9Cxmvp61L5dzkcCPu5M5gYJtih4mlSHKM/WVQ7PLoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SIDiLblRp7SluxLwaZ/Zduamw09xTaadAdtsu8A2uCBtZcgrZXlloy1RJ/GjFeYD+TMm/sp29jYI5nZRxofmf27cLvNczmB6EucYB9EL+TXAMm6dTiBiQvBiNBA6gHl68haMEOuJVhH/C5V7fRdqWTyISkqp5SNVIWqKp9H5TNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Syxd2pAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Syxd2pAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097DEC433C7;
	Tue,  9 Apr 2024 23:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704562;
	bh=a9Cxmvp61L5dzkcCPu5M5gYJtih4mlSHKM/WVQ7PLoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Syxd2pAqj8Q6RAdckoeY/IMfkpXRqY7uocJZCoCuvr83a+IKpl863/WxQek73C+S7
	 y/ngVvHDld+Id2a7Da6NyziHeqLLN02GhlaGWOUbVX32ZZ7PatCXOiNVfqJPqfiaWH
	 YEMRmSOF7jL0VYtlEJG6T9LFkN4hlIdzC+Jahr3BxPfi2nNEPvcBjy62t1d//HrjRm
	 6K2wwA1j7UoDg9/blu3tuOTjoVsAxmqwfJ6oa+FY+axBrmUCm5yzO/l+lDV9uOeMoi
	 uulgfRlpLytm/0J+FipW8QlBBvU4/2Ba67pcxFx7OhA32b0dmL6/QgZChzxyn2f/RL
	 mDfoecFuXYvxA==
Date: Tue, 9 Apr 2024 16:16:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/8] xfs: do not allocate the entire delalloc extent in
 xfs_bmapi_write
Message-ID: <20240409231601.GJ6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-9-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:54PM +0200, Christoph Hellwig wrote:
> While trying to convert the entire delalloc extent is a good decision
> for regular writeback as it leads to larger contigous on-disk extents,
> but for other callers of xfs_bmapi_write is is rather questionable as
> it forced them to loop creating new transactions just in case there
> is no large enough contiguous extent to cover the whole delalloc
> reservation.
> 
> Change xfs_bmapi_write to only allocate the passed in range instead.

Looking at this... I guess xfs_map_blocks -> xfs_convert_blocks ->
xfs_bmapi_convert_delalloc -> xfs_bmapi_allocate is now how writeback
converts delalloc extents before scheduling writeout.  This is how the
mass-conversions of large da reservations got done before this series,
and that's still how it works, right?

Whereas xfs_bmapi_write is for targeted conversions only?

> Signed-off-by: Christoph Hellwig <hch@lst.de>

If yes and yes, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7700a48e013d5a..748809b13113ab 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4533,8 +4533,9 @@ xfs_bmapi_write(
>  			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
>  
>  			if (wasdelay) {
> -				bma.offset = bma.got.br_startoff;
> -				bma.length = bma.got.br_blockcount;
> +				bma.length = XFS_FILBLKS_MIN(bma.length,
> +					bma.got.br_blockcount -
> +					(bno - bma.got.br_startoff));
>  			} else {
>  				if (!eof)
>  					bma.length = XFS_FILBLKS_MIN(bma.length,
> -- 
> 2.39.2
> 
> 
