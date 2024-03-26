Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843324CB2E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432351; cv=none; b=c6pvV3rgrhBWPicSNMVDtBJIGiHs0prgaR89q1v/pczy5cmJJuM7W3pr13Ci8idhnaMdC8wGbxKKU0TKkXwrHeQYli+s9QZRHAIdcpS8mTMTcC8uPvcSgF6brGMLrFHZPuUdMPfq0dSaiO8hwuzn8jE/E4onewUBws3n865MUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432351; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmIH+E7B1D1nik/7xYgKv7+a3aHqq9xQRDVvkVQSA2AYhliqDrvgH7n6wLAydWDNqbnWm5//iBJ39z2RJBPVMkT61PTNSHcI0fB5sa6pjDuraX48uFxajsljXvQ08amn2o13KwZa2qIOEMXAWA8X0RVdoEc+mvQUYZ2t0pR1lYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NzQHIbMM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NzQHIbMM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NzQHIbMMUB7EuUBkgpCh2JIfoG
	gPoprFLvZvqpa+Wou4/p0r3r6sl/mQlpLR0wl2DN1PyoQXY5TmuR2+xFiIBunShijphfqCrhWksNs
	Xqx4yeJku+kV/ILipW8s/BGgwozXn34bxNIPof+njS3nrLdbPiGp6yWeQY0df1U5eyPWzoDLQQuay
	jdiZ7Z4mgzbRsW6w+Loq3UGVECZaDB7VO63RW2ATfWBvvrk9lnzEyaSMOuEmFRgdltgrsyhf7/L3l
	cQ+vXg9F5lQ9gKiTSh994vGyf1NRKeCZVzys8iJcCATYNbzWvz/aEubk+ucRzNucUDT+WXeGJJs5c
	BCJh6aFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozja-00000003BNz-0DX8;
	Tue, 26 Mar 2024 05:52:30 +0000
Date: Mon, 25 Mar 2024 22:52:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_repair: verify on-disk rmap btrees with
 in-memory btree data
Message-ID: <ZgJintC4jGNcRLTy@infradead.org>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134708.2220026.6548177116311124542.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134708.2220026.6548177116311124542.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

