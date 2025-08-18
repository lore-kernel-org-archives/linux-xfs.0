Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E755F18871F;
	Mon, 18 Aug 2025 04:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755492240; cv=none; b=i+7i/lyNpYAQbEQieNafOMvg+AjwB5bX7Vj+eA5wmIcvZpfAhWLQMUjHkpDXIq2SuKUjT5zyzv7YkhN51ZOTvXU5hSy4IpbfW/9CaI1REPsmRs8+bXKucWprSR1z1qhz5l6YRKQ/kb2DtuMxWZwaIzSSr1BsCXV+Bmzr5kO8zgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755492240; c=relaxed/simple;
	bh=80kJvy07dW4KaqD/Q0pkwPLz7ZxqGJbsohCUNiX8eJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcpbU/a9jqZ9heHUUm0nGacDTdv5QgyVLFjKDq/dQWMrMi0EISyT4wXQxX8tWqb24BBhzFjYlUxh1ssk4Ch18EeYHjQd76K1hwVhqvJdvpRBMvU2txAHf/Bgkg1Mh28MNCW4TpmKsZzL6hVE1xMsdistJV7cR2dTrV0fVKc85TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SqhO44r2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SqhO44r2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k2Shf7AnNNnzE2815C58OfEvJwWhlSkhMmIH+MwrRqo=; b=SqhO44r2LZ03EJTg8Jsrb72RGf
	tj8C8/ac7vtcDLeKgfciPiufRq7fU+BsS+wSAYCecj7km/uIA5bbLwiHB346VJKfQcLtnCvccLhrL
	oZhfQy0yyqsxhKtpWcVdanFPzdkPC52qKlcU8vFmK0h8SG4XHLW2g36m5ZyZzs8Hu23dlZRT0rDLV
	AViO9Ol1UA5H2ARq1FseXnnlnnOJWuzENhvZLlYpDMYRBHhD31GQq+eSHlgbNr5RuF1vyt6O8kUwy
	a9Yk97Vm6kMAqweNdCg8o3rBd5+DSSEB6VPIQO3qViiVgJiMm779inIpjq7AYjRFa6QVQ2REA2D/e
	O4XyNEcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unriv-00000006USp-1lBr;
	Mon, 18 Aug 2025 04:43:57 +0000
Date: Sun, 17 Aug 2025 21:43:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
Message-ID: <aKKvjVfm9IPw9UAg@infradead.org>
References: <20250817155053.15856-1-marcelomoreira1905@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817155053.15856-1-marcelomoreira1905@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Aug 17, 2025 at 12:50:41PM -0300, Marcelo Moreira wrote:
> Following a suggestion from Dave and everyone who contributed to v1, this
> changes modernizes the code by aligning it with current kernel best practices.
> It improves code clarity and consistency, as strncpy is deprecated as explained
> in Documentation/process/deprecated.rst. Furthermore, this change was tested
> by xfstests and as it was not an easy task I decided to document on my blog
> the step by step of how I did it https://meritissimo1.com/blog/2-xfs-tests :).

I tried to follow the link, but got a warning about a potential security
threat because firefox doesn't trust the SSL certificate.  But maybe you
can add what you wrote up to the xfstests README or a new file linked
from it to help everyone using it first time?

Either way this probably shouldn't be in this kernel commit log.

The change itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
