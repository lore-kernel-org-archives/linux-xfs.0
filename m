Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C235967
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811369; cv=none; b=F1JUA2TxChGwo2fgHH2g8/QE5nH3993+cSq2XcStGCKyJ9IYovxIEi+hD1gADhrE8dzGJYuTbDVgzBuIc2OCNAgy5dUymKyWYh3pBKVxg4U/ZSm/ozpCRmjzj659kD6WGfrZWz0dmzrWM7A2Gnz8YGS5YvCpPwe7cbxGANfS0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811369; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXsXdRwrdondXNmcZGgVmMUvNrowfCkYCRuhI+f9+BgD7IhHqZ09lNuEyZ//23ZYeve4ixok5hOQvgMLPwJLwqtsRJcP2/pfOFd2r3dnaZ+SYdLyCvzH/Y3I+uREBBX1iPlfvWq5TP9yMMQ2MDxD4K5B2V2Ft/DyLYbCiryWRDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LFJ9z+6X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LFJ9z+6X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LFJ9z+6X4v2SxhcUivt6bLFWGr
	nadJhWgS+2abnDHY+lBQD8tKXEIJCPFhlX5vtFeGy4O8SmMgXwpyH2TA3FuzFKB7Fdjx46VPHwq2m
	EGTvOOC6URAKkHU5FZLEJDqdJ9tgBbXmQv+GW051P/VLVM9D8Bv2if0B5Rhs9OAPdr/7e9Op9ndFz
	gCVD/zjrDxnjZdSgEk1H8HSjUnmJyju8QHHikoPSk3CQ3VoV0STToLZpf9j6zhPjCy3k+ezUSYnb1
	KfIDO2hjFwF7KCC3ed0uflXtZoaAqUgbn4+l9pkRgHR0f+RPiUk2pqmvaW1kbaasQ3KYyKwJ9dAfV
	k7FY3YPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtXU-0000000AO9z-1Atq;
	Tue, 10 Dec 2024 06:16:08 +0000
Date: Mon, 9 Dec 2024 22:16:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs_repair: hoist the secondary sb qflags handling
Message-ID: <Z1fcqAWxMTEjqgNS@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753294.129683.12319167915814901490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753294.129683.12319167915814901490.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

