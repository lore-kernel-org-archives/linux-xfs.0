Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443E1224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809067; cv=none; b=gIFYYglUw/0FYn8C6xQ27LkOoVIVD8mGvPhn3ERK3zzcwqZ4zVsQshcCPYML2Xl/eGWSlpKx+6W+vQ3rJPccx6+4XA5VYuJ0l9tmCv6cgl99mig4JbQ3RdztCjHLraWee9xvIqKyUmIoTAo5samCGP7r9oBaF9f3zRwTgMeWGPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809067; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dltNxQpyuk0W7irO6H5yVxL+BQg9mPRgTS1xxs3Of+mEr7TU4aN9qsTTBqvRS4XKwikNEO5XHtaaseCi2BInYJIJp1AokmuBuIpGhsIZI1gwd94r+DRYM7vjxHETcMKgowF/pmUKhMZZ5XBELZZEqGH06LQTX741x3xqCQe2Lvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=opks6cZN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="opks6cZN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=opks6cZNT5NszdiRPNCVLv/y1+
	9scvcFsn+mURjfsiNET8vuEJ/PlrWI/Y5sP1AW4Bj8cI3Zhb0mlTg4LVBvFb2bw9UsXcVx4Iz2/D+
	MWfH57UiFmN2IKiqBcwSJ99uAn8JuMna57ZXkDOVdS7NMF+6QvCPeWwuOVWP70RqTdspYaDL1Gt/+
	+/xdvkgbA7ZSGX/2fWig3gaC5W6WSqjv0i6FI1JyYYmiXFONMHb/1dwSwsDSwPuuYSdg8sXu3VAgp
	ZWyLHA8ALDV6h5DA/sgouAjNjnPnA/u2CFlAUozs9fiZ8nHIcNAZyMlKEJhGIw3b2sbFuN6KAVJzd
	RjZ2UkHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKswM-0000000AIGx-09Fl;
	Tue, 10 Dec 2024 05:37:46 +0000
Date: Mon, 9 Dec 2024 21:37:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/50] xfs_repair: find and clobber rtgroup bitmap and
 summary files
Message-ID: <Z1fTqnudJlmI2yGr@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752266.126362.10125424805572848219.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752266.126362.10125424805572848219.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

