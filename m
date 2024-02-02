Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0871775A
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706854796; cv=none; b=qmZ4W8KS+qmrnAvjNR5eRtF9wXnXmWK2tYDZi07WewYoFj3BwMT2tv+fhvWGgSFBbRhbWbNEOYMIo26oWlLoIGrhq8DmIjh0EWV5buXa6Fp+aGVSci/ZEyfi0p3TtTFk5OkwtxvdGGzYAPCsHlFT7ZiK5osNBic1/5NvcyA15mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706854796; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLnQpQmMBJ52lKVz8wvjRJxRzJXPcLxcAmdCcZ9kUO476CvXCoCTHHE7lKgbf2bzauz9TzISA5YEsV0rqw+uhDmTnwsqRcd8Rh6K3Wfs723xCAMwj/3TDZLkvIRcPjcYQoq0a8gB7oC1VWIP9fTmDbJkJy3Ag8kdJycMNi3oHSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bhUlOtRn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bhUlOtRn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bhUlOtRnb2m+Un7Ym18INPk9oO
	zF9h2bzoOpXpLfHnlw2wuUJoQkpZHtjmbdPTxh78T10IhsF8cpJxfi/DyvWgCRDpSPjVub+6vMh5U
	HezFNBjFcJ5UR4JfawZhaJWnMV11v95aozyPeqJsrTp9DimJQgwnJsjG7CyRR+bWRi9rv2cmGIwxa
	+Nvif2MaBZ0m6RfQE5mEdPzV+p1eVpSjX0nH0CVOspiylNxX2srZzPi7W5YlcPbjnVtYVXVNyLXgZ
	mFRdWlpGRecHe4lU8S9YjjDiIUFzHehR3RcpLTw1H8cZp96DBLoA5kxmt9lPdIGzC9I/cXpkDMu8M
	MKlCJDJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmu3-0000000AOd0-0RYO;
	Fri, 02 Feb 2024 06:19:55 +0000
Date: Thu, 1 Feb 2024 22:19:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/23] xfs: drop XFS_BTREE_CRC_BLOCKS
Message-ID: <ZbyJi5vKVJbsQ-I4@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334001.1604831.2802875167307440195.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334001.1604831.2802875167307440195.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
