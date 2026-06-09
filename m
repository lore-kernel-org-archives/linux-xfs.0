Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC772E9729
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 23:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781047237; cv=none; b=Mc+MKXaso+QizqJghVm2cKPMb4POtkrupG2Tpac0jlh1Eth8RvBY62Pi7oEd7kc+qM45ox7HODjtT4WSVlA7FZWhPLuTUtr9oSa9fFpCRw9Of3sxTgB7QoMx8pBRTvZG9r8FH+LaJrkQJjw9/dhXy4IMgRvYXV6ahkxvE7iJUdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781047237; c=relaxed/simple;
	bh=7FuqQ1rY93QTg25qHOTTIg53mKZwnZY2Mxigz7ZLO/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tumWuNKzawNbAWlzAjxEI5vEKagdXqy59Ie7tUoRD/fng0FMD8cjY8Y1LD2pPXoGmdkDNlhKjhnYJgSJl4zdehrYIf1b9AfjJWqaC9L+dqemEV1u0+L3obW9tz4U994QuhsJF6Wd9zVVkSRVfu93QNBYeM1qwrVhQTar1C5vpNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lw5i2c82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lw5i2c82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C5B1F00893;
	Tue,  9 Jun 2026 23:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781047235;
	bh=MV1JqTDc0fnIEPqlADUMdcjg7vfYN/c5VRJ89k6RpvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lw5i2c82/GyLl7cHVR2PSyoaZktk/mTdre+P6nvuoBkFC3kPtDeIR5vIH9kTpaAKP
	 BLbJ0SpVnto16ctZNS+oa/lBMaaPCwJMIYSTyQFpg0JrpZXkHmOJeGo/GXwtrfVySW
	 vVKjSwjXsio5Nj/N5Cfv96VsKpfVUPlom8SekmqMz8yZYvKcRskpT5QqOcM4pZgBTD
	 r1NJ6aGfbjlcwnp5IZCl9jST1YvnAtbevyDsmU1+HJJa9y2Zo3Cidr7aYB1l3M7OvQ
	 EtDivgtrDxLjr1PifjnHcMfjvTLdKYxmYbLtLTdlKT1Nk4LILYOaHxSAxFRzDQvukT
	 fqWlL+7i1Wu8A==
Message-ID: <46e85fe2-ab35-4630-a062-7e4ac91e2e9a@kernel.org>
Date: Wed, 10 Jun 2026 07:20:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: only log freed extents for the current RTG in
 zoned growfs
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260609075655.1698743-1-hch@lst.de>
 <20260609075655.1698743-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260609075655.1698743-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/06/09 15:56, Christoph Hellwig wrote:
> Otherwise a power fail or crash during growfs could lead to an
> elevated sb_rblocks counter.
> 
> Note that the step function is much simpler compared to the classic RT
> allocator, as zoned RT sections must be allocated to zone and thus

s/zone/zones

> realtime group boundaries, and also because the rtextsize is fixed to a
> single FSB.
> 
> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index fd07c1a18615..728f444fbc30 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -890,8 +890,7 @@ xfs_growfs_rt_sb_fields(
>  
>  static int
>  xfs_growfs_rt_zoned(
> -	struct xfs_rtgroup	*rtg,
> -	xfs_rfsblock_t		nrblocks)
> +	struct xfs_rtgroup	*rtg)
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_mount	*nmp;
> @@ -903,7 +902,8 @@ xfs_growfs_rt_zoned(
>  	 * Calculate new sb and mount fields for this round.  Also ensure the
>  	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
>  	 */
> -	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
> +	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
> +			mp->m_sb.sb_rgextents * (rtg_rgno(rtg) + 1),
>  			mp->m_sb.sb_rextsize);
>  	if (!nmp)
>  		return -ENOMEM;
> @@ -1219,7 +1219,7 @@ xfs_growfs_rtg(
>  	}
>  
>  	if (xfs_has_zoned(mp)) {
> -		error = xfs_growfs_rt_zoned(rtg, nrblocks);
> +		error = xfs_growfs_rt_zoned(rtg);
>  		goto out_rele;
>  	}
>  


-- 
Damien Le Moal
Western Digital Research
