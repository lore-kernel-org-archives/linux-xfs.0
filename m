Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795702535;
	b=CKrz9zMb5P9aBSA1MJvd4a6L635Xa/8AFh2GqRuTNisgoLft6TTC+bOQJnHClEITyic3
	 jBh/sqBh3830i1cKWGpuTkTs4oEz5PHo+stIXt+90/BH+C7ENRl1Ellfqgd573DluLE3g
	 Ny3GNNBiepXWEhocI3I4SDgMqPipwO4m9XMn4AR8hD2qPpJ3GqrO+eykwtM5Q++I8NBuN
	 fxff/aD8qZosskxe31LKzlVwlbZ5aGC6p1eImqbwV3R8aIWcu4rUsREJjwZtNLxpTyKj+
	 WyGx3c9/dOontfp3wh2+VKuUxqvQKqt/LESJi+MOnGJX9nY8k49c0rfHcKW1vNTDvAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795702535;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tm2aP9IHJto56VqvlWlUBRTCk3Rbjf21oUK1cuoG/6A=;
	b=usx46/24o+x5YCrsgf4hPwFGmMW6olETLFiqg5K/M3bPhbqkQCd5RjPJle2PxBFz5vAR
	 7xAIwbFkZ+qLrVqforWvYNrgngTui2QcA44iTKR4oGT2TWO9539d7m1sGj9wuJ24D4DvW
	 iK4lfgZsHtaB8tLMakMQJ9GlGne9QUN7odhjsM3lrLvD0zkuJblEdVmaN2UNH77oM4F5X
	 jaKqHhhihcS45jsoEX9kvd28s/SlgaWCzIWxUPOnMNG6rKnzeyuPUObnUhWHaTISfhHy+
	 y+eFesO0TF0/6itIMLxyCzrP8YOAv0ynKyQVmZTUewxF5k00MIrAvqk637xbXfhuHfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0h+qGFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3193606A31C;
	Thu, 26 Nov 2026 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0h+qGFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816391F000C6;
	Thu, 26 Nov 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795702535;
	bh=tm2aP9IHJto56VqvlWlUBRTCk3Rbjf21oUK1cuoG/6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k0h+qGFrZxA44sM0hlxfcYrFaNv2R5nLMFSTZH/oYtxZjPFVKW0zR505VOTgM3od3
	 gc61y9LDACE5OqfV47jdf+q/RSGGaE0v8G1690/bTmrCX4zxxUjRAWYSMM1kxEMbVj
	 Q/IyESOnbr4agz3vmd4FsgXMtgSLFQ46RSvntn96mtKJBGpNQuEInmRi90BQiBDZSt
	 eIQLz7fGXv8hIjGxZLP9bELn7BUUVraP6WBlsRboGnDrQWU/VOC5nYJD7O0IfIAzLn
	 qKbI4+hpVFg5+/gL1y371IxT0hAH92V5L+0V7vz+fWpIoU2GC7dTt4fgdRbhh77Fql
	 osmocMVSkBdZA==
Date: Thu, 26 Nov 2026 15:15:29 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: dgc@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH V2] xfs: remove duplicated lines
Message-ID: <awg-k2ZtQ3BHioE2@cronus.toxiclabs.cc>
References: <20261126135947.2820748-1-wozizhi@huaweicloud.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126135947.2820748-1-wozizhi@huaweicloud.com>

On Thu, Nov 26, 2026 at 09:59:47PM +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> Remove duplicated lines:
> - xfs_ondisk.h checks the size of struct xfs_attrlist twice.
> - xfs_rtgroup.h declares xfs_rtginode_irele() twice.
> 
> No functional changes.
> 
> Fixes: 650b774cf944 ("xfs: add static size checks for ioctl UABI")
> Fixes: 6b08901a6e8f ("xfs: add realtime reverse map inode to metadata directory")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_ondisk.h  | 1 -
>  fs/xfs/libxfs/xfs_rtgroup.h | 2 --
>  2 files changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index 23cde1248f01..ae16b1bc2bbe 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -303,11 +303,10 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);
>  	XFS_CHECK_STRUCT_SIZE(struct getbmap,			32);
>  	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,	8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,		256);
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index fca2eb74908c..e505be68462b 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -326,12 +326,10 @@ int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
>  		struct xfs_trans *tp);
>  int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
>  		bool init);
>  void xfs_rtginode_irele(struct xfs_inode **ipp);
>  
> -void xfs_rtginode_irele(struct xfs_inode **ipp);
> -
>  static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
>  		enum xfs_rtg_inodes type)
>  {
>  	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
>  }
> -- 
> 2.52.0
> 
> 
