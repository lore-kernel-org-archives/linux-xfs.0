Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF3F16F270
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712761213; cv=none; b=cIW4wGjHLTQeDLF1h4jBH5/nesU0XcsCSTgrZtWSc4LeB34Q+1lf0EPBokZsrD3u6xair9Q7SPWN6j1zBD+DpfirSPx9TGSQKgiFz/OXSwEkzouamGawJGgFI1s+GHyMHd/7r/mKjb+L9qBI2pTtRwNohNNdZSVFy6MHi1T+vDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712761213; c=relaxed/simple;
	bh=6f+Y7aVVCYPrkFIER9sTX8tjSO5dywc+9gHFjda0LmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPrSITasnlR2ClWyr0MmDp1AZz7LAFNDTnvd9byIpY1kB5ix2Ix9deKaL+/jnSfMWUmgFLvtHJ9E4S2E0sF6Mx/P0Rx2fNjQcYLPy4Gk1orFcqw+rL4D+2opDQlk2koXruWsKC8PZJnpFQJm23uQW5aEcx5pkihPfmvGhk3iw1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oZIgWWpf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oZIgWWpf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hi7wj4RrzwN98lzIZOcha8Qu1ROxRLqab/8M1PvPQGY=; b=oZIgWWpfaLKmvXYMkgxSAwqzCn
	AWH1120sLvs4bejec+URlBDafrJAEyhZ5DNNHuV55LJv3q6/z8ZTzu59sgMx43oyblLjXr/i9DeDJ
	alVCkI5vha5aH3iDHFmC9NiXRwr+Tbn9+nFMSTvhrRi55r52TbE/k5awVkb6uXmRSqt4Yq85gIppr
	CiAoArafD3az57sM7H2+S///noQR6d5n3+dEt4vlt7LaCi+QiwIe6le0f8YNbSaWr3hbT9hSn0vy4
	icyyMRlKaRGDfVB1k0R/E/2Q3eRx0Fbr0Wmp8Jcs1iE6svBNgIqesYyDG2n+qjAcKha/zPzSj7BLD
	qeaoZanQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruZQp-00000007emu-1FhJ;
	Wed, 10 Apr 2024 15:00:11 +0000
Date: Wed, 10 Apr 2024 08:00:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: introduce vectored scrub mode
Message-ID: <Zhapez1auz_thPN1@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972051.3634974.4637574179795648493.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270972051.3634974.4637574179795648493.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 06:08:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Introduce a variant on XFS_SCRUB_METADATA that allows for a vectored
> mode.  The caller specifies the principal metadata object that they want
> to scrub (allocation group, inode, etc.) once, followed by an array of
> scrub types they want called on that object.  The kernel runs the scrub
> operations and writes the output flags and errno code to the
> corresponding array element.
> 
> A new pseudo scrub type BARRIER is introduced to force the kernel to
> return to userspace if any corruptions have been found when scrubbing
> the previous scrub types in the array.  This enables userspace to
> schedule, for example, the sequence:
> 
>  1. data fork
>  2. barrier
>  3. directory
> 
> If the data fork scrub is clean, then the kernel will perform the
> directory scrub.  If not, the barrier in 2 will exit back to userspace.
> 
> When running fstests in "rebuild all metadata after each test" mode, I
> observed a 10% reduction in runtime due to fewer transitions across the
> system call boundary.

Just curius: what is the benefit over shaving a scruball $OBJECT interface
where the above order is encoded in the kernel instead of in the
scrub tool?

> +	BUILD_BUG_ON(sizeof(struct xfs_scrub_vec_head) ==
> +		     sizeof(struct xfs_scrub_metadata));
> +	BUILD_BUG_ON(XFS_IOC_SCRUB_METADATA == XFS_IOC_SCRUBV_METADATA);

What is the point of these BUILD_BUG_ONs?

> +	if (copy_from_user(&head, uhead, sizeof(head)))
> +		return -EFAULT;
> +
> +	if (head.svh_reserved)
> +		return -EINVAL;
> +
> +	bytes = sizeof_xfs_scrub_vec(head.svh_nr);
> +	if (bytes > PAGE_SIZE)
> +		return -ENOMEM;
> +	vhead = kvmalloc(bytes, GFP_KERNEL | __GFP_RETRY_MAYFAIL);

Why __GFP_RETRY_MAYFAIL and not just a plain GFP_KERNEL?

> +	if (!vhead)
> +		return -ENOMEM;
> +	memcpy(vhead, &head, sizeof(struct xfs_scrub_vec_head));
> +
> +	if (copy_from_user(&vhead->svh_vecs, &uhead->svh_vecs,
> +				head.svh_nr * sizeof(struct xfs_scrub_vec))) {

This should probably use array_size to better deal with overflows.

And maybe it should use an indirection for the vecs so that we can
simply do a memdup_user to copy the entire array to kernel space?

