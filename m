Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D770B2264BB
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990919; cv=none; b=SscIBJMIF8IMOSSb+M6Qde/tpwTRNtYlgv6AK0yNHaoShd/qJbuXlUno1wZBVcycXlfI7gFY1QOPMNWkwcCV6VjjKQrxF/6ZLbsDSQT+kwFnROgokFE3mdepHevBFWTcWxA4GZvThFKlRDZ6RX4l2YdgOy15wRzpHl7lkfpAq6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990919; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZnmZ+JrSxEHbyb7M7EIo5isG5u0ADtBAEdrr2QelQ8J6XUlV8ceLz5ODuHpin532VBeFR+zeNgVU30MKpO55LjN48AiNqQurIHEubF5W5F+sgN5QeeazCQ4z94oqyeCKJUhKiCqQbYmoXwiSiseB72g5zAqfaWPYM5BRi6YeT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Go4YzWmA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Go4YzWmA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Go4YzWmA/3gWY4pTejWsqRxdnR
	ohMLY/pb9931Uq/pnrsaLxH2nBxOi6bZNJMorftyFkqEjnJmXaLJjnxSPN03scqYhUqu8H06rPCHD
	zd7GuhvYYgNF6eciDMEZZA7zducoa3bsgVbd3ZFl3nBH9h25cswOM7dfNbX3xW3opA/oTOldgrKLH
	CKMPED0T3eY0KgfhvKdKinKxrnF7k6u/tXMq5QDC95Yvy83WiylwNHxGYuebVJWKmTCI+LGkI6oIm
	rK/6IUPYjW3RsC1TEFLTk/TvT+ISnsYZJK9QmZR9bI2Wjuf0ScgY4ZbGo4msvShQ3N5/lyuSGIgXp
	FiwAJdVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U4k-0000000CDa1-2fW7;
	Fri, 20 Mar 2026 07:15:18 +0000
Date: Fri, 20 Mar 2026 00:15:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/22] xfs_scrub: index read-verify pools by xfs_device
 ids
Message-ID: <abz0BvVB15ej-m3-@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507252.3681140.8941083932552299301.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507252.3681140.8941083932552299301.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

