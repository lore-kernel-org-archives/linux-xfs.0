Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41034446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431758; cv=none; b=uvl+MrerYydeF0njHcVqoLBmaBwWivYt9d/zpnj1VGoRNSbVOg3E85WfocYTrNfwxR8TKrH2RddL3wiLR9eQG9Uci3TRTjQw4l1kj84X+aiU2FTd8vq4UjEE7WF9cdcCcUIJF4H9CB6wAQSTm9ttx7bbqCGFTtLCVF0Cz3jEt4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431758; c=relaxed/simple;
	bh=n8sfKTT3H43bpOeXnYyP9OTxGTaYQTi5227X3YYkUbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuEdJtWuRZCRLr6Ag745YuRT5Lz6NLOkPSMPAxWHOLrtht/M784iz/tNUoATCp38J6BiqLD4KJIJ37Bh3DtRiU4iR9CsfGCYdsLKAdDEQGzNlNpK7uh7swC2ahLDtWfGx6ZiyPl6iLHBI7bvj6FOcviY3tCZgvIg075XDj8Cp0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DZWgQecr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DZWgQecr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n8sfKTT3H43bpOeXnYyP9OTxGTaYQTi5227X3YYkUbE=; b=DZWgQecr9hJWUux8iIGseeMYVZ
	/WRUULnmj/y4Xb4kHJT0iFvxecoV9KsdJ9LeAppQWOCbBx7j7j55uxFqKxQpzPLqE0+wfp3ZkwHzM
	E3Y2FvBD3g/I59VDJg6+90GdV3oRIvEvVsSw6GJTytRprX2k94qL8ctdDeMYkf0MB9JoINhtRyFwE
	ydZH+dOc9uf52VuH83UFCwOtyASjfk/jJqWeAR2Q96kvhqB6XPRjCjBVeCZYIJxU+L1djbUYMoEdQ
	xK0JqnDMc0jtPz+VMzBInlZZCzWHFlYRnXQPgOzJg9Yar/7pqludqBayldoypnIt5SCPG7JApN/FC
	oS5rvvlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozZu-00000003AO8-3kjg;
	Tue, 26 Mar 2024 05:42:30 +0000
Date: Mon, 25 Mar 2024 22:42:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 11/18] libxfs: sync with 6.9
Message-ID: <ZgJgRkLXfn0CZobN@infradead.org>
References: <20240326024549.GE6390@frogsfrogsfrogs>
 <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Except for the specifically mentioned bits this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

