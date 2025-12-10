Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE4C30F94D;
	Wed, 10 Dec 2025 04:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765339545; cv=none; b=Dl1TO3ujez/4ifnKvryWHaEHampWenIxlMbB0kiannTWoDHP2XR5nNCsAE62vDu2q8yTCdbSDaaDZeCaB/lOCBZ/f5OYSSaTfzGhbPhxcFjT37ytNcg0EpNYlhMz31KkLbWlPNN/eP/fs0utHlekxfb46BINkZ5Zkw7qgD5mT1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765339545; c=relaxed/simple;
	bh=DDXeGI3PrVCWYn4HgWXYJxRFC7N8vlabUufE9+1W1hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIugEN2XMmYhVMXVlrqXBog7grfEdC8zdbrX1CJh6Hv/BuTRmR5vJkQCAlrlu2QxZFHJJz/5+NnPGzBInHbOKwKDxYN3k8xDZbchIBILkiFUnGLXBg4lyHEOqFzOQTPAjtd/a3vdWL2bh1sqzWQHe69g1/+XPmqHEbX/L0ipX5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3gYJbMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3gYJbMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D2CC116B1;
	Wed, 10 Dec 2025 04:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765339545;
	bh=DDXeGI3PrVCWYn4HgWXYJxRFC7N8vlabUufE9+1W1hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K3gYJbMVRCC87PmUQ02vWB+jUJdMU6wSQL3EWDlwZ4hdXkL6y1EW8vSd8b3I22MwD
	 gb/M6kjjt6Z9jA/SkjKVeTwpYzLNdGiAE9BPpVMBReng9K00FrH3PjJIyb2NM/3Lah
	 pmCklcpqHMPc76RFgxZjYIk6WdFDg6qMOUc0bZih+0piHrJIw5UQ7ItfiGMiROwq+m
	 tsHBinhfxt3Fz1ONr9RZTxbhlBb5TYB1s9avApO0Cm8OhTGt1VNzZBthCyKd6Rnslu
	 Oj0Gd8RQBNPjiaZwH+Zu3Eiy59RKsabggSdbwLMy2w9vXNsHe552FCZ64BDnuX98kd
	 NF+OXmPBOsyIQ==
Date: Wed, 10 Dec 2025 13:05:41 +0900
From: Keith Busch <kbusch@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Sebastian Ott <sebott@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Robin Murphy <robin.murphy@arm.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
	Will Deacon <will@kernel.org>, Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Message-ID: <aTjxleV96jE3PIBh@kbusch-mbp>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
 <99e12a04-d23f-f9e7-b02e-770e0012a794@redhat.com>
 <30ae8fc4-94ff-4467-835e-28b4a4dfcd8f@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ae8fc4-94ff-4467-835e-28b4a4dfcd8f@nvidia.com>

On Wed, Dec 10, 2025 at 02:30:50AM +0000, Chaitanya Kulkarni wrote:
> @@ -126,17 +126,26 @@ static bool blk_rq_dma_map_iova(struct request *req, struct device *dma_dev,
>   		error = dma_iova_link(dma_dev, state, vec->paddr, mapped,
>   				vec->len, dir, attrs);
>   		if (error)
> -			break;
> +			goto out_unlink;
>   		mapped += vec->len;
>   	} while (blk_map_iter_next(req, &iter->iter, vec));
>   
>   	error = dma_iova_sync(dma_dev, state, 0, mapped);
> -	if (error) {
> -		iter->status = errno_to_blk_status(error);
> -		return false;
> -	}
> +	if (error)
> +		goto out_unlink;
>   
>   	return true;
> +
> +out_unlink:
> +	/*
> +	 * Unlink any partial mapping to avoid unmap mismatch later.
> +	 * If we mapped some bytes but not all, we must clean up now
> +	 * to prevent attempting to unmap more than was actually mapped.
> +	 */
> +	if (mapped)
> +		dma_iova_unlink(dma_dev, state, 0, mapped, dir, attrs);
> +	iter->status = errno_to_blk_status(error);
> +	return false;
>   }

It does look like a bug to continue on when dma_iova_link() fails as the
caller thinks the entire mapping was successful, but I think you also
need to call dma_iova_free() to undo the earlier dma_iova_try_alloc(),
otherwise iova space is leaked.

I'm a bit doubtful this error condition was hit though: this sequence
is largely the same as it was in v6.18 before the regression. The only
difference since then should just be for handling P2P DMA across a host
bridge, which I don't think applies to the reported bug since that's a
pretty unusual thing to do.
