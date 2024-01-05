Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBC3538B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="khKQ3vP/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=khKQ3vP/K1qwPTG4J7jnP+VlUL
	1uzIR7U8nilTunhngBOLN/bZwIzMNyNc+O1RGyUhE/1dnDUJvZOHNf70Dzlbk883qN54TsUtQhTCD
	T7D6w/m5ETHalLNCXR4z/yZ+MkvvvHCFX+W6IRkWJO+8GXOESEJU58mx+/nwb5j9wgGODNyTkHuAh
	/p0OgLWuaKNGCdJO751k75jXrm+xGOlEOsmL6WemAw46SvQMsM93pdCpAbDRPL3zu4jUOVo+xBc6A
	0Uq2L1WiMTZmSPJS2GO5RFWxSsD+D0uFAoSJ+qcUnejl814SexcdOXRtz0oaQ4z1nRb+KXqp1WTJj
	b0YKxipA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcSF-00FxVe-0K;
	Fri, 05 Jan 2024 05:09:11 +0000
Date: Thu, 4 Jan 2024 21:09:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_scrub: try to repair space metadata before file
 metadata
Message-ID: <ZZeO9xlmfsCFHro0@infradead.org>
References: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
 <170405000278.1798235.5942937767888494780.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405000278.1798235.5942937767888494780.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
