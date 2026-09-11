Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A3E4A2626
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141753; cv=none; b=ZY3zJq6rPYgYdXR7kUjBDx+IZKS3Bkx+YoazcIzxgL3oNrFxLBeZPm8qC3GWv8OiJg/DuyLQ935YMzFbBlz/1BtDv6NXtyBkqdOWp/hHQhFaANAe3DybEXF7m/Qt9VxYhZVby+TChtGLGZrVfGF3Y7YyY9c3492NFv3lPAlR17s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141753; c=relaxed/simple;
	bh=1Ml+NhUj6cQlOOH70czAf+Y7uHiJjrdK9vO/by0Rft8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmsyFAHohnyNdmVf8TCdaZwVtf4cQc8TzjGMCUpg20O6OrJlvgwCowaBkIAS5aYn85PhVaoX9mAE1wLCw9X/2VzBcELxUl40YMAriq/TyoP5/K/Jmou6gF9BMwmZqboOaYatS7XsOE4A2kqIi1yGDSerKaK3pppCfAOG68K+Blk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BGxduGv1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BGxduGv1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Ml+NhUj6cQlOOH70czAf+Y7uHiJjrdK9vO/by0Rft8=; b=BGxduGv1WOfY1e6Qiu6swXG8h3
	3NjSYiuRZ+apd4Yu89/N/O6t/lM17qlHRibc0kdjca4aCF4uPg5GIuW8WGDUeRDyvuclR40SeurY1
	yA5E5/jo1IJlDql1/dMSF/JvP2NRx0e90b8cKpfwQVQXTPk4KmBzLceK3JVIlIx97bivkQVj3BQ/q
	A8ctUVV9iil2Q/vVTTJzmw98hovGhEutgBHQ+v/4P1ZOcLL/rs90DDIzkvtohsSZh5QvMbGMdWIVA
	zVl8B5bk/44Xo8r69IbtpLHXh49rl4RPK8JiZU/ghRBhVs2XatHc/XA4/i/NoMJ1vTC8KyF2OUt+C
	AO8tG/lQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x53V0-0000000H8KC-16lH;
	Fri, 11 Sep 2026 15:49:10 +0000
Date: Fri, 11 Sep 2026 08:49:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] makecfg: handle old V4 options that are almost
 always on by default
Message-ID: <aqQi9rMA7f7fCeZ6@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910641.4047311.14095703802962095779.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910641.4047311.14095703802962095779.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good, but I'd really expect this to just go into the original
patch?

