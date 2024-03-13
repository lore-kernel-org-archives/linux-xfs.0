Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0AD54BCF
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367255; cv=none; b=UWMkLp1d3gsZRFtqLXFueOM+cvobCmXnsmWjA+3rYJEJtxSZgh2/6NHRHONjPBrid1AebBvo1fEuFPZQqggtZhRipe+RGELIZZU+V19ssvfIOqBgF/tLmsEUj06r26iYcmVT0XIDM2B6I1nWBDBH7LSVSMs2ZcceYWWZfEaelBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367255; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4NW+hPQQvcNDu3OpbQaJfLAjk7i/DuXNdTnBaCa+cdBEKRbMMg2zmR051HlyYTpjcArRrFPyxHW//qXRLz3FzmpobABZmy9scKqMnCx37viP4gWi4UBOSdYE9Lrc2/hoee7LoegFDod5LeuzVwvbvp3cgLqwrXvAJdrbfZzP3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0R5fitXQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0R5fitXQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0R5fitXQoVoh+0OXQQmqK6udMi
	Xy1wiKDWLs1cEQVw8EVaEIPOHfsmIEUP9aKkE5PjGcVMR956x7vT1K+4XUy9/X+sMIedhNC6EotKz
	WnR4yYxwILRDD2dHgWlpRvXKpQJvLJQ+J3NzwhMKO7Bq28gGW9CpCeV81cRHt01SJ4uzK8d/wUVVP
	6YJVHJGlyJhqtBv27jBa1jFfAg92lIBdmHkGQ+8wY8iJR1s511Ko1C5muRpFkzIGY3mNhd7To3KkA
	rMtV2dQGXgf51cv2fG60pR30YGnx44xFb797n/+RYYuSEmRQWj01IdZGeh+ogOLfZh8YWmKp/ec98
	52Af2Pyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWeb-0000000C3qk-2HRT;
	Wed, 13 Mar 2024 22:00:53 +0000
Date: Wed, 13 Mar 2024 15:00:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] libxfs: use helpers to convert rt block numbers to
 rt extent numbers
Message-ID: <ZfIiFZz6aqAonjOp@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430629.2061422.7288266899318934644.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430629.2061422.7288266899318934644.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
