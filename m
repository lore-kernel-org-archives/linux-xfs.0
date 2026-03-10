Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CF9441020
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134983; cv=none; b=Pa1d90C35crkvMDKw8q/DGrmw5BOHBarLbt2z1I+JtXtb893rJ9HahLGCFP1mKPgBUt+srjx6TjalJw7/jymnwoRQ1TXyirbFVvMmYPi7gd1YfxbXJjg29oH3r44XbZBwdwNVe/MxRdRV/rWRqrs6KaafZElKO3pzAcBFUKpqrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134983; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5xBdxEJjwYEEBLW1mFG9R2kZZ19ruUR9YkU+Lv+dHSBYaB2OR1L+d8C6OZ7JufSJNN9EddqkTiQhr2syrFPu2cwTKjW6y7CZp22kLeE2Mi0gpa04KtcTeg7GZ6N87mO9OfHi9O3+x9o8tF5WQIzWtVGcsiGFlZ8Y5+4CzNmwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BBXTDXtR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BBXTDXtR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BBXTDXtR5aeuzdiOEhrpOgllYn
	nmp9wyjvUNgRWALPXb1GW9SxNW/edN8NC8N6CfGfcpEdr8nwSi3x3LrGejLk2WBMWvriS+HxSeY8v
	uOf1DBZMvTkrzQ14QKe4cC+GIhzuMKdEm2ModjkyU6I/sOn1OVj90+M1wGHf1jnT/JZ/szig7a1Uy
	/PSiGJFqvPu/kbrxUuL4JQTFoAFdJaSY1i6+js7FxgdP9Hhw1EA+y2XMKNI/LPIF2Fi4MuayTXCTL
	hy8qJoGUujt76pPv04B6W19TFkFPqWyEkFz0I7mzTWABlbZ27j69kgfIWBDDfF648QBPGDToHtc62
	7aW+HDLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztPK-000000095ij-0b8n;
	Tue, 10 Mar 2026 09:29:42 +0000
Date: Tue, 10 Mar 2026 02:29:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/28] xfs_scrub: print systemd service names
Message-ID: <aa_khum-TpoYRt2_@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401894.1183235.1360530757418376989.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401894.1183235.1360530757418376989.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

