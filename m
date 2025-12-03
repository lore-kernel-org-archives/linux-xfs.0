Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9744C8F;
	Wed,  3 Dec 2025 06:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764743108; cv=none; b=ub/cIOHY7MyNO7ks+nT2Dx0XaNvIOSkBLLs8GJFPywVAATNpjN8K1ZYqVEZZxZ+0DFCZd8sE0GCVBz6j5jBphc709SY4OLMfVeQGVQc4F6MY49a/fB5dfe0KH60qQT31rOvnFPMrfRCU6BDx60s/1IJsLnYZ6uCXiTyhYaJAdAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764743108; c=relaxed/simple;
	bh=eOaRjc53cZtQBYfiqTgEag2N25yRlzTlRg37KWycoM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOj6rqaZ7N2vRMl/cn+YAD+4oTtzWlw4j2mVz8PQJZWm1W8VnPA65hldeLmPenW2UOXkQ6qsQzno+d7NdGmRgKirCaU7yGUCd+ROceZSsHOi6N5+kCjDQwjqmQf9jpHxtuAY4EflMH/KKOhWvBvEwensYITxOXxtAoPwRSXST4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kyGQfx1r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kyGQfx1r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=w2dTkrzBywgfj5paCdFLbNs9stSgoNN/CqiqRqlN38g=; b=kyGQfx1r0tXrA+hf2757yjDEJ7
	4JBHvb/YzH19+Wsvcg2xEaTiXsKZwvkZ3CVHh7dOkPfojF6dXm8nCuqibAv+QWcIUNK3BO15x9ZPt
	3kYpzxDEG2WXQ06VlSBNX7V0rg8jrVcV5350msHvwF9izNyefj8IjqFH6n+vUxyqz9L9/c2CJX0KY
	UUiTQQGh+dEp+jxldkcupZIrYOY55t7Bf6K3qWV7fmab54znfVowx3VmVeTd34gHxnAXJR6pj5YmL
	ekoxJ737cPFgFu+rZapd3Xq4gzFaqfLp7D+8Ngy39pNZgS67W+ykRb43XY9eL71Utj3vzNgYEPqy1
	tLO6W9cA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQgIT-00000006BLA-09ww;
	Wed, 03 Dec 2025 06:25:05 +0000
Date: Tue, 2 Dec 2025 22:25:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, aalbersh@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] libfrog: add wrappers for
 file_getattr/file_setattr syscalls
Message-ID: <aS_XwUDcaQsNl6Iu@infradead.org>
References: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
 <20250827-xattrat-syscall-v2-1-82a2d2d5865b@kernel.org>
 <905377ba-b2cb-4ca7-bf41-3d3382b48e1d@maven.pl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <905377ba-b2cb-4ca7-bf41-3d3382b48e1d@maven.pl>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 02, 2025 at 04:37:45PM +0100, Arkadiusz Miśkiewicz wrote:
> &fsxa should be passed here.
> 
> xfsprogs 6.17.0 has broken project quota due to that

Your fix looks good.  Can you send it out with a proper commit log and
signoff?

Andrey: this seems almost worth a 6.17.1 release, unless 6.18 is
going to happen very soon.

