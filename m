Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF2D507
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F5rivNgW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=F5rivNgW4ElnWhypMXqPGUMI3b
	S9Qn3SgXxwDDaGBhFRoihLXnkMawJRLgwf5ZK+9cExCAfdZbfGmFBkPr0245m+opd6xVBDoifoEL4
	ckbcKY2acPKHzej4pVRG5WGymRoy/hJlFLmfjEP2vGqosPeQoOj/pwYN8x3oXxhUod8LvAytLrFtu
	UJAEyDTs0OGX7D8REz4Sbpyz0Prved0bAONKTlwkBx811nal5txzFf1TzqNJJnpGGuTj/esm2s0mb
	Sh5OdMFuWjM8NO5eoYM0EHmfvOpBFxBhqvzFFJfGQ+YZJHLNEwteaxotej8lZYH2wmU6s2m6cUgJV
	okuSEVMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc9k-007cHo-1w;
	Tue, 02 Jan 2024 10:37:56 +0000
Date: Tue, 2 Jan 2024 02:37:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
Message-ID: <ZZPnhPgsSunaY2Rr@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830610.1749286.7818323072611455833.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830610.1749286.7818323072611455833.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
