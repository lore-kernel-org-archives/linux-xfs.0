Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A930ACE6;
	Mon, 12 Oct 2026 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810715; cv=none; b=d7s+gooyZSNM+ShmJ3I2FcRrgWSjFK+jlOpJ7glOxiox6eKouZq4BTT2StizzQewM0ZXIUXWDLLqMvtWXf87FAZTq2R9MJvjUZ4ZfXWK01VFpoR5N/pkCfRVA6GJfvK/LwgL8zySriC+WjuCFc34cytrHPcLhX3tFfOBXv2NEPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810715; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1UslPVg8YQSfBJODByuxgIiQYUe56GZ5gssqkTcDjrfr3NZOM888BibgIaHzkNQGThj5EO3VZiSKJeurlH9RECaZcV9sKw3ujSKlxH6NDUX3USyVFWaxHPe6Fr1/xYv9wmeSnG8u84035NxGVJVyezo0CcmGVnqF1Y5bz+9VWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jI6dlmYC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jI6dlmYC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jI6dlmYC75fq+Md51BjQWTU64T
	q8MrqAfN6SDmThqn46LLKunzP+M+aL2OvjLn2VHFQip+wNLv4G4S9XLS8MdszLduNUnG6yn35X8fh
	ErZWr+WZ2/IylEejbpTqvTY5bSY5lSqsT83JxQqUpsPmsKoDls9D1QktKbQENnbw5rV9Z6AWz24Q7
	R+YSoNmpjXhPj9XOXgmEUV8Z/z1a9actZOgy44tjMeoMyVJ5EETHbMBNuhStVyyUXM0dEcXRcWtZQ
	TH6o0/nJqOa0M1paVLpwtL47otSHg66QUHXs1HSaj8J8kXqQXyxER7HusNazWxriYFuefXFT09OIe
	ZuINkeog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFon-0000000AXOF-3gDW;
	Mon, 12 Oct 2026 13:11:53 +0000
Date: Mon, 12 Oct 2026 06:11:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: don't scan across metadata/regular directory
 trees for dirents
Message-ID: <aszcmaEGm32LcxKY@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065454.1058326.7569360626998167597.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065454.1058326.7569360626998167597.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

