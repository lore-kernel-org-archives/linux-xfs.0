Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5632C538B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G+2YUPNC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=G+2YUPNCwRzgoU6HoXFZorJ7V4
	+e66mZGb5RcbtJXG0rAKSasKQ0QqyLrhwRlipeM1f2Q57t109AVqXQN5LaWk1vMKYbmhovTQmvwIr
	ki6p3aNn/istUxW5use2CvKSGXWHSzbwUH6ILfcZz3yyvDbnd1UaIeLyTkQIWbFp5W13SMY06L+t/
	uoE/Z3BprZPI7uu/q/JEJ1voDHMzEDqe+1ikYiTWHQ6rlXf5oW7NC4Rs4XyqnSYEiCy8IO8tGntsW
	s/wILUDB/mty+kZnTsTMq2GHYLOPsIq5a0vUi8SPmw1HLDQfnTfalM7MGd4nRL0VQSFir7EdgC1Gx
	qDCPcnKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcSq-00FxYM-0F;
	Fri, 05 Jan 2024 05:09:48 +0000
Date: Thu, 4 Jan 2024 21:09:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs_scrub_fail: add content type header to failure
 emails
Message-ID: <ZZePHMzFEfdgqdxE@infradead.org>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <170405001924.1800712.10812613070481678255.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405001924.1800712.10812613070481678255.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
