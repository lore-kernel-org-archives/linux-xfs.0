Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B568493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390089; cv=none; b=c4Vxi1gRzcA8BRa49PombG+SBohj4VVL0i0wAIcXVK6q9QFghRCygD2jVtfE1ORhAxzi9Ppnjx7f8omKkOPHV8rC1Yjlbkw0WoVW58YAhhhWzFzk3s18eSa54kJ+cP+peyHbO91M+yZLbMuk2XMVe3CoFUzCcSv246fPvljg6x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390089; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXgdtxoMvAXgEwo5QLsVXOY7jhGSsjP3devgEdI2KXy2ubeItXWli/vQA+kP5wiXAT3k8HyqcCrxPPZF4k2Z+mTKaVwpxEHwo4gnrFo9eh3ogag9gh8FsmkNkcPybQuKat/G+IRfCuA5dPib/H2s0Oe3ueQxhhKd8aG02qP3cmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CkR5F2AE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CkR5F2AE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CkR5F2AEmjHvAOTXPz5DL2lJ+y
	BkIgZkX3xNj2yv+nOMxHM+TR4txvtnwbgB+0DvICVKwIWcXCzPwFbseuREDreEK5zeYPS78ApuIby
	OOJSjlaRuh+EX3KX0T/p8EqQ5IaqWhUuVa5MbRdjb08AZbhGFNodt/PTxqA7HWBOgn7xadsNlgWQG
	CtimYpvCV1kyc79cvWYE9y++CuFDk7y8r2GgWirVkgcNVXCCc+UBa6IeZkjDbP5px4/zRqmD9Qzex
	KsRx+2xn815B9MEsSuCCSfzgkQSPpHmvio4T4ll1LgDCnyBDOSoAk91eDxrqbLDwNruwa+kFzdX09
	wlrhI7vQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMdM-0000000FH92-0Hlb;
	Fri, 23 Aug 2024 05:14:48 +0000
Date: Thu, 22 Aug 2024 22:14:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/26] xfs: export the geometry of realtime groups to
 userspace
Message-ID: <ZsgayJR01dj6yXHd@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088693.60592.13218743269576141133.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088693.60592.13218743269576141133.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

