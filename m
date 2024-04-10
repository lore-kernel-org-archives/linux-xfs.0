Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2CC8F44
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725762; cv=none; b=m+luW0o4thEJ2HP/Lr+YTKRklg4qBP0mpwKYA2DkM9cVp0gEriuKXVDSDGXswndvSiR/dy1PcCQxCuSfLP55H1dxKrtD+eB3kkkTHVRH5+ifqXMeUHb1kzXXjBZjm8ubjUqDN106KiSwswOp9KPwqjHLvMw7cct8YKKKbjaXCEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725762; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3KZqwSJ6PUUQyC/4KlCgu9N2Zwp5lHtRj0IU4/rsIgww/78YYq7SH9jACd80MZY3CA4VwvHA0cfIglF4+1wL4XoPjHYnC/cZ2L86iMVcAhA+U5sr8hp4hoc+TdlbkhTUAzot8d66ytZpM/XKMU/Mfq1R87d/7t3JIen6W8//kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zTRI1cAD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zTRI1cAD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zTRI1cADrgfMbAA+cYUGZF8V2P
	5+Qk9ek+bnxRzAEjomBtMSylZIV/CrImLvLK2LfAgpGDASLDx6sxuRlg/rDDrxhfb7tGmpBF8y7ue
	aGiIsuXJ8yREbF1Bwrl6g2hAV0Y5RXxQiMyC/kNwXhwVAgj53PcUQGJ1B/fFECX1hjbJrtqpD7gQI
	1+WnFjtdQQzajELs0rQUJdDTz6NwL7a3d8F97N4hL/kVkTZ/qQw4Z7rSYy/Q/K2U8QPcXsxSb9hwC
	NrVYgfhNYMGN3l2m8BIL+WDqVsEi8AUmryq9J0j0IU0/ISPMn9sjTqi2qnO7knB2iQRRNOD/DUoel
	3CtlTzgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQD2-000000057uZ-2Y9i;
	Wed, 10 Apr 2024 05:09:20 +0000
Date: Tue, 9 Apr 2024 22:09:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: enforce one namespace per attribute
Message-ID: <ZhYfACnZkuHbNmzi@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270969047.3631545.13061481708392950797.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969047.3631545.13061481708392950797.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

