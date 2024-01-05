Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7881524C
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dhj59oux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Dhj59ouxU9BsbdgpM2/hOXkBh4
	w/JM64Xsg1aBje9op9UxYZzopc62YC8hDIas2lrZ/aUHOAELIShnPJa7VIhx8mvM56dEkeK6m3Ayx
	DNM5v/oggxLgaF3GiP1ql4ViRaF79/l+pO19/NXid4yNw9Ais9gRdPxCeA0Y6YEe85sq9DZHwXEIm
	CctTWcVqD+bPJojs8W3typyiA0zARrmkDxIcHelYcmlOsX4CJulRf1I/NaRq3vH1J0pby3BzB2D1x
	TBLYEmTU+a0hMAU3KIPsTpxy8mbNwlgD3zo4H0PxOYM32vyG3zsaYfZCJ6a2SCyhp4us6gYCQpXPk
	ngWnp9+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcPM-00Fx8A-0Y;
	Fri, 05 Jan 2024 05:06:12 +0000
Date: Thu, 4 Jan 2024 21:06:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_scrub: hoist scrub retry loop to
 scrub_item_check_file
Message-ID: <ZZeORDwc5O0s97+e@infradead.org>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
 <170404999930.1798060.1234122907296127847.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999930.1798060.1234122907296127847.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
