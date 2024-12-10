Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6BA13B59E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810456; cv=none; b=aiCnN5RDCYIXm6ibdHl+Tvg5Jca1yHQltbzrFE5GlM3m+MUsEiIKMIJR3HDZcPFOwbT6+EPbhrUi6pGRHHyY/usE6bZ+XqGMyVUMyDu75S1rtBRz+B3oJ4jLRUUvSWTtnGlxQkl7yALcM+vpopc/nL00dsWFotSTYheWnk/Ypd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810456; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/KuJhA47wo+Rg/fCyqWkksI0tT/EbJrV/nKzccG1uif2JlmqaqiIhOhh7jj8ej2ALxr0ri+b6GMFNIgqIf4AdEjYlDZly4TJq8Vq8+BFxfb4rHFwqYW56jaIRWb91fCBtZNDvupUzUFhcROJPuvbVzWqn+/VNPn2x3MjZmfj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hhAWwPlX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hhAWwPlX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hhAWwPlXaIS+JdKs8zduNV3n0e
	UQSGeRXq+/1UmcfE+0ixKaCQlgIc0zGTwNSnF2f4FpEzTxHiC4rP5f4q7Y6yLDm9g4+iy8ApphiDv
	7mU9+bQpUZQoSVqzI+BEPqj/IeTqRlBmxTQRrDT85xcotIC2E9z5xO5emIAKy+QAdQ37rtfySeqTf
	M1jCIyaXtiZG0pkP2LIjNM7wQUWj5VX8NR5e55QW/1BId1wHXzB4/zlplVzXEOI23EOCP9DO2vLYV
	Cc2DFJHHzpQIFDC6CTST3igtTzANoBDQ55ZdOnZu9O7NitgTkY5vR0Lhh1MkeXw/e0iN/rSZDcPkO
	EbGuajkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtIl-0000000ALgm-1XoU;
	Tue, 10 Dec 2024 06:00:55 +0000
Date: Mon, 9 Dec 2024 22:00:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/50] xfs_scrub: scrub realtime allocation group metadata
Message-ID: <Z1fZF0E6eTvY8wNV@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752618.126362.9145973725226791141.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752618.126362.9145973725226791141.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

