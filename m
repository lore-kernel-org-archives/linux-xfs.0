Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EF3491C8;
	Tue, 10 Mar 2026 06:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125123; cv=none; b=dzGrG7bpcrXqgLvD5xiOSsjt34tb0s+w33z1VGke2or+58EcGbdK7w4gAzx02QDVUVJN/4wZLIupCaNZ6KG3iw6tJgo20NaHLmFDo2ZRy4S2Pg+FnJvf1qVfBJ6jCpTrie+rltCK23A0i/cuQ6QMGfL5ORyKOivxEsDTobsmNkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125123; c=relaxed/simple;
	bh=3wglezGa2GwjRidvWKXsh3oa4HM5E5wMyPf4kUWfp0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpVmGZizg98S0uEitDYyc52qvF0372UKh1w1a2VQXMSuFIR3GN3+qCvkoI04rT5bFGfqSUjVaBvwc8a488oC9Zbj2rs0u5qMD//RKiUtb4FL1pUw+ybZ++yOHmkQ9GDdp+cEkaAwx9p5i+7G9RdWVKoVvl6Hmr4ZP6LPlgx9M8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hXHLkhqx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hXHLkhqx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xImeCmdwbY9nXEn258bTajrn3IcAlCtPjyeEQWxSX1k=; b=hXHLkhqxxxgxcu53+UXQ3T0NaM
	x67LOkrfN2YM5g3RK9ZJa4rEZ6cWO/7Eb7jeCDl0Y+hY77MXSkqgX3whkrrOddH4qnsg1KwEM6qqT
	Rm5gdhx3WadItmFJA3zLeDwtFBDzHo+iH5hn2dvdH5TKlIQY5WpuzZo/6ZpsdgHThghI+GOKigs1z
	Ay0BDyQtQcJpqDogcjijyvZH4MpiJ2kwD07ETGF02NX6DeYwfdQR3qYTd5LGh40Dr8fWeyN+XVTBS
	V8bUMOjkeZspIm1qVI7XevPJltvtwRxg2PRJReigM3wmEr5qBmyw/hjjBVbEtUdcCDQek7niQDVQf
	BjL2gutg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzqqG-00000008nbt-36G0;
	Tue, 10 Mar 2026 06:45:20 +0000
Date: Mon, 9 Mar 2026 23:45:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/8] xfs: fix iomap hole map reporting for zoned zero
 range
Message-ID: <aa--AD_UM6UKv5ma@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309134506.167663-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 09:44:59AM -0400, Brian Foster wrote:
> The hole mapping logic for zero range in zoned mode is not quite
> correct. It currently reports a hole whenever one exists in the data
> fork. If the first write to a sparse range has completed and not yet
> written back, the blocks exist in the COW fork as delalloc until
> writeback completes, at which point they are allocated and mapped
> into the data fork. If a zero range occurs on a range that has not
> yet populated the data fork, we will incorrectly report it as a
> hole.
> 
> Note that this currently functions correctly because we are bailed
> out by the pagecache flush in iomap_zero_range(). If a hole or
> unwritten mapping is reported with dirty pagecache, it assumes there
> is pending data, flushes to induce any pending block
> allocations/remaps, and retries the lookup. We want to remove this
> hack from iomap, however, so update iomap_begin() to only report a
> hole for zeroing when one exists in both forks.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

