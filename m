Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AB03749E8
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979360; cv=none; b=OnO0OCx+AvaAP/4zC3jb5xFG+yBF13U0+b4PDeMLSx1az72zKSnxS3aXhGr81DNeTe/c3Sp/07oXEj82uD7x9IwnuAle9G9/Mfpv5+P3LYuaLkjJp7EFvfpMVbxW/XSdLnBYOhQqXwjNyEh1hFMxEqDvkkllu/oL5mn82dNqtKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979360; c=relaxed/simple;
	bh=k4P/zeuMRuKcJqHbpuoAJkg82NN/b8oHVgBJhIswDgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDfqH1ifAsYBoGXnFhMw/c2444ailyjihWgIlKKLhe63l/3Q5hwi0ycf97NSQg7NKJchbgQ1hRBM1bS5EVzoRKf3KaIzSvjFfbUP9P+hdqgJFEdl0LXlC3NROB8yHs8OM6KpPzmdJXYfhUm9P/o1dF9OPP8FIgWnAOc5WJuJTjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PfbiUR8O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PfbiUR8O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zac6lFQC+8D81XJ9SE1VkS5C1cIHMFVZPqe+3AStJ+8=; b=PfbiUR8O8DUaBOkZmerP5zfkqM
	fi/uZQrIBtT3W6SB9UughJ5j/frFHxHbtTG6jPSYxdGc5F6lAq85p4tgwdlIGvz43j8Xhd8dJcLyk
	L0lq5Ml9MPcd5ij52VKwQtWPkkjd8brv0b/thCzXAuTg2wBouO2tBd2ByN4XtqZZWw74Vyb1HcPlL
	618vXLASEFJkCD9DX9Rc1lrWaKbLCKOhn4CpMV3BRND9zxu+G8XkuBZWe5pcx6zxfY0XmaKM4I2Wh
	zrAQXS+EvmUqOVX8BosJ1j1RQDDUVoMMw29/fs0ewgdsj6HVPJD4Yi8bCauh4XPGX35xP9rsDbLLH
	0/azCmQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ZOn-00000001LSv-1WGN;
	Mon, 21 Sep 2026 08:29:17 +0000
Date: Mon, 21 Sep 2026 01:29:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_quota: fix XFS_GETQSTAT parameter pointer
Message-ID: <arDq3c43kg9hFhL7@infradead.org>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
 <178996057694.169604.2071446642858108847.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996057694.169604.2071446642858108847.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:14:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that XFS_GETQSTAT is supposed to take a pointer to a
> struct fs_quota_stat, not a struct fs_quota_statv.  However, quotactl
> call throws away all such nuance by accepting any void pointer, so this
> got broken by the recent refactoring.  Fix all that.

Heh.  Should we replace xfrog_quotactl with typed variants for each
argument?

For now this fix itself looks good, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>

