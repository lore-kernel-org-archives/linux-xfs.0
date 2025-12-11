Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB923817E;
	Thu, 11 Dec 2025 09:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765444733; cv=none; b=ErzsYyI40EtApwCWqlRWzIv9j7hQgUJij+sOkPOfP7b6nAncLBN/YmOnbDvBK27u/r8aNWakRO5BFFlqacT2riUAnAeSA47FsXIPzkzQTNDFIVY/ucBwrqI/gmKEP4taI1faslZ0k1nO1zkoJ2JyiEPdi7tO7c9ZweY0EMfn1eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765444733; c=relaxed/simple;
	bh=WE2U7wyVzJcyGyArkxgph0mtkBEOqRv2JkAvIN8bJjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C+Bp55yXidE/h4Hoct8jrGL1MUbI59t1R+hLqusQIxpwMqUYUqegQ9iPD8vammEEdv34bPk2odxeTJdCVWlbNw0y7CfgJtKxQf+P3PaZnTy2bEnMFLaxwyYSb6KS6N3to3pi3W0Dw2cxwKbQ2QVDRtKlgmUNc3riP2/lXvywuwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mmc4HqbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mmc4HqbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021AC4CEF7;
	Thu, 11 Dec 2025 09:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765444733;
	bh=WE2U7wyVzJcyGyArkxgph0mtkBEOqRv2JkAvIN8bJjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mmc4HqbNS8Y3J38ZInXf63r+bmRZ9tHRW4BRDyXIJfE8rYNliM9tkDiDUy0i6/1nY
	 diJPf/vZnKS+dOvMqTwOWZ/kXdqhF7YV6yu6BpXyxZ0/Ulf+dNzZhPTt7yfMktoa8q
	 22F4XJb8qP719+YUPjOhdrrhcOinHOpowANFNO2LDXQoHPhHlKXdVX0FSeE5W1eZVq
	 GnSU65NfB4gZ6+xe6j28g41B8Zcb/hEDBrF5yMdeb6j/Zp07+0eAFe9UsYfoV+WHe7
	 ykk2wdX0hwlXOAYe1Gw6V4Lk5qJ7dDAsp9veKcy6cqIw1V5gc0SwQLO7QomViX38yc
	 8RcIdRZjMD6qQ==
Date: Thu, 11 Dec 2025 10:18:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: Fix a memory leak in xfs_buf_item_init()
Message-ID: <ojskmuuwjgieezp3zrff6ub5ihgr5buk6gtgqrm5gnr2zzcolk@ret4ukkxzcfo>
References: <JtqOvUhdDjJQGig4S3xReSdQeTJx9dge5OmgMD6FmzXiRntc00kZDqCOczMDCKG0zvW1TWYcDPkxMXDZ2MocWw==@protonmail.internalid>
 <20251210090601.69688-1-lihaoxiang@isrc.iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210090601.69688-1-lihaoxiang@isrc.iscas.ac.cn>

On Wed, Dec 10, 2025 at 05:06:01PM +0800, Haoxiang Li wrote:
> xfs_buf_item_get_format() may allocate memory for bip->bli_formats,
> free the memory in the error path.
> 
> Fixes: c3d5f0c2fb85 ("xfs: complain if anyone tries to create a too-large buffer log item")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> Changes in v2:
> - Modify the patch subject. Thanks, Christoph!
> ---
>  fs/xfs/xfs_buf_item.c | 1 +
>  1 file changed, 1 insertion(+)
> 

We have a cosmetic 'rule' to not use an Upper case character for the
subject, I'll fix that during commit time, no need to send it again.

for the patch itself:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8d85b5eee444..f4c5be67826e 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -896,6 +896,7 @@ xfs_buf_item_init(
>  		map_size = DIV_ROUND_UP(chunks, NBWORD);
> 
>  		if (map_size > XFS_BLF_DATAMAP_SIZE) {
> +			xfs_buf_item_free_format(bip);
>  			kmem_cache_free(xfs_buf_item_cache, bip);
>  			xfs_err(mp,
>  	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",
> --
> 2.25.1
> 
