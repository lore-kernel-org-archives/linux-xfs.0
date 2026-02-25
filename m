Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557453D3339
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041874; cv=none; b=mh3Yef3CmnVMW6kY6EU8awVeQsAl+1dL3pTssOZPfx+VEbdPDqGFirjH5JPELZy9bJsTNTvCeenbOTaSuS7JXgfxxajovhMKqUey6PhKvrU3wqDfhXsWqvrXDaQwkKh4SAyr/VosXV5gf48q4QPaMOLa93Y05aQUEZKDTJYZ8gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041874; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCncKdiqzheQ+9tzkJ/AdkW5xMH6KeTXFBVPKCkV/jmQKij9jWv7OsARF4M4XIRJ916qXycin9JUKE61Q/7AoGjE6Oy/+0ZwvBdexDAgUvFGbG9S1rLnVKZld3Ig2rOQnP/jPwz8qemka0XeCDvlYdUjjCQDs8SmINlA81T4VdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BNvyuevL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BNvyuevL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BNvyuevL6KEBT+JYvhAhlEAJrg
	O2/ZBJN1aWJhCaWgfYN+LNlGfDv2fWFWpXKLbm98UVofEGxwhexuP4d5SouskKHsMUEqhTvHH/1Q7
	evBeNBevsWgcDnfrJU8Xk9kBZG3FWwabVymOntzwO8hOsWU2fHa1O3Zbq6cW9lpTiCtbj+/19ZuFK
	8ApZcLF8wt4pgYn+rrwBQDYIAxmnAMaX62cgjVT74ADNthHl1TZ61DsrMQM8zASQqe9qt1nqTJj1m
	X2vWh2oqXusnhuXn/F4pcAoBtLRRCYSMg3YvA7QsGue5H1VMaZLLBV4x8zPUfqmrhr851H4xUL4s+
	hSNmNzLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvJ2T-00000004h5f-2rWZ;
	Wed, 25 Feb 2026 17:51:09 +0000
Date: Wed, 25 Feb 2026 09:51:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix race between healthmon unmount and read_iter
Message-ID: <aZ82jVtI3y-VS-xM@infradead.org>
References: <20260225171146.GC13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225171146.GC13853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

