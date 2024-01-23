Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9301848
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 04:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705983328; cv=none; b=ACKAGN2t8QHVKBXFKjckESrvD+33BeKaeJzn3LCkMiYGrSPlI9eNgjne9MBRyy2E9tId3WtWSvcB81U8DsB970AZQxfcI46ShBqll+4/E9k2I4fXkcHLKifggXRnnZEh2qabZ4tHnhAUNVaMweRGa47+kIs/HK3kqLZmtWIx4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705983328; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byPTRY4JPExlwTtjpT+jbLcqg1RL5mh1yAhhs8Ea+NCQT0ivNSQxYDsBluqxMQz9jNiEE2yngDbyblKIysjxUCG2YxxdFHRM9JrSctAd1nXJrKRJfUG6FRKSUbOGg1L5Hq9mZHlC2H2NJl8pSog86yvVE2Hd3L4yhJsQ4z0z7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KEio+pz/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KEio+pz/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KEio+pz/LwZl7wqiTsN01UUpkD
	WLXj8jDVaqw3RS2DM70h+4+iKZ+p3wTMOppd4uAGlwSOayiGEMlt/RQNApJn6gkFa0LpJ5t5JqALY
	mwrtHGdRYPF4JJLbkyO5xqvs0bxjxVBVvuDVU6RwCFOLHo5+TamHyKDbr3CDenAmqg84stkgZao/N
	cphRQmjxAVv5oI3ela4WH29iGQZs1dArUN2vvgbFIK9PzOywU3syR39rHAk+HcBaM0k0VAD34sdiY
	aWhF5Q3VTC26ZjOGhaqhZ9SGmwXCxHN6dqCjVCidB0bKoMpWEFVA1+ua2ByWAKNWyQBhQnNj8tTI6
	6BYb24Bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rS8C6-00F34r-1G;
	Tue, 23 Jan 2024 04:15:26 +0000
Date: Mon, 22 Jan 2024 20:15:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: don't hardcode 'type data' size at 512b
Message-ID: <Za89XjkGP90eh/Xy@infradead.org>
References: <20240123041044.GD6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123041044.GD6226@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

