Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5644EAFA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848076; cv=none; b=Cw54Wl/7bcghs90jEaj9gvmLUGa3iOUtzDs7t2qVS35PS3HiTOwW42MAQByu+SMP9dCRG956n08neIrd0aSZ/eSWA0nL3ITvAkE2GQQCibBhqEDQ7p5PYL0dHJMEvS1tLJW5mLoJJ5/e9DIii8B9N6T9Vq0OOb6sA18Uzzww65w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848076; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cON4f9CfO57biHTCZuQFTaRWozQcOJSt+aPfTNPjyH5O2hWAV7knUVKam9LSCDZpRBRDBNH2ByZOSnH2rI65Odz7UQCSZHXzsFYRRRoUZAm4TH02LGMxGsrZcLrPMY3sFqWkqMGcgG+HSDzHDbGEqjQWu5dz6xuHpsfDWn500FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uG79tvp5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uG79tvp5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uG79tvp5yaTalCoNWLS12FUBJs
	QaNtWoNia03edrsmRW8c8Q00lJ8PMZ+fMx+4u05BiCosPg9iEVtOFGRqSv7N8e+KBkpquTf0uWdGg
	/kw68e3Y5JoY85L996/a2gIrDHsxjmy25U5qxfZ13lq88R7w/KEpa76tMD1HCh9b9vGduv6nbCll+
	Z+t4bt1PhFh0Szs9By5/0W0TrkfXp6BD8KJgiWM42pNZmmcRQ9AcGFhO6vRZVTwSi+0/wJaxy/j7o
	4jF2Xki/Bc6n/l23CpgmoEG04P7hncpN4e9pOg48Q/0W3IcsUCalT3e5CSkcIURh2lShsYAI7XKRK
	aBOx7Nfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsDK-00000004riA-0lbK;
	Wed, 02 Oct 2024 05:47:54 +0000
Date: Tue, 1 Oct 2024 22:47:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/64] libxfs: pass IGET flags through to xfs_iread
Message-ID: <Zvzeiq0kZ1TaxnS7@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783101902.4036371.12068791279134429342.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783101902.4036371.12068791279134429342.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

