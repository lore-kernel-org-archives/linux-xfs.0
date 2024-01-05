Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3B5243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kYq5OM7P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kYq5OM7P7z7owfdL0pi/J/Jn45
	K6nbd5FuH7JJ2o2NNs1HRppH55KmctsuRphrBMST1/yJ9OtZqp01v1IXzuorr6jGHYo0nAGb7TRGB
	FudqYuOOXMNtBHDN/imETO29mB8apI3HB4OWLEIFijcdnC+iUD7aY/NOMhQrqo40j9qCgXjErXP+K
	sF4JJTJGx7VTP8wgX2P2daV9AmLLaF1sKrv0WzhPI5jZ9i+/b5nRDrezibUrVvdk9f5U4JHwtdLw+
	e2h3Hq5ooz1zWDXxShOz/bDKe7oRzG9+WgFIjy51iNonACtFc9faYqBOqT5hdBMGPS6j3AlTbpZge
	6/kL0ceQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcGV-00FwZg-1l;
	Fri, 05 Jan 2024 04:57:03 +0000
Date: Thu, 4 Jan 2024 20:57:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs_scrub: log when a repair was unnecessary
Message-ID: <ZZeMH/zZEQhQ6GJ/@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998713.1797322.10083768087196595064.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998713.1797322.10083768087196595064.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
