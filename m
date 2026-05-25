Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB2734D915;
	Mon, 25 May 2026 05:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687797; cv=none; b=GF+KgPGam7OUkTDqorCsko8XX2r10qhm9ChyZp36x1B+Q8YIGSgoUwa3Ufz2Udi7YLF5JXED29/ydBiF6UiBig5Qoj8f8/7qHkaq1tybfvVPZH5wiYUnyfxZTllj0yQec+E47JtXHapBEJLxF14OhjIJ/OCSSLcfmk2NFmUcA1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687797; c=relaxed/simple;
	bh=BgoFNhjwNmiplHThsWTGwQm9dCqZpGDXhY962PWX5U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Smr8e+yehvHErPlFD4Ev+Lv2Uvm3OkrihXgL3/HpJIWXMZu4ws5/+vJBvc1iApA2DtjYYG1Odkzy17+0YwWNKSe6FYH/mX6eFbuKHZo4CjjmHjwAQDo+DkXwpPApmjCwfKh1GF583osQHjDU8G0JTRa527o0NzVPIrEsNm/oQCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tgHqJbti; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tgHqJbti"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xVmzDWwKLQciW3fNwlhEA73AAyW7HnbhS4hLLlwqSQM=; b=tgHqJbti8c9smxpmuNsDoSbzu3
	UZNnEJvX0Nq0zJyhbCoyT5j5LfxnOL5EM9QG+eDmxva29CRmWL5rMjgxYwo5u1PTp/BWZQHs5hMn5
	u/RIr3mZeci2RYm1XtkwAyNVe+LwffPONYQXrzJN311SYTlR1V1eBbJ0pbHkbi648uZlTtGI0ntap
	+XUexhMa3bWsSJrx04xpl8P7rleNZA3voLc44jTrFpplgBFGb4qZttxwAEWX4q5eu2+OBQ82pfy+w
	V5EapCknhAOefpDL4lyTw02II/ICnA5BsjXQpQxGPWNQR5p8VEsO7VobrEhPYTx+Ms3uf+W2f+KYk
	i4hHd48w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRO5p-0000000GLoS-1v3D;
	Mon, 25 May 2026 05:43:13 +0000
Date: Sun, 24 May 2026 22:43:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sam Sun <samsun1006219@gmail.com>
Cc: brauner@kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: [BUG] iomap: NULL dereference in iomap_finish_folio_read after
 deferred failed read
Message-ID: <ahPhcZvPD4S20UJf@infradead.org>
References: <CAEkJfYPhWdd59RKmuNLJg-bkypHz7xiOwaWyNVu3A8CUqQCnvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEkJfYPhWdd59RKmuNLJg-bkypHz7xiOwaWyNVu3A8CUqQCnvg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, May 23, 2026 at 06:58:46PM +0800, Sam Sun wrote:
> Dear developers and maintainers,
> 
> We encountered a NULL pointer dereference in the deferred buffered
> read failure path. Unfortunately, no reproducer is available yet.

[snip]

> We analyzed the cause of this report. It seems that failed buffered
> read bios are deferred to a global work item "failed_read_work". The
> deferred worker still owns the bio/folio, but by the time it calls
> `iomap_finish_folio_read()`, the folio may have been truncated,
> invalidated, or otherwise detached from its mapping. In that case,
> `folio->mapping` is NULL, but the error reporting path unconditionally
> dereferences `folio->mapping->host`. This pattern still exists on the
> latest kernel commit.
> 
> A possible fix could be avoiding the `folio->mapping->host`

The folio is locked until the folio_end_read() call.  So I don't see
what could legitimately clear folio->mapping here.  Curiously waiting
for the reproducer to see waht is going wrong here.

