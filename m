Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAD6421A00
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779905025; cv=none; b=RnwIiFR5QKGsJQn/ZprmuYalGZhnlQA0XzmoYnM2zJHDF6ruL0pYX5kQ+4zEZp2NZESgEmJZ6XE3+mu7o0e5Pnndv6ai1VtMi4Rhfqg0TgZBb+h2Z9IZl392m8Moi11wkyfNaH7AzQ6+V0n4dL+hLPMnn6xZ/q0/hoZGruJu5N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779905025; c=relaxed/simple;
	bh=mW33SAH8E07mcu45AR3o171CCBl2nDFAeUZJtaZRDnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uMmq6mIajw6vCbUFAeuUI4NmXc7QVepG+cS3EGL1tK7E0BH4RpcgYrXCo1zrVZJzY2WadHe5NyIYa2C3rt1NmYlEcBDj1jfhIxneS16uqZUELJz9RTh5So8WP3hsC4RKaiXIW7H+3k6RbPi0Bu+3piSy/xksh+zB1Qn2RwjRaMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbYys7cL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbYys7cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0103C1F00A3D;
	Wed, 27 May 2026 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779905023;
	bh=BEahKK/hCwff27snf8XbHV7VNPwG2Nwo3aTsAlKqUSY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fbYys7cL2FKt+oBHiBQ+W+HIKpgezig3yeFiKA0KGeXO+5n13c0GgqgkqdT7FrkI9
	 Vo4QJwclwN3SDhsIic2+REcUJMfSl8FMpc1Xkv0tNbiuwk17ln9AI5sZ8rIjootVin
	 cPouSo2ev3jtT5wGBLxxQGMm0D6J5vShorPsuQ3GcLUHimAzcB9UvC9TbrePtCEHvV
	 CWs/oMEVQasPkRnPbtqouPnvEXbHfri7XrkCwbu1+909FBRjt3ZsSRsEKvqkudSkIc
	 XOYKQBT82U9z0Xc58duWaNZ/xSh8i4T07NJjH7VXvDJkZEQEqXpywdRjlNmMsNsl7k
	 YGQ6l43rB147Q==
Message-ID: <4038eaae-4551-4a22-8f75-3b4037a6a5af@kernel.org>
Date: Thu, 28 May 2026 03:03:41 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: drop the experimental warning for the zoned
 allocator
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260527123941.2319377-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/27 21:39, Christoph Hellwig wrote:
> The zoned allocator has been released with 6.15 on May 25, 2025.  It has
> seen constant maintenance and improvements and no major issues, so
> promote it out of the experimental category.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

One nit below (feel free to ignore).

> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index d964bae096ef..66a02d1b9ad7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -580,8 +580,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_OPSTATE_WARNED_METADIR	17
>  /* Filesystem should use qflags to determine quotaon status */
>  #define XFS_OPSTATE_RESUMING_QUOTAON	18
> -/* Kernel has logged a warning about zoned RT device being used on this fs. */
> -#define XFS_OPSTATE_WARNED_ZONED	19
>  /* (Zoned) GC is in progress */
>  #define XFS_OPSTATE_ZONEGC_RUNNING	20

Do we want to compact the numbering and change this to 19 ?


-- 
Damien Le Moal
Western Digital Research
