Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1910A1F
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724062; cv=none; b=Op7YHZtiKG7lx6QmHyFHSlsUMmH7H8H6+6/AHtlpkrIHAtmtWLXfr2IBcRwLCj/lbUTjifhQJcReBNhbQsiGRL56Z5F5G3rPsJpDcS6NfsDpwSNe6udnQJ/Zqi5IU2hek7H1qMlnwNc24X4LkLgp2JyXBR7luQk9XHiSllNHFDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724062; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISWrHdBy5cVtdew0UM2FjLuHej1piCOTTDb/HUd2HDA06MpMcY/Ti/ZShlHCofkTvufF9jKlc5GDKnhtivYHVfbooVqlW/DzvCxB9ls8qYJqkHNQ22H/XgnVCi+/p+oLAd+/H72GEW14abYICV9d4IcYfyNZa4Y0ghGKQUEpNTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lT9+nMRp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lT9+nMRp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lT9+nMRpQEJgWsu1kqD9TViqzs
	YplNp7G3kIFg1ob+HnKPkzaJtg4N+IQfHL/zElyioik+XbTzqghETveEDNF9hM43Hb3Q5W08ntAAL
	2hA2k96nFvtjYBRb3QVE48N3QiEF65mPI1XasXdoHxd+tIcJChoe6fQUCnQQKeApVVg7M74lHXJQU
	OEokd6INwWRHIG4ajGvpVvQRvwLsHRFmydmX/flqIWHiH0jdqfChWkDf/PuogsPCOtLskslJJjqVg
	Kb1X6psL5/VNs/3WXOOmC9nNGQaTCQuzBjINPvN+A1RLKazEblp5OhEjaLVNyobOZKdEHQWAydG+D
	MzJq22dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPlc-000000053X2-2rT7;
	Wed, 10 Apr 2024 04:41:00 +0000
Date: Tue, 9 Apr 2024 21:41:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Message-ID: <ZhYYXFists7A1tqj@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270967922.3631167.6063402039662594735.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967922.3631167.6063402039662594735.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
