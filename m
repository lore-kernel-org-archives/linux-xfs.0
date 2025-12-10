Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C022FE0A;
	Wed, 10 Dec 2025 05:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765344799; cv=none; b=MZbYuo6SMGao7zEWDH0wcy0D+CPMfJPfE8ZwRSF7XDgsWvU68yDUGR5yK/YYlctiAc27nNgamdutF641W59W6icdkRbkNkJk/CFEpTvvVG8ZeBM/k4Oge9h11pr9lQOy98Un0Bm0vYLsS+m4UT/WI24S7ifsbb5Pss3C00JB5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765344799; c=relaxed/simple;
	bh=lbwvwXWzNJQg0D0whYabQqpf4faHZKOzfUVbRO2CbTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCBCSjJ282onKjFFcxBx9m1aF/minxkLpWlrwNorWGKNTfQd9xXF1LZ7iFZmucP8MvlW6cjt1SB8SXD41bQrqXI5XMiH2pIyQ37oMveQgaxlfQVE8rIzuIan1q3lrXjOnpF1WxOZeT2r2QMA47IvXZB+sjtu2J8dOtxkVlBkBzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdqCFQqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdqCFQqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D61C4CEF1;
	Wed, 10 Dec 2025 05:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765344799;
	bh=lbwvwXWzNJQg0D0whYabQqpf4faHZKOzfUVbRO2CbTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qdqCFQqrqVi89XDOyo036+Bn1o40mBQGFD5AKaJFZFEk9KkxJKHw3ytUaxLKN6+u2
	 PmK2tO9JBdxUF2Wu9L5hyRsIJQwzD0cPIGr0XwpFOzItwl5Yh06Sv7RNRXgHPLeTrt
	 q5t6BfHFqnJEfWEn8SWt2lhfIOLIaJcP79XJ9p7n+PWeCuH2RfTrx/iDDZTTo8UYCc
	 ExxjRqURUG7QPuv1IX/RosIKJMEpycUSR/i8wPDI2jov/bNTZBRCcJDni9MsBVwvP1
	 Q9mzzTuKthJPk6tKz/oKRXeFNVR5/Ozco6aS9hbJ4UlVVgTF3vq+++SpzRrth5+fjF
	 INebxkxbqRDBQ==
Date: Wed, 10 Dec 2025 14:33:14 +0900
From: Keith Busch <kbusch@kernel.org>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-nvme@lists.infradead.org, iommu@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Message-ID: <aTkGGt9unmCS0r4d@kbusch-mbp>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <aTj-8-_tHHY7q5C0@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTj-8-_tHHY7q5C0@kbusch-mbp>

On Wed, Dec 10, 2025 at 02:02:43PM +0900, Keith Busch wrote:
> On Tue, Dec 09, 2025 at 12:43:31PM +0100, Sebastian Ott wrote:
> > got the following warning after a kernel update on Thurstday, leading to a
> > panic and fs corruption. I didn't capture the first warning but I'm pretty
> > sure it was the same. It's reproducible but I didn't bisect since it
> > borked my fs. The only hint I can give is that v6.18 worked. Is this a
> > known issue? Anything I should try?
> 
> Could you check if your nvme device supports SGLs? There are some new
> features in 6.19 that would allow merging IO that wouldn't have happened
> before. You can check from command line:

Actually the SGL support is probably unnecessary for ARM if your iommu
granularity is 64k. That setup could also lead to an uninitialized
"state" and the type of corruption you're observing. But the same patch
below is still the proposed fix for it anyway.
 
> ---
> diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
> index e9108ccaf4b06..7bff480d666e2 100644
> --- a/block/blk-mq-dma.c
> +++ b/block/blk-mq-dma.c
> @@ -199,6 +199,7 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
>  	if (blk_can_dma_map_iova(req, dma_dev) &&
>  	    dma_iova_try_alloc(dma_dev, state, vec.paddr, total_len))
>  		return blk_rq_dma_map_iova(req, dma_dev, state, iter, &vec);
> +	state->__size = 0;
>  	return blk_dma_map_direct(req, dma_dev, iter, &vec);
>  }
> 
> --
> 
