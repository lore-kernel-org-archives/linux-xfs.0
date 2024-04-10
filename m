Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBAB1CD3A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729618; cv=none; b=rR+bvMCB7peI3ahpdRaXKAu/ScK9lwmJAA5ue4HBzMID5SbJi2mHP2/Mp6gcYWj9WstL7t/RGAqA7YFMbZ+ZZkt56IfZBbRs6T77jMKNaA9oxPzK6BPFM+L5cgUUpsRHaXDwKn8BFHCs3oDX9dr74YxCYL5lK2nGSu90+pOgvkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729618; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRfnhtc90bRefSpYpdir7gSgnfdUneQKdLdwkvUFZRL7jKMegeMQjBBp5xdsqPUI/lVcNN646UzemUUlbDQ4KQdz9xmSGqid3+CdZD6h2ZiKHskdDu671HFvxrpQFgwzuX5a6wYYUoWtF9P7HO7uYE0otkm2DknKkFS6+hM1+Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kboRK3bj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kboRK3bj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kboRK3bjMOfLBcJuFoU0wcSqiT
	KITVpLQo3gTY3nWTbuqeGURV1ZoUubrsVdmzP+Jac4tThWOApBxm3B95n/yR7GvVssBlON8bmNV0q
	QUw+t+YRZVr1+2VBwpDl3eYqnXL0iyP1LHv85he3aKk2jbPuwqALu3LbMeu1twFAOaMFuzxuPyohY
	6RG6BkBkiGaDIxUfhFWxEFNVOITF9cGoXHk724j7yLTN0vBVILhMevsu4kVHyRhplh/3Xz6hlvTUZ
	hG+RrztQMnkavW03jWFpVvLcze+VFRu2Byxhv0+XkaeUTW8EpPgK8mQErYAUnsnndeRPYzQF04XVM
	lILKKemg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRDD-00000005Kcm-2v2K;
	Wed, 10 Apr 2024 06:13:35 +0000
Date: Tue, 9 Apr 2024 23:13:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: scrub parent pointers
Message-ID: <ZhYuD0tvXfDjGvel@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970517.3632713.14790309685305343360.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970517.3632713.14790309685305343360.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

