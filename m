Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F25377AAA
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811089; cv=none; b=FYLRn3SNJV5lW80xxEL405igVC71OE4r8b6BrZIG4I7G9NCjPp7mgCeZkO81DAEocReH6d3Yzgje/j3GIMV/1WDX0s3Ur4fA80XAcLWeLu0LqPY2OHsjWdaBAa/P16mdpw3z19z3eHNhnbVfNsYKlNyAriqiUhYzeZGuPlS7HjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811089; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8jRTJP1hXBs+vRSy4B5YniSDSn+sQBucRJOQbFN6nLZjjuJ2TKlmdv3g4SmOGucqmTOhcToovVaxdK8fG1j6BjvvVhLBblSQWmMKgEshZB0PKMVVs6cNDJu+HZ60MVHnumXGGRSIFoOHeYDwCvxQzRsjRK1zVV7ULycoxSZcmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=juXsHyck; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="juXsHyck"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=juXsHyck+pi0HVedvuAQuNeFA8
	QrBegNmp1XgWtzLr9AaU2FqQzXU+Qn02claJ8ayix8Jukoq0phRkOIIoyfWTCML7bJvw0w284v9wJ
	+gi2VP9TUEIygUcG83n6w+TyJx9mR5u31EK1e6DFRKc+CCBKtB/ANeTCZTUIGjC941iFHIj5eRgZb
	CzgjSnyBUrGPZO9AQTBGF1/ucZbc4ULpx9QfqmpxW3lI2wErlgGT+Kc3XB2sB5i6omdcek22B87Xd
	X6OqyrTZpETt0RO/biSIrd88SPxpR06tw44Qo49zxxZ/o7M7ZwbAsjKtjin+YhtUZkpqkWKhuk7sI
	HSRJ0KSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFup-0000000AXt2-3LiA;
	Mon, 12 Oct 2026 13:18:07 +0000
Date: Mon, 12 Oct 2026 06:18:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: refactor directory data block walking loops
 in scrub
Message-ID: <aszeD82ZHWwzjdSf@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065924.1058822.11820236791113356787.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065924.1058822.11820236791113356787.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

