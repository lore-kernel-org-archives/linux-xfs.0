Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461E835949
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420472; cv=none; b=K6xf4hXja3XqcNZmgbcqrtAT3d62PIQGJKdEMwdkdNECdaWxDeFVp3kIdUFulK+l8UeH7Eu5CQfkb1U9jfjqLOCpaJG52IMkhl6iojiO5vzSXmu3Sx0Ey7krUJ5njCQL80L0lUpi6frTA1OaiIP2KH/T+7epEXm0hF8iENBB4tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420472; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m/odscWCjwWZgIIf6YBnOi75ztuJOzdqoAxT1t3yv2yRHzCQ1prZYrJbJB7RESamgMZgGG0ajM5sUG/gz8aPGtFU8RqCKW80fMBFv3XwaNMLQaNPh6Vdbl3zFCYhFCEsEbtkt9HNRgYhzt/QTQIWRA9GFztE6P2iL4arKYtjtAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uPQmgVO1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uPQmgVO1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uPQmgVO1AWmwaH3xzCXKyri9Oo
	ZwSHra/M6w2HAEGr8VBencJ4loidlc90eta1urMNcJLj2EOO+oNsGCBzO/KOyOJ4uPrN52I4imdsf
	CARXp/Bv2GkQtapABPEnLlczPky+bHJonxD7DLFSoMdz17uNbjZjOEwscu9FJp0iK2o4IraxBq1CA
	/F+Dy/gMjp7fLs0fAD8e/XX3VxjZvR9TeEK/8mTY03otyRw0W95hhgUAOt4QrKYAmRlcXn9V257St
	Oj3lANp36sirBtNKGi2mZLHT8lLjXM4uTG92+ZknK0UT/KiBhY2t5roipcyWNlga3xrU0uy7N0nzL
	Wlu91kAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQis-00000009huc-2qp7;
	Thu, 13 Feb 2025 04:21:10 +0000
Date: Wed, 12 Feb 2025 20:21:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/22] libxfs: apply rt extent alignment constraints to
 CoW extsize hint
Message-ID: <Z61zNvj0KLE-LjSR@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888088980.2741962.5884510369918809895.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088980.2741962.5884510369918809895.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

