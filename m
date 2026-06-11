Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE434DCC8
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185871; cv=none; b=MacHSqRVydFZgwwAhUjdyNHd60aJQkNT3oxs5/fKuldWknmELpaLPEWswY6djizAEqP2l2X3YmOn8UiHi90voXqbDFgtmYKdzUWA7Z4jiu4B9OufMcyzR+i6la2a7mZtJsUiAHjpPYchbBvrgaV61gry9zVno+QDJrkzhFjsXxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185871; c=relaxed/simple;
	bh=Zc8Tcd9z3NaBEfU+TDS9bj36iINdizWl2DZY/qszDrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIDpnflacVTmNk/FhO8To0SqBwrOtT9H9RXzcR9YqERKJh/ERyCtkyaDDFgxSjVrdVFiMyhyPCgfMB9TAAMhNlxm83SkZVlvMQMJL6NRBHPdXs4UpEfQmdfqueOP2EJe75FQi32uAm4wOINvfS41+a2kcO9c8nZQ9s2aIuB6rqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CqkPMJ6F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CqkPMJ6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FhcRwBQq+CJ8ldYy5JNmG6jI/CT5o5nf+U4Cz8ethOw=; b=CqkPMJ6FTCh+Xtc1FbMLOEcLye
	6eXFGFfj1A/PpygY+T9KHIYeqrPo/6YpWDzJBUBFZGJYDNWuV0ELAnhT1Orxb8FIV6TyAVW/WLGCt
	sF+8oyrQyXtk23XKNfqLR/GTn9Qu6B0nu0JuVqsQdfvNd7bXchktOGAeSn+q78kLXKeyJXRfcAwKw
	v7qtwYdnPukf5ZPf+DuHn9aOquHx3m7wA6mnyBXCwXJ3A/zOhNPsWEW2QqDeZ0FSBrCNK/dzgbSFg
	zw6HFCbvTyRTmu6RS78X88HAGUOGM26Qb47pIU0FdO7CoVbpXM1mzH9gpKKFyj0YlPeecZdJqkGTd
	jBOnZFdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfoL-00000009Yde-1IQR;
	Thu, 11 Jun 2026 13:51:09 +0000
Date: Thu, 11 Jun 2026 06:51:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yao Sang <sangyao@kylinos.cn>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: shut down zoned file systems on writeback errors
Message-ID: <aiq9TdKU-h6kHWPc@infradead.org>
References: <20260611015305.1583003-1-sangyao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611015305.1583003-1-sangyao@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 11, 2026 at 09:53:05AM +0800, Yao Sang wrote:
> Signed-off-by: Yao Sang <sangyao@kylinos.cn>
> ---
> Zoned writeback allocates space from an open zone before submitting the
> bio.  If the device later rejects the write, XFS cannot reliably recover
> the in-core open-zone allocation state from ioend completion, because it
> cannot know whether or how far the device write pointer advanced.

Somehow you have two commit logs.  This version below the --- looks
a bit more polished than the earlier one.  Did you want to update it
and the tooling somehow messed it up?

>  	if (unlikely(error)) {
> +		/*
> +		 * Zoned writes update the in-core open zone accounting before
> +		 * I/O submission.  A failed write leaves that state inconsistent,

Overly long line here.

Otherwise this looks good to me.

