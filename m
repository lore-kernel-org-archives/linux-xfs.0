Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19EE16EBE3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328796; cv=none; b=JO62VkNcNoQtxAjxxa1u/1wlPdNCNBw/e/e84cKl7y8HU7Jz4EtfEz2rMAp2GmS5gmgbmkPff6xZ0pOFDivsbGqKCLf+yEzuN1CtxosmhBqXLifsxtdnc9y4N6wNurkQutl3s6AnIMb2ppJhjADPrbk67m4NoxJlifmoGwcYs4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328796; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tzF5q2wGt5hBLalpGgGkRTYpBAGkmlDWpNpKMNZvKX8ApTf3NMhS/MCr7xgaoUYe1sZn9IIaAhwtYjN1q+mnE1j7feJe31iJqtsZTOJS9EQ8aXa68RI94W+I/eGGP8xXcCT05xRB0LglZaNJikePhYBv80wu0dQsRpuic8zOF10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GUBClZ+0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GUBClZ+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GUBClZ+0xDDxYwKOtaJrySQwge
	vFIHUdwEKXzfUN5cBOnIXfRw49doXbOwz+FBb3wS1Y1L0bm6h7csgfS1ke2xjObkup4fau5O1E9Vx
	bWmCRZe4wvDOmvTeWKGjsr+3frKC06Zi9TQ+lYGmGfGuCwBSuF5dyFun4kBGYlxmOiVORQxN5IOg6
	MwIbSiGRvQoLFcLJacBm1moqHAnkvskuTKXRphKMTc9DK5NBSvZ07fVWKthKLOb6kePV8Oa2Mi/QJ
	7tjkOnXRxY8P314iWumLNY8ndo0qyVISSWMAh+eh9LqlH79q6xKlHQYP9uVDY0lw6MHS/N6GQOMdF
	MB8RMM3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rskwK-00000007ayr-07Ln;
	Fri, 05 Apr 2024 14:53:12 +0000
Date: Fri, 5 Apr 2024 07:53:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: pass xfs_buf lookup flags to xfs_*read_agi
Message-ID: <ZhAQVx3bUmYTR7Sh@infradead.org>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
 <171212150618.1535150.1160220960086130932.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212150618.1535150.1160220960086130932.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
