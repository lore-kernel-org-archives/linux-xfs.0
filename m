Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86919D515
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724035; cv=none; b=WTRY3eU/HKqdhmqoloMPc3gHbcupeHVsWfcLhYWVYvD/vgP2joYX1buinHQJYrFvcQjZV43kPgLVcagpI9ZcYtlnI4SZlPgrI/KKlL9T+XbwVDarg3tIyAND66cc30W0GQS4OZiMS+ReOfZUVoPIa8itiRi7D+vXu5FCUY9QreM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724035; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWRbtEKL90SCmSSagCS7wxjUP2CCH6AXszPj53ygtK5HtLuPPOaZx37KIq+He3gqDkqIHQP2pU5U2oz/CkIvfTZQ4MVEU1T9K1UL3ZyZHWkf7+ZDJo+ESmvaq7mnNYkJvHG/khIlg+EIflkofewR+WSwPwr1IE06cj1da2tTKwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0k4ymYvj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0k4ymYvj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0k4ymYvjz4CU1Uj3/ig9pOJLDW
	6E1QD4CR8nxzWyqUGWt+4hwyJqo4LgZsPZZma5xwrB+aDdGa4El1cDEity2JVGeBsI56uft/rJOqn
	C/UpOSIMEdwDIeLsIBI49T8Hf7jYZTDZPxzFDttlNVJkE3KEMbgo3hB55qWu4YyMF7SBwxQrtWg4k
	2TUd/loyA+vVDvIizf6GZTyxLOl6EmHtS58SAptRogwueynMzGnI3FNjHnjQQtW3iyvVsF+GkFWoK
	Cp0YJfraWIhX72nbaXHxLVnLKRPqoLAUm7KYG/4gDbrWAQNha625REqvIl7Dq+k0oqVp5PwPjjPXf
	qJgZZPgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPlC-000000053Q3-0dQ9;
	Wed, 10 Apr 2024 04:40:34 +0000
Date: Tue, 9 Apr 2024 21:40:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] docs: update offline parent pointer repair strategy
Message-ID: <ZhYYQn6AlGuXPDFq@infradead.org>
References: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
 <171270967515.3631017.5330745726828504817.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967515.3631017.5330745726828504817.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
