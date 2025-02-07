Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC1E63D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905438; cv=none; b=ZIitcQTXJB8AkEGmtpeqKLeRYCyVa3aB4WH0TK4NITt4Sp7RzCOHOVi5yUtbHvfHgHbySZT4DVHnLPaiUWXx95p8dglkmgEmQIH3/2kFkZmkU9mLsQln9ejnC6PRVJLT8kGQITkhYazRMVVai6W/kpuFiM9VSvNevMNR1Uat0gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905438; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNJbYN6/ca1tz/yxnxnzS45Xj80h2S2bR/70yjzO7EztFzrd3pAQhEyruave1rw7+od5cctz6uKPRIrNSs1nacu0x6/FaoGpKabbLNGuMimVcba6UZv64GWKKCX3LD+7DwdVxJlssEWIqNgu6qJ7o7A16tfw+rqOF8Wc5H10FIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UT7P+iqU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UT7P+iqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UT7P+iqULY+cQd3YAGtqHjQzVs
	V+1LcfNjDBzq8I01M2udMrpFiOFNqvSlN00EGR7Jv0ScUv5Vupk9TkU8VNgDqYsMg0ooKCejYBOM3
	JgA6hHxNpgx10Tw7cLsqClSQzpmOc0whjGYQA6XHdPZB9EX544bwHg0P4yMVWFL1v5WbaRuqJbApj
	runvZirrn/NAvpg3YRhwS/Fu645h6rD5ysNbx157KnHYbsuhcS+IN3UKLJHLdXYMYwgWF2W2790TH
	xZkwn9+iC1jdTW0WsMch2py+fEo0QSUQAktg+gzTvQHeVDIqNfnmIS0NcbaTrF73v9XOfi9DNqaeM
	BC9JP6xA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGjt-00000008M4Y-0lN0;
	Fri, 07 Feb 2025 05:17:17 +0000
Date: Thu, 6 Feb 2025 21:17:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/27] xfs_db: support the realtime rmapbt
Message-ID: <Z6WXXd9L43mM_NBq@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088218.2741033.7947778465817978960.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088218.2741033.7947778465817978960.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

