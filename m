Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972A35228
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oacmOxYZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oacmOxYZ4mQwsyJxGY5WtdnMXK
	qph7BIsS8jKOql6w427gVwXX3pIv1iaMrcfKkeC4uNkzVt5l867bCLNBJvom6BiB4U91OrDtLsk4L
	L1q7h0Os7i7isexDf+gMNLWnQ5SIAbP+Y2dTs8wqL0ie4kHaB1tox2W28aPKk2hFyf3ApEAars5bw
	u6qBRb6wjQg5BfB2X0WaTRLp6NUC/FBXQ9ekCnuZFZtRJCrv2X3aTp3GzBeX/Ha3rwHpm5B02jgtd
	6a3rf5qie7DPgVPuRA1GdFsD/ZOokNaxaoQNBa/thypdwlOWTp/vGlnMCogsaYccjl8B79ZKZ2b7g
	a0a2x7vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcJY-00Fwie-0I;
	Fri, 05 Jan 2024 05:00:12 +0000
Date: Thu, 4 Jan 2024 21:00:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_scrub: warn about difficult repairs to rt and
 quota metadata
Message-ID: <ZZeM3KGYw81P9Z5M@infradead.org>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
 <170404999127.1797544.4265175049929354672.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999127.1797544.4265175049929354672.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
