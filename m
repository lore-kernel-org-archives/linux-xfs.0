Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22D270818
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676333; cv=none; b=IPH60EbQSj7CMuFJCnxHhlFRpNB2KZiu7Rvv71n6VwjNL2HJmk0dxb8Q8731DqxkCxVUfDJHZq2IvFW8BQ8pU/gF/anigFneiFNT9s5PJpVBr6B/WO+JrvpEqgHewWCum6vh8PrLOfReWqfxF9kCQ4UQfSXEBjX12e7mJ2p2mUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676333; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUmQLNc9eDBrVM8G33463xVqzobWYKYnIF+F4Nsk9A1T4t58ZF6ybyu71ew2qdhmABs08qQdvi9XIk7X48UGrGT/WmVa3TTXb8EDiE0O+BjbzdgZXCgcNKxEceLrYmWkG84wyMCsCFd2yLy0iq0sT15UiCJUew8FAG012+Iu0m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HrrsHM8r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HrrsHM8r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HrrsHM8rkhQZTXFJX2KuVNK8Oa
	uFlPp3uBLU1uL9uBaGJgS2Tmhcyys3MM3Giz4PHF/tfJ6TK7vFLxOWSIlnzqtx2rRJRbXboKX+95R
	hnmLYmK+qlhCZiSSmNeNWgwoD7jDyh9sV629ib9F8V49vYNsI/1K3hTHTWh/AWiLGYu9aYa/nOW8E
	YfCprNysdAdP28TAGWNaBAysv1bb73BayAQrQovbjaNdkj0Sg2kRrK0LdFzzV5EVnwIMHwArnlkl3
	Qsgwwq04xNVrzcH8YK7DRofbhE0iDuZZNsKOWYb5S5Xs/IPDaQeETn2xO7Shz8Ks6nRp6NpIE2B4B
	HZIo8wFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWYV-0000000462J-1RuI;
	Fri, 20 Dec 2024 06:32:11 +0000
Date: Thu, 19 Dec 2024 22:32:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in
 the data device
Message-ID: <Z2UPa82XlyjARxVP@infradead.org>
References: <173463579158.1571383.10600787559817251215.stgit@frogsfrogsfrogs>
 <173463579201.1571383.11917455509404722918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463579201.1571383.11917455509404722918.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

