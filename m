Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B929B12B93
	for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2024 08:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732868411; cv=none; b=gZb9bOUCT+UJ2oz80MVWwUM3rBDgxCBpGeFlpRo2tuKbh8QhjJlnx0nwt8j5OkBdDbr7XA0BzhHHvhhAAZiElmAuBzw8OLhfSErO3sW5A1jGKp2q2Hc7FM7n1LOlIMLCuvy7FcYMPhYbwqDTiOACKFi11P+nxiiMeGV88QMsy+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732868411; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTuya53d8ROt2/9VTyELfcdF6loPtHffmYcdeUiZHdSwlXLl/31sXgJWpzjhI8Egra8h5lIFYikNIRDlqtXh4Lwodl9MS3j1tQZS5HxsQV5eW6vYwGRgleK0vdjDbj1ztTfFiJcavzsfpjL70EA5EKr7pyZGlaf4mjIt99pccaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1WxnoznO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1WxnoznO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1WxnoznO8iCtIYmBNvhxuEKWeP
	dkPXLXx4iAKstO1GYkt6kh+g4fH6OZbDM0W0s/UcE34NlTI02fZtO432eC0Wu4hWWBADBnmKmwvme
	QDnqLmH+nXneC4Yhi+3igvVAczYHXInajOUOSqLg2Q+9/k92AqhlxbQTfU7YkF6S2CacqV+fxjf/j
	596T2PGGrCUFC9PdmZQTCXmqFZrs4kmcbUjUTZlqZoOuodndV/u2+jCEKKPtsCqk8Fuf6t8iBwnQh
	BYm8U/q9+j+fK+1UGv1EvCSiJZ6GkNgOBKzzLOmes2zPf3+c143swkX8yu8k5QPINXrOqU0arS5PS
	UHtGShFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tGwET-0000000HArK-05WR;
	Fri, 29 Nov 2024 08:20:09 +0000
Date: Fri, 29 Nov 2024 00:20:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/21] xfs: fix sb_spino_align checks for large fsblock
 sizes
Message-ID: <Z0l5OezlOv7QGCeT@infradead.org>
References: <20241126011838.GI9438@frogsfrogsfrogs>
 <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <20241126202619.GO9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126202619.GO9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

