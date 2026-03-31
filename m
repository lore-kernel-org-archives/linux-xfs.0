Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C11434CFCF;
	Tue, 31 Mar 2026 06:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774938205; cv=none; b=AncpM2bEReqJA3bexwgTyVGF8qFhemS9kHjYDATYf/8Nz0B6IuDtx+PW9Uqq63GvRa2U1iiUxfVwlMsylD/6D8WC+san3dFDhyAe/+UiGQFcmzPQxMMn8srvUqTDlZq/1nJiinkdHVFYyjTgkAhF7n4rIRMZeAQ2c5HIXHdPjn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774938205; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuJP7j87DRQ8GbTyfa85ySfpjrNMVmHGWfaGN7oJgZL+JgVsvmQ15+YC3gP1Rh+FphzGW1kmnC0hLNSIhzVrqKo1DKJhuzKsXDnuyNa703Yd/qz12BADVKmiltj5Rqyhyiu0sKTREuZTUsaL6lKn/euhuOSlOsW+cdLIfIzTUDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qvHzgXuC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qvHzgXuC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qvHzgXuCE549xS9XaVSmLP8H1T
	D9D18Q2VqvhMrb1HAI3MffqxUQtb/hZa34BsimRkUDmGWRUZFauzV7qEF0jTuFi3d7izd9t6tw8ts
	fJr/mxqmSQkUUlHZ0siYK2z3SqFrT6LVyaY/nPH87u7rl/84YCD/5MjBNMfKU04cBHW8ckzBioQAK
	gC6NqAU8enobPPLulcwB/NlgSQVoZFl4myT8HxNQxlDeUpYy6OZIrCL6lck4v4DakSy0J0B4HzVKm
	p5dOFCeqrO1vns0DALio4R+oeZ+8VVmqG4MwBas1BBtbA7V62QoxX/oDhHHDzT6ogIQK+yk8H+GgG
	mM61yqNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7SVN-0000000CM3j-0qrB;
	Tue, 31 Mar 2026 06:23:13 +0000
Date: Mon, 30 Mar 2026 23:23:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, jack@suse.com, cem@kernel.org, djwong@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v3] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <actoUS6TDKKebRh5@infradead.org>
References: <20260317065947.306954-1-ravising@redhat.com>
 <20260330061414.1190802-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330061414.1190802-1-ravising@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

