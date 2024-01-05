Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DD0566A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cTUQOrR6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cTUQOrR6vISubx2wBsRROW+ySk
	DcsR+oyAKA5NjlyUh0S7/ZhaA/7S+uqWMeWa4DX9jSNZaYWI/OgpLH4uInIYXC0VSmOn83sJ3QSoJ
	xI29trmZv7D5nQBwo5WFSGfRQytbsOawLyGMlpEl2NCb0JhZ8RyUOZhMHp10o3lDplUe1cgrAnNYJ
	EfSrNZcDhYkxoZAa6M6QAtnUFqzkijjWQvfKhQRm1/H5YpfcxkZtPd4ZAL3SJ4eGc5fYIQ95IETJe
	xWM28wSw7jbGFfHEaD/ClJY0HWwJ+rPJ4dpVTkZ/hyuFBQrETvs6tx26Mrfv0cvDnKIcH0fiF3SPd
	2WSEioUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcs4-00FzXN-1D;
	Fri, 05 Jan 2024 05:35:52 +0000
Date: Thu, 4 Jan 2024 21:35:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair dquots based on live quotacheck results
Message-ID: <ZZeVOKJ1tWEkGNhD@infradead.org>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827476.1748002.18340574099309258328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827476.1748002.18340574099309258328.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
