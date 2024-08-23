Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2AA8493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390022; cv=none; b=XToVTCScRTumia5Owj9sKBHtkpW9PBewO6Fk+XEyDq+s6OfBuZYIx6A8BUKWyl92dlJw+113NaSGl2TsUQr3N/PCVTIDkxgLg+RFpqeLgGGtJngMfzFJVEfIeoLPspZQnUrOiPRIfZ5ns2sWWUTJ+xXlKhV+pWm1a2BACX4hfHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390022; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrH/lOKIxX2gmSoBbk99W+U2RkMcnUsQ3wknQHAihfPFIjYnXOoKsEauTizBU4jeZi2Qvk+Aaa9kNcrfC/lKqrxo4ISXLnxl9EROTe/UGlCdpjBXPj5c1ARSfxuYsXoV98RgmXld4iqN/VGBV5yQeN8b9N4dFHqdycmmI+y/33U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UdGULN+d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UdGULN+d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UdGULN+dxcpHHbF0iOnPmpkXHH
	SyLDdFXaG9F69FIWBWzzSBa6G2sj7KKfB7GfLUCGcxib6BEPjdwJcLZ7rIkmd7uySPxhqkhj4e3Mn
	N8D3Qex2MLmC1gk9FLS/GenOMIX9b7wT50/8rjkdLi6K7sSTZhpvacgUAdqatW4HrdY6s/z3OX6m6
	/+4obUj/VSTll51ddbZo1c/syP7PFKblGxgmrwKxTqgwgexPuAYzAbQAXDnKlDSBl8UoSI1LV8iXm
	lJl4XfOIHEAwPbQOKHeCtP0lfnhPaS8soc5UniMZX5UBmHXOZsG7sEx3F4mIBc3INXSuSDB5x6DXT
	xmf0j8Cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMcG-0000000FGzg-1TZX;
	Fri, 23 Aug 2024 05:13:40 +0000
Date: Thu, 22 Aug 2024 22:13:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: add frextents to the lazysbcounters when
 rtgroups enabled
Message-ID: <ZsgahLE0-ejqXa7Q@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088640.60592.9292030505966688400.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088640.60592.9292030505966688400.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

