Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023841552FC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074142; cv=none; b=U/qjnwvv/dssLQfOMAExFueCcyiZjq4NuPweRd/7nlj0o3eR/EnLdwqEOGk+BwEtxgLLXEvG5/YlNFx0woJ/zkyUCfDi7LPtcR89iNLJqt8mCsUHLI0oWD/9JkSl+9IroWaPckz59E0Xl+uUBfNtCoPOAlo5kly9bbbzcRBeYd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074142; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYy8pgy92+XX+QAWfm7E0BgraUeD42XCRWBnXx8xi5ZbQypn0oJ9bc6+Kf8WiM1OcMHnV39Cko4FsJTn5t2iv/vA/sfbG9FzDgMOTAtOjNqoWREuJ6fXvy+Tdykpmypl/f/H2iid2D35MTx6X7BBZd/7lOvz9YIW7mnTvVGuuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UpfjD4jK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UpfjD4jK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UpfjD4jKdxa044ebjgYHksYp3g
	qVZNXslvvkGDBRr0sMMrlf+ZML6ar7lNsKP56W0eWBlhpxf38SqziltZ874gQa4RZY5ZkosTbYvaZ
	3AHh6TEjKmBT6x+clz+OvvcBurp2fo+5oICIg9XTs9Nf2ebzBjkoJ7sJFW3hDtr6dRJ8gC2iS5ZVo
	SjCAn7hU9jNcyQZgJqbeiyRSMb4c7/Ix8CRaZJxYKVf0pE41nNOC927gr8KTugAqRscJE5Yujf1KE
	PVhwyXHUXg+mXSyiTXOGIVN7c4Hx7PLgp+5j/xuAVNKVHJNVsx2pHXvy5zQNuv7Qs8uvYNrPIPxyk
	7qbQ3/Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLztk-00000002wUc-2QXK;
	Fri, 13 Dec 2024 07:15:40 +0000
Date: Thu, 12 Dec 2024 23:15:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/37] xfs: scrub the realtime rmapbt
Message-ID: <Z1vfHML9FTgiVrma@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123675.1181370.3767884091836095098.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123675.1181370.3767884091836095098.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

