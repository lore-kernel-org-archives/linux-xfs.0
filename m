Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC5154BEE
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706543826; cv=none; b=SEAS0p5562A30UxK6wZEegnJ8yKpGM8Wa1+viP79QJPWVMBRVyFrU5NTexkfWgFRIxJ39aIENLqm2cvUjZjWl4cFFvXUDXGbTy4n1z9e301EZQJzkNlrXkfgLHIa247G3VciXkWIjVybv01QUb+eXdheNw0Mmk9n2kC7FVpaIlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706543826; c=relaxed/simple;
	bh=XlfhkpL32P2D1dwWQHmp8dqOjKP18421e7PfDA5TDGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9OYI/xoeObb5EX2spnH7wuRMLoL5zwOYQ1/mqENF4cVDDHl3AE2xuBTSeTx5SVy6BSuD3TAzyEL6HCm/Fw7q6OLqix7YeThfzg9BFfILE7NAAzm3l2T2P563nhwMnLsYSUEw24XC/xl1unaw1dWug548xZLZ03CVGa5lca4754=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aR5nwxXD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aR5nwxXD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Zvh4vkcliPtNLV0y1qfHG2/fyuPefQiACwDTXEpBpo=; b=aR5nwxXDHasiCj89zb9QYCYzrZ
	VARb9r5RmuuKpmP1n10WgP2j3VPRSHHsx9ZdTWhosSILb7Ty85vMMV7JMpDuRuT3/beUr/TX7mzlS
	VuA5ccydrzjAEm5JXJQhSrwItMLNiPeFY474jGV2CwGGBY4FegPW2csiCrB+BLbdr1qbtcRTjJWIf
	+cjV1PEMNdEWqdvbu46xVtlNlqKOgN/bCJ6X1oQhXWRk+/S//Yd1H52Dr7K8IZlOXF/bmpS9QYAjp
	XO7POuUNNsGbs9KOZD1JOu9O6kBealfsLLGpJs1OowF9B7iBfe/YTRNn6s+QsDIPe6qDxpSWfC44X
	qXLwL1ww==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUU0J-000000072J1-02z5;
	Mon, 29 Jan 2024 15:56:59 +0000
Date: Mon, 29 Jan 2024 15:56:58 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/21] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <ZbfKykFtm64CjjL6@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-8-hch@lst.de>
 <ZbPUilScedGAm8g_@casper.infradead.org>
 <20240128165434.GA5605@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240128165434.GA5605@lst.de>

On Sun, Jan 28, 2024 at 05:54:34PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 26, 2024 at 03:49:30PM +0000, Matthew Wilcox wrote:
> > This doesn't quite make sense to me.  Do you mean:
> > 
> >  * If the caller modifies data in the folio, it must call folio_mark_dirty()
> >  * before unlocking the folio to ensure that the folio is not reclaimed.
> >  * There is no equivalent to write_begin/write_end for shmem.
> > 
> > (also this should go before the Return: section; the return section
> > should be the last thing in the kernel-doc)
> 
> So the first sentence and moving the section makes total sense.
> The second sentence I don't think is very useful.  write_begin/write_end
> are relaly just a way for generic_perform_write to do the space
> reservation and extending i_size and not really methods in the classic
> sense.  They should go away from a_ops and certainly don't end up
> being mentioned in shmem.c.
> 
> What I have now is this:
> 
> If the caller modifies data in the folio, it must call folio_mark_dirty()
> before unlocking the folio to ensure that the folio is not reclaimed.
> These is no need to reserve space before calling folio_mark_dirty().

That's totally fine with me.

Could I trouble you to elaborate on what you'd like to see a filesystem
like ubifs do to replace write_begin/write_end?  After my recent patches,
those are the only places in ubifs that have a struct page reference.
I've been holding off on converting those and writepage because we have
plans to eliminate them, but I'm not sure how much longer we can hold off.
