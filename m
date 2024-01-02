Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C984ED304
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ErEYKVS5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ErEYKVS5QvlQiOEq4r0J4pEepT
	1Bi0AWuiWwJegPDJzurlpPlfj2UXssD6TOprHx2x/OUcL6WqSuhDk5hAjwrKr6jRgQhpxDfLnHNDm
	zeEp43bWKP/LNtbroK2f9JtRAoOHWx+ZiDRxnnpDdKjj0oSMV61zisZAp7lASQSHVRAIZEGKjnsoH
	q1Em5PbIo6Ks7Ac2NVURqGKFsWqCMhs9ARBdkt6V1O0yOt0L72ia+fAXzMyzAEi28JcAMGSg6MKDl
	aeVWR7h9srglFME6+1WhNUfvHLdHhoKrgsG6qLa35rED4APObWd6SzWXxjuQxhO8z9GgJxH1HXTa2
	ZBP9/51g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcG4-007dIi-1c;
	Tue, 02 Jan 2024 10:44:28 +0000
Date: Tue, 2 Jan 2024 02:44:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: remove xfs_trans_set_bmap_flags
Message-ID: <ZZPpDG23xaW1SqAH@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831473.1749708.3949699027505473459.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831473.1749708.3949699027505473459.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
