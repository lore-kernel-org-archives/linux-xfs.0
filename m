Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ED5182A3
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gBMZHTQe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mkixH15VxtTgaLqi89LRnth6WifSotvo5W9h0xOQOxs=; b=gBMZHTQeyrAgKPpvQUPw0t6cs+
	QtFDbdaOKOtvy9pr9A4zyfTZ2PAMALrfgFVyTDpY1+PiSexqFUY0+RuRPS4vNZ5UpO1eCJ/SR7ABc
	IvA+afhetWHpAPEv/tHPg2j63SJ+Db/yYBUCXoMaY48YdAl/D7GTFTTcW8J7zcdtdHrS7DwDWzFQn
	WT4gGhlVVs5ucs3J75vo8sO7p9DF6u7f1wOxOvHQyX3tWkGw3HyOoK0Ry9LLWQG/j8jPXp/R4u+fd
	K4uSSqALpxq7XAy9397vv/HLVOJeVfoP7/5H4ERYxIwOGNE2JxBuDo9L+j80a2wpWa+/rjO+CXcs+
	npW2a9zQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwrf-00A7GH-25;
	Wed, 03 Jan 2024 08:44:39 +0000
Date: Wed, 3 Jan 2024 00:44:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: map xfile pages directly into xfs_buf
Message-ID: <ZZUedyZUefz2Ttnb@infradead.org>
References: <170404997957.1797094.11986631367429317912.stgit@frogsfrogsfrogs>
 <170404997970.1797094.13056398021609108212.stgit@frogsfrogsfrogs>
 <ZZUZx6aNB68kbRLo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZUZx6aNB68kbRLo@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This comment should have been for the kernel version and not the
userspace artefact patch.

