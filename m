Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8F194094
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875855; cv=none; b=HAF6ydxkxUHIsP9IGx0XOKcv1e4Cc1atBZpDhz9/mr1Nq+hVYsOyPgKYTEXvYtFyRUCv+UZl/Sg+temSTcITbKZJ9jWQpV6ccoZ6nRn463fLbS3id8iMYcjfUGvnEFGm2H3vXjGgtccJ6d89UnAOcCbXQRr6DL7rr1ojX0u5dFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875855; c=relaxed/simple;
	bh=pEjuhlIZwAevmcJUZt40yelf0sqmTHTl6thG8OesCyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/RAmNvPOw+PmA1DIL5OxK9ZCOLLrouGnudyln7/rywNG2MTWKZMWisbvgknsIu9TEJ6gFttp3y8xPmXQXrVrr/8uT3/fQWT2HzdN/R2wrq8xv5NIHgO5OhmH/5VvBervoe3KPOsJ+H4Ziklvg7dUoCSklFi/lZmfRL7WEJWj68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXKfuD67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXKfuD67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE626C4CEDD;
	Thu,  6 Feb 2025 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738875853;
	bh=pEjuhlIZwAevmcJUZt40yelf0sqmTHTl6thG8OesCyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UXKfuD67Is/jCIqg9PcIwI0JK3A/gx+B7nXdY9UVQkLnZyqWiU6xS+DRJNmswGCM4
	 y/E8CrA6Aiiu1DHJPNF44od8oon1lQb3fpPMA49LOhwD4sp0d++ozBaGNzJns0sq2p
	 TnqzjXmIu/OMDiLGE2aBn9Z8pWESoYdDrwFhLeSN68AQaQz/RoOcvwUwnV90BZ0MlQ
	 TlIFF7thIUULoL/XtmfP337fQzRyEG4hSFkNxwjDt6pr1KSsnxIMyhKLlcVhNtz8i8
	 1vq+535rGDfF6EHFZJPArmUM3YXFESjffh2jlu/p9JgAZvWY3BW0/2EMv2ofNJOxOn
	 5HGgjw0WXTlww==
Date: Thu, 6 Feb 2025 13:04:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/43] xfs: skip zoned RT inodes in
 xfs_inodegc_want_queue_rt_file
Message-ID: <20250206210413.GR21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-21-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:36AM +0100, Christoph Hellwig wrote:
> The zoned allocator never performs speculative preallocations, so don't
> bother queueing up zoned inodes here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
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
