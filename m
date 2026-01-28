Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF5110A1E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564298; cv=none; b=m81USY4kwRc8f+L6WOAAsWjcOZEG7PnDALSerTcwsXcK12vXZGX3NA8JXWa86VA/Aqc6mDuTyyKNOLjU22vG66pogVQQeUJ29L4e7odRvVeB7EHJP6Q/StBP8fyzZltftIuhqX5dxx/DXHKfGY+slt0FThwTX2BDKSh9nRynfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564298; c=relaxed/simple;
	bh=UZ2YoS41AFBZHjgZRh/B0CovEmt6n61KzvUOQzl+Yvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p2QNXUrhBBgbJvfYragcJF0+xyK4NWsFsl5v41dGKCsDv5ItTmm9Sggqr2o6zrDUJ6nc1sAP4NTwYW3vBh60ROBpGX7ADZmQozXgwB02Wl9uZimb2xOsKgiXuWoDAXSafNCkBr8eddl53JjerQdg285B97zvNDSU991EQ96B0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpeY4Z+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpeY4Z+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890DDC116C6;
	Wed, 28 Jan 2026 01:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564298;
	bh=UZ2YoS41AFBZHjgZRh/B0CovEmt6n61KzvUOQzl+Yvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpeY4Z+d/pVti2UTNsMk2zIcBQ35IAoTLJ8r6due3/0O/2xhrqKo68I5ufpdrTFlk
	 gSqXzwEQfB6xSu5E1a8/QzHBbcGU5TXR2U1jCdbJUKapBKmvtYLCBD25a/z3+7YnOS
	 kQDuPu9jt7Zs+gkzgvr4gGFOWRcIruaxMuOmHChh4C4mvUkyt7uNsLEnuivJg31ee8
	 Qr7RVwuSO838Sja0GeBhAKyKvyjA5Ek/7gyrsHlfEz2ROLk0mpgL63S25prQ3vIn5M
	 ccVc7BYDDWRKGbtnbVLrXNyXK2xrv9AaxtYwJeG+25TTAzznPTeSrnPsiIi1T0g6R2
	 L4RHQ+2wcs+vw==
Date: Tue, 27 Jan 2026 17:38:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC as
 sync
Message-ID: <20260128013818.GG5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-8-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:47PM +0100, Christoph Hellwig wrote:
> Discard are not usually sync when issued from zoned garbage collection,
> so drop the REQ_SYNC flag.

Cc: <stable@vger.kernel.org> # v6.15

> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

What does REQ_SYNC even mean for a discard, anyway?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 7bdc5043cc1a..60964c926f9f 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -905,7 +905,8 @@ xfs_zone_gc_prepare_reset(
>  	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
>  		if (!bdev_max_discard_sectors(bio->bi_bdev))
>  			return false;
> -		bio->bi_opf = REQ_OP_DISCARD | REQ_SYNC;
> +		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
> +		bio->bi_opf |= REQ_OP_DISCARD;
>  		bio->bi_iter.bi_size =
>  			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
>  	}
> -- 
> 2.47.3
> 
> 
