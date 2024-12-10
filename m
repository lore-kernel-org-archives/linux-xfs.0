Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203FB1BC094
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807799; cv=none; b=IdrlzuNt4zE5/U+44lSDkpZEbXY8804uuOHXgqzZdH7l0RFywAGI04gtVu9/jgtzsVPKobweou+UOku4RxV0RsVHYIKaUYooKBu1KKuYGYtPMpwAdThCdBIInHIyc0HFrA5j/MDxEJ854MoWXS2an7ecXLYv6T1ojeehhbIwZLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807799; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmsdJo/Dz89gPPFxxK5MXLBMsBuVkWPHbE1NGSotGHaFoK3fIt963qxxErIlReiLuaTAhkZMUkxQICxEd4bVRfiSVC3h8DOPyNy2+xVPYpcNLZrcx6OPVjztFKKmXAlTWAjowK7nv4HaywKa9Oy7ioKWTsCKXcrvf+8HGsQbi1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oIc4jRrE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oIc4jRrE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oIc4jRrEwKOtiIK8kCvMFG+pvk
	/Q15Q8YFRj9HV4CJILTG2gPHLhzyosJVpUDkV7oGYFzqszRVwwfGE7XK5BvAF1l4DRXWPIq2e6VHR
	1+t4CYhM+x8dTrMpN8uneOSRdrBXgQzIqQ3vLO6xIjoYBmcPa8UbvR9CzLbXfOjdL68qQhY46lOWb
	MnvYgvDIzbfe1pOACcgtIEIk8RMVpISoFhFIO7tc4uo+jI822MuHJFW/qinj82YZpcKqy++1uyd86
	p/F9at0ZP0yUMWvS4+elBUlOc03mCTENu+sfsiSPn8LPx4Hn84e5nNk+zVX2YRKE/17sdalkAtrXK
	nF9JNEAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsbt-0000000AGB9-3O2D;
	Tue, 10 Dec 2024 05:16:37 +0000
Date: Mon, 9 Dec 2024 21:16:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/41] xfs_repair: rebuild the metadata directory
Message-ID: <Z1fOtX89dX0fwPjz@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748680.122992.17095093569693871336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748680.122992.17095093569693871336.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

