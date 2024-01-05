Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211025242
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E7NWCCSl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=E7NWCCSlIGm05aOgXGSjBwxYHB
	qpjgozBode39IRAByw7k2dVzS6VBZXonLHoES3oqfdXzsyGfk8C/jy4AAlMp6Z5eyvBrmpPaGrcGX
	UWmulx36zX/0WKXvV56XYLLxADqyMelvr0g6M4uhz87BJ5ZM65TLy9eeK8ohrMTvylPq3L3FO2pTz
	8VbX73hpsmR+2QBFQqyVe0DDw117x4AhzpLkH3P6k8mkpYux0jkFyQjz4z2GIyWYDtmgHxac37V3n
	AecBxPqjPCebEsg0iwZgVNkvdp4Gb7ckpldz+8pR4fGMF2Sx/VryAYSsJx0N2UGNXRA5FLOSTWZyB
	uYGgGbng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcBW-00FwCi-20;
	Fri, 05 Jan 2024 04:51:54 +0000
Date: Thu, 4 Jan 2024 20:51:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: allow sizing allocation groups for concurrency
Message-ID: <ZZeK6kaK5kMtQsRd@infradead.org>
References: <170404989423.1791433.6933477036695309956.stgit@frogsfrogsfrogs>
 <170404989437.1791433.58561592257201816.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404989437.1791433.58561592257201816.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
