Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115845;
	b=uadCDllns29LiAKEHpcaC0J6xQiQuR00xgwQ57xb7wmbXZS2IheTZJsN/p3W+llZ5mEB
	 xkM4bX+GKEDJcAOnubjFn6jr9dQBQ09TFTtmdh1AON8cBSKl06SNeFlu23IhKeaz0zVtQ
	 +2BfQLn8k7gVwmpVe7wAPHskEJE/pBlsIF6V3U43kBIwTTPWZ5B4CplHLLa2TZWJdikEj
	 SEJBL4mt793iZ9ET+dz3xTuvC5izD34KBRfTi0DKnYvKJvCZ3M5lWYLoNdpzPrHxiivOw
	 0Dgfr6lMDjvJz8ZGPo1s91BB/ojIwS3hnV7SQHc0EDorgwleuyCoRBTeTxp42uLDSLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115845;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=r6NvXfTmHLLs7SbJNLllPk6BEnFoi7Z/GGWKbJAxbcuop5c4ZE/yq6jXVWQtDnvrFlZ2
	 QryjM7HRscuE6M83BjH3/MUyYZ6jGmnjlkpWit9c2/sMjUYvlLsu+EQbZZfbK9HnsR5sI
	 d91FxLQYWgGqn/gYGTG2hpFxsG9GIbdyuiqMldyiLgd/ahmRofxndNy1BxngkYyJhXQAN
	 5Gnkha3rIw/yFs4bdMJBddMC1Bx1kFd7qrW5NjyvZ1uodbyIDcCBieKG9uBhW1dqaCvZd
	 42iF93GVF0p8OFuRcp/OwTEgUIRhS5MtT9aeshdnOCy54xNgCz7iGbsiVwBgu7W5wxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=UcOx+sHO;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660D606A31A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B660D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=UcOx+sHO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UcOx+sHObNtFMCaKO7Upzkal/i
	GAu4Dr5PzRnEh8bBAcwO1++LDSc7BHkhhgQ8vsO5iVSnRJk+4sP7Ej9OsTSjaDTkJQCSJA2dbyfwW
	jTptXrEQq+wD1tFG1jot93oeQqvQ2G8semzkTI13zTxwZmqn9L+QaImezOgPln2V/wEeIVKBujIbU
	9lfjX9c1K/IXqVPYM3BQFZJkL+ENGa5uNmLAIpCILolM16v6/cmwYTJwwVwNzfSiKw9qbksOkscUd
	1PvijMvJ9/KAHda/LtLcBmuTGG+ftI1FbQCKtGAa6If/wchG+Y6+VxCC9vfzU/fE+anKTSTW0E7wJ
	Ju4ysnew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjLI-00000005GA5-1tPA;
	Tue, 27 Oct 2026 15:44:04 +0000
Date: Tue, 27 Oct 2026 08:44:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, Pavel Reichl <preichl@redhat.com>
Subject: Re: [PATCH] libxfs: remove stale xfs_trans_mod_sb() declaration
Message-ID: <auDGxNmO_XK3H0BA@infradead.org>
References: <20261021085921.56883-2-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021085921.56883-2-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

