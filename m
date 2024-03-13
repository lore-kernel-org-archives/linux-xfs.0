Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C39559168
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367222; cv=none; b=Q0kaebrwqj11zagvurPoUCZc2tcxLX0BhBr4iUoDGCSxaLQWq9b746rAL0M0ZqWjRSUVApJPWIENscYzK8r14Vojy949/0nvdiPCkuLQSOBqKiYDbMZUw/EUCbwuc4lPMyza0JGwyG+NtRnujPZmhbZrkpx5ta448Y2yDthAepE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367222; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z56y+mG7gVDSQBQXWc5x4QLYf5gJ91sbNWWibrC/X5eo6Xs7fVAAtSSdfTyWz0jDFOSnlLVcz+iGPGcdtqyhgRR716/PwY8i442QaoxgHnzvMT1/zRG7TOUdu0GVvW7PNTRDhM7gQXoZM1XwuRkfBqdghkvUa9vwCwHeVpCha7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LGGsCzvP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LGGsCzvP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LGGsCzvPWI1bQa2h46Uv5oTlOy
	k08Tx+ApjV419wMBOELw1aWevfVWnSYGncpimoa61F1CVYlx93yLFwqFwyB8/GxVRdxv+cTWrh7lJ
	E7TSotg7JB8Iiq+9a7lbmFWBFf1rdlud274M30on1J88XhTsVDmfj0cZuikG0TiKlxuMAgBM31zjW
	KiY54BxGBUjsHIGl6QRF3cF1kS+MrNQ8opioa+kghfFftmaOYfmf7n0hqM7KZv75BwEyeYyxe97y7
	Yqw6bYkrrufpnGAwtINcNKUCMxfcN/DYq6N/X3gShyZHSPgliaow5or+NxNpvPcPQM44F+7qrLvrj
	Uvcxb6PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWe4-0000000C3kt-2ctX;
	Wed, 13 Mar 2024 22:00:20 +0000
Date: Wed, 13 Mar 2024 15:00:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs_repair: fix confusing rt space units in the
 duplicate detection code
Message-ID: <ZfIh9KhLyRTL_8uX@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430600.2061422.15290444691248517445.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430600.2061422.15290444691248517445.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
