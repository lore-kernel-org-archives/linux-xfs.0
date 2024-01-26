Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40391C2A5
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706280021; cv=none; b=F5C9Sn1dwd3KkorYUJxf6swT159QLQoZB/bVhnhb1OQS1NmvUHabO2V5JCj1vOkGSJP+RNaMm3+sY+Yq2l7eHBqNur54XEz5Kqq784gCO5CLOspvPsFCKAA8me/+Ea7M2/P2hIpKUg6sSdLDLFXTXUZTcQltJMFsyz0R56qWiA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706280021; c=relaxed/simple;
	bh=liVzAfdIkeKSnE1HfekMIZxWiPrwvR3oqniUyP20z20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KU1K1ChWGspU/TiAhj+PSkTi5yEudgfgHFOHxAbXFWN1JKBLXGYFqmr4IAzN1dCOqZYPwIIlquoyArMkkpkbgiWCe06iDR+EiiPjKYsnnJSlrPWQWSUWclx3OngaCR0KURLd6OhRcOLRwwkZ/7ALkmroxijes+OIu1+GcJklzOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KDH4fJta; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KDH4fJta"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MgrB43yh1WR5Rs0uflQHKJQyKZM8D7xR2vkEthU6KwA=; b=KDH4fJtaqkNpS9AjaYP60gbi0k
	TAqSILPgsYIikd4VcCzaizqDWa9MFatLBPxrYiL5l4JAEcKpVr3hCQRUElsUsIleO6ZRNGW9WTdwP
	HGphjXWmxk1grekFQTFw2EKiF9bB/5tRucSRwlY1lrHEVIg+GYbLpyQFugzTdjAnubWhOkpD2Y9Ec
	VpGYmkKwMsGpv5ZnqFt5tJvWY1Xoz6ZPnxfqi8j0CXRFS6TZ02p6Qq76aIEudseKU5ppJQfxk+UR9
	KFX0o8qxJxJa482ifkWJJKxXe0afKqHb4/vuD7g4B3XUr+SJhlH0IwGyNZfUKhok3AhpN1bpeIFqV
	meQp2pLA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTNNR-0000000DtzN-0OQb;
	Fri, 26 Jan 2024 14:40:17 +0000
Date: Fri, 26 Jan 2024 14:40:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/21] shmem: move shmem_mapping out of line
Message-ID: <ZbPEULQaArVMPt7W@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-3-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:44PM +0100, Christoph Hellwig wrote:
> shmem_aops really should not be exported to the world.  Move
> shmem_mapping and export it as internal for the one semi-legitimate
> modular user in udmabuf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
