Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E651487DC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 16:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136052; cv=none; b=ALHx1i6g3yfv2QaJum8AoWDFp47G361n5YdD9tuZeIBzaClrfKFVl9IfMUdeXJepKFVdu3naigEcB7dEa501IMX4zQ+3cGIzM+Zs7uLg/p07nZ0jzhn/zvuabYfGOubLAfSd0nddehE68Fx/nQZHiOpB3l9IgRZnzHf0m2b+ZTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136052; c=relaxed/simple;
	bh=lJBtDC1g9ppO3rE1dpZ/O6GdPxvVWqgKJxRDZqGQFiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJs3p2/hD6hQNGzBj6d/Pq6oNFNft7y8FDMQjwoQFfaRIkygR3+l5OZpDJ0vIEstWEOdf2mMLrUuoE+reOYsXGaB1eFHRTWd3V46HI8kMSFaOdNpPKslknFoj0/XP3FXoLLtKkv6TyULAiO+0RNqljwOtjy9tP0HeO3BR/ZjN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1tTBxQMw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1tTBxQMw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5wshWlcLX0JvJiwagbGGBOS6cXEtdtGqYGm5L5ThQy0=; b=1tTBxQMwNf8PEtIhAaupWQrJyZ
	0ySqIDmzK5Jjv4+pEMvK+ajIuBa+F/sAaDNGvrgynHYumBpA7mRLbHhDqDLhZhZ58POFso4i1EAeM
	y+n8dgq8rYqc1xW99eT+7FzsWIXTSHMKPPqtNGS3TKe+J5KrNcmBws/J+sKxZ8oIxM+9HoXmMq3u/
	Yv3IoHbLelgocszVdS63bOOSpRvUb7Gw0YzFFjDb9LEaERsuO/+vKHreabj8eFfTCZtV1pylXTjVR
	CwljWyGDCWbTnOP/Ek+w1NsuMHkO+Kg4bS+EVAEKWsYpKRRELT0MK8ZbiN56z1J+HjcZwh2GIV4O2
	jEuMiMqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMMU-0000000A0ic-3cMX;
	Wed, 28 Feb 2024 16:00:50 +0000
Date: Wed, 28 Feb 2024 08:00:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <Zd9YsjLkMZ5fccF0@infradead.org>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013644.939212.14951407608685671445.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013644.939212.14951407608685671445.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/* Discard pages backing a range of the xfile. */
> +void
> +xfile_discard(
> +	struct xfile		*xf,
> +	loff_t			pos,
> +	u64			count)
> +{
> +	trace_xfile_discard(xf, pos, count);
> +
> +	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
> +}

Can you split this xfile infrastructure addition into a separate patch
instead of hiding it here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
