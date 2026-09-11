Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C449482A
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141814; cv=none; b=nnQxfAVEQearK5fpmeY8PGWuB7iLO2D7FKoYsqRkW9TUwhXyZdx1b9cgKD19v878MFkYMLImRHViFklVCTedWWzDNtHzst5glRv8GVksmUhL3g+EhpLMBEhqQJ6SHGxkQHaEIrwj+xmO0K5wltE9pkoY+u2IYO3BO9kHDmtD4zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141814; c=relaxed/simple;
	bh=T+spPHZJZjR6ErY1QzeU6dnLZHmMp6UR2SanE22wqFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZqxO3A8vw2/eznwl+JMLlNEBjHlPndjxR96HOEMnA38u/kxA4Ux2rYIBw14Q4dipqPAO3RzXIMUFToPVvucpLwNNYcleSwcAKV3M3iwpkvom5aM2nuIeB/rmrYQBgPl/obLoMYdgPpHZKX+cqhjE6i2J74uPjA8ZIdA9KdiYdBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3YsdOC8p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3YsdOC8p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T+spPHZJZjR6ErY1QzeU6dnLZHmMp6UR2SanE22wqFk=; b=3YsdOC8pJe2WlPIIn218XEG91G
	RvPeflGHfh7T5mHxe4jp3jsmZ0QerRXPSN9Hi5mJlitFAodX2JbuhLIGKjtLx+V25zK6MfGApMiEj
	6Rrdd9FszQCACDhoiSP+6erAuznV0/ozyEOZyBUCttMKWxegEfgfSXpKgVivpLsozy3LCSRN7m1cb
	rPHmXWeZj1OLLUieFeSXpwJc8XHHF4cJH/eBmi+dc0exg7uaJqvBReaYUH7RBcjPJChC4OJzkZWqK
	8eYyszSpl65PZqd6IQPl6ZXyD/2N4LpRgq0bixbu9INa9AWiQJig6gg8j/5orlfYeYSm5cLrzl8t+
	Lq3Temeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x53Vy-0000000H8Tt-0EPn;
	Fri, 11 Sep 2026 15:50:12 +0000
Date: Fri, 11 Sep 2026 08:50:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_admin: print configuration file for mounted
 filesystems
Message-ID: <aqQjMm12fn42Cdbs@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910678.4047311.6897947264568294544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910678.4047311.6897947264568294544.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good modulo the manpage nit.

Reviewed-by: Christoph Hellwig <hch@lst.de>
