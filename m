Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9942D3209;
	Wed, 12 Jun 2024 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213104; cv=none; b=cGoupNk7jFHkoptSGiAG9SthIOucSFipmplyxWgzfV7wdCBrgTZd71FOVVgcF8L1E3sSo/ZiwbgRHJlirJNp6yw/5YuYjw7ICce6cf90reRu8TKkExEMnXZXuIOIPtTVy1kpXxm3J0zDroEZ5Ctt5EAOgu6tbcGqPahw69VM9Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213104; c=relaxed/simple;
	bh=j9Ce3yFE3sDH+2AWEO7WyDZ03Ns8tASD/cdNexiiKsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fICQ5P5VAABrRgVArnct5Cjz4dZJFRh9kINT02DqSzQt8DSARxjHa1CL+TdTqjalTfBizgpJ+3b5jMgOJUlauwf21XLAz9RSiLNXxjWpnMPTgJ7GsUZYdbiBU0P4n34sIFk5xOsQEH0p4Vy8BC4VShbEUXPCaxtfz8h2uw9S308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JSC2fm/3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JSC2fm/3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=amAeSiLiL/5PV3oMw3RYgelQ4VzuG/TJzfRKgkx8h+U=; b=JSC2fm/350AJHGVYIofS85JA6l
	LAB1PwbyUL7UlyrhGj6j0lN6XGLmXnNr9CehZfuT4tL4bUqAyS2HwvyrKZD/vS8o7ZGHgfP8ZVqhQ
	R0j+9U7YosceH9go477TzkPVw4QH3k9iRLsCKqBf554QA7Jv6FfFqVxuLytZzSNiGbSy73lYR8mZT
	+JHCegogZmo81skCsmDHCauhcSUov+i+itmhCvWzsbG+sPMbWn0b5ad3bdmxZ+3Wrmtts9zrfsdB+
	/nr2xxTwpe/N8z5Pf4R0KLlkKXjAGQjwDt5ZJmBRwxgrPDq/mx+Lb6LIPIOynB9mgJn6n4PWkORlQ
	w7uQhO4A==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHRiN-0000000Ev4s-1apg;
	Wed, 12 Jun 2024 17:24:51 +0000
Date: Wed, 12 Jun 2024 18:24:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: david@fromorbit.com, djwong@kernel.org, chandan.babu@oracle.com,
	brauner@kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org,
	linux-mm@kvack.org, hare@suse.de, linux-kernel@vger.kernel.org,
	yang@os.amperecomputing.com, Zi Yan <zi.yan@sent.com>,
	linux-xfs@vger.kernel.org, p.raghav@samsung.com,
	linux-fsdevel@vger.kernel.org, hch@lst.de, gost.dev@samsung.com,
	cl@os.amperecomputing.com, john.g.garry@oracle.com
Subject: Re: [PATCH v7 03/11] filemap: allocate mapping_min_order folios in
 the page cache
Message-ID: <ZmnZ49dqeJkCJNYE@casper.infradead.org>
References: <20240607145902.1137853-1-kernel@pankajraghav.com>
 <20240607145902.1137853-4-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607145902.1137853-4-kernel@pankajraghav.com>

On Fri, Jun 07, 2024 at 02:58:54PM +0000, Pankaj Raghav (Samsung) wrote:
> +/**
> + * mapping_align_start_index() - Align starting index based on the min
> + * folio order of the page cache.

_short_ description.  "Align index appropriately for this mapping".
And maybe that means we should call it "mapping_align_index" instead
of mapping_align_start_index?

> + * @mapping: The address_space.
> + *
> + * Ensure the index used is aligned to the minimum folio order when adding
> + * new folios to the page cache by rounding down to the nearest minimum
> + * folio number of pages.

How about:

 * The index of a folio must be naturally aligned.  If you are adding a
 * new folio to the page cache and need to know what index to give it,
 * call this function.

