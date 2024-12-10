Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E80BA3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806937; cv=none; b=t4zldSRMJzXehheIJtsj7L+A6MIkffWLYYp6QpkuCiw7SE74FbXqfipfOeq/qFsSEBVG/b2nNqeJMJQVwNyTpEeMwkWQqtC4ZpkvMaqoNJU1o7GONH7bBCjMif4dDm8+IqSNdd6ZD2vjuQt6IyxoOd5yTi5RhSUg2TJc0S6zX1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806937; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPa01U5q1b97mTqzT2cw9EkiPEK/7dpB6sbKzyWwoT4DxkHJGGQr6EXfbRoB6gbMO4Gtr3iOBHIbFZVvaMU2JMxGRG2Hs7liytPFeH7pEQ6nyI9y373pAz5k7I8qZvFeE0SogqbGC3W1hQ8RwUv/z1tnVXH4FJSUFuq4Fm4gMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D1BrtnDj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D1BrtnDj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D1BrtnDjzBlbqrZ+QMKa/SdsJj
	1mxqlJypjJkHsKxl8r01ZNkJpVtUDRl2MYE5bfOS3n0rdnCG3ftNSLR0E0anE++FWVTDeLKOREKSl
	cRz+DzhFwi96uFXGo8oQDhaMCS3yMQT52h5qSNzfwmCqjjNP+gaAKb0TYp7D3dO2NVZacEPdPYQnm
	XpO7l10m2E8Jr1AXpkw6lqOJSPm+y4bRsAOFNKDmV9ZFzVvMnA7HEWgGl8LTeQIU+YifyTSPFY/lB
	TujS7BSGwXADw5Rkqs3olH+Mqzzptr7Ta4OIboLC48e+raUVIbx1TMg39HnuNV6VYrMwr1WPyoNZV
	jmeppv0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsNz-0000000AF10-2sgL;
	Tue, 10 Dec 2024 05:02:15 +0000
Date: Mon, 9 Dec 2024 21:02:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/41] xfs_spaceman: report health of metadir inodes too
Message-ID: <Z1fLV5RgGcRGdrjb@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748498.122992.14830696708287221369.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748498.122992.14830696708287221369.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

