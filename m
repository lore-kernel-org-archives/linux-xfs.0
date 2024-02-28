Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0888A6FD08
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 19:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149049; cv=none; b=kpv8RLXVAERC8rWh73QdTJK2154lTjXRLwWnnmRopESRoYkFNQ5GWiyt5jm9noyItCFzua5tSIzWjBi/FyxlExxfvOiwVWjiOH3uGw25QI5TauopldykRIvAiwZISMCx9FlVHWllo920RfVCSXXOd5mM5qlRe86Fhsrpbu/SKhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149049; c=relaxed/simple;
	bh=BDJyL9ppjqlUE4hqHaeQizqYrwRUirBcoDnTUdnRC+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBYTS9iAAbTC1jMvGTglCjJ7/hTsYijY6drccMTlrCkBwIB+hg2/OSw8QasUZeRFlZGVMyCXL0qlKmfJwNoZ9rct0sdiEUYuZMhJI9tIYD9u8mhLaBnAFuQ4K7JTCjQT9097KHBLq0orPMyKbgDeOA9cOCIrgbGKxlbwjKvyVr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vTA8++KS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vTA8++KS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bT+jDU48HFMt0oWww7NQcueyAVdw3S8GtTBF7XKACHs=; b=vTA8++KSU69p5A54eETTc26nO/
	UwrNarOWMurmFf8fH/VJPHUIlji9CFRWu/J99WY1J3F0zm2Zk19sMLAa/Jrr//I/aPx1dEHbBqXjW
	m0N/v/AM/42WuIdfyhskKXGF//QvJJ0jNNOVZFooG8paOlwWyOCviEv7nfJFfQ/lt3ruMJPCAQEmD
	JU2xNwgFg11nxo7IyBnVRmx2EOcdRCuyFcpETIJT2Sm5NiH8k2oDZVz1MhhTpsVz5eHxHNrz1iylB
	3w0OSc61PFIUshFw73APxEsfMpkBmr0LO75dszXoiv8NTYHtxQxppYL6YyOkoFAERBT2qbQAhm9z7
	nebHw9JA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfPk6-0000000Ahpc-2rd8;
	Wed, 28 Feb 2024 19:37:26 +0000
Date: Wed, 28 Feb 2024 11:37:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <Zd-LdqtoruWBSVc6@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
 <Zd9U4GAYxqw7zpXe@infradead.org>
 <20240228193547.GQ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228193547.GQ1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 11:35:47AM -0800, Darrick J. Wong wrote:
> > How about only doing this checks once further up?  As the same sb also
> > applies the same mount.
> 
> I'll remove this check entirely, since we've already checked that the
> vfsmnt are the same.  Assuming that's what you meant-- I was slightly
> confused by "same sb also applies the same mount" and decided to
> interpret that as "same sb implies the same mount".

You interpreted the correctly.  Sorry for my jetlagged early morning
incoherence.
