Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vmPcdxKh"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E538170B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vmPcdxKhRxDI/XHlgXLrfFXVPO
	k6FzXMhxftGPD4gxhP8AWIqnrQXyIlhw4/PDrw097UBxDysUcobQxqrVG0wl9X4TaOvOCdIgoREAA
	EK/rr1kpmW17T2gt+3/zHfupt0DXMMChr4b3InpHCnVzzMvzhDVQAgcj71OCRV48iYS7J1bwEbnYT
	lQvqFnhmkSk3mONuASpvYsAtZ3NhOLwiEadpj/Q/Nsb/fJaf0BMYcTIFFy1bd5DcRPyYqbnNMr5yF
	BpaoeZGI3FIRDTXhqTRhKGXrbjvufuyEg2DdU5WR8imq3kQO97Eq1H2PkmYSuvqqCN2PLXDYSiXh1
	6TMsxV3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6laB-008dNa-0q;
	Sat, 25 Nov 2023 05:51:59 +0000
Date: Fri, 24 Nov 2023 21:51:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: move btree bulkload record initialization to
 ->get_record implementations
Message-ID: <ZWGLf0cedDVxm64t@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926625.2770816.4294476046504213562.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926625.2770816.4294476046504213562.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
