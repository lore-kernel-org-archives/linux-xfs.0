Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D034B40C;
	Tue, 10 Mar 2026 06:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125270; cv=none; b=CQcP961qWT75AuPVhA5T31lgxYjF0kkg1Iif8dOxQCuuh8vByUGdQ6y/NomeCwis84MB6v5wkyouPSSOfmqUDp40N5nuMwgickurxjqASwdRp0hQOon6XYkPXSh2neuQV7XqSn4ep+1EWWx/wm1Pf95X70bVtihJ6RaCnLhWRWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125270; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABNUTk653EJTNdNyJibz/zhCWEhOllqEvVnp8tKblC74qMXGl27cPZFBVaFauYWLmlvl0EASRt5ifnDqToFisQm+yRF93GVjPX0B2+TgX81ruuC72l8lOqJxj4tYH4NaX/AAEs71CIXUQ+TxDhvZzo2oo8o6ncHf84ymKev0FEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4n3zeO8a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4n3zeO8a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4n3zeO8a6iTHFsOqrOYn1rP4xJ
	1wmzn2ZIx2B5Tq6qMscYpTWHB2Zpoplg7JmfvTkiRyP2twbPVBmAL0rRfsuzsGcpvPShQEr8QYpj3
	qdAKgKXc4c2ARBtsLdzkDUQ0j06Uy4o5BhE6vin0QLt+skaYcB+zmpPRAARic3f87JwBn8tJaBZ+J
	sO2cZ50XeOBVzsFlM142WE31OW9Dg+tbLjF5TLBxPOsaBkvBm+A45ippxZTQmhMGg6iyzZSBX9wDy
	bAKclxubODqu8qjjT9hAiS+ghT1JK00DjeaLOTjMmkAmecLZQZByxeoBWQ4KiXhMdyPbFLPV5kM24
	ZcmTDLDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzqsf-00000008o5P-1U93;
	Tue, 10 Mar 2026 06:47:49 +0000
Date: Mon, 9 Mar 2026 23:47:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/8] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aa--lSrERZNDKc6s@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309134506.167663-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

