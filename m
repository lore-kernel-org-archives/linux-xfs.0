Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D17168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808029; cv=none; b=m3FQGtKggH090BQE7qEjIMTpSf/FdiZnqpQBAmI4UxXCUWtUpA3v95VfThQiZbFairEdTeqrO/u2nyQim1KnwPc9kHjbgIA0MNQEwI4EQphQaVdcWWjmflVhDvLSVpRl+mhAgJAoulF3R+mPqkPOxfyEb/1aZ3scimBgv20kUhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808029; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUxxJJC7XLvjYY63dma8p8OEpTZ7gomdKO3GLHY5RezkWytrAwtBIFJqKxka+Psxx3pY0KTr5BJJ1xk12xjFIPT84Uq7opBjo38DgfkzPDGEF+GeEBgUJZ7fyOqSgLsCsLCduhsdAJ9Ob0ALvJLwcOngLYFzbv9lXMB88xIP5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xzMOgAtR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xzMOgAtR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xzMOgAtRQlTNWDFoC7CiY+TLKV
	SnHgbD+f/6CGzSMRReXvculFQm4HK4EK9gOhqDq1izEvJoFQtLNf0gcvQ3nyxprKecWaECLvbxJ1o
	GyAFCYFPDJxpxKQ7dmoE5GEbVrleKZgRBsunuNIabqAFFN1+HuTehf2OwNlSKGF57rQZTMelZaX0J
	RFy4AGWqMKvZ8oiDx9kG2JpzxtHGDZB6qeiN1aImegCU3qj3WJYvEpEuDIUQklZFE1bsjPz8Zfjvk
	vH3NQPt38FoUzHz/Q8S2OkyC63mW8UT3dD6TJqzaJBTniXomDOPJpL3qyRatfJ7vvdRgxUCmZs3/i
	Tsszu4Ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsfc-0000000AGWX-13LR;
	Tue, 10 Dec 2024 05:20:28 +0000
Date: Mon, 9 Dec 2024 21:20:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/41] xfs_repair: drop all the metadata directory files
 during pass 4
Message-ID: <Z1fPnCfOcnSn5NkW@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748786.122992.11426516667642776775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748786.122992.11426516667642776775.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

