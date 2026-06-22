Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFAC36EA98
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113451; cv=none; b=LS6N+YS+femjtl1DGilb/WXPOmXJjaUBHX/gWk2fRZ4p3mzzuoOniarYWrwTDWQcfz/JlmJYf+/KkzbTepgdzsk4oeeQKoNAMzuzYO59/yf4xwIM6cOU1UpDeagSbyaFhWh08CPN4u0nId1I3U5bsjvAlmUTO3P9lieoitpx2ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113451; c=relaxed/simple;
	bh=i050v5UT8SBcZd0Qv+hHDhcfASZfIBmRcgL0D/JPbc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ppkb6DYvXxJWyEsyLMufImPEFgKXLdhVQkMB28+vXy23DBoJtYZCwaut0VIWHe9oPw2siFhd+D0jh4QdNIXL02Q6woX43oqsRkJzvPUhS0cINTsEMNWzzcNGVE1CE9anKHhsA1jwLPzeWN/p+b+7n5SvRNKgC4uU0q8ENu/kS4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vmbFgKfl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vmbFgKfl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=N2kFfRuTlYZmaMSVhYO1t7nu1/K02Y2JrJdjcikwOe8=; b=vmbFgKflWTQOUDCoqu5uTqFUhC
	aGbkZS27CB2NvK1xNWgQzodHee1MhkK8G0zLI1WF7veH0B2ljMkFPYaw2oZTiktYCwWaZSd+YV6Ro
	/MrNhMYeGn7HmqEPa3ieq9kHJmhvc16u7pmWRDr1okoxaBP/tk2MYQ6Ln3/czdmkvW6xtsMYUk+Mu
	m+SI0VcXjuVKWVUsJfDpZ5hVQBB5YTldz1LVw7Y3v+aJ8jBxdexmQ2Lm7CudvGo/+8hwvrz9hR5/y
	iL1M+lRouFe4BqzAHBuiyWcTs6ZcZY3c5dtcrY/5p/cN1Y00Xzx5OKO1xIuYzgD6ISmwiVYcUcRX5
	6MtG9jMw==;
Received: from 85-127-105-127.dsl.dynamic.surfer.at ([85.127.105.127] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbZ79-00000004Xe5-3Urq;
	Mon, 22 Jun 2026 07:30:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: xfs_buf_submit error handling fix
Date: Mon, 22 Jun 2026 09:29:59 +0200
Message-ID: <20260622073035.1370904-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

currently xfs_buf_submit can execute the endio handling twice when failing
for a synchronous submission.  This series refactors the surrounding code
a bit to allow for a non-hacky fix and then applies that.

Diffstat:
 xfs_buf.c      |   86 ++++++++++++++++++++++++++++-----------------------------
 xfs_buf.h      |    2 -
 xfs_buf_item.c |    3 -
 xfs_inode.c    |    3 -
 4 files changed, 46 insertions(+), 48 deletions(-)
