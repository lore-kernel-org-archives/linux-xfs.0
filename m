Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF64515B973
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142189; cv=none; b=qtpj1HvpzyWREJhxaPEYb3/8GD5QAJw5t67la8mqs96XxaW1K3G7RS+yNkbYxr0gnb50DbLIX17llj3d1hihkM1AAFRnUHD7ZVBxDHIVFnLtgd+5dl2bnwNtvs/BqQ+dCMLFPvcjkXCfx/cU8r3WGcZ0P+wrvhitJckgrciUUwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142189; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WDkwb8RD0yaXvg9jRxO8Frve41vIPPfZIbsR9WxJ63Aao4zwcIlnih/8YeBKHOzSTc2mLB4B4zjHY4Ifu/WBZDDIF2yrjVaqSnybJXAwLo7LtLSVD8i0MrkaDkaungB+64RS/kxMWzOS7sQD8fEawxQvjIgLFb3wxCkkGiFUZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZAO33MkK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZAO33MkK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZAO33MkKqZlMKh1yiTb3mys6QK
	x+7CsgPmYqgFPnb6aS38mv0v7NwWAv1Gor0f8wO10D9RWSJFwcg1a4wHXLkyGwYANKhxx7i7ccq46
	e8ZpjfBQOsSCULFKCQicapQ9r1YMppKmKv8px5bPHpzWyFkYd58PCPQFjTJ8NahNvlWLFWMZX6X24
	tHZKTzrXkQ+5lR0nIxEJMy0lALpcx9DLQfkv2Cwh5CJuPv23RKx245PAsPBa6FKDf57762vkv3K1j
	+TQxJaLzexnqG7chuqW0EhNLIqgsdZrL3Nu5j/4a09mztMJaPFXRAVpJ+hZodc/SZ5SuJbK44/mMr
	ddaG602A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNxT-0000000AKyV-1QEK;
	Wed, 28 Feb 2024 17:43:07 +0000
Date: Wed, 28 Feb 2024 09:43:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] xfs: try to avoid allocating from sick inode clusters
Message-ID: <Zd9wq6NG2R4IdicS@infradead.org>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
 <170900016075.940004.12735354681652774834.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900016075.940004.12735354681652774834.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
