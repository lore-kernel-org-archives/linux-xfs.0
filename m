Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EA34EB5F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713330116; cv=none; b=V8wDO33CuCFZx9Q1baZAcvEF7J0dfGbDRZC59xK/VfxxfshOtsoFwO4y6y7ZtheV/1uciaEkHDH09wTV8V/+fbgaZiT9FD3q+XJ7/Tfuv4WhpmA0BGtHoH5X1dFK74yeb8wit8aUTQtmB9hd5lFwIDS80orOiG2tdKt/XLEnjtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713330116; c=relaxed/simple;
	bh=4OGPsSLWo9WGDNFZ8R1+j6URlJq3h5B04Na0TYSiQqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0IdTJRt/6vUaRQJiFKqUGxlD96WJ260b27o2JGcH2jSQEPXQ1v4rq3RM+O2iAM7TUhriKRu7KRDLnw1j2zpfCSd+GoqGH7zlq/ILm7BcxRa/LKlR89K9hux8iaHja2mTaXLg99SKvFYFVfKmRghDVJ0HC1sAFdQvFwAo61w6Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XcYvazOp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XcYvazOp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4OGPsSLWo9WGDNFZ8R1+j6URlJq3h5B04Na0TYSiQqw=; b=XcYvazOp+tUYdMcSvcKXV/V5g+
	zcGKRQR0PXPZRzek56vyWQU/Hh8QK706EG9YODkW/wqvd98qA+/a1l+0IKwHSziCYdDRie1K3klbc
	BUg26DaWeBKnwSKUbs2skzT5WgPitdwlKkiKfTBBJjC2d4WMLrPTv7fXAyoEdY4dUiN7XZXpIiM72
	KYa295bpRJjCOeV/cGxYNA2lJv3dBBMy+FC0jGH/vKTAiDsyAbjyVx9hXrBAza3tb9tTh52/H5UQF
	dK30EqhChKXLnWhn7CqPfyl91HK1ZaFAZftjR1O63Hr8g43lc+RF/fPnOi5AG88xZ9lTxu7UTZUDz
	mqHYN3Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwxQg-0000000EjA2-3TgP;
	Wed, 17 Apr 2024 05:01:54 +0000
Date: Tue, 16 Apr 2024 22:01:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/4] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <Zh9Xwq7SOlZw53Wx@infradead.org>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
 <Zh4OHi8GI-0v60qB@infradead.org>
 <20240416223148.GH11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416223148.GH11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 03:31:48PM -0700, Darrick J. Wong wrote:
> So I think I want to change xchk_irele to clear I_DONTCACHE if we're in
> transaction context or if corruption was found; and to use
> XFS_IGET_DONTCACHE instead of the i_count-based d_mark_dontcache calls.

Yes, that's what I thought.

