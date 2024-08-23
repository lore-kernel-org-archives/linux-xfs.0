Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3B48CCC
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724392509; cv=none; b=h24xDzH/B7i8xrkQeEAWFvM5RjC8dfPExABhqHK8YuCGiQho3aH0pvbMu0lCneVxpoIhcXAK23JBOM7hKVUJKTm+XWHMcuJyaSnytCOehjjJ2jJ3N7L3co6elg8YF9Gse0d9ZljqgpHIgSs61fzT30ha050T+3lxtz2AMgO8a+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724392509; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZBAJyuQqnEG7Uy/7kXHaR7pXuivQm4CFVkQjZRTRhc3J3PKsW6oeFS6nxyAS0tEjvYPeglEyp2N7gLYCvLHpOXs5jQSqhCcqmmz//5Gw0Fz6Ujeqn9WwNSgtqyEH9q0B1TP2kzOPvTisvvMd2uiXVX45yZsqCrvwcbL1S9J3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4hOdRd21; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4hOdRd21"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4hOdRd21IUCL22jYzIn4eagiCe
	KvUqYq5HTo9YMTackoRy3wnzPEvfStkJ6BawAilZp3JSWEpDLybDzksYNza/xmBLs3Cv8RmBnIdgM
	52cSKvXsIIJfzwRh/dKSWKZ1wczLc9A+HVsQmKtBPhpik0VUCprBp+YWBG7js96mPUih9IYjr3RXT
	+y/7otok5yH5q2T2dDIWhJfjD+pPJAECvJd7q8KGywLITkhmhNffhq7Nac99ccfmC1ZgflKzXWn5o
	EdwsQZJNFRJ6Iq451Mo4wuTv/mj8/AhzLTOHXd2z/zv1gg+MPZoVzDfco/EMtS0DpeJAjYdV1JoAb
	5GmC02QA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shNGO-0000000FNX2-27Qi;
	Fri, 23 Aug 2024 05:55:08 +0000
Date: Thu, 22 Aug 2024 22:55:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: update sb field checks when metadir is turned on
Message-ID: <ZsgkPCPdFePrpNEG@infradead.org>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

