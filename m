Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795699571;
	b=Qto7xWa+nKoYRd6DY9zWdkY8JzMBDyO1AtsnbkekNVmPoP35tqXk3cCl1wF3X0uAdBIU
	 3Hgynugi/CXaAWsJDxVwBTxPQV6poTokMBt/mVP9O5ZZX6lIhTuleOOLQnwVD/oZlAVvh
	 J2t6sKK7g7dWek21cO6nIAYxrQpFpLlBNah/Vk+R6PZPXL0hVnbhrLMvKc0OCoSvCtVr8
	 3iJS4VePSlvFEyvpETkALHCeKneq9wIn/jh/SshViB8mf7vlF+GLp+zdCHBU8ZKUSxmlu
	 eq3BYtEIbYQMpAUkAwwt2BoA60ap1AsxSDHU0tGmMa/qI04zURDCR8+ckSm2YktCG+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699571;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bgVuSd2pjaxr07X6enbjUrrxi2+4Vw8Q2KH9vB7w53w=;
	b=SbBAXv/gv8F0m5ySuJhW+sLCOF+F9RWydvJi3fzysKI2Y/iDtzRYuJw9n6iYcHm8AeZd
	 0yCReJwktKtYxb6+zn5e3Jcu4t7xP5Mt1r7fC3PN+qlHJg14umnPTBFhF1ElAhgfyrGtl
	 GSK/MIqd20GHNmAw2bQOMjV53I+LYISonmJtg0WuL+0bwkhjjwUC0Niy0Jdv5MihJYy1C
	 z5b4o1GTMAwoUXhhIuLFxJ+KnnlO2W93AcYdcWr+G9qlgcjD4xhM2Li6OQW8Cx5k/96lL
	 b//Zbr4hoXBzeGwnScyH8La3EDGYsw1Mb+hUQjB+cvRs2vEpdx0ZGdlQxr7djVp7y+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owOgclWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E90606A31E;
	Thu, 26 Nov 2026 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owOgclWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303721F000C0;
	Thu, 26 Nov 2026 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795699571;
	bh=bgVuSd2pjaxr07X6enbjUrrxi2+4Vw8Q2KH9vB7w53w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=owOgclWkWG9eMwzav+rf+vbO9ILy5ya66C0vovIUiMbQLcWhkl7s0QFfdeTML6zrA
	 +U85JZWiKI97G9ZeF9oapowTqsfsEV2cGCjcgOBSY4i29RMm6uHnBB1gFyA+f+LEhE
	 MbuBnqJ9/VzG6wvpxqLkjiD+PoVREpMiV3+ogBZNRwQ9XOrDcxIpktIqGl9LoTndO4
	 rEbX/NentCiLqcHPuGVDd203NnH6/An8V+NaHKLQDDB9lAfmRauK/ceElf+8DNYb3H
	 LB9V/LzJd4FD+1vgnNgPXRucLsNao4t8RN6rAM3XGMkk0w1TAZ01sBcbVm3SFKj7Wc
	 45yNMa/kSnhhQ==
Date: Thu, 26 Nov 2026 14:26:05 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: dgc@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH] xfs: remove a few duplicated lines
Message-ID: <awgy2d_SbrvHtvkI@cronus.toxiclabs.cc>
References: <20261126122229.2281679-1-wozizhi@huaweicloud.com>
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
In-Reply-To: <20261126122229.2281679-1-wozizhi@huaweicloud.com>

On Thu, Nov 26, 2026 at 08:22:29PM +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> Remove duplicated lines:
> - xfs_alloc_read_agf() checks pagf_freeblks twice.
> - xfs_ondisk.h checks the size of struct xfs_attrlist twice.
> - xfs_rtgroup.h declares xfs_rtginode_irele() twice.
> 
> No functional changes.

This patch does not apply cleanly as it conflicts with another patch
that has been enqueued in for-next for almost a month...

Please make sure your patches apply cleanly to xfs-linux/for-next before
submitting them.

Also add the proper "Fixes:" tags as appropriate.

> 
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c   | 1 -
>  fs/xfs/libxfs/xfs_ondisk.h  | 1 -
>  fs/xfs/libxfs/xfs_rtgroup.h | 2 --
>  3 files changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ae221a158764..2c5b73803a6b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3509,7 +3509,6 @@ xfs_alloc_read_agf(
>  	if (!xfs_is_shutdown(pag_mount(pag))) {
>  		bool	ok = true;
>  
> -		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>  		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>  		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
>  		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index 23cde1248f01..ae16b1bc2bbe 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -305,7 +305,6 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index fca2eb74908c..e505be68462b 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -328,8 +328,6 @@ int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
>  		bool init);
>  void xfs_rtginode_irele(struct xfs_inode **ipp);
>  
> -void xfs_rtginode_irele(struct xfs_inode **ipp);
> -
>  static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
>  		enum xfs_rtg_inodes type)
>  {
> -- 
> 2.53.0
> 
