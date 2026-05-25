Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83003469E6;
	Mon, 25 May 2026 05:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687841; cv=none; b=Pjd1iXEVwoo6w1Tx+NDOJEEaYbVg9vHyNiWpRzk43McUEq4JZjQbfI8bP9hFuUeT1nz0E/ajZUd0aPitlqmV9RPCuVs9uV5FSwajsiaWOXqshiAtMtUXLV57PLtemUCMMbVZmb02YJFNK+wFfrbTlKEQRDgux6pQOx5PVzPRr48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687841; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/GMp4HDNy9tQ5ouQufwKl3nOwDz5COFfjoUoabgF/vBZErQGy/Zf1NWF6hmgF5wGmbuAoawSdmDJQ1mw4AoFvsXeessZrMpGN5btMkjwiNI8o7fIae8HOrEebfj5FsVWzOefIHMByVrJ2YpLoBv4boZO3cGzCvqMB0W+kyVDIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ipCY3aPT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ipCY3aPT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ipCY3aPTmeDplZhoyj1YUHetDO
	T2oDJktKdfKsm8/UpxuOTVAOq/dCI7ymZRG/896ZwbuisgbhKtjfRL9AaXo7jQ18GynP3FW4oSAje
	vUYJSQenU9ewKxB4SfH9piuWwqZlQ3otfgqWKHQCx1iSz6eFxTNOc8yXTxkuavSDsGsoFjxyQR1Kv
	TcfZ9XWBEx83MGOYmhBnLWUwYU9I6IfrLA1Lf/e3smN7INSEuFGrSXUZ0oFvMu83LrNphbD130pE6
	JDft1OhqRNTNs+kWYWGYVIX7dGc7CsCYizUAYVUPGHKSL7xQeTfdtBEEiOuOo5JYnad1m/s9RBftN
	sal2FnUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRO6W-0000000GLqi-3uLW;
	Mon, 25 May 2026 05:43:56 +0000
Date: Sun, 24 May 2026 22:43:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] common/xfs: fix
 _scratch_mkfs_xfs_supports_concurrency
Message-ID: <ahPhnCOHJdTk8sRK@infradead.org>
References: <20260520185202.GD9544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520185202.GD9544@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
