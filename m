Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A74C65
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711470989; cv=none; b=qqIIjAqXbB3XHG1IYq3sIZi9dK3EuovRljZkSS7LUWDDeTeUzwAzlkuofcY6P++R3WYKJyMI6xBTal82ibp7zGtyw2Ra9v+vsxO8QKA/tCpQZJu0k4hETh9jSESa8/+gcMT6Y90Y6Czne+zk4it327wOmpoERKD6z1Ve+eol/W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711470989; c=relaxed/simple;
	bh=LTuk9naDitTl1PrxRyaRwXH/x0sF7oPjRljAstKMWVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGeNJiagBTH9DUIV8GgLZJj961iwB2cjEPT4QIAY62BRwMt6YIht7RQHh/J7ndvR3sXsftOQ22QS0/Tl3qJguc9oyIVr+HV46TXir7snYnHkzj7m43ImMR6sQsWBdI23W2co2Lm1gnrtQdpZR54PlPCaNGI9ta6Pch5OVtEw4l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T5yJoKzD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T5yJoKzD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=SeiqyagQ7wJKsueCP8A2YEOP1wx0XZlC+2wGmOx7YB8=; b=T5yJoKzDb+EecAIjig7GyCPFae
	gR9xmkXfZCVkqxNcDbsyX5F5PhWCW4Y9h9ADLj0oCB2YpHODt9Od08kPNHYXIALJBQyTckB85PPzR
	Vhjus5X82N03FFDQoGocBwlgj1J6Io8tWXdr44ZghAHmUF55FSnaty71/Y4bBsxpa8ZDpIdzrplKF
	nEKS7NBU8C5wrkX8AwUf7C5NrsVghD6L9bDvdLN96zmTuWxWGAyxeonLzGWoQpgDz8OsWqZ9W1HwC
	wUy4QMUgOwIqcGsSw+9znanRFK9985bSEtmbm8WvnKdM7od2l0JKbIBGVzjgXteb/WGcA3fmvB+4o
	7IwUphtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rp9ml-00000005V4d-12JR;
	Tue, 26 Mar 2024 16:36:27 +0000
Date: Tue, 26 Mar 2024 09:36:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
Message-ID: <ZgL5ixDHrUbIgOLe@infradead.org>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128608.2214086.995178391368862173.stgit@frogsfrogsfrogs>
 <ZgJZ5t7hoeckBmig@infradead.org>
 <20240326163006.GJ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240326163006.GJ6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 09:30:06AM -0700, Darrick J. Wong wrote:
> > Maybe add a comment to the code stating this?
> 
> 	/*
> 	 * Each read-verify pool starts a thread pool, and each worker thread
> 	 * can contribute to the progress counter.  Hence we need to set
> 	 * nr_threads appropriately to handle that many threads.
> 	 */
> 	*nr_threads = disk_heads(ctx->datadev);
> 	if (ctx->rtdev)
> 		*nr_threads += disk_heads(ctx->rtdev);
> 	if (ctx->logdev)
> 		*nr_threads += disk_heads(ctx->logdev);

Looks reaѕonable.

