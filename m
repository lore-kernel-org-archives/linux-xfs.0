Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F74A1D;
	Wed, 19 Jun 2024 06:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777384; cv=none; b=pOUXK5DGwVFcdtnEkplEdLe9Z23N5yfXpIAe0eU6yUXt830/5LIGCXINGCV7VHWOHCqvlxZZLQbL+nrZL3+HjzQfqPvYZ15SCxR3G8WqHIKTcbmvpvtLQPh4hn/BDQ7PEBPbrhdCwi9ca1EqlA76nnMhbl+QTxOU148BWzHjLM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777384; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTLCmPGFN0f5XEendjeamlQAymZLXFH9wzwJ1H3j0WwEa2rLtcNZuSNK5hJ5GbeldIaAPztBInUPRLzvvBcCT4AxgfY9sVi+gg2KIB8Pnb0OiDebOMPpur4VNF5v6O9XQZytQd0owu4Z46O1ihdN9XNAVcehf4qE5pPFVxqNOUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JfEkNRBY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JfEkNRBY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JfEkNRBYKnm+f8+gt52s+0i1iC
	cPUZF8gnf3hCoMgyuOz4kvJEy5I9zycj9wR0vsQry34wsdRyLmuMERBbXnSVl47XlEqI6Lstvxc0l
	kLfKzPVM5W0hCCgV3d7bBxLiMPafNsa7qDXKifgvLkTzP22gxcoKjntBSR3fR/6mDUGqd6xW16KVm
	0KUiVuOj3agg10yZjPrNhYA6SH30ERBiyf0WnBMpUr8dC/FpKTlUaKDWYGb1R9UT7q9AaNJkrf9RU
	YTKJIPINNwPeZshNltsjJmr6wZjrZY+bNcSB2GSfuI/HXLCcBuM9CsCwsTliX7PsFHt4XWzsHV2KL
	7l+pCF3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoVq-0000000016K-3YTx;
	Wed, 19 Jun 2024 06:09:42 +0000
Date: Tue, 18 Jun 2024 23:09:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] ltp/{fsstress,fsx}: make the exchangerange naming
 consistent
Message-ID: <ZnJ2JsxS8T8MJ8Zo@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145374.793463.652926155831384070.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145374.793463.652926155831384070.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
