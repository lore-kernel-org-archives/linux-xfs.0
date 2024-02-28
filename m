Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD50624B39
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135505; cv=none; b=HLvqJl9GvgDne6NLnE5MFiK8510sD+t+fPKPj8LvXGjI9QTaodevWgkCEeZCMV6IMcwJRR0jUVVJWATSQK/nVQlVm9UH9uS/6cgzK5ohjGqTGqw+LVsTkmKBF+rRrTDsPB3ljbfeEpWtmQ0TWaOw8E5qZbWv8mAJyN1cd7AbZAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135505; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WgnfPhTB1+oHOQB+ic3YDo+iAwk9UwB4u6sQ3rGbcFj7RpYX83PQA5f4dCqwGlxmp42QJhGrHI1dnYul3ZbUk42UDdx2wCqgpKks/4mEll6mUGMKGP8EousJiB9QQonD7gMsVi5vGx/ZdDslYGaKZxdA4SJqBQkdLX5K+nZprAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2/QPDfAz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2/QPDfAz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2/QPDfAzMY0eSIiqooJhzXDLqW
	ASgSXou6i7RAF5suRlXeFuyzgcffO+sthPCeZ9IuXnHxrbg0rHoGFJytskQHb6fVA2k86ugxddMNR
	jAe0sNTtu3AQ+ndwqULsT8QNwAJiKusqfIIoC+ip38JbeKoDUGbvXTW3awJNg1lSTggIzXa19t0CI
	nSgyxo9J+Lho82x7xDCEToBPJclZxmqW7JMzUqIFQ8563HzaHwPvXmjiL0h6HcOjRGa1+89wV7kyR
	jduFcYBZzmsCq6gsklbV0uky0+12sGjEHjJ+ga7uhgyxFI+cscSMpr5IS/uxvs7snRMGCnkdI+TgP
	T3tTswog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMDf-00000009z4m-1k7C;
	Wed, 28 Feb 2024 15:51:43 +0000
Date: Wed, 28 Feb 2024 07:51:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/14] xfs: make file range exchange support realtime
 files
Message-ID: <Zd9Wj3yaxF1EwKV0@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011823.938268.16910707678204143695.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011823.938268.16910707678204143695.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
