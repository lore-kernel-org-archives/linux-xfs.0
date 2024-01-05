Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A397566E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cnMSTTqw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cnMSTTqwnEhocBwi48Q4hQx340
	D9AoyD2Tq8atYgsuDO7QUhHu3gw9KJN2osW3ButMr8xbPcn8juAyAst2S4Twr/wxJwnmpL2A/hslv
	c1QoTynlh9ZnGNmzkkUyNlAoMz9vg8n+FnQDRJMP4XLLIBFc61qYiYdSKcpu5Twgr7/HV3LnW7k/j
	kTe+ZxtAyp4AeVNigchn+X6tscTw1X5K7iROu9Zm3L+D26eLRsfMqpSOD1iLApBr4kzHBoXGibV7f
	C5OjrHpG1q19oCtxgCmqV/+gdDhWQA/OpsYxTtt4jusacYa4vQIDxvjMpfkhLWKk6SOfkpvlMqQmX
	YuA3HaKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd37-00G0Ta-24;
	Fri, 05 Jan 2024 05:47:17 +0000
Date: Thu, 4 Jan 2024 21:47:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: update health status if we get a clean bill of
 health
Message-ID: <ZZeX5Qry7jO50NMT@infradead.org>
References: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
 <170404828862.1748648.8875885962116664930.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828862.1748648.8875885962116664930.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
