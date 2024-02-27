Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12304145333
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045311; cv=none; b=uHcq31d9gyT/YkOlI3vhHVgUrxKypxKiKH6k2gXNphaCkIWqXBC09D2I8XyTD8obOcGStMbXeKiktOrzZu40S6RDu5BRK0VzX2EiL/Cbt+WFocJ6umhEbrq6/lapu8y6mDgP1eOITZkknRvWUzXuAJM5KbUWUoiNi1/1rlIdm+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045311; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+NvSqSVtJxpjljuPntqYNCA0Ybyz5oMUYlUWdXl5zYyqTuH1Od+RvNSFwODyyKE/guyR5dMth+ao8PFgclALRpg+4e/uKeT0jLFOSjbnpeg3E0+csRRjz2iwBUWJpZmnpa6vHGfWni9eu8FYPXs9ojqybN9OzLhooFwPJ11pnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cvTN6ozb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cvTN6ozb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cvTN6ozb6yiV4ZY333z2SSWGrA
	Be9qNahXLIqGcP7mPJwxUx2MAOcZwRGHvUpT6BVUE8lUKBMCmzQonXSeUYlkr12c7H+vdTXIJHgJS
	xgEM6T4Wzk8I0bpI1wWcGm/TyVhNJkC9+XDGFiNM+rIBqARc6bJyYcbuikpyiEkOjyaKhli265RVP
	7jjrTguLpJ6sem6ug9BRmPG2BUZkE2arkpm6epPqDHX7n0DOp6wlMjEEcKx7IPKv0ns92DaTmgf8U
	w3dOQ2oS9IcbMsTLnKiQfUIozWJeLSSX53zLUf8MQJeCdbVY8csXQKhUF6iroLEQ9sQti0ZBbOvRm
	r4ZvYypQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reykv-00000005do4-0jq5;
	Tue, 27 Feb 2024 14:48:29 +0000
Date: Tue, 27 Feb 2024 06:48:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH v2 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Message-ID: <Zd32PTa0sdjUKuPo@infradead.org>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
 <20240227004621.GN616564@frogsfrogsfrogs>
 <Zd1QhmIB/SzPDoDf@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd1QhmIB/SzPDoDf@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
