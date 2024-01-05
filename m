Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CC61DFC5
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uMZno0xT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uMZno0xTLZBOprYms6I8SSkYuA
	wqUraVWtyGRqkiOvXrz3OeTEpXBw/TjEn7cNqGsuqw+2PPxARBYEYCMbppzkFRLDhObV53MolEVqs
	4m+oVN3fdytQIgwF1f6fVZhH+agY51+mYUv+CxhQyfM2ci/RV2ci9S9j3SCfdFiOgEY5hgcrG7Ci2
	yg7Rbw44k17mULx3AP/Xkr6zQBrW6u9CWdNmYvrBYeoctljE67b7QILDIh5Vlv6hNijpn6inEeglu
	hXyefC/yx4re8IeryMLG67BctS4kzPLFH+HGAT+HXGNPPnQhnAP4xs0e6HUysEO5SEdBrDa7X7X6L
	Iq6St1tQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcym-00G0DQ-0k;
	Fri, 05 Jan 2024 05:42:48 +0000
Date: Thu, 4 Jan 2024 21:42:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: report fs corruption errors to the health
 tracking system
Message-ID: <ZZeW2LWe5N7KJ1cq@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828312.1748329.16461521590521058147.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828312.1748329.16461521590521058147.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
