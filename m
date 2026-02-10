Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73AC2E7BCC;
	Tue, 10 Feb 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740465; cv=none; b=l92+OjS2WGQibgvAl7XY0mSprCJWdjvkZX7QGyjiMlD3x091mTZ0PUblbtKDvt7Ml+aEK6nZKcwbytf9XsyJHEt9MFeKqNYjRfFmOlPZw9dmj6TBrGrKsEM2Jq3I7TvglEHEHBEopWqDfR7PMiv5lStrPh9RFMZSusAQ3PekZeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740465; c=relaxed/simple;
	bh=6m9ywh+7CtQXO9LDljzJqaiRP0wFg9sht4dJlcqYQek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZzUlnRqFrTdk8LWkCdq4gQwxgcKb72H9Y4kFHPBosZSmJL6alWeZTq2tlVqx79Bb0OddMgK1zAS1c1Z1bNsYIzezVFgYLDR4B1+2vI6Oa3rrtZi2s9m988Fgry7+c69+fcOxR+4DqFIACAWsK/MXdgNp0CDXJn6JvfKHiI3Z5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x+rjC7dW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x+rjC7dW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y5zcvM3DB/X1SwvyJUyqRbQJv0rWF2nynRpSDGvWd4M=; b=x+rjC7dW5iF8EioZJe0rG9Kf5C
	IZuDHhWZXyfropzEmoDj30i8qkSHETD2zOAaeuywi2GKqFvNB1cjPa57LSl1GXzvptX5sGHOwcb9J
	AnwuT9dWYBy26H4w9wkC1j4R/QklqSzaNx4saBu3Ukfq2pwI9u1JRwD5JrWamJ1DIZYIEGjNvEVum
	aSA4naoyvxDQoq5/goSTjgAbqTtqI7YkxoXxZivkl6ukHNFcWI4g9/E9iycFVQC7WQi1NoHe7PFKZ
	gvIbzlEhAtvjzfxJ8LAWa5TIIOLjY27dtS1aQvc9hHkJMPLEQfaQdPDbM0xTV+cLMjf+3C0Tf4ReK
	SyTfZk9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpqU4-0000000HDdx-0zvi;
	Tue, 10 Feb 2026 16:21:04 +0000
Date: Tue, 10 Feb 2026 08:21:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] xfs: replace zero range flush with folio batch
Message-ID: <aYta8A6dBpjZyb8c@infradead.org>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-6-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129155028.141110-6-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 29, 2026 at 10:50:28AM -0500, Brian Foster wrote:
> Now that the zero range pagecache flush is purely isolated to
> providing zeroing correctness in this case, we can remove it and
> replace it with the folio batch mechanism that is used for handling
> unwritten extents.
> 
> This is still slightly odd in that XFS reports a hole vs. a mapping
> that reflects the COW fork extents, but that has always been the
> case in this situation and so a separate issue

I wish we could fix it eventually.  One thing that came to my mind
a few times would be to do all writes through the COW fork, and
instead renaming it a 'staging' or similar fork, because it then
contains all data not recorded into the inode yet.  But that would
be a huge lift..

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
