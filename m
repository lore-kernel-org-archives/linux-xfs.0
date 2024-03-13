Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0A54BCF
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367332; cv=none; b=BYZpNxGzunrxdCve+AQOpHFQCAIF6AdM19GiDvjOrFs1tYk5u89XCUqQNlbJDj8QSNbIsvNVy3Cn1XcZvgXK7oJyAM2b/67kbNwZeuFJ3ALMKT7KNBUX2qD1/Sl6QXJaDTMhW719GWdrmiLhW69eqrVQuS6E2VKTi7tezI6DL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367332; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ok04yVPo2vMjUwsZmnGuQekIo9tSx7GI2L9ak6Skd5WIviTQJzKjVSQZlqD8xSihE4wV/ejntAOARjrvYnALZJrMuKGEfKN9/7d9lxX0Kf/Jo8/45Murx7he1GKS+0JLGcoUYd3BgLX2h/wM8mxUAk/c7XdoCdEkOgOzuBak6kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u9VcBWJe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u9VcBWJe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=u9VcBWJeavjosZC1YxgtLQlrnw
	gkKAyP2WioTXt5kYa80oUNN2Xn+QjodWvcLVX7/fweKgPpJCFnWlt4l3iH0807XwJuWQ34Y76l/L0
	4a/4fhAPRMJKHvldlBGiwzPsSAcdQd5VlIxl/pR1FlsCBZzpVlkTKDrANgd6eNX5nvUHiLfQiq1BW
	8chsgUpOkUgWjzpi6CQLdbA7N82sR5UF2Pbyl++OBb0p5gc39H9i8M9lo3o3dFdAtgzsKi0Fae5FZ
	mNlJ0/ZJ050NaGsvErXxQQIV4zG1/cByDHPrz5b0BE+CetH7HWSABBbk34zT2t6MQg6680NnELm4W
	IvkOZ35w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWfq-0000000C3zE-37KU;
	Wed, 13 Mar 2024 22:02:10 +0000
Date: Wed, 13 Mar 2024 15:02:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs_{db,repair}: use accessor functions for bitmap
 words
Message-ID: <ZfIiYkFnfu8ygYI7@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430701.2061422.2336669086852112996.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430701.2061422.2336669086852112996.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
