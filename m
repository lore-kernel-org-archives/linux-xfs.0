Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA321400C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 09:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763976918; cv=none; b=GXghzZujtJmGdQqr/ZAyez6Og7O5h7jrnEjacHpuJT7fIXO8aqJ0IYK6xrHxj4DUklmRXu6uVgUxC+EqcS1j3PtjuUvzOwKxB8tKAGD4OFoBEhsWhDhkVEAzgEX0YNGFcaoUHuZxWJTst3jE6p0TI7aB/ard/bxKmiuHNDEU1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763976918; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1iY7oj/6768Ok99bhzPuJb/pUBTNcx6eIKrqWNh7ujb279qEue1aT4FOE2ubEsEBdPESE4nh4Nmf6roHJ8eWIz0dA6TC1aTfVmFdIBNYmrt9pLPpVfNUyQ+i9vjKc9gXjZhj2MFkflganJJxlSrCZeBjecf0ICRQhuumvwRXP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l8ZZySiI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l8ZZySiI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l8ZZySiI04U/Sl4EunbzaRarFH
	yboi3fSCTHlhUVbJpbvgRAXUdGUDfv3syXkL4dYjXK0dcydRIbF9a52JRMzY4rRn6dMdCQJDin7a1
	Y2aD3RMviqMhNAWlCg5cfFf1hA4q+Ylse4erMc8/5sPQIFWieOshl0ClpJ3ZaWcRRvBib331snKHF
	+lr1n2GCrBRhCUJY+iIUtaspcQBE0n9tVvDdyX1CwJWTwAR43OY8d8iNjKfTnIJSPWj4t4SQGdEbM
	0Hw9yxkiVOi04zi/neeZ6j+ONxma0T76J2CrbLkRtca9y8/pVUfTermqcCxp0h8H7EclV2Jn3DcdG
	RhKHATPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNSya-0000000BMQZ-0ESt;
	Mon, 24 Nov 2025 09:35:16 +0000
Date: Mon, 24 Nov 2025 01:35:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub: fix null pointer crash in
 scrub_render_ino_descr
Message-ID: <aSQm1C1H8ROJRAMW@infradead.org>
References: <20251121163937.GN196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121163937.GN196370@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

