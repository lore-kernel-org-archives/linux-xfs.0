Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F071EAC2
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IqssdTEV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=QIxAoRZwQ90y/AgQjAi+N9Sdq849GeU332piJCP6SYw=; b=IqssdTEVoXlK7v9bVto3WqvjIm
	Q282MEwuV6wlZebbTko2fPVwNYp96nGjM/Z7obSkt1ScOyIXezPJi2fAG5fVtDrWyIRMUoMSxWy0d
	BQaP9gd7N/9rUXkfo/kx+VDKJGPOcz0L1xYX/ES+aKquXefjB71zrUkYs+O9N2qR7za5C2/vryEYF
	q0XKS2aTZ3gtqrn1sEX9MbYp7Orylob0eM25ksj3thSM4RpsE+VfRCIOzGHp49fa8cmI0elxJdjq4
	6LzH/ijl8j94lWZyQzvWDBlQEOXoigfLbFkevzPUVOLDzcp5EahW54RsnONykdQN8TofWugN8vN9m
	lYNe0lhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcrF-007hkb-2q;
	Tue, 02 Jan 2024 11:22:53 +0000
Date: Tue, 2 Jan 2024 03:22:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: implement live inode scan for scrub
Message-ID: <ZZPyDXHtty9hTqGH@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826539.1747630.1668252376408967257.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170404826539.1747630.1668252376408967257.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	trace_xchk_iscan_iget(iscan, error);
> +
> +	if (error == -ENOENT || error == -EAGAIN) {
> +		/*¬

This has a weird character on the opening comment line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
