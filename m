Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDAB1D524
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706280088; cv=none; b=r/sIaBoZQugyM8jss+9Qm4UfzVyIpOwx62bYLTlnEjC8bOUTwibkMZSrtQ5bjZ+TSQVAgtY2c/iKwEkKgKfpW3qIPNc8c/X8XV7/xAGlQNBC1AQKdhpeErjWSkG+HhXT1N0UrhSgqJEuLru5/WULQzAfKadjC1X9ZSslf1QVi7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706280088; c=relaxed/simple;
	bh=EedCeTnANfFtzMWkKfmD4pXYRSiJr0GQszHKb4PE/0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIcgl2wx6i0bRfzeSvFDwAQEPEKJFGo0B/AA9e2/rWeYzL0KzPE/BuNDvovfLrjKROEM2cqoFNO6XhyG/e0lunk2Xhc2yn3FUyJAFKiQZU7h8yvfxhUXY4eVp4CaYYW3H8ZuEWiVKQg2mgflXuO8ymPqT2lIcZfSNQDBhrxdEqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YWR6c5Bv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YWR6c5Bv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+WIH38k2mW55MoxjQgsbyE0tGvR/aImyaSrjkSqIFfo=; b=YWR6c5BvFnf3bqumMkZBad9JPw
	pCHDrjZTP0ku0CBsP+sUrCi2XJEjXApUPWt2al6FWUihFVAfx+1w9AE7lVpTtCQ0zeiokwcOFKCG0
	vjZURgsTWtjFtO05LDX/pmBC5XjXdX0BYI/ytukXjtLzeuQqEgN7rRFHmHwHpoBUfp8KhLxptXNeS
	7Rpd5maPJcZx7DyHvU4v3sRaerhAT7HWIyHFEjD68UW9iPJ4MzR1Mi/A3NlsFuE3uhm+l7y0+ZVw0
	w0u7XB9zFL5ZbH2zPkGULglNl90Ut39ZxJK3Af2O4j4HktOBfPeVx9FT3+Knex1/LZ4cs6wk2GL4w
	HRD6VgAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTNOV-0000000Du4K-2t42;
	Fri, 26 Jan 2024 14:41:24 +0000
Date: Fri, 26 Jan 2024 14:41:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/21] shmem: set a_ops earlier in shmem_symlink
Message-ID: <ZbPEkwTGBS9Ws_fh@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-4-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:45PM +0100, Christoph Hellwig wrote:
> Set the a_aops in shmem_symlink before reading a folio from the mapping

s/a_aops/a_ops/

> to prepare for asserting that shmem_get_folio is only called on shmem
> mappings.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
