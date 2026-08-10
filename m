Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5C935F60F
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786385467; cv=none; b=j+MMgA9N7pEnR5ZKDCp4dS/FLToklcTDNy7Znh8sdxGtYVJLCN3sU5Z1hWC++6uW3KuUFF3ZQDAXBFkwctj1FAlTA8bwYCDEvSgHzmkQeUO/vRHSgfDX39a9pwth+qobgn/UUWWNVhn8CDA37QFw7qeIqbivex4HSbLSCS//6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786385467; c=relaxed/simple;
	bh=EkIUI4QTkZ8Y+mr4yICF/craqr6Yh3wE92c/Ys692Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zhe88agJeEqGqxOyRAE9Eny2NJjJ2LPEqtOHYqIMjV/z5seblmRy+stfaVS25zzdIhkwZhMzYr/18N0VeK7zXs7gpG++cyK4tw9ohTxVGjWi3nclXJIYRvlOi1AyeU0rw7u9+QdVw+dgyhyrBbnJxW+L5OwLN40LzSJM7wytocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVXv8NMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVXv8NMK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 482D91F000E9;
	Mon, 10 Aug 2026 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786385466;
	bh=K/3Fx6rd5LGzgOrlkPrbVdbrt4cFXtx6Hzedx89yX2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VVXv8NMKLLN4FyzFG3D1OWDBr0uG2wlVSJxsfH68GdQwdyBlQpXvQ8vk3qqIerkT9
	 x3D+8UskOkpXR0NpRks/u7hQcb5/Telebp0OCIW+lu+DdybbbDVMnd4uLelgfwNvMk
	 Wi12oYbOMeYOjv4N4smnG8ruYt8K6PK0rcnLcceh1ksGJy6/LbKL6YdNge1nTv6RFE
	 rnKFqIdFazA9s/JtQGILRUkUa4zf3PtzXxPs4HZgL2bm/06suS/fjrJKigo56vCXFf
	 QYLEeE9wx/fISLQOKJMfxAqC3gxi9/N0fDx8TtOUHsbTj06iksUDrvLdUvG/A/Bem7
	 1Ketv7mqW93vg==
Date: Mon, 10 Aug 2026 11:11:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Message-ID: <20260810181105.GU3556460@frogsfrogsfrogs>
References: <20260810153759.466417-1-hch@lst.de>
 <20260810153759.466417-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810153759.466417-4-hch@lst.de>

On Mon, Aug 10, 2026 at 08:37:44AM -0700, Christoph Hellwig wrote:
> Don't overwrite IOMAP_F_DIRTY with IOMAP_F_ANON_WRITE, but ensure both
> flags are set instead.
> 
> Note that in practice this is harmless as all zoned writes force a metadata
> transaction anyway, but incorrectly assigned flags are still a landmine
> that will cause problems at some point.
> 
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,

Cc: <stable@vger.kernel.org> # v6.15
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c  | 3 +--
>  fs/xfs/xfs_iomap.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c80f05507373..9506cd8d15e6 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -634,11 +634,10 @@ xfs_zoned_map_blocks(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	wpc->iomap.type = IOMAP_MAPPED;
> -	wpc->iomap.flags = IOMAP_F_DIRTY;
>  	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
>  	wpc->iomap.offset = offset;
>  	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
> -	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
> +	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
>  
>  	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
>  	return 0;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 225c3de88d03..9fa9aa33745f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1081,11 +1081,10 @@ xfs_zoned_direct_write_iomap_begin(
>  	}
>  
>  	iomap->type = IOMAP_MAPPED;
> -	iomap->flags = IOMAP_F_DIRTY;
>  	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
>  	iomap->offset = offset;
>  	iomap->length = length;
> -	iomap->flags = IOMAP_F_ANON_WRITE;
> +	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
> 
