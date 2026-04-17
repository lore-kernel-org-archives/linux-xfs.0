Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A143A3603E7
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 04:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776399234; cv=none; b=sckvkzSKbXyW6xIZag07NwZK2h8VN4HXAXZpKmZJ8FPt22GGwQ1FRIEJTOgTjVTwVei6KMcaMknbJxQvcbtmfFDCTX9QuZn4bfAw4TKeUWfS+8/CcEeBrmuRXlg61nbQSlT39ZP++EWAHyDWQ49X7vQVsXYbuwdKaoG8FgETTp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776399234; c=relaxed/simple;
	bh=iyC6BdIQ+Z0rGRKdVAoI98gkiW4mKjtU5oJBqXDRaOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1seawVj6KhfDHYA/aglE4w9gn9eFJ7ykZcmTzz5FQPnY2/jWIhlL2npPtAGJkJz+YapADFxIF/OrXGKGU5Foi14IWRZKz/+330G5rlc3DZqPUwSXN6WuL/9fALEOkmqMbhKpt6/CVSPcJzN9nlwl2rVuMn/b23TtNDmo3HXihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mETVZEOu; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mETVZEOu"
Date: Fri, 17 Apr 2026 06:13:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776399220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XUaK1uP+6uJO3z8Fwm4PBPbv5RYUn9z279QbRwk1wDE=;
	b=mETVZEOuB6FUvW28gEH2W7joKSOQVVwk9uQHP8vGpER0/3RF6zLF0Fh02TiaJ9+zynry00
	064wsNt5G4t0VMJBo81UcDM0aj0XeAuIPxPQLhU0TBul1ZV7tCB097AWL9XRcKyz0+E0Wn
	vnc8A8/LBLEIihoRIRj5Pcq+dRP/1Pg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <2dmo4my5rml4ymfuw5afc2fnbcxn2l3w3bz2boj4eevognilni@vgy4vwlikqx7>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

<snip>
>   3.3. Wait for any current writeback to complete and then call
>        folio_mkclean() to prevent mmap writes from changing it.
>   3.4. Start writeback on the folio
<snip>
> +
> +/**
> + * iomap_writethrough_begin - prepare the various structures for writethrough
> + * @folio: folio to prepare for writethrough
> + * @off: offset of write within folio
> + * @len: len of write within folio
> + *
> + * This function does the major preparation work needed before starting the
> + * writethrough. The main task is to prepare folio for writeththrough by blocking
> + * mmap writes and setting writeback on it. Further, we must clear the write range
> + * to non-dirty. If this results in the complete folio becoming non-dirty, then we
> + * need to clear the master dirty bit.
> + */
> +static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
> +					     size_t len)
> +{
> +	bool fully_written;
> +	u64 zero = 0;
> +
> +	if (folio_test_writeback(folio))
> +		folio_wait_writeback(folio);
> +
> +	if (folio_mkclean(folio))
> +		folio_mark_dirty(folio);
> +
> +	/*
> +	 * We might either write through the complete folio or a partial folio
> +	 * writethrough might result in all blocks becoming non-dirty, so we need to
> +	 * check and mark the folio clean if that is the case.
> +	 */
> +	fully_written = (off == 0 && len == folio_size(folio));
> +	iomap_clear_range_dirty(folio, off, len);
> +	if (fully_written ||
> +	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
> +		folio_clear_dirty_for_writethrough(folio);

I get the point where you want to prevent mmap writes before the current
writeback completes. It is not very obvious to me why folio_mkclean
and folio_mark_dirty had to be moved out and then we call the
folio_clear_dirty_for_writethrough wrapper. Anyway those calls are made
after we do folio_wait_writeback right? 
Is to cover the cases where we do partial write in which case we don't
end up calling folio_clear_dirty_for_io? If that is the case, then a small
comment on top of folio_mkclean would make it a bit more clear.

--
Pankaj
