Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FC71AF0DC;
	Wed, 19 Feb 2025 05:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944757; cv=none; b=iY76mZEH2ecpcCfbUOh9bZ/oZh927a8RVOSZiDUQ0n4QKAHNT4H8ol5g8P89oA1N5FhSKZ6LWaE6HVraA2abKwEwN42irES2qTxhFMkrZs1eVWkMf0ZTvK74vut5VHGQzH9kQ2p8EGRiup/9Rd0WOc6LrcY1qGVA+4XskSRkDv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944757; c=relaxed/simple;
	bh=zkZUo/njDNOyJKRBWt5g37PQ7uaL9iYqGDNeTyAmMTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmY4TcGIK3QdC1pct0jBYdbdtgAXwYCQtytVVqvZk9FJqzGqf1aOyXPo68FYrvvYh6Wk/9RPmwAMZ+ewfO2DanTq/MGsAaeAo41wSLHLQSdFd0uq/Zw7qGWPbohero+s4sxERtzPOhiKJrtuQrsxvoLcVhKI21u478+K0uwjhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VWliXV9N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VWliXV9N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jOHbhYPE/FpHMlF5hqZQNPhqrU7b3spzKsn4yqf5Duk=; b=VWliXV9NTbCgo0njuYQ0atQgjX
	E8lPd1O13OabvihZCEwSFJKtyMYKz0/pDYF8UR+JZjNK5SWHdLDhJbs0D7KHZZWozqH0OKNK9HKgl
	f+VmIfxXe8xWUkAAfybnTFOJL/OZ0y6eYsqpxx3Ooq1Yg6dAZjP9exPLqUBUBlRvrm4v19FMiFcev
	DV3wVAuzYg4lfIAyibRzIBtByUyg+h/pXJw/XfQKPO8t3sT5dbSOQS8TAtcJdhDzXC8oQGSTMRFQF
	53Dm9zxnZg5IeGuKEWWq3e7I8Dg345+WX/1YF9DmHIRdUzgTt5SSttwVZDvRvppLPnP5cFQupEj6e
	pCjlCtww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd76-0000000AyIH-20Q0;
	Wed, 19 Feb 2025 05:59:16 +0000
Date: Tue, 18 Feb 2025 21:59:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 07/12] misc: fix misclassification of xfs_scrub +
 xfs_repair fuzz tests
Message-ID: <Z7VzNKuvpm8BhxKV@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587533.4078254.9647021431489098153.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587533.4078254.9647021431489098153.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:52:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All the tests in the "fuzzers_bothrepair" group actually test xfs_scrub
> and xfs_repair.  Therefore, we should put them in the 'repair' group.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

