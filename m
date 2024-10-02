Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248517996
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848201; cv=none; b=hdVh3Vir+z4z4KeERalDuCGIKcdG20WvuPCA6L7BiBaUqoAx4ZfrAwrot46TuGBD5LLEIi+cqgXZo//dLJerI1RxNSaQfBJ3rUX32XCd3xsJEeQwDrjwWod462Q+u6j1dAzXJmfI1LoZuDU0JX26uUMCFhoeIIoCHkLuDwYPXes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848201; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBrLSwHWYkuGDg+R6xQyY+pZYIP6Qa3s41SYbSVRxMifA4EJ1yPPkgx/ZzPBvsOukmzil5y9s+TVy6OMqqQKlsEuYNjuIAl1NNq9s0DK1RuYTSYkqqGgqIN34eomECDmyDlGjPwIGd4MvHAvzWML6DK57rVaRfC5OSfmP2AsO84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3jfUNLwz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3jfUNLwz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3jfUNLwzjy6WvZJJXfJL8UWa9B
	OwTZuCswq86N84BQ9gwL56ilHtRinyKMv9ngMxkM6aDgbj0yysuabSnmY31vfuVSgasVUEHJjl6uZ
	ujaH3z0OTp0gGyPWxxmktMfagEcnpIhyWq2EDTpi50uPixHw7KXvQbiBjG+GwCxrClUhLGskiRkqs
	jb924i1PArEvgxyL8i3osfn1EycT7X/tHU3WQKeC2vsuEGxJbyzzDfekVRQnMh4Ghp2m4nivlkupX
	bbCnrTtaBmYfznCiQ7VWhvULEE120tBCKzW6d0dCgxwfB1QHGTAAYj5obTdAE/E8Bap5y1wZIfXue
	5krRVXrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsFL-00000004ry7-2Yyf;
	Wed, 02 Oct 2024 05:49:59 +0000
Date: Tue, 1 Oct 2024 22:49:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/64] libxfs: pass flags2 from parent to child when
 creating files
Message-ID: <ZvzfB1p-ovxJF7E3@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783102007.4036371.6326005460816006792.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783102007.4036371.6326005460816006792.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

