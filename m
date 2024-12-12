Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3581DB540
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041594; cv=none; b=FKammdBZT7q7dgpJe4BlIeLkH1NNnQCr3UQNz78mWGVkYgR/8KMrUS6VtU2OaiMPxXuQCox5Yslz4Mv5qmpvjN3A6hTVYthAvEJk2Br57BcxFOCHx/C36X2ZIsHit8VTFYJ8CeELqrZqeZbYJwJvdaVeUsBoI2mNphbyFZxGvww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041594; c=relaxed/simple;
	bh=8SE7QJ6Rrpp4QzZl1Iinyz89eKj82c0l/ICAgPaPMro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUKAW19SIuUdrzyDZ5hQ0502ywXzi/JH+5klXFJ/J1gBjitxmWyNFwZr2ScHrPEJR5C3pV3nzadJ4U5rYTyqC/n2Q8jZY/3lzDe1bYPOFVvZXq9uxUpJQTFaeuzKMT8xiDzJJWx66wzKH4ROnaILFPSt79gFOqSztQxl9C709kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYrEvqmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYrEvqmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F359C4CED0;
	Thu, 12 Dec 2024 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734041593;
	bh=8SE7QJ6Rrpp4QzZl1Iinyz89eKj82c0l/ICAgPaPMro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZYrEvqmkKNYBxcj4UwHllFbAxOu0Uh7FtwqSuE7Tptx5FSQ82qDmd/0koV48Tucpz
	 tGLjObZs4SoYBYzuq19QTwbHp8Xh3rKg1GONFojlufJ8fyttSwRkdwF6p3OO0oQdUr
	 Vf5hIXLr6Io7yFHo6eNFb7i7mN6nPeXCVI1qDk7d91hw+hD/VOPSkaDcG5e1aHM5en
	 GJtHsC8iyz05quSN5pFZuI82SzfESwmSFAKeXnDjptKVCwAfZLwM7lCoWrB53vM06j
	 T699g8VftNcF1Uudjoa5OH0VUo7EKiriRHJM/2Ih9TQF8qW5/hHPKcpcTKeQa54Xt7
	 V2aNjTmqzcq9w==
Date: Thu, 12 Dec 2024 14:13:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/43] xfs: disable FITRIM for zoned RT devices
Message-ID: <20241212221312.GE6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-21-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:45AM +0100, Christoph Hellwig wrote:
> The zoned allocator unconditionally issues zone resets or discards after
> emptying an entire zone, so supporting FITRIM for a zoned RT device is
> not useful.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index c4bd145f5ec1..4447c835a373 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -844,7 +844,8 @@ xfs_ioc_trim(
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (mp->m_rtdev_targp &&
> +
> +	if (mp->m_rtdev_targp && !xfs_has_zoned(mp) &&
>  	    bdev_max_discard_sectors(mp->m_rtdev_targp->bt_bdev))
>  		rt_bdev = mp->m_rtdev_targp->bt_bdev;
>  	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev) && !rt_bdev)
> -- 
> 2.45.2
> 
> 
