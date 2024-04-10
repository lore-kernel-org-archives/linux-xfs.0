Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1D12E73
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726940; cv=none; b=iQZ4hkmWpnHV92X6ex6aW1OXQZo109MOve3XSx25HO+YTVJPM0vDULmOK+Y9FjqBgDzHkWPjqZwnr5bFB7zQu6fiuSoV/WLbg0Lfpd/aXVkR7wzJpuTBY7oxsFTgv3q+QXpjzDL3SVVSxvmI6OA6bGFb91aLFPNngD3OcJOdOig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726940; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsRTYPpHCmQ1w3dyWnqNUV64wqYeiuRT012EvM/jE737GoZDzxMhKR93n9GvCOc1HGK+eGA86eTsjltAg/+4l4Kit0MfXZvPrEqFrBV4BtW4y8f9tzM71EyYYvt5fsLr+kkmHPjoUh81gLz4kgagTlX15EzJYsLUm8QmTDjNnMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JKtOf/yu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JKtOf/yu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JKtOf/yuttEW/xWSfCOEETA3v5
	e111WYKnTkRFJgmCRArHPqHNE+ha1cI6ZYw7FV2xITxYUjBrMylJjO0PVP6OpA71M9Q8ixpaNV1kq
	qRwBEvnlPWZXEXxevfSrBqbToLHGKqH6HaIgQ0hRV38li3nhrHX6q4Mg+LmaeK7N42yaPz6fWK7kS
	Ml0wsOWfh2MhDD8N3hWVtkiGg9VfH0wnR7l5TvLhrFKRJBZ1zJWlJF17hR0VTh87A+Hv3EDFVdc8a
	HLpWnRO2eiNw/MQ8sZ/+UCT19zr48nXrSUAofElfNy1icEZv9QM57gVL7oy55XXl9gn2Rk5n404K0
	kgwe94AA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQW3-00000005CR0-0HDY;
	Wed, 10 Apr 2024 05:28:59 +0000
Date: Tue, 9 Apr 2024 22:28:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/32] xfs: Expose init_xattrs in xfs_create_tmpfile
Message-ID: <ZhYjm7nw7AoJvVQG@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969773.3631889.2961452043600653365.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969773.3631889.2961452043600653365.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

