Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEEA3B19A5;
	Mon, 20 Apr 2026 18:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776710471; cv=none; b=h0ZXU6UBorT6oQtegnzoXVOF7IyABjB5oufHvXaK00WYrbMPKyfcGITCawY6NYJ3qvcxWGhQHgaOSO+dwl4UGNlyg6fslFt5QP2GbipYKHfUz24hBGhSfbZhXUPVBPrApude+Ibrt9sMc+q5DDfUUjzQQOmgzYJSe7/5zuKElxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776710471; c=relaxed/simple;
	bh=koIsUOiW6uhsoaE26yJZoZKBgb6/CEJrDeBMb910ceU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQDV1hVHbMv/q4iTajfWpMr3mlqiRwTh4aq4IpIQSSyo3/vuLVzAYz7NVX79KjAfGmAl+bu15bRecyuXSjJ7W6ETatZA7WNzV4cBLf/bbAEIoXskUWl0/L81ibdd2fQU+0a2PhZAGRkWkgm8OWuCBJXBn6Ov5ggob7KEI4Gh8RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uxw8dq3M; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uxw8dq3M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=US7xk5FxdqbPrtNDg67ilQoyRup65Jv5pMgq4MufUEM=; b=Uxw8dq3MdMz8mXBvJk8pRiEKn1
	inBCGK8of1iaOkAOH8Q5SLMr9p+3iW9qIQ8VWWQtQsyHX6nwUex+PY9yVzSVVgA3yXPfUiZPwLRqM
	ifRYOL01IYQ533ffUK5FqeBZw8iaqD+nHhNWjrG/IDhJ7AqvE2UjNA/Mp+KgioX/2xx3GZ4lVQKgG
	VWDRAR8/tUtwx2bd3UPIqeK61prrotV4e9ab/HuIliklfa2kXB2i9m88KnHIrn33QIunjlcdGlkdb
	DLOpWdWmXYDYW5q9O/JWD9++JoreSB0f7kYG9O2n8UM1rFHqSwbOzkwCYYOV0vySueq0pgy5x0HyQ
	593oZOZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEtYN-00000008sKB-3rpU;
	Mon, 20 Apr 2026 18:41:04 +0000
Date: Mon, 20 Apr 2026 19:41:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
	ritesh.list@gmail.com, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio
 allocations
Message-ID: <aeZzP6iQel-tkZOu@casper.infradead.org>
References: <20260420161404.642-1-dipiets@amazon.it>
 <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>

On Mon, Apr 20, 2026 at 09:51:06AM -0700, Andrew Morton wrote:
> On Mon, 20 Apr 2026 16:14:03 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> > Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > introduced high-order folio allocations in the buffered write path.

No it didn't.  5d8edfb900d5 only allows the use of larger folios if they
already existed in the page cache.  d6bb59a9444d allows the creation of
large folios.

> > When memory is fragmented, each failed allocation above
> > PAGE_ALLOC_COSTLY_ORDER triggers compaction and drain_all_pages() via
> > __alloc_pages_slowpath(), causing a 0.75x throughput drop on pgbench
> > (simple-update) with  1024 clients on a 96-vCPU arm64 system.

Why are you pretending this is new instead of already being the source
of much recent discussion?

https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/

> "Good money after bad"?  Prove me wrong!
> 
> Instead of performing weird fragile hard-to-maintain party tricks with
> the page allocator to work around the damage, plan B is to simply
> revert 5d8edfb900d5.

lol.  best of luck with that.  you'd break a lot of other things if you
did.

> 5d8edfb900d5 came with no performance testing results.  Does anyone
> have any evidence that it improved anything?  By how much?

Christoph reported it doubled write performance with NFS once NFS was
converted to use it.
