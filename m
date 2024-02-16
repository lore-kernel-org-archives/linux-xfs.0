Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D812BEBB
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708091596; cv=none; b=C2pJNQs9lyBGmeIUDESAvMxxKOXeanihBJebe90jQwUyS6SDtfbUZ2/9vjv91TdVcS7OpCVlQ7k58UsGLJelEjG0SI2/R5f1ov6xlA3uZ1Pez7AwH186Ac9256/z4NYddCLuVK6aT2nhc/A9ktvgtzk8Xa3GuXBxzFb/VdPARbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708091596; c=relaxed/simple;
	bh=feJo708ajudafcVA8+vayDIyprUjar1KqHXMDSnB1y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLgUi/2iP/CEMwIOEzOsYtlkdXQuF6V7ALgscEvPZNLe9j8BuxIWiRjT2fDNt0XwAsFNJKGPexEdyaNAIEPiK71lvvZ2T311lzKyrKcs9RpL1B88PqNZZBGzAtyqQ58Ibs04DR2EPJ6JQLn5bEYoEouZPuxIWF7AsQvoJtV9+QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bHuV0+Ic; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bHuV0+Ic"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=173zbrHCTEPXtEmszW1jYj3MRJacOHFLh12fNSZQHo8=; b=bHuV0+Ic5LqJhynFqJ5YF53Wbu
	ozepYGZaIy7Gz1Sx3QMxQjBvaL5urDOClhLVjKsnibPzJjfeMYRmlhxyAh/TB3jezZ2cqAfMN9gMR
	kkgQNlwkeflEYbRjA6JGEABvW0zd1+yj2IA8RJ1Sr5djNuu9Zo3Rw3nNPODCX6UzS04U/K2RS8Obz
	aYcFePqraZE1vgvnIRZE+AWoYLm23yACx96HkSu6PLv1pOFC/O5kRUNAdz+/LdT7plzU+7p6ycgGw
	W/X3WatPg+J2wEoFiWrc73ZjwQVMR/tCjA+5Q8yV+5ZcoRhdgR1+cNSK2SVlQhxmZzqZJGA7rccZa
	F3B+lHAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rayeM-00000004o7S-0EQs;
	Fri, 16 Feb 2024 13:53:10 +0000
Date: Fri, 16 Feb 2024 13:53:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/20] shmem: export shmem_get_folio
Message-ID: <Zc9oxYc-amPs0X3V@casper.infradead.org>
References: <20240129143502.189370-1-hch@lst.de>
 <20240129143502.189370-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129143502.189370-6-hch@lst.de>

On Mon, Jan 29, 2024 at 03:34:47PM +0100, Christoph Hellwig wrote:
> +/**
> + * shmem_get_folio - find and get a reference to a shmem folio.
> + * @inode:	inode to search
> + * @index:	the page index.
> + * @foliop:	pointer to the found folio if one was found
> + * @sgp:	SGP_* flags to control behavior
> + *
> + * Looks up the page cache entry at @inode & @index.
> + *
> + * If this function returns a folio, it is returned with an increased refcount.
> + *
> + * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
> + * and no folio was found at @index, or an ERR_PTR() otherwise.

I know I gave an R-b on this earlier, but Hugh made me look again, and
this comment clearly does not reflect what the function does.
Presumably it returns an errno and sets foliop if it returns 0?

Also, should this function be called shmem_lock_folio() to mirror
filemap_lock_folio()?

> + */
>  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
>  		enum sgp_type sgp)
>  {
>  	return shmem_get_folio_gfp(inode, index, foliop, sgp,
>  			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
>  }
> +EXPORT_SYMBOL_GPL(shmem_get_folio);

