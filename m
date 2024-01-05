Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7A8524C
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QviHt84G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QviHt84GQjGZeh5No7kuP65jPw
	NhWmYKipJOQzf1mz2FiwdCJFTNeGH6VMRCC3LWHRJQ9MKWKZ1y3M6WZHQYr6L/w51qz/Fd3PoQsYK
	73lV98YA2k64Kj6X8o/EG1ZOAWWJnSpwa3uQNl1ZsqY6A7FcwFfOc65s9/cQr6g18KddzP4v0KyEu
	7zao49Xzt5e31DlRRNZh+VmWVelzkHwN8YQzLDnTZ+a8CvnM9HsDbp3ydCXvI2E4YZfzQxMNTfiun
	alPof3eSXB94z8aRHR2rL7YpVZF//vKibUdJyrcZXOA7m47aOJzgEyUYPTLNo9g1K8gHKG4JViNzH
	uR/E2l+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcRG-00FxRz-0J;
	Fri, 05 Jan 2024 05:08:10 +0000
Date: Thu, 4 Jan 2024 21:08:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libfrog: enhance ptvar to support initializer
 functions
Message-ID: <ZZeOusjkP+spaT35@infradead.org>
References: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
 <170405000237.1798235.3216092633181820932.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405000237.1798235.3216092633181820932.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
