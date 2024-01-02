Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DBCDDA6
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g+n6s42i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=g+n6s42iQjDxQVqaxRKqPht+Bd
	d3uaxniQYnMVqGtGET12Lh4nuFKifoIiSeQ3LPR2B7E74HmXN1FgSwzynk8a4eGb3jqzuNwsTK5xf
	fbUiTzAygXaonKxLrOHj1oFW0KlOYjYaAzhg4WigvXODIRHefbLwlzACjDhDu8Xkx5Bjc9ngqTcaZ
	SursIK7HfApYWxpBqTVtwVIvDzOAJG8eNpMLxJJYYuF9xs9ZkHMavjl9Tr9EeuoWQcWmUxE1fVu4r
	EDseOK+VNCqXFK3UzIzpl3MefSe3PG5vkRL3gP/tr7nZc8OtEyHHAriHZrIUalgC2MNWW7hguNt53
	Nw+1wa0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcFt-007dHp-1P;
	Tue, 02 Jan 2024 10:44:17 +0000
Date: Tue, 2 Jan 2024 02:44:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: clean up bmap log intent item tracepoint
 callsites
Message-ID: <ZZPpAUInT5J2bHq6@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831457.1749708.3486156175042539563.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831457.1749708.3486156175042539563.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
