Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C539253958
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552670; cv=none; b=IjagB0mxDOt1ZQIwWDV5rdfGelQ3D8zeUvdvAx4pucZL3bfHEslj+rgezZo14+8fErm1ef46AWp/+G5oJjqGkejozEjA0SvyZEuru/N1Ib8y0qENmkSSHjoHQBwqHQa2NwRSXK2iOT4i/5wHUYu+Lnp6L0UwSZg9Ewze5so+an0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552670; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t06nWLaBAr2AzFq1RJmL8scZRT5z3FOitAqjg59kB+q77wVk97sMagfAQCPBUXlQwFjm84wDbPStk2g/1mSfpXm1zTOBUfFWNBBWbZAXYFfIOce5QNqoV/05p/8+B1L0QuqGveXfqmJZuPGbFDeTQ9jysqn/lUL4vENDYhiUwQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xApt1klE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xApt1klE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xApt1klE5G8fyuKrQXsHqBo51U
	O6u+dnDUt5zrH07+WC2Mix1mFUMvoheCSvqioR1ZG3Qu7ICPkfbO32+y/bjB65vToC50G+8jKwFlb
	YpzUORdfgDCnP4663Z2cXMGU5o02B5sOEEQ20zU/3BUk5Cj3BfDvkNj/tmSfIRdvErwMk3wmtGaOb
	reh6/GPRJURAShVLj8AwjLdsUXQOBDSXiLTlgUW+sFzhNmHoMPZi2tH2DtgfG19P0LKhh/O0Xi+Hb
	EH5tpxBuZRs3aRFJ5h8Jlxuxzbl/04vN6Ehj2LPvQbWKkeAARcPDHIPXUaUucc4Hi5IgumW4jnF49
	UMnN64dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRvB-0000000FRxo-2Uv3;
	Tue, 03 Mar 2026 15:44:29 +0000
Date: Tue, 3 Mar 2026 07:44:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/26] libfrog: create healthmon event log library
 functions
Message-ID: <aacB3cYY39gA2cQN@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783329.482027.15425948965186591920.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783329.482027.15425948965186591920.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
