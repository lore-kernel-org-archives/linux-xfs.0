Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D981AF0BA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081171; cv=none; b=gDhTJB5icQpsi9tqnJn6VhDdh/zGRBZ0MM3zHxHwXbdi+uBMX5kbZrorq0uw1OJzRwz5oRx/qUer2IiZmapoAM+nIcbT8icKe/on91qOj08JliVVGXr9XFz7nxZE0lV/Cc9G/MYptb1uAUEXI7zhHniWzUXS3UQkM5Tq2rnbcbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081171; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trVudpsAku4PwpSWXc3SHeyx4IQZgjS8DS1XyaFIVsb3gEjF0iiocrg2DChpAsEhKAaINchCMtN3woaxo30uuFlwvlukjaPRacFe3Wn7HkZhMhuauEkKaVEPPHAPy5UJvD6GFReKFp8IpRqkpWNzc8y0GuIOXq172x7lLRwXWUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fz7upC2U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fz7upC2U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fz7upC2UXEuSv1IxU8YMmtH01a
	vJddUnG/FTxQUkwmicd9ewtWLeBIhaWqNWr+rgx6EUSTt0YOlnbaHRQS/6DqCTR/RcRM9kJqy8jxA
	zL5ARBSaHgm07Dso/TZ1h9bH9cKoGx1SCSCiXQktNLOz+AXkRduJMM8uNQmvlWkgU2TFN/77/ADvg
	yH9045izmShMcOW/FKS80gNn4nfkJ1p4B1STA8Sw/fzbgRAmv8gEf0RgzmgVZTM5kIPP6r5pE1rNm
	XWx1IxvXSf5B/b3LhuUvxvBfISDxFhFG/or1pZyui55zKsOJqwdVee9IyQaww5/NmTC6/RTLeMMVq
	sqsp3XoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1j8-00000003CdQ-1vSi;
	Fri, 13 Dec 2024 09:12:50 +0000
Date: Fri, 13 Dec 2024 01:12:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/43] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
Message-ID: <Z1v6ksJ-5jhd1mO6@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124825.1182620.2612165173359034874.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124825.1182620.2612165173359034874.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

