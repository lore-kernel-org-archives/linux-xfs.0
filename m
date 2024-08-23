Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E0381BD
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389934; cv=none; b=JPJNtTFe/MSOkBqZ4FkwfIcGE+SQPQhg1sQRU8ikPnD57AHxG+kV1O0HyIjRjBJ3e9bbFyEP/tcQTXRsad0BJ2Om6hgaw5SDadweRWvDkYzJQN7JHqU5YWFh+6MyOLZZEmtRw5z9X/3SrL/2d6kL5mCc7+L2kNbFLIpFST1SZso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389934; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUdiytyWADcxZqFSpHvAOjpqIlhk0fmo48bHmo/Gxif++NwFO4YMJcMGHPaFAEJcv8AhOm4dvTXm0Ak/x6vRnmQIOVARFV4cNbyLNtHWXhwsOqWY9XTU1yiBUWlgFgGUnADC0KaNNA6BZ95qSeHCBvfYJaPzB7xJskDgNyibPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YTmAOiyF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YTmAOiyF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YTmAOiyFdYepkaUS0HnzewZlsc
	s37HmWWE1AGSHWgtHHxokMXUkvdnHjctBG1CtnWrs5vBPZjhpEKBKVTyRK6iEjAFWzzJwxnLZvbYD
	RnBSDrFH9Tiiaro3VQCh4OJhpg6c8DDVnp8nnJ0iut81U6mn813y8AsdSde3LbnJc2Q3r64T3/8xb
	TRN5QIdeErc18kLolBBM+YgpegcMeUUEuSenbixiz6Gn30o2yxzj7LZI+AIQ3wVTkRVd5+pShbW13
	QOaTDCBjkoWnA1BGThM3NLqT100tK+PVr+NYd4YlDh83ua19xM+DRfYnrkIVQvuM36e17Q89HT8Al
	/by1F41Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMaq-0000000FGsk-2g77;
	Fri, 23 Aug 2024 05:12:12 +0000
Date: Thu, 22 Aug 2024 22:12:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] xfs: update realtime super every time we update
 the primary fs super
Message-ID: <ZsgaLPz59TP6Oth2@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088569.60592.5726593744140992214.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088569.60592.5726593744140992214.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

