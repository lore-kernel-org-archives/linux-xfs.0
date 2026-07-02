Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D8B38D41C
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 10:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989689; cv=none; b=DMwpeLS9r1EGDqpNPySlWvnZo6mLwqLpI41G+sER9uBBcZC0oCtLZrDd5TrvBCqHpLBwAs/80+mJmHg0KKbd7kVaYBJbRF2ENSB1gqqsQXXicqfMA+HeEYRmOQvp4p5RL1ilW+qhZzRvcgSZqdmJLbsDJ1S1li2dRZRPbmL5Ozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989689; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osieTTpJGZ0EIlbqLQg+8soO9oiAOrMZhnVZZVB93MHloXAUS/zwrOLy52ClaywV8M0N0x9RPsGtU+PZRH1oLfGjjJNnD6hyGWsoGpmIYHmxDUZZ+6UzHoG1TCjDZ638XhCLz5fI1ennBc/qp75hXinFY1bSTiPBLyo+ifOGS4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QPObFJ4e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QPObFJ4e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QPObFJ4eUcgTwvTEVG2BcnikBG
	nNVhjezU9dKA+a8wf5umwSWHdLLSyKF4qE0mk/RQBWlJm+cFCaQ4hAmPm0/KV2FK5g/pjjdDa1/3q
	OK8F0iFhdTJnxKqM+bAnR3JmELO4OWc1X39A7nh84dbK5SlIWzn3XIhyk6170PF2tDIXFMbZNV9xq
	2ks7JxFwQkvL2ijy03WA7d0WsSrMmTiuXMUuGFdlqL8Xzc65xwjVNfnybzeXStu1lEZUfx1oiwZmo
	QKier7ye/C/G/zGBJmroZHtfdbHOrNEgX30Oe+8TchrdGzl9yas/NmX4wQ+h92Uj2/bLZEO0evHY7
	+GD7QoWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfF43-00000004EaV-49qk;
	Thu, 02 Jul 2026 10:54:39 +0000
Date: Thu, 2 Jul 2026 03:54:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 1/3] xfs: drop ASSERT(0) on unrecognized log item type
Message-ID: <akZDb0RJEL2qPF1j@infradead.org>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-3-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701153833.3155514-3-bestswngs@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

