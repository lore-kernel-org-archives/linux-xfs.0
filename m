Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E299D30C617
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 08:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767687879; cv=none; b=rsKcgD+O2bFU8PGIVNhQdVry8RqDhbzhBTxMpPirNkL1RWDDXMLcMC6OCad1uAupS7FRue3yJlGsdpDliMGvJIYjjDY2ZQ2qR0h211rgwBsjnud2D6qT8FNYaW7PNgDeSk4w/8zMqINYbVDADBVlkEp6KAPxW3OxplIZshDe1Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767687879; c=relaxed/simple;
	bh=N0rEOzlpyyDtWQwv71ta+1oD+CyhCkN2JOoeSrmqdMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0lYM7s45m2elRtpWKtBF7o08yslrMvLpMC2tJ10B12CRY8f3dloqKftZ1xfSKVxyLHTt/3pYi+IdJZ/n1nrVJYBDMgWC5ffYn7c/WHAM9OCmEfGDGCy8FFxFKvwIjEqMG/za5gFh06FbKq6YhroF60Q1FcV4qLudTBYiKXYB1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MYkZBfLQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MYkZBfLQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N0rEOzlpyyDtWQwv71ta+1oD+CyhCkN2JOoeSrmqdMk=; b=MYkZBfLQFeuN7XfFttPT1sRr9D
	iLvIE6DZf7gxvK7PxQXorrBYOWrmO0rLstULANhz63ShPkUTzUHNl9/Iebifcz4ZJi9TtDkWUZRij
	1WcG283XvFFvDSSRVX2O6O6tq20Ci2BLjT4HVzDkaS8kRSqovAA1ohM/n65QZ8ftYWtKmsaHetKEG
	Pk4AEsiSeGD0bu+WtFQRmsfVcrybgHlTHkT0L7cS0PJGKGy4GZefIbrr90lXbOX9hJp6gYzKucMrV
	MwT7dotndW03BjsueSYEhMjY11uQQT1jar1OBa9ziDhZ4+gynMqfXcyAPiMw10SZO/qL4GpvjULzA
	u6t2j7AQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd2Mn-0000000Cbrc-26I5;
	Tue, 06 Jan 2026 08:24:37 +0000
Date: Tue, 6 Jan 2026 00:24:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use memparse() when parsing mount options
Message-ID: <aVzGxYb7paXD-AWK@infradead.org>
References: <20251225144138.150882-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225144138.150882-1-dmantipov@yandex.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Also a wrapper centralizing the end handling (maybe even in lib/ and
not just xfs) would be even nicer.

