Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F7384D0D
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432735; cv=none; b=c4wVFx8mGhwU1tSlPd8TN7ggfls4Fa3uIa1diBqO8EwuIXaN0phzrynSB37GEPzlkVdNMlbmSJbP3jzdOfyqemMcFVVuSHVfTgcXrd77KmEU63P0Ix5WZXkMS3Up9TnIusMnd1k/HPY/2B+MJUnAd/4h0RiSanWgZ5TRwCSTfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432735; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctLaCkOH0ymWBO6uiaxpRsUZ3ni9KbeEZ8cZMwrGvyumqiD3nPu9kQ4BVqaWqcIxLLCwoNtzlP53qF8M0XSKyAxsHnbcqMd5Gr1mz7O2GGiw2tPA3di4G1qOGWqey1gTnhgp1AFEFYL2URqL+50hLR5wPXMtaYAKszk+U0pIdJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x6NAzep7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x6NAzep7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=x6NAzep7194oIP5rpf+iXwCxiE
	cpyEU7XPvGzpr+kL7haJHwsZiFgaq7B1HSAgbhPDOv3PI/w2B2v9Y7DGnTcQ6KRf5o1ku7QTW26BJ
	BQEcWoAtatveRlri2fPQpRDL6IJalYy8pcyq8tV+48C0p9SrI5ARyiXYzNqt3eWrYxZD3A2RuPb9h
	bfzyiT19ujAec/aUejrJgiggHgabJnbR+fV+CvswjzmGjnGZoxiW/aO37l7BB4mKH1MqsiZBt3xpK
	BIb4IrOJU+DNBLIKbGIQGN0+bn6cyG7FnzLQM/ieMqxE0Q/N5Oq0z/CFsoHmnFAHf42PNB1Osnwkk
	EeMeUxoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozpl-00000003Csx-22oY;
	Tue, 26 Mar 2024 05:58:53 +0000
Date: Mon, 25 Mar 2024 22:58:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: remove the old bag implementation
Message-ID: <ZgJkHSDomyJBw94s@infradead.org>
References: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
 <171142135138.2220204.3087650473605368317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142135138.2220204.3087650473605368317.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
