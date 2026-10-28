Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200955;
	b=i9rcfO1+oWIcdAB5Nvug42SIjcplE9NWN70vQV9MKisVzD4cQO5cgAa/LvTFjcSwgTMC
	 1xXoqDzM0unYG415d462m6gBUGGyso0RWsuUoqtuELOvzSZ4CC3x5zLP86rzaiMphqUCj
	 RuOLA+l9gQggTYjL78c/XobRGZmQVQyYWPs8rJuBMcBWgFnw3fCsFGUbWXz0pmTJFSV9i
	 ltw3rqmv+Kwws5oLk0emT15ehsakQTE27MKR6UMelFOXgJpM0jpBpk2SWWHszSgUObaS6
	 1tKSQ7RCX0JICdP+l29TRFgd+Tdgtl+PL8cmfpy9O9B5Pb2hYYM3KHQt+jpxfDhYShQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200955;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=V93ADw/8PTr/FJI7of77M67jS1b2YmOqHwffaUpxxmGL6/Os8+G/bQuO7WoTQSGTLfAx
	 qFfmVzX1og56NobKf0KvhQjmiqTJIOH3lBinsZe1L8sHcEx8sxlkiFYASTDP70hbSxGTY
	 1RbvaOaFjnVzzuN7BqyUCgjFlG/Iwh8gkDqZsDi0rSRchQCyFhcmmySjm6RhGtXJQbQZp
	 AeXhTO5LOT7RGVeCMCmxbYutdp+Y80a31Jk+oCkC56EugKiCGw7bHRyeB4Uqzc6OmGXRD
	 KqHZ5/SFB0n0hoaO0/tjuPtFsGmYDNDqOkTz989yHg6BsAKjKJ/AYUlTJEM1EhU7VfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA36606C03A;
	Wed, 28 Oct 2026 15:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AA36606C03A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z/xJAEAZPKWiWSXxfI45Sn+rbm
	7UVd+zV4J6PYJb1wqYwjN5ggLm/ALKN7RJDo6TU9lHWilQ7cMFIRF/IuOlvzGaP/0rPsk0fG4DP9M
	BFYAEVh1jnEEAGqSURj7gBgD1e3AKUgO/jWJFl3dp640kssuNjBC4M0z3ZIaY6BmLNQt4LghJnheY
	HSFKinh1T8tq6yUQ3RDe/30ZuM7YwiSabnGeFBJY1dxzrO1Sqec1/iekDCPUtgh033B0ZaZno2lw/
	u78/cWP9m0VICUU1xRCv/mE7QXw7dvLQEVQwU8iUAOy3dkWTq5Diz9GtJXRMp0+Zkm0hs6gqOXNtF
	IyAy+Snw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5Tw-00000007L8A-38Eh;
	Wed, 28 Oct 2026 15:22:28 +0000
Date: Wed, 28 Oct 2026 08:22:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: =?iso-8859-1?Q?Adri=E1n_Garc=EDa?= Casado <adriangarciacasado42@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: add __printf attribute to
 xfs_buf_alert_ratelimited()
Message-ID: <auITNMC1N5YyvwjT@infradead.org>
References: <20261020195628.248878-1-adriangarciacasado42@gmail.com>
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
In-Reply-To: <20261020195628.248878-1-adriangarciacasado42@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

