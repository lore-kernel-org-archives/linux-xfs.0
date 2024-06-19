Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0473A6A33B;
	Wed, 19 Jun 2024 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777886; cv=none; b=i/2HeYqRY/5Agx1fEyBvSxkX2mIvD99rTgp1JKkQp3TLE7ZsLewnxY2uX2O2mx44aYHO1ovIIALA9g78A9hDn4HAxbpjdUP4k86NeIeu9w552Yk7xbF/8IUilbC47Seq7zNcTobm6JBdPJQhf6TFaRbCm8zWY3JCqfHPt1Kwt5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777886; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYdSAVzWwnR2T30K+tgFB5B8ONtuQZQW70I/k9f5PSzZhBD85A2A2fa/AG+RHb+mo9FZ8bWRU3RhuGQ3bBepHTqVwuhoA/76tFKVOF8i++IP1D7QXLrYBNxR8NRbf6Xe/oxZSxij7/QIGL9HUOHMhAncxCRotHkSmy7WVi97XPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Ch2Y8x9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Ch2Y8x9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1Ch2Y8x9qycaJrW3hAdsbaC9oD
	FYBjFAHUV1xct2JxL8ebXp3Jb+UPz5Yqv2ilLwWTLZaG9F5Cb1Jif5ytcq1NdNiG+kUG23a7a6NIq
	FtvtUELoZovWDBe+Ee0DRDMK24GGtqBWihZVC4UiMN8Sl323+n5XUdZO5ejUf6FB3PudUnicaR+7a
	aDPTcSrX7qwCaojoXMXiUdAcfuXwl6HOf3atdfqzcEtvKvivRlYSX6nqXHSmSOTr+xxOEAq5fGYto
	WDA1fcx4lPqli7zizlTeJi2hHw29LVf6WZtPumX/p0QF4nxpnF5c6PKongx9BQKt4e47wuad7NgJ4
	3bOgTmxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJodu-000000002BV-0goB;
	Wed, 19 Jun 2024 06:18:02 +0000
Date: Tue, 18 Jun 2024 23:18:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: add multi link parent pointer test
Message-ID: <ZnJ4Gt4WXreYt1Y6@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145960.793846.8382128634634633132.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145960.793846.8382128634634633132.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
