Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03751ABEA7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081320; cv=none; b=EpsbowZKHV3pWbbT7XhUA+pDO5kPvkQ4JfnO6u4Pbn6MJKZHOxkL652Gg6c345NRvwg1hmwgESAB2fFFqQcGkSf49PQxARuWj5n5xrs4KgNryO0GCSrQSr73YfU/i1fYyjfB/OO95ITPmxhHYD4Et+PavOZwLxdtQkX1UJ/9Pac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081320; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLHblNdvO7r1t2JtYGFvSRmbWcUG8S4J6QDS8MuoAsiz/NIvS7mbwU/qRnXab8GZ6VDLKUNP3nCpdjq1rzvgpBIKtzPSiNGYngOqQfNPko3f5/PMrgWp0tjnXWf8v+rMSXUy6Y4SYWcoiVyVb4s1GHGggRHXEHPMS6PVDmFSTF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lAP+03z3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lAP+03z3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lAP+03z3sTt5GTApmzrzHT5FaT
	LMDr3NU2bZrvZk0ECA0CMw3SkZQ1mjuBEbKQZJMGf1szF21X6K5aSU8IKYjkv1nGyCk7zIHW1xU56
	rkzV/LxqQTFYV9By9vl+itUSFcoKgubfdROg2RyHpb2GBjurh2t2D8/vKB+HtQSvskVYsQfnoCppZ
	H6/mhdsE2VOqOJZeztEWkaf5DetyfRIER6O9vgaFWCu+I0rQwvhHtIVpRzKbLOcwiRrFAmoIrEQc6
	B9I9FG975jFofrQK+0Z0INl7ZwuPxOI9SuLdaf/CMXUYSR1bOxKmE4DkqspdAN6Hmp7q4RQw/Hpoq
	bGopwygQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1lW-00000003D7j-1TIe;
	Fri, 13 Dec 2024 09:15:18 +0000
Date: Fri, 13 Dec 2024 01:15:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/43] xfs: allow inodes to have the realtime and reflink
 flags
Message-ID: <Z1v7JgihebS7cI_H@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124927.1182620.3219838636826332787.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124927.1182620.3219838636826332787.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

