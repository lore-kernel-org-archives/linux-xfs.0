Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98985384
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1S3FzEI0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1S3FzEI0Yg1TGpHnXwPElGcDej
	nWnP1+LBdNm09pyPV+ROsKobIi2zwXmtxGwBnSDCDqolQdxy4ULsd7brO3sF3tudeh+kc/+0hgf2G
	cKE1LmrJzSU6oKlWDn7lZjP5glSec1kN4oCScMwsvibmHesQ8waPVxbOFKmtMDWKYLF29gc9u+UNR
	wSkgy6L83rZ2VvgXQpvgh1Gj0eUD8uqmwTs486fxUgLybXwrY26bpLNwxNZz8ie1J2CHWPy9VAKyj
	dcA4lqyyM/F/UTIbJXYassh+nDHsbJIZwIdDWNjxn2953A1WBQYPr2T3KUh+8PkWAZS9h27SsLR7q
	VEOQSQFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcCu-00FwKH-1p;
	Fri, 05 Jan 2024 04:53:20 +0000
Date: Thu, 4 Jan 2024 20:53:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a
 scrub type
Message-ID: <ZZeLQD0qjW0+Y1vX@infradead.org>
References: <170404989741.1793028.128055906817020002.stgit@frogsfrogsfrogs>
 <170404989769.1793028.5722357923930882062.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404989769.1793028.5722357923930882062.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
