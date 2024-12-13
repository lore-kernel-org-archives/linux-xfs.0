Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844AE18A92F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070851; cv=none; b=Ftr6hs7y1icdz3o/wkwgjxM7Lwdq7+eIoZOvBCEER57f9jUAVEGqiBx0pUXpZ7dTKIWhUPFs2BhRl/+uv/MmtkIM+DIbpHT7aLmevxmOvkjBmvPBjjUB8IQwxEtDp9De81561juLmK+TwUKzCXaT/gKLf8HFpfbVoxJawPP/Kr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070851; c=relaxed/simple;
	bh=dNyAOTZtV+y+F+7FC8a/ylpS2qak6NfRFeVW/ALVyZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaudCxCy/dFiIM0BG/4h9y+QUCu2rrB7aFvFXOVvY+GwCm7+9+QMfdYBuUSF86f6Jwfs7cb2sW4kuIIhhzq5Z4qPBrU/GKFxUIQL9RwkVxHOMcyF4dwP5ndXHJfZBMSZmqOLgFYJW5PTpwF8iUUvMpR80sF2dWpbCfdGfrRP3u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gUQ1Zgh8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gUQ1Zgh8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/k+sEiqZ74UQ9ovvompOtnarFuIuP905sES+Kd5WZiU=; b=gUQ1Zgh8iZXHsy3qFtpynepJaq
	FnWNVIREr7Ar631rF+gS75q8kg1A5L3WdogJDMyOaScDkI2pdBRT/irPiunutEbiZ8xO6u6zBkhwb
	duUAW+CRfiGyLR4HH+/UZQzwSpE6F+K0yeXzTtIda9blmXkOPVp9vK4r3jyXz9YQs4YKQ7jsMJf1w
	5CmteNCY/Fe1SqTbi65d+v+ozh1OiAitYYDZwiqT5OqjACAL6Ur6sBXB7FsuxarkMrOlqK5qbTjYU
	QuL7DTAfdbIAtx1UUPi1TKLvJxhMLGdGFUyj/xa+F45Zw3ev4Mic3AVxKbGtTV0ZewLpQcUS7RAMy
	Ey/yOxbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz2g-00000002r7U-0eq6;
	Fri, 13 Dec 2024 06:20:50 +0000
Date: Thu, 12 Dec 2024 22:20:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/37] xfs: simplify the xfs_rmap_{alloc,free}_extent
 calling conventions
Message-ID: <Z1vSQmsDeRO7-rXq@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123364.1181370.781600665689768961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123364.1181370.781600665689768961.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:01:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Simplify the calling conventions by allowing callers to pass a fsbno
> (xfs_fsblock_t) directly into these functions, since we're just going to
> set it in a struct anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

