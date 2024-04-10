Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475B58F44
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725947; cv=none; b=gdFXEkBPRQ5UwlsVt+HkgXoJLPn3fCVQrQvnjk/aU5uQD0qDZwXeTCeoWAhWcYpoEkezhhFRiDXpqlr5E0YgoeGd9BXDiMfm4+SOZWgaEuqGpkLqV+D4RmxHWXLCClolZ5xDlCSw/hDBEVqH2ApjY3tY7nSpyOVW7m+3j9APlPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725947; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8XkO24RKcP75DNGDY1h4r/muEeVmpYtjJo9GLxHxiE+v7uJi11MsduIeiHVWN3SMcqJJsVfyaKQecDik/0wPpOr+tsj5HylOrk+jMxxGHOnwPEQets7NPjbFlWhkPqIWPcLAsA8wDfbFWwQ5JuTLbeP9aPDJQLyvAPTvUvB9Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X52NvqAt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X52NvqAt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=X52NvqAt3vSrO41eiHN2xoq3Tp
	F1iBFBDPr4OUd/sJ2ykvHmAOlDoBKoZxSWj7/sPurMkUxPKY1V9AqjI4mtiMhsvEsHQsX/eBlVic0
	oLebBbr/sG6s1dMlZ8fR1+GjoMTO3EKCt45pG43qs19Z/uHAIYuesbUSsKKLvLHRgDWV5eZmp9Fhc
	ExPOHr9RtxPAlT8isb4tHAtBJMXLiVtis8J+XLNptD+/Bx0UOUT1KxAf3dVC502wLhyzeObxTb88x
	aHdMBFQG5KifxSdVrw7PBb+1k21jk8b2SOO6z/lVuC2Xo7YAIj9xDJAs9+VeZBbKo4/+c3M6bfIpR
	1wWDPc9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQG1-000000058M2-3MWX;
	Wed, 10 Apr 2024 05:12:25 +0000
Date: Tue, 9 Apr 2024 22:12:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/32] xfs: define parent pointer ondisk extended
 attribute format
Message-ID: <ZhYfuSDwi4wGxgEt@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969657.3631889.9403759718168544689.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969657.3631889.9403759718168544689.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
