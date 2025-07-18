Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB782292B4F
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 07:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752825274; cv=none; b=mqRcMp9vIU8pn79ycINOpvyJEh3gl9Cb1i+8galFqIrqS2VTRZ0ZsVtE639fBows3E7zus5xk8Ya6U6d8DXYAxPHgn7rx4KM3x+4tw+ZMlxTex7LUVoKO5t/gcCzZieokrTstpH5CbQ3v5XHQH0CIjzjy9hWSfMSwzsf5QgrsDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752825274; c=relaxed/simple;
	bh=h+vMDnxBC3UBOy0JWLb8SR6NljUIMvGs2/J1h6jCfi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMZ8vZi//NsmfoQbf3B4bfvvfX6rjrkJHiZuHrMlspKkWSG9uxorQEd7dFx0ausu9LJvyY5KcAqKlkSxLGrHnKyy7NE1ZqNwVtX2xoH9Zxo1cV0xbRFXUadHTiw01bCGkz1Je0hEZYzcee/UHyVb1dJeD0CbCNyOZ4xVmeepLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eSuyarmA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eSuyarmA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h+vMDnxBC3UBOy0JWLb8SR6NljUIMvGs2/J1h6jCfi4=; b=eSuyarmAHgPkwgEOGCNHXbvVMq
	4qP1SV4MhxKpccG5bPu10Wl70x9lMYS3gneEiM/k/AY5+GbHKd5QZxXhiHXgh4px5F5HWpbazFwOo
	WF0xYNdj4EvROGmK0AwXNBaKQF7uMLPEYxgwCiA6BtSMnPJnorxN9HO8uHT9X9dewBky/+PFch3cS
	4BewbHw9hD+rAjS9zwYbaC+hIO4YPshQDdoBOHVTNLWRoEdyb4wvahx84bZqkMls58o4rCBCzGF5K
	BfgDMf8q9c34LxXjIqOkT3dLyZUtYrFfCh9job8tgVbVAsnxpTnI13aELPSZCiHkDcZ855C2STSQH
	CbN0pXoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ucfvL-0000000BwHg-3MSO;
	Fri, 18 Jul 2025 07:54:31 +0000
Date: Fri, 18 Jul 2025 00:54:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alan Huang <mmpgouride@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove unused label in xfs_dax_notify_dev_failure
Message-ID: <aHn9tyrlEwRUyLvW@infradead.org>
References: <20250718034222.1403370-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718034222.1403370-1-mmpgouride@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Ooops, the fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
