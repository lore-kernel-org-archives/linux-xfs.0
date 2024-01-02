Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9CCDDA8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eOP76Ypl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eOP76Yplp1UkUc3+ucd0PNYI2W
	k7SCzi3JD+5wGeG61JTZaAznHHT4SvsIMRRrGbGmNbOgcIQJ6jDPNAhRc4VEkttclffgirLpvEl2D
	Q7U1oCWpOJxGJxshuumyO4ayxfV7xkFQHjCvX2vo0lmwnd962ZObWbgeSYB5soyK3Ejz6e0AcAdPl
	grtpdv1Dx4NBwca6Muttm9M/3weoxdSlWZTnFuofKJ7A/N8KfjdCNQayYmxFP8p5xbppZwYHeXaym
	0n7ig8E1f/AaPZ7960aIiA7U5RyBxdFFXgpiHU2QtNNIIq0YBVoyMfjWHoZhb/P+79I7HpRgEKNzQ
	5ONYB2Mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcHZ-007dV6-0Y;
	Tue, 02 Jan 2024 10:46:01 +0000
Date: Tue, 2 Jan 2024 02:46:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix xfs_bunmapi to allow unmapping of partial
 rt extents
Message-ID: <ZZPpaa6OZS2xc3cU@infradead.org>
References: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
 <170404831892.1749931.10507668815062235816.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831892.1749931.10507668815062235816.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
