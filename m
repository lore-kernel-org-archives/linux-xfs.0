Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E11C245C;
	Wed, 19 Feb 2025 07:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739951079; cv=none; b=Fl6h63feE0/LL4H/+RvgvMQ17WDZh+d65XkQaJZBYhTxg1nCF2wSxzG5zIV8hkKI6F9QI7skEIYNWlqzIVipTR71kjcVAkUPfSBTVRznErxYzjL066wqEs4hamOnooxvdSvqJGyCWWyk/Nl9neVhrToMV+YXctum0DXDhOoHxpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739951079; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQ3yhkftgvHFqme+RIstv/LXFMVYZKiq0dsJ/L8wKkyuNHYNhj0VSXfgbgVEpTLssQoGH73Ce+rLMIJueGAQBo+ThcWhZLGNquR7cIp4jFyUi3DMHetwHZninrsqi8aL1P8rwQ6R0TArjRvdeRyLCaGA3FZF9oD+KZk56h9/gR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XWMAkgfD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XWMAkgfD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XWMAkgfD92B86h2WKtQNHERzGd
	r6SFAaj/U5w3vG+ThejlixmK9oTBuvWGf+Ag5QOsraJqFLv1qzSFtRZgNiokjnjkhaXkWKlEr10Iz
	9pGC0pJhixeGaFwpHMO1A+OKE09xadqqoljnr7q6MeCUMT9/Kn66WF9dW+tSpBgYO7/+VbQ2y/qjX
	OyzOsh0SYnzdR5Xh39VPy5w9O4bHl3LuHpastUcX1SAe+wD43O655AiKp95ZoOY4cSiYX2PZ5WOKT
	P4LAMW7tRyrAfD5gvaj2v+0qDK84yo4LFNkrk9hUvfph8Wbhhk7my9aQJ9nk9tytQAqKfiQU2kdsa
	vqzoaKEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkel4-0000000BK3C-0fUO;
	Wed, 19 Feb 2025 07:44:38 +0000
Date: Tue, 18 Feb 2025 23:44:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 7/7] common/xfs: fix _xfs_get_file_block_size when
 rtinherit is set and no rt section
Message-ID: <Z7WL5mm_CN3ziesn@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591882.4081089.18268850968814879942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591882.4081089.18268850968814879942.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
