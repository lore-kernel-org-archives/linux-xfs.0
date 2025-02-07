Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A863D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905513; cv=none; b=NennAYGS4yWjND5j8iIXcW2CSZbmrKZkAXrHdwH28Nk6cY4w8fsPxaew1CdWpEzx+NfwHS1Fkuc/T7661UjoYHeNmCx26iFW7eerX2q5yi1DIH+rRNo6rfWAvpPJbSNVHCMdy8ciu1t8Xz+GhcFarTDoAnmXN2AUxZ31ZMr5bbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905513; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BH6ijxtIcNk/e7/c82XugD8aa2XJfkcU8x8DBM9D4cROXFQNQEKciFrYWs8L0Hy+pgi+8n44Wjg0oGlZB61E4lnUdeZKu+cpMSAN8ktOjVsYSu5ApxYe78QNEYnhbn2Bm88vFajTD5SCHn1+7roqIbV1fEUKvgoSs8ecAcYGCug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rZzuz7jH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZzuz7jH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rZzuz7jHun7P4tfZPxudTgUUkA
	IxPPWipc3OA+6xMZPsa215VCVOlTyvCpvUPWj1CxiVvlMQw7ox6dn75dLy6Fky1oxLXtvdQ7iv0BO
	K9ZcX18v6i2J/yRJn8L4w0VboTXlN56qUG0xiwnA3BBgS1Go19rhj7xJ2GTXJZgtqQYuDdJXaFdRU
	FwNQnoJYLYevbEmE0N9khGC5xPWzDTyLFRGftRJ1BXS224qMbzYb+jggiusQdcolUWhKOMgQHZIbY
	NDT9SYHr5sim+0Z6F8ZjDaOrK9qPB1feA8/Fg4ixn7JYyF/kygL4VgK5SdX2ba5fRDEug6EnvxD3Z
	c7osO+0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGl5-00000008MBK-2muz;
	Fri, 07 Feb 2025 05:18:31 +0000
Date: Thu, 6 Feb 2025 21:18:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/27] xfs_db: make fsmap query the realtime reverse
 mapping tree
Message-ID: <Z6WXp3W-ydft59ZL@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088249.2741033.5588270076246724853.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088249.2741033.5588270076246724853.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
