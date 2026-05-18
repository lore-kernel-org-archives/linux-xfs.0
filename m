Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95C032936C
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779103118; cv=none; b=uZ0LnC1ost1IpgFHBaP+AXBUKl3HVqeV9I2ooDZ0RYjqgc8VBl71mLQnggKT1UWdiiHgiOhY5NqH1fxPWDIoGpCpbduXPlrCZ953EzVeThIaOFCD5vJf5zNXxYP7Zl/A6xEVJIohzIIpjLh/oGB66XMYsc+b6xpo7nsBYg6QZGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779103118; c=relaxed/simple;
	bh=v2DElWWB2p6/Vlbm4qAjWlyEw8Vtz7I26/7tg2HeXBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sX6/uQhE9q6nsOSm8lU7G7FPJddD+oc9fJMeKKPNokM0nqb2GrozVb//UFSvpCxlx1NJl1YdqpYj8OqKQ5w2Hd3j3emO5VV/alkAIG/7rluXwK29j4QLhjJoa8m7i8v4kG2GrGkpDhIzdI05089HDYkvpnfqJkccyT0Cn0SCmAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bip0Htpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bip0Htpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEDBC2BCB8;
	Mon, 18 May 2026 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779103114;
	bh=v2DElWWB2p6/Vlbm4qAjWlyEw8Vtz7I26/7tg2HeXBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bip0HtpgX6X+gsrEggI/JMYdiUtYSBpNDutWSliKpgaoAVzvHE91/z/S3Ryff4QVq
	 MjIJzAnT3FXxxO/wSKL83N640gj6uZtjc+YTDkT8pLaM3Rw5dZQHVWekb7xXfYUG6t
	 hKU9eYNiERR/RenONdJAsLSzbWIlP0Tlq9Uwle+pacUItyMO/ZkbSJ2yV6EucjOVIz
	 wIdUUAvEuVqH1I9fcz7S+v4UGdHWUGUlB64k07BukvpVb2MpfVpAeHPiI5JavL2YJR
	 xltcZ1Ow+PDFgPYer2rNcrYY8AVBiT9YvRF4BW+f7Xwo6Q2pCfXu1pY6YbOmW1FYc7
	 NM/qsaPBpL25w==
Date: Mon, 18 May 2026 13:18:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove xfs_setup_existing_inode
Message-ID: <agr1gXbrYymF1_Pc@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-9-hch@lst.de>

On Fri, May 15, 2026 at 03:50:29PM +0200, Christoph Hellwig wrote:
> xfs_setup_existing_inode only has a single caller, fold it into that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_icache.c | 7 +++++--
>  fs/xfs/xfs_inode.h  | 7 -------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d0bc8ea79d40..37caed10c089 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -817,8 +817,11 @@ xfs_iget(
>  	 * now.	 If it's a new inode being created, xfs_init_new_inode will
>  	 * handle it.
>  	 */
> -	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0)
> -		xfs_setup_existing_inode(ip);
> +	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0) {
> +		xfs_setup_inode(ip);
> +		xfs_setup_iops(ip);
> +		xfs_finish_inode_setup(ip);
> +	}
>  	return 0;
>  
>  out_error_or_again:
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index bd6d33557194..724baea02c8d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -630,13 +630,6 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
>  	unlock_new_inode(VFS_I(ip));
>  }
>  
> -static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
> -{
> -	xfs_setup_inode(ip);
> -	xfs_setup_iops(ip);
> -	xfs_finish_inode_setup(ip);
> -}
> -
>  void xfs_irele(struct xfs_inode *ip);
>  
>  extern struct kmem_cache	*xfs_inode_cache;
> -- 
> 2.53.0
> 
