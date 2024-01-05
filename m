Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D926612F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FFZ0Um9R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FFZ0Um9RsoUxvJtfR6IW/xL59I
	o0JvDUqA6uVd6r6QIvQ9Bju4ddexwXi9HcXOrCiuyt3Z+U3lV1e03MzOsQZsnh0pVkz6EyjfFZeBg
	VCPpeEO8DN4vHfV4BSYsjW46N+fTHrh8gWbNRCbp6Y7+OZMRkr2stor5t2ysFnRyVnu5roFZKRmF1
	oPnjaDeeIE7lTTy6TWZPnHrIlvyXhzHc3I1Ni5YtzJWlx0RwnnLkxmiITNAag6Gj1E/IVkUux5B/k
	qfqPUFJRlFjp3bi1SPPpJ5zpzcrgDRgj58tx7eFUw/JfHsivasXJMG7/T/b2XVaM6ihhThSaQf1Kz
	BwshElhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcOx-00Fx3I-2t;
	Fri, 05 Jan 2024 05:05:47 +0000
Date: Thu, 4 Jan 2024 21:05:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub: hoist repair retry loop to
 repair_item_class
Message-ID: <ZZeOK9BKkD3Yl12r@infradead.org>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
 <170404999917.1798060.16464082372157795545.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999917.1798060.16464082372157795545.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
