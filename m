Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5917B1D524
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706284175; cv=none; b=RbcWotKGz+uUnVOlooNcdLUfrvNyYzO6aiI2HGU8cloCTqpe4i3kJu1qtyumv9Z2FQPPg2wO2CXD+BYO0cnfqRxXIFLvTbHAcHYF86kYjpDuJX7sWo71cT+umE8Bf7MA9W4N8v8ym/UlIPhu0RUDlp8OptfVLnSy2DvhJiyvKXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706284175; c=relaxed/simple;
	bh=qf2AFeZ7NdaKo8EvkM+r4PRWpJO3FEvllrD2g5BZZYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaBF5Bzy/xPlHQbmuPqlk3KsEeXFn2RP3F+8QYJf5sL/fbJ++E5ml2IHSnspgF4wtZuc8tf6fcYSOq3bEJ4yc3rhsmirIrqGrg8X8cfhlFk0tfD0yfMst+MSVNit9UqXT5iEgV10YtBsn4IZ7rqyuR3JhZZhTbkpfH/3Yklxhhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZWap1XKi; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZWap1XKi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RQIoaubNFOA6BD84xMXnA0OKagqm7V7VFuX1bSprj3U=; b=ZWap1XKiu7Ns68COObnmUKY5z0
	CqTRB+PQCc47ydXa3zHY84TGHGp7R/oHbXjz9JtlRX6FrHBwFhBmgXWx9lMFRTcjydmRAcauTSHTJ
	FSyzrhYQcG/u/Vv0fBkZLEuscizqLbUvhXltgYc4iVnph805fb8p8XAg/Fjb7Su60tOKy9kF8L2Mb
	nApnvSFN2GysSm9AY+Dgpg3vI6zQFjWO3x7B+3v3QcB2VsZ+6cojTX3nVcDHMPDrKmYL8nqcTi4x1
	JoehJwccjeL/UEhQrfcBUxvV1Wg64G8CIBBFQi0TK/YzJ5z9Zlw3SMtJ3iSq0B48l6Hgkwxvc3fBH
	d0nEsbGw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTOSQ-0000000E4uC-3btt;
	Fri, 26 Jan 2024 15:49:30 +0000
Date: Fri, 26 Jan 2024 15:49:30 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/21] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <ZbPUilScedGAm8g_@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-8-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:49PM +0100, Christoph Hellwig wrote:
> +++ b/mm/shmem.c
> @@ -2150,6 +2150,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   *
>   * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
>   * and no folio was found at @index, or an ERR_PTR() otherwise.
> + *
> + * If the caller modifies data in the returned folio, it must call
> + * folio_mark_dirty() on the locked folio before dropping the reference to
> + * ensure the folio is not reclaimed.  Unlike for normal file systems there is
> + * no need to reserve space for users of shmem_*file_setup().

This doesn't quite make sense to me.  Do you mean:

 * If the caller modifies data in the folio, it must call folio_mark_dirty()
 * before unlocking the folio to ensure that the folio is not reclaimed.
 * There is no equivalent to write_begin/write_end for shmem.

(also this should go before the Return: section; the return section
should be the last thing in the kernel-doc)
