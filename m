Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BFB15CD65
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135665; cv=none; b=VrQCjqFVOj/okNJ7dAKf0i+X+7xiKQAeA2BEBixaf4hCoOuDiG51KWu54LZNs0m41GBK/hTBVSsKnxTnGYR6VSkunP9COwy8YsnxZSxfbHAqVF83H4q+AGl5xTwlcEYlbfFEm69ljdwfuVJwwSciCXNbPczHPLdcR9YUEF41v/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135665; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogwn6e9Oh8eEzSiaYd7lrOwolZmkoPXFIsPT8l8EYOghJgIRYopihyrB5lK0+i6oVB2bxzMD2wHrYwndtCJep3PRDMZAThsc2wZJxhiwTcxB6cgiU5U92la9R05WRVSGftWdcxq0HLNi1D0SoihdAwAKBNtFl65pPL2gVDZvAps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k7AApHqM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k7AApHqM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=k7AApHqMopkIq3i0ly6fraeJfh
	sThqUoWE0lp373m/0Qy9m5KQrUIZzOqG3b5wfvWAGdkd+zqdM95RzHrl3sRLqjnzLWdxD4eZyukUi
	mawp4XtzNZrUGebz5ojFwV2gwIC3xyeuwsVNQ03SxEr0Z2CwyHITHu6zT+RyKQJuEpq0Whlpw/8u9
	DoUdlEA6sBWUPky1W9ytU4F/s10Mr9QWhA4NmCcsBD5NSpmoVc7FgU53UAm4+69khAjzO/GW3/4nq
	q/ArJ7F2vS6CILWK6a9m1EzT+YWrUscQrA7yPUYcyiQNNzSrJMa+jlkrRFJ0ZQAXijZgQ/MMD7rSg
	AAMgobZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMGF-00000009zYT-2NAn;
	Wed, 28 Feb 2024 15:54:23 +0000
Date: Wed, 28 Feb 2024 07:54:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/9] xfs: use the xfs_da_args owner field to set new
 dir/attr block owner
Message-ID: <Zd9XL8F9XGgwmTt_@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013126.938940.5185893300236524104.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013126.938940.5185893300236524104.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
