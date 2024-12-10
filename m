Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E9BBA3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806877; cv=none; b=Rh2B4m457KSTkRDsC7CqoubPOoaPNosw75f/+u12WrZAAJaA7YOGcq9H154ZIWwCd6SQRi95vQDRCkSd2QZlc5wFg6AxOq41eGS2UGsxxx/kf0ZJMX/JgRMJYwD7ilCIGSPnbNL8tIpbMYEWvWkzqeKQ/708xqkTI/67a+2VCmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806877; c=relaxed/simple;
	bh=BwqrZD31ATDIGJqCnck8N8cpmjql7ANwe/PPPEy85T8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPmWK5DoOwsSQeIciZM47hIYKTkDOvB6EFXfn1pblbW8A7SRyaxb5ri2L7MT4KTJInHNDqDztyB3wM+dI2xQxvGWSLJ4gWXq43YL2FU/Gdax+hTBJkV3gBkJ0s3GR4bHuW1tZ1Aj3cw63Sp7pEElkd6fLL2mHPAmpO9hfvhwzqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fiNjcaY3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fiNjcaY3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BwqrZD31ATDIGJqCnck8N8cpmjql7ANwe/PPPEy85T8=; b=fiNjcaY3gMZ9NeFLwO8SiDcY4T
	uy/0f+Q+m/0E+OFybffl1aLB/QIiFlOWAi0+h7s8Hx4LPJV/yZWHhKM5HoVfrw4JCfStDaP+VC93i
	nQsYDwaRO0E4R2KlPsqUVo/uU4SHONsSe5UyfoPtWWLVK7xJQCLU8it43wFhsDnbWgVK82kKP1/Z/
	Ou0p8Aj/Rk+HrHtouk2+vvAJrPRtL6By5E0iX/MPBgMPpp28Y7d+j7WwO4TFbgM4zzsjpMR7yVQS2
	TSMbZtaHBAc4UTH1gAWpIQ/jDZr1GvT2+fdDe5adEkekYFM9unqGUwRC5DvGaDkQk3iWqLttGbrj8
	7lhD33Dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsN2-0000000AExY-17Gx;
	Tue, 10 Dec 2024 05:01:16 +0000
Date: Mon, 9 Dec 2024 21:01:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/41] xfs_io: support the bulkstat metadata directory
 flag
Message-ID: <Z1fLHNNSMpmoKRKa@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748467.122992.7994504931432399626.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748467.122992.7994504931432399626.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

s/support the bulkstat/support bulkstat of the/

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
