Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4385142E7C
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 05:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995282; cv=none; b=EchtFxa7viGSSB+whJ7jpea4ntam4MDAhUi3E96gJfcYlo8geLTDjeItkLgLcWE9XGwzzWrUNQfK6YLFk+qAk0M8SQ9DlHonsP7kAXjTGmQ63R7jyUxwIT8KuSfbMl/CHRWrfE0S5PrTVs5AeyiBu9+bWLgJbXYqMTPxmb6oLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995282; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXGozTRUt1jNNPLfgAobNN3onxYSoKeQW71DZZ2t/1Bf9t9Y7wge44lbaIFcME2/30bv/F6DwYmsZeEVWGafZdRML3afrJ39VY7Fkfh4twDYGzg5wZdEpn0/LZrINlh9K26VL0Md2OC5UZQ/opoWXVAgu44QYc0ilyUuNJyiEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sJLF6lBZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sJLF6lBZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sJLF6lBZNWjUM71b6m/gy8ZU5f
	0FvVkGpkOPXLScNktwf1vaEoltyfKROPmbowDLuDRz+0lmxzWd8mbRi+9ejG+TPCTbHXP7ZY97O77
	FdZDHJguqgXRdHLOIf2AK6bbGrmrFPXoGWuT9z/bO7zTPKB8mw5Gb5Zz/yYkauaPm7vBdXC2mR0cf
	Xd6tKiYE2XBSojzAzBX3eCCpxMBKKM/mW4NbI9aQdsAn2Vw3KItvj8Qto8ngpnA5vT/vyUQ7Lj0w2
	BUiv0s9iF5ZqGlCna6Lbh5HlIFfnqtyfO74V2C5FKnFEtWMVmEwRmVc3CXmJUixYZyn0UqdzN7XqF
	DfmVE8Yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH5k-0000000BSI1-1bJG;
	Tue, 19 Nov 2024 05:48:00 +0000
Date: Mon, 18 Nov 2024 21:48:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: mark metadir repair tempfiles with IRECOVERY
Message-ID: <ZzwmkDJwMkdaQp_-@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084549.911325.5472870057444935473.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084549.911325.5472870057444935473.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
