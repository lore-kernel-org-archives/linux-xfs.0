Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534339FD8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390324; cv=none; b=X/pItyoufAZeFyhULDBzl6bimB3gO5tU8khuttGJRWAN1fKxaVRAVxPjkLTzRn4LhiI/OPWuQEt1V09MAYimj2ZoH++R9T1d2xflgAYfZeJqmzo82IEPyda27mwYRlrp8Ib4zudrGEoZ0Pl8XEzGTa94sfqPNPgP3Mr8D8ODwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390324; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rw/6HtYE6j40NlJlR9lW58eL1OM2SuPs//quH/BeJoeuC+Q1Hcd4iwnZo8XJo1mhEQPDjHF5TsWpvIyC+RBoprjdCFtEQZFFqIfn7vRH6PA2x6DlLKXXPG9g9Zc7oXE5DfFMqu1n5Ca5VxNXkp5MyLvgkLGCuttnl4zGjyGxxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AGT1Ao2b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AGT1Ao2b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AGT1Ao2bTkr3H+FoONXsn7xCqy
	nCkfNmaSG1ecKtGdBRKBYPEhleZ7AqYgeywmG9JMBn2Klm4veKI98gUWTr0/080HmvYHKvk0Zx1tD
	A+QI0fiMOAJ9860j9LGYDJ3T70XC4wiDGW8UskmRVMooZH57+bGdsxzM4xUj6G4DyaGxUl2cctN4J
	qxYD6s/qIsQM2fHQpl4uWQNxCBiSDLS9Q9IZranLd6mg4m3gMS8OYYolimruaWzLZmWoHHxSiZj2U
	0ui5ED5b9v19IZVo3nCNWLTGyZfK9HTdD1c0A3ZS5gXCpE0sxn8tk7GjdW7vSy1uARk/AIEIa0moz
	+txlLIEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMh9-0000000FHmo-29ML;
	Fri, 23 Aug 2024 05:18:43 +0000
Date: Thu, 22 Aug 2024 22:18:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/26] xfs: use realtime EFI to free extents when
 rtgroups are enabled
Message-ID: <Zsgbswb4kz6MVpRc@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088851.60592.2012898665553673543.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088851.60592.2012898665553673543.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
