Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A7804
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 04:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R9Kbf85J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=R9Kbf85Jmk/ufkUUNN7LOS8gxg
	dEAwFVabm4gkF4hdl5hNHDP52eDM1FCkTMw89C9ofukOdirAvos3jxD+uB/4cRLrU/cA/zJzz16jU
	vbgtShmKEVuebZjAdqAtGnccJa+JdjZ30JTnLBE8wqQxMhRJq/jF1GVQu/CC+0K56E2A8xOOlqqnO
	I9XhAiMkIbn3WCE3+xboN/5DF56QCVXS3JDJdy+q2iN67iaH3pKN2bYQK51kDq2hosuvK08e4/NUf
	JakOROyR4waBDdFhX0h1WV3j8dMOByDKAxGG9zjkort4OfRfMLzN35nAOa2iOBZcr6Ps3FGQtlTnf
	F18R4WGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDzs7-001yin-0f;
	Fri, 15 Dec 2023 04:32:23 +0000
Date: Thu, 14 Dec 2023 20:32:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: initialise di_crc in xfs_log_dinode
Message-ID: <ZXvW1xe5G4ej+2l1@infradead.org>
References: <20231214214035.3795665-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214214035.3795665-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
