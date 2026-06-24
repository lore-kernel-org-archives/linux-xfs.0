Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D7E368D5E;
	Wed, 24 Jun 2026 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308083; cv=none; b=U7faW/3x0oZr7irdFMoB/GzXo6yh3XK6L6aZwC0ktP5KpbkazHDmKdsK89qpmOxOhQQehf1rBmGPlK0Raso/24FnWgZYQcB+aUX7W1kK14ycCMktlO3Tz35ofUrbqQzzu1Q34jJV2ndCuaEnagEud5kgo60QHWOiKi4YELZGabk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308083; c=relaxed/simple;
	bh=ySTgdXSLxA68VjwcqL3JPNndsXFUYeV0caTDcUsSCBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkEuaNgzUBD92u5aZMXq0vTHgylEipVgphbpOaqRXaCSg0Rpz07ED7Mpfgt5flm5n5mrEawuQrhfzIbNn/wQIb42EQFuld6EPgDTK36BPDQ6+nlI9MTcjfA4cFqqpRc8fKT9+/eD3YtEMbx8YaAKVVy2NSYJQoo+AndU3tIIyDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gct7EzQR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gct7EzQR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=WnIbvnh3iSm52wFeB2rpH5sTTY+sTkta8vjSnNdSMJk=; b=gct7EzQRkOA+lmJ8C6JMtmipYW
	m86AxGSJHqWIFyXSiA6QvPytgC/XEKIyi0+SpxESW+nnmk7kxSYAk0t841uEhuSX6zDqOdSvQjGlG
	odylKrJcGOIKgguo2n9ongjsOyEWl4OItBrgl1PZ8NFzVB25Tw7ebpnCkofQrOp8DZQwOAvNt6QWF
	8kPLcphVqLs9hxpanXtsKxN3qm2djkm+LK7vwOCJWFefaBx6VON/juALMmQBMuMqrrXivg7/Ow+Uv
	TfYQnrwYBcHfffJaH1dNz+wNTz+eQT+tPMphVYiw4R/SP9UGDWjMFYbIx1KTWtcMTujZoFUwiwmH2
	s5jjBVbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcNkT-00000007pWy-0VhN;
	Wed, 24 Jun 2026 13:34:37 +0000
Date: Wed, 24 Jun 2026 06:34:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: ritesh.list@gmail.com, willy@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org, vbabka@suse.com
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <ajvc7fSDngyx0X5j@infradead.org>
References: <20260527162412.19922-1-dipiets@amazon.it>
 <20260624080639.17100-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260624080639.17100-1-dipiets@amazon.it>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 24, 2026 at 08:06:36AM +0000, Salvatore Dipietro wrote:
> 
> Hi Ritesh, Matthew,
> 
> I wanted to kindly follow up on my summary from May 27th regarding the best path 
> forward for this patch.
> 
> To recap, we benchmarked all proposed variations and shared the results:
> 
> | Patch                          | Change Location        | Avg TPS    | % vs Baseline |
> |--------------------------------|------------------------|------------|:-------------:|
> | Baseline (no patch)            | —                      | 101,979.75 |       —       |
> | v1 (original, iomap caller)    | fs/iomap/buffered-io.c | 141,194.20 |    +38.45%    |
> | Ritesh's suggestion            | mm/filemap.c           | 139,200.61 |    +36.50%    |
> | Matthew's suggestion           | mm/filemap.c           | 143,863.82 |    +41.07%    |
> | kcompactd background           | mm/page_alloc.c        | 134,278.47 |    +31.67%    |
> 
> I'd really appreciate any guidance on which direction would be acceptable for a v3 — 
> whether that's the page allocator approach (kcompactd background), one of the filemap.c
> fixes, or something else entirely.

Do you have ointers to the patches for each approach above?
