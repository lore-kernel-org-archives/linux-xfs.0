Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C505A5464D
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 05:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778132063; cv=none; b=ciGGu7Lpc/lctYmVXFWXepl6QfrSklGV8Z8xtN/h1VCP1iJAlXg7493w4VQkewG/O0kvWQX1PntNtB7RkEPKfFTt+sBbxd5hLcBMjQEecwttpnOSFIrUjzcA06fQbevG5KKwTEDkG3UPO/yF4mMWNlV4XS9EftIv6CaA10hZupk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778132063; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbvJaHP0c4mZojW2HPPEEsK4xbM7rNR7ozPz8HciP/bFeEpCtBBE8Zh9EkaE4pooAyXsHxEu4p7IungSuiP2swCIZnVV2aokEQClKGkSP6x3LzrOzopc5WY62Bf4lf8boGM2wPrEPId5MXWU4FprqhK07L4UAXdnK6WMcatr8Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4nJqfq12; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4nJqfq12"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4nJqfq12aHkGJ9KNaojcMszL5z
	YGD7aHCY2PDQn67Ub5yWntJMrTOJoqN2D9Wu+XqVtOinvWySPQsBahFbfklDWCUST9b0r81vUuL7l
	65XuDvrBsj2Z08Bui35iZ5La6HxG03IfPmvjN0RaKmlgO6lJP6VOMSBb5oUsmWp6QLgL21HgZW5dB
	jjM/zsZ2njtecKFPEAWVpMhxH1g28GhIODAL9s+4jVAgDsCCsHQ2vk10gKvtvdYFZrAfPhXV54miz
	g2IpD5WPSrNoa+ce2K/LsFDwUDOCTbjVzMQkWlcxhjO68tCJCin6/P+eagqL18KayiZ2tx7b0oY8j
	sKc+Ocng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKrNM-00000002or3-1rLc;
	Thu, 07 May 2026 05:34:20 +0000
Date: Wed, 6 May 2026 22:34:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfsdump: fix permissions on files installed by
 libtoolize
Message-ID: <afwkXMAJ8Wbc80w7@infradead.org>
References: <20260506163746.1083845-1-aalbersh@kernel.org>
 <20260506163746.1083845-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506163746.1083845-2-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

