Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DBE171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388668; cv=none; b=Rfz3hh0H4cVH5sv2+gMCKKxXfQApzomI/otH2t91zTwUCA03i6zcwINvh5bIv17TH/h7npj7weuJ8uPdvEH5HCJo6vzX4cpkKysjntRtqJQ6EYmnVwtWZgLuAEHuMMdEy2QKYIiPQfHtk7usFpFlil7aN4f1w9wXu957kXVkLYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388668; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJEqLBM605+YcFtAYzuI2+Ps5lOUjj+d591TE3Ix5nv+vruL6QnHiac23DWixtIGlq09WOofRR102cB/ytb3Y5uHO5B87J+2NnPrWsH5lfk4GvwPQhIU8Q4aCUWXGEXH1TihmEauQSezd+Y+O21L+M3ofqPMy/avB4BMcBtYSpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qET14jR0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qET14jR0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qET14jR0NQgXpSDHKPYhPOYqqO
	BDMZyK+/63NjSBy5aSTxN1A4HnJA0g6tpk5bqh8s5tDlN8MO3JGxVZZrBoJzUzzimp2MMx2YRB013
	km6fTHMHGtIMs3EfQYUNfvEx0afFrLAItoQdyYAqFixPf0iJisMf7DMTdu55GI/qkcl/8qDp1UNH6
	cYgvU0Xf5zKEQ3i3EXzPd9UqSWR94DOoP5papgMPTFhRsR2YZfqFt2UrXDgI32dwqwyAFqzzEleKV
	3jjPMUuom2aXcHG5SIIQYBE+TgNOewYO7SrKCtbr3ep4+6cB5SQ5GduaVMBsnnbZzRupUjWpeP7PK
	jQwwMD1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMGQ-0000000FEL8-2Tg1;
	Fri, 23 Aug 2024 04:51:06 +0000
Date: Thu, 22 Aug 2024 21:51:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs: fix di_metatype field of inodes that won't
 load
Message-ID: <ZsgVOgtRxmxY53IZ@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085518.57482.16444514043671384485.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085518.57482.16444514043671384485.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
