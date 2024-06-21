Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A4FEA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945652; cv=none; b=hQq3FchQKep/KeQ7WtyeSGhCFrpAh7qfzOhRGdzboelE76gqMEDmt9anJs+HEHzZQrD3XPQVssXk6E2Nug9OVPo21Z/DSUIdCLeX2KbSltaA+skOknM1w7tLMHwTE9GLVUBWkuFcwnZGYHCKHAf7aDX9I5cwPDwiuny7FM/EQmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945652; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuLr+OYOpiLvuuhzW1EXXrbvUlvH28Ayc6tulkpUQDWH1RqyKgd255CLjcgXQFoSkf/vMhY/awgKeK8M/XyMAIOW4g7OFWtL5Ml4jnBhkilBcWG5NJwaP5jo34V74SeQQwnmu9lPe3NPqbJoO8oQzZh263LSvhjp3OvNn+B1bMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KqoVczVh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KqoVczVh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KqoVczVhyqgR5nk1Z4IvrpUq2H
	tB5TepHXijwX5MOMTr11q4X7ffXBVJ8pLF1fZ1S9sZ6cmY0o4t1gAbY591sWwcpL0X6tg9aQ246iK
	NNjdTOmjiPS5teb4gYETGHyEwHz+svDHpZzydL6pHU7Tgbb2BBy+zr0JF0yOVqPvbX6e9uKcto1ZG
	hVKwua4kIqQVKvXGx3wbv6AIIGHQBu/Qbfg2KnuPXzFJBI+0b0u/rIuEzUi6KwR25GeJqAVzGSU4t
	RFmOvYRk9YPIxgNf5tylIOEFh78H4RHIvDw7oSg6ixde/177NvWTbyj7tfzW7Gt0Kc62reoaJS6oD
	nqqQ5NfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWHq-00000007gyN-3mC1;
	Fri, 21 Jun 2024 04:54:10 +0000
Date: Thu, 20 Jun 2024 21:54:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: reuse xfs_refcount_update_cancel_item
Message-ID: <ZnUHchkl7jLNa3Rs@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419892.3184748.5587189586405596401.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419892.3184748.5587189586405596401.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

