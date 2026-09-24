Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDD1489FC6
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281855; cv=none; b=AhBCbozmSM4BgPy6fx2pb5Qf3WvRGpXNbY1q8nhSwtrCPAfh0gPaBccwI36f50+UXRb4kTMPUVRF1L+SMxTQaeSnRLjv1z6Cy/Iv2jZ4H6c1rMKbE5M97FbinP87WuHLbLaJnrWO5FJfAuBkTuPHja9chJKsL2v9ZLYH1AiK2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281855; c=relaxed/simple;
	bh=0DTgQ9FLm8Dfi9yhl5qG70MbMkXfjhu02AGkSRI0kcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWv6fY5niIvRx0W/zExp1SooWnsSOXKqusPqXa2SkOlLZ9j6Ar0fzUZuYAjsZAgKqDIIay8HQhASuaHvoYrCT7Sgd2QF+bJea1NSL7LTVw0ZwUeIENRsPeR2k8VJwzw+44cyIEA8jqko7XlzF52uOgohFI/4pDC3pmL1x5PKbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbTy0G64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbTy0G64"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9BB9E1F000FF;
	Thu, 24 Sep 2026 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281849;
	bh=BzdcZ9b+CAYHkOZ+q+zg/1gptvFwvA4o2B0ZfqJBFss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZbTy0G64L7Ypmo59at71IY3fDYpZivHVKaWrd5rGgvqzTFv8Pb5pGshqz/hLPedWt
	 QFzSPWdZX8LwFSOKXrdl5rm1920QJpPKPHhn/vY3u/vvv5dx4YK2c9xPOxrrSytWoq
	 O+1p2IY8hew6y4YBtCzmyBlDigq1zyNTJ2WIZzqbkUsVvKn1EQGrCzGRZGcSPwgDOt
	 RmnyniUVlBOQvGxsUA8Ntm7riY68KX2fl5bwGa/u3AG8nFDiHqN4aDg1ZkxemPma0y
	 KourPLprcf/JLmpGanhzOyfUvkp6N3ogYdN30rYhto3+DGkRrOI0OYS6o6LClSdNGB
	 1z8Mdbxpm6jvg==
Date: Thu, 24 Sep 2026 13:30:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/32] add cpu_to_le64 and le64_to_cpu_helpers
Message-ID: <20260924203049.GB2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-3-hch@lst.de>

On Thu, Sep 24, 2026 at 12:03:52PM +0200, Christoph Hellwig wrote:
> The crc64 handling will need them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/xfs_arch.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/xfs_arch.h b/include/xfs_arch.h
> index d46ae47094ae..348ff0077c99 100644
> --- a/include/xfs_arch.h
> +++ b/include/xfs_arch.h
> @@ -195,6 +195,8 @@ static __inline__ void __swab64s(__u64 *addr)
>  
>  #define cpu_to_le32(val)	((__force __be32)__swab32((__u32)(val)))
>  #define le32_to_cpu(val)	(__swab32((__force __u32)(__le32)(val)))
> +#define cpu_to_le64(val)	((__force __be64)__swab64((__u64)(val)))
> +#define le64_to_cpu(val)	(__swab64((__force __u64)(__le64)(val)))
>  
>  #define __constant_cpu_to_le32(val)	\
>  	((__force __le32)___constant_swab32((__u32)(val)))
> @@ -210,6 +212,8 @@ static __inline__ void __swab64s(__u64 *addr)
>  
>  #define cpu_to_le32(val)	((__force __le32)(__u32)(val))
>  #define le32_to_cpu(val)	((__force __u32)(__le32)(val))
> +#define cpu_to_le64(val)	((__force __le64)(__u64)(val))
> +#define le64_to_cpu(val)	((__force __u64)(__le64)(val))
>  
>  #define __constant_cpu_to_le32(val)	\
>  	((__force __le32)(__u32)(val))
> -- 
> 2.53.0
> 
> 
