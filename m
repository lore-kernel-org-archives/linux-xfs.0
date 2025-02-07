Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78BB154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903153; cv=none; b=QUYVznMgDjRzKuL/O5C0MQBXi5hpFbYmrenbsGMG0gmhGFLK3kxzWILY+/d7X/ev8/1vnw55EMugU5Yi5uzDx4I8VkgVfr6Vkohu9yGjaEBJaaURZfhSOGXJW9uIVgrS63Wji/92XGrOpZ4d7Uy3RC6saVKlMgjq3a95iW4Gey8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903153; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNbMZa8/xJeQPlLdrXIFl+ziBZLxqr83Rx0JRGRMB0wfmJRFWhxIktBaFgT1vzAb1qzNBESembsb4rXSuGqzmwF0do4NQVLJp+k53Gj3mfa/dvOQ0UwKfrCFAiYRfVHSnR9vBqjwqPDBSwuxlFbiWey09EskBNMiQJfDigWQfVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Y0yhmKP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Y0yhmKP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1Y0yhmKP/jP69f6VUrQmQ/VJ3D
	B7CZv8KFJZDWj3HdTHOdQ69sOSExCH4dKBLJ7oIq2WIKSlx0zCFvK+e+5d6uzfCEpvQkqkpqdAFVN
	iGgMnh0P2p2/ykeIQu36Ttb44M2WWKfca7Xm+YOtSrwUnDY/E8+zyimhiNCEVePlkcRIRFMpe6t8v
	N8lgz92pEYVGpbIB6VwTIfQkam9lc0XdUf1g+CA5xGMUCaWnx9rPlcQ10mMi7TUqJXpTlzRaPLkzO
	fc6DQqL4c7tQlmhUiyZZY9As0Np8XrAf9CYVCOrxCBDRwskUy6gYRuT7T8hl5L4aXeWHQNvg4oLDP
	8xBu8mqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG91-00000008J61-0pxD;
	Fri, 07 Feb 2025 04:39:11 +0000
Date: Thu, 6 Feb 2025 20:39:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] xfs_scrub: selectively re-run bulkstat after
 re-running inumbers
Message-ID: <Z6WOb55wzpt1mmwp@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086183.2738568.5501883032377295543.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086183.2738568.5501883032377295543.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

