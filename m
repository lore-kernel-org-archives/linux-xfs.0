Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A61779FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806724; cv=none; b=PiFfsqHywQE1Xbogaxln9mjP3Pi2g1VPW86B04F7WLyIqvcOoSBrCNMakBZ/urvM+62RQ1X0itI5eijFbsY3smcV+DwC1AT3jmrIHxk1HKyPg7MggL84iAFqtwKCMk3ghC8+ognfM7+XMIfUC6XcUCoEaBdCoQxnDGi6drjjI+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806724; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0IqqfF+hZzWV0N0dX3sha5jdiHlo6HjaZaxTXVeA/XyzcCLRz9DD6Zna1nwO1yHWzgCxN3ZE8nmH7wuOE+D+3rG5L0s3nc8kZKYuA8FtOMFPnHy1MwLSUK8CvzUC0z5bqYgUHrTetUxwQHo0/dpu8V4r5Z1kZcbJkLIQBAQmL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ozMWQdfC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ozMWQdfC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ozMWQdfCiz1nKjC67VddbDGG3R
	IARo/s6Oj/5w43sBPlhteuDN7fwTN5wLNmAdy6I5LHQpyt7t6xSCC0FgMLLMvMY8cblJ81zM+0e8z
	4XbsfNgiGVM5xDZhOwcnJmMMo4/lSisvVMb2T690Sg2Y6+wIktkSWPLGemucT5lF927WPAxK4vZBF
	4q/OY/MTJ84wZF1a2pE8fTJ0ZLOSurcT57z3nOP2tDqTTcxrXzZK+f65UHP5OMF6L5IdRFQ6tI34E
	e5g41yVVGz2XDk8xXi9fkC04wU0MtpJ2/aAxF72ILNiKx1k9GLQTvQxO8+mqWwyKoCEfp5GBnGZkP
	aMO+1I3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsKZ-0000000AEm5-0RkK;
	Tue, 10 Dec 2024 04:58:43 +0000
Date: Mon, 9 Dec 2024 20:58:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/41] xfs_db: report metadir support for version command
Message-ID: <Z1fKg85zSjDfo6aQ@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748392.122992.217997535481983808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748392.122992.217997535481983808.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

