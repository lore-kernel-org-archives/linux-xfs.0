Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2782BCF6A
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 07:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757661254; cv=none; b=a5O96AcuZRk6dPcyLz47Icd+8bbcI8FI2tMuslnFeZQWa3Mqh9WdUR/PvN9BJbRsOgHjpARL4Me4LHwuhs/R1O+fZStJlUM/GHad8zYAjibem76uAco9GlpUilUTS9N1xiIQeKQj+nlVl7NTGDOm7VZRetAiEFntT0UvAdos7Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757661254; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCuiBGazZdaw4OdE/hoqE9b5T/6jI8Jgw80jJkfTgQudOcWmdJunnEQOkkdcTyjQfU6QJS+aoAApV3SxprUb0O73kMFVfGAHO094NgJmu8jp5cuagT5SwL2aC3L/olheUwvVjs8rayq5Wc5EBpb+5ylN5A/yfx9lXjPrvBaVPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EeYFKcll; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EeYFKcll"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EeYFKcllYHegv0Jrsad6rsbgYp
	ulmrqz7k9MMgJi+YJYbDrG+bPJdqtK+AiK7S7I83zHSZ2m4SlOOPIbYmzJPt3bgaVNoou06oJAqbS
	WkoADY/PrbV/s9MJr1Sy5NFsPLs7Qv0N4qVo2eR2oR1ByOXYtGVgCvgLe/JBlzG87B6DvhpwTkibS
	qQLGFh2z67jk8n1kdF0iTnBo/4hHN3q3ktf5bzCg2Ik5vuIhbm1Sh8DZwuSLGRH6T4EnK9W7rkRNz
	XO3bQCYqG6NWU0M7ohZsM1T7FGTi4rI4o0egMQlD+GReMQet2u/8X8IMXhCs4N9vAErZ12pP7OW4e
	dNQWMW+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwxyu-00000007aTD-3mUa;
	Fri, 12 Sep 2025 07:14:04 +0000
Date: Fri, 12 Sep 2025 00:14:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: Use POSIX-conformant strerror_r
Message-ID: <aMPIPOE_l7VuecLu@infradead.org>
References: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

