Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733CF43D502
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773135075; cv=none; b=ooCcRqlcKDrfZuhvVKeZsDUwTXhAQdSD5oVCZI0B7tMvxDH7lNWLrRUaf29Yx39qBlOqDCpF1G+/DG4f+5M0NOG+VUXmbGRcaObtWpLowBGqXJwb33Q1ueBi0OwSsaxJPcQWUoj4Og9erxwnGeW1gNwcdhlO8ch17NOZfqUauoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773135075; c=relaxed/simple;
	bh=C4y2SnNbluqxTVBb+tNfu9XiZfMoRNQlyvrb/vf6AE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSrMi0XucO5jF2d5AJgO74hltqvnO6mfkUDUFR25aFSzt/3nwR7eEilFHrHeAwEdv9Dz3IeUZX8E3NDOWwB/6Fxscs9zs9gmKBSKFLUotWWMgbl/7QFyqIxMGgGqqopfz5mKSFdHSzI2E0j+KNZzloGgU044s4foZaRAqlIHt+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JGLveZVD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JGLveZVD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C4y2SnNbluqxTVBb+tNfu9XiZfMoRNQlyvrb/vf6AE0=; b=JGLveZVD20kaXjaDfXWU2RsK5M
	A9UNKjL3/GMm/W+VdxTS6d0fjdWjwr5aiJBtdpuZmQB3vwOY6axFQtl/wgwcy4yAMSUp6GVBDduZk
	OViMmXBUhA7CcvMio53Lt1lqbcx0+QqF3DdN2JQp319XfQAmz1J4MHwq3tWleAWpgy55rwz4h1bEJ
	lxjl275zDIBFsnPZgaRc241E4cGFiu6JDjRvag2AWu3SsZl8+typUsSRy8iCQOJrHLC+6f2net1vf
	IkGZ82Cn2O/YphrWPDIlAF5YB+pwGRxTz9sWrd1j7jjBMHVOAU0820T7hMH0pNbIw2peHmOG/jlBe
	3aCaSgrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztQn-000000096Ep-48Jb;
	Tue, 10 Mar 2026 09:31:13 +0000
Date: Tue, 10 Mar 2026 02:31:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/28] debian: enable xfs_healer on the root filesystem
 by default
Message-ID: <aa_k4S2RF0vj_UDj@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401966.1183235.18355245095682136285.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401966.1183235.18355245095682136285.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and I'll see how this will fare on my Debian laptop with the custom
built kernel eventually.. :))

