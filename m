Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD3DDDA7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F0xKi2Iq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=F0xKi2IqfQC013WJhnfilwG7h2
	OB8zgsvCx+Gg92nKJ3oLvXN1YtQV/1UT5k/H80bBuuQNwun/AomhmAlALDAHDPkkIaHmrZjBJLy1m
	x4pcgd/WU7cG+1N/c3+HjdnX5guYtIB+I2IkXeRF1Y1fHh4KGbYl1564lWqVgPs+H3ZJLlczeR3mf
	/Gk+hjun2qSMlceZrVRTmiEaI8NnFj9UZlgseHoNsJmvrXK2ic2agOGI19Q56WR2rnTqYN5c3kr4d
	ayREhALgjG+I7jRDhF5m2oWKG7h8tlJPxMYiRFdkWal+vvdVpA0rTuZ4z1/IIa8WDfzyvVKw7J3ha
	a49CNArA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcAQ-007cTz-0S;
	Tue, 02 Jan 2024 10:38:38 +0000
Date: Tue, 2 Jan 2024 02:38:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: set btree block buffer ops in _init_buf
Message-ID: <ZZPnrvAE8A1UGWMi@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830643.1749286.1497935316877337415.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830643.1749286.1497935316877337415.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
