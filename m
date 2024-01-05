Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF5B566A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zk0z9IpN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Zk0z9IpNwGQOajcPcD/P9JumCZ
	2pWMiveASRsp64sfIjXD4bi1zpGSM/useMepx6IoKki0Vj76smrpqoVbNdKkX8epp8hzwTiS+YFpz
	3HmjRBZxh6rCsg7mBkCyYw2ykg157A4D4aPsqCsN/MnnHtSefQwfxvGF/9BDhD3+a04bQtG4BAWoo
	sV1+P55BJmYmmw7DPPhUZl3v91FBEGeNJBukkdl4eMbaSGYZJjSyFFpCI1CTZ+NUBOA73B4dpX9JP
	ATgIIUh2xdJJVPb7TasP0Vq1CPmEWT1mMeQkmuwD3OAfya3iOtcLNtsVSq7jJtfqlWGNJ20qEVe7p
	gN0jwN0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd6v-00G0kz-2H;
	Fri, 05 Jan 2024 05:51:13 +0000
Date: Thu, 4 Jan 2024 21:51:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
Message-ID: <ZZeY0RIX1uaLnILV@infradead.org>
References: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
 <170404832663.1750161.5605007924957293446.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404832663.1750161.5605007924957293446.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
