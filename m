Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5BEFC1D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907794; cv=none; b=JccFUsao25/b0R4RMsugoUex6lDVoQLVz9B5xyyJ/ElTGt8dYVNOCJfLKetc4qpt96HhP4RMuH7u07guSWaVJWxte4XxzYRfELx2jT6od91242SnocZZxvI0mgNvtT7Z8FS7nnetKC3psq4TyoistXlBsejlLpx9WXGXUK+4lcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907794; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YlBV4vB94MG90FtP0tnLCFC2pXLfkjugybvym9bFS6y8QULxg5mY37e7NJLhNzSgFKwgjj9oecglQe01SJ29VPKVo5OuYLXd9irtGs5KpawV34FEIZzc1rk1Rns2rI9de7sGl/wekSwfMeBG4/AYfX8+Bid/fRC6qkUyWkkSv7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b/iC03He; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b/iC03He"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b/iC03HeKpNOa4xZWEolWQGaAK
	VfZ+/OVTKyT18L+FhUbY/Ur50bE5azyngnVKVN/GaQ48e7kM/VJzMJ2CFGhM41tdcpNi5BniiZs+h
	jXPzxTJHmvalz6EWrS9MZAXbdva8vK884pdO0YEqxgoX9XNYjaKfM6l1NQRfR1ObFxS5fICTMz0YD
	gvaxtOEjnwCkMP4Q0Olw8a23HypwZIvgmSUmkxbe3ur2sSgdyj62EDpBNg2pp6yT2l43y1ieR/OKx
	4mZv3QeQe3KriWNC7UyGuui2edzGm+MX0B9UIi3oszUvJ87AiU3kGIvnkX7vbfbnf5kif7dNbOetd
	af6fNh8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHLt-00000008R1R-0aTe;
	Fri, 07 Feb 2025 05:56:33 +0000
Date: Thu, 6 Feb 2025 21:56:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/27] xfs_repair: rebuild the bmap btree for realtime
 files
Message-ID: <Z6WgkXEVHW_N4SFk@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088448.2741033.9119599638346403244.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088448.2741033.9119599638346403244.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

