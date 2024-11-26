Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6236E7E9;
	Tue, 26 Nov 2024 05:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597282; cv=none; b=FpFN5sSC5OnlV9iqk5Zd7w7oK2FaPtI64bSH849LE62ov0TVEuPpInOjNR7ZBqsGoVpx/muLpxgTm9D6x7fAwL0/NrPTxrgNfxSodsDDiCBMJmTVRvfCkRVQ9K0AcIka4xjgSbERgOupq7peTFfIaPgAT5xlVKI8xl3DDeCy2Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597282; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rogbND0yp89JSoABYjWpl+pGfiTCWr0oDp7zeMn7pAVLRlhQesGMY4L1QZlS6SEHK/vN36uPsb8tI78GJRSSYUrn1y6J6VCXju9fTaU8l6pWfuHUzBDFNXiyxUD84Osn6mHmCTyTMAlAchu/vp8Z99s8mVnqsszNBsLzbDev8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nlLzXh1v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nlLzXh1v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nlLzXh1vO1Dq0UBT5wBz91EG3j
	3PCpuBanJikxske7+nma7Eni5Km9GbrW1iWJ+zMaoF9acEtpcYKlPUZKzz0evlJqJwtrb7ejMXFCC
	+/NzABc4wughL/dS7ejDpHuaUGhptwyZL4Toi798uj/VAjm9JC1AT77I0sMSZdc5Lqup99h+3QODI
	+u/QEM7K7slZ+7/jRUcLFJOtvjkVRww0PjeXIL35zAWFD+Uj2tZ+ZBLjQlKAtN3YT1HuBTlC4qhEp
	WhCZGtGBmyXJhLzhVptjXqzZZTwYXHvGCm0VW+PfyuQJx+0Dh6h6EGAQSkNXYtpO62F/N01fDGGdJ
	7rbZ2ACA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnhQ-00000009ds7-0ZhB;
	Tue, 26 Nov 2024 05:01:20 +0000
Date: Mon, 25 Nov 2024 21:01:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/21] xfs: update btree keys correctly when _insrec
 splits an inode root block
Message-ID: <Z0VWIP9l32OeX1OB@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258397991.4032920.4586526854197814179.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258397991.4032920.4586526854197814179.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

