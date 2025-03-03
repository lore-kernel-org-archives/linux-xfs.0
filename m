Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E4C13C816;
	Mon,  3 Mar 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010945; cv=none; b=pFvCipalJp2tkXPBgcXg/4zfwNSwbWpMhA3KxAST5p2y0KXjQUtubtsNAO0vQ6l/nKUigqtvcl+0CRc3WwyBBQEzzqyfiG8x45GQeXRPHFE3o/wiBqxpS/VU4L7nVQXv6y7Nhkh1KcU2b8CwH0wmNQyfsggQIbF3xXUf77JlZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010945; c=relaxed/simple;
	bh=Bz1lkAIfe6XJhf3eq5SVjSBSproAa10eY3/wDj27F2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7hXsMQO6SBP1bEAnvmWUDa6NVJA8pDCuAhDrTl5zUZCgDJrK64pBGXjE+h2taHFhFjjKrbRv41UUH3cgxR4936udKJRkd/+kYAL3UM+p80xcWRhBgrOe3nggc31yKB7oiPDCz4ayxEBBv9sb1+DdFA9sjWJ9MNC21gorNnkK80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWADDRKw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yWADDRKw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=da6DZJIEZngOU636aAML7UreXiQIbQlvEAqAV9JlA8Q=; b=yWADDRKwjkLdCq/W/PQvaik30N
	0WruLQPGjrswfXxDKwxx+1WQMUfx750OQAM24RECp2kOZAgjevytteVQNn6PqpP6PzdEr/9U6QUag
	vyXBq7/jum9t2mJcqHLd/9LNFAFluSZRdJobILmJEl4zK83osoYeKSi39U77Qns7TxoZy1an00tYG
	Zfdw/l3rd48uH+2izKyhVKLaHpE1zN+463MrOqLdWHqZwZmt6FEJxtFR3gACrbktm/mV2tKxoqRmb
	HXr3zbkSOn3EExsPDiUAD3ff6bvEwSB87pfzvqHNQxZXyzzqHxeP2RGHJ0PjReJnvraPYRPSnhJbm
	u7ADZJQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tp6TY-000000011yk-1M1Z;
	Mon, 03 Mar 2025 14:08:56 +0000
Date: Mon, 3 Mar 2025 06:08:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	alexjlzheng@tencent.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't allow log recover IO to be throttled
Message-ID: <Z8W3-Jni2k_MqmZs@infradead.org>
References: <20250303112301.766938-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303112301.766938-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 03, 2025 at 07:23:01PM +0800, Jinliang Zheng wrote:
> When recovering a large filesystem, avoid log recover IO being
> throttled by rq_qos_throttle().

Why?  Do you have numbers or a bug report?

> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index fe21c76f75b8..259955f2aeb2 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -22,12 +22,15 @@ xfs_rw_bdev(
>  	unsigned int		left = count;
>  	int			error;
>  	struct bio		*bio;
> +	blk_opf_t		opf = op | REQ_META | REQ_SYNC;
>  
>  	if (is_vmalloc && op == REQ_OP_WRITE)
>  		flush_kernel_vmap_range(data, count);
>  
> -	bio = bio_alloc(bdev, bio_max_vecs(left), op | REQ_META | REQ_SYNC,
> -			GFP_KERNEL);
> +	if (op == REQ_OP_WRITE)
> +		opf |= REQ_IDLE;

And there's really no need to do any games with the op here.  Do it in
the caller and document why it's done there.

