Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E712028F1;
	Mon, 30 Jun 2025 06:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751265574; cv=none; b=U88aBr6XopkCCiqYB233yG26vws7P7bcDl+NLLd2+ifC3LN6gPkdB9ygGZV1GRaT6dBkmbRJCj48ZHvXE296i+yc4gK0RITrrqheR7qLO5SecpcytqttsA7Iq/pqy9DzggpYOr4z9KEUrYJjS8H5aeVd8TshbmYTl8I724uNiNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751265574; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OifbLgWOUm578fwIDrg6xEh3pDxRRqx9CnrXrJWMZm2P0k8zYUXR9M56reYh4+HVsIuypQSWiwkAv5EhpwKGaV9Y6VypFTSV/PbpZye9DAODjfE54SNSQf5ugOD/fYsd1CYvEmRRTb0LJhy9uwpbXSbMfvQOsE7fNXG1PrIYY8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oTEg6pAX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oTEg6pAX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oTEg6pAXfeuJvVLmiuT7iA7a6D
	VclC0GnVQy/hHa4iEDj8BPJSUT5B3wnsDeEPyUeVv3vRXHSQiuSyHZu26sZrXwCWigK7etl1O6EGt
	Ki53mXtJGwyNcnHG+muvUmH9nN+qVrnaKcjUspmHARJJxumkoanhWevGvTT4wg76JUstJtE0dtnEX
	7o1+M7dM/W6+7+Hfk4+mwwgm/L2KGPvWKAGDKBX8HWh5PoSTj9D0CFYaELRGOp0AWT/Smp2fKA4nF
	3ezBJPDnbtVQw6A6gjNvLBM83HrTB6obFh3sbttMangMXOXOZza+dheXF17BAojSY4D8JEUZsGePu
	/ngCk3hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uW8At-00000001M5Q-0iJn;
	Mon, 30 Jun 2025 06:39:31 +0000
Date: Sun, 29 Jun 2025 23:39:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Youling Tang <youling.tang@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Youling Tang <tangyouling@kylinos.cn>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags
 mask
Message-ID: <aGIxIx6XZM-qu0iY@infradead.org>
References: <20250630011148.6357-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630011148.6357-1-youling.tang@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

