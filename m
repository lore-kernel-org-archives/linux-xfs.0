Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C73E4501A
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 06:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711470; cv=none; b=d7Sr41D1af2snfpPtvcFNp6BL48EJ+M7K1AQBN2rKJgrcsnUVbuG7wolXZ7uq8EzV2+YAUZL/8OKtBlPgRgkm5ZCkefDA8JlzG1u5JXXn9mnOH5Q6IlkUCojiMkpZ00NeB+KK44tk3YpMbiolHtogr0B+bwuuFhrtK7s6gsCQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711470; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gD4imeflqwsgA/TbyE4g30U967WZ44biiWXiIlyGf0E0x9NK3qcBp13E/YTFxCzhA4L2onaCsxIypTKa2gt3wq7UTIqrpYofoTZxYxsld756YOhGzcTiLANSUuA4W5hu2pAt/Z1ScXqMfEgQwe9cfIWrK5CntQRfEmmBJWVW6PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z7g0HfaL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z7g0HfaL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z7g0HfaLis++2Y0N/bsil9M2qd
	2urnfi4F6L4lbYiq6cPsMg7XdQZeDNsnMXCnTKr8qYI73b+SvMSxTcpV1F9oK2awGi9I0vXO8Awtl
	LrTiMhrCvy//eWKAmD66zVikM1e0nC1hrKB/ysYDXXKcF1mz4xviCYIZLLAB09MauJ+yirfslyve4
	lIeyEkrUmRnlBjjrZJFIbIudXPLd3fBENiDWp+V7j553q7tbvK2bWSIP02UQRvea7P+SniFsSvPp7
	r1aSGnAzbsBoRatjZnRBzS4F6OFL5coplrlqg8tbHruN4BaME3DDR70CnvpZMosOxovZEIXiGJeH1
	oMtmguUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1twErT-00000000lZ0-3XfB;
	Sun, 23 Mar 2025 06:31:07 +0000
Date: Sat, 22 Mar 2025 23:31:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: bodonnel@redhat.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, djwong@kernel.org
Subject: Re: [PATCH v3] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <Z9-qqw5RZXcjidC2@infradead.org>
References: <20250321220532.691118-4-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321220532.691118-4-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

