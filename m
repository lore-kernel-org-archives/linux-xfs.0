Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC9F145FEF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375577; cv=none; b=ENhwW5Givg1zcfj1NPkNQ2XGZMQq1OdHPOLCNO1NFXxkEqDOf6/zw7sMaYclHErBNieNEfSWXK99GaihSso0sl5cpopTotAn+DFgDopsyhf4EG2DH6KQkBD1rPAJXFeTECHUEdevFMYRfoJxiec/hWg/GgeVdNKFgR5WqDgyvOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375577; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2CbBOaGSb85SogIle/+l8IwSkAvm3VNLrLWC0JVT49+tcdNQ/gNdisy90AFaBEH+R5N3ll7Ao/XA7VS6zzp/HTZpj3mHj6psY1z/tivTSRQteDlLJZkROKIFTBWkAWxGaKNd8v41iSzL/J2sbaE+ATE4pjNN7dbSNBxd/tlOQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tEltlL3G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tEltlL3G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tEltlL3GrzwpqPj/2PAYmdonvr
	DLXlSPFK8SvHWy8N3HabjAjkia27XV6AMtVhLqFQFYrTjAWrT+iYVnX3GfHQg2/BGuCZvnYRLqivJ
	SC82saZT4dxrVTGNGPF9lv0LDCwLvnpWYQ3oxeArIwYRYrL8Vzy2jH4MPKUd5S0trjMQJSkroQP38
	cYcJniqu6Q/IuGhBAJ1yGQ8a029lUh0zSbal2yQhgRzJ+Qz+8nAu86nYX8ZLUTZPYkoh3/+ug4ZG4
	5epJ16iNqJGTceRsp8v1WtwWpmnE8TU0CleSvxn7QULRbzwvKwWCD2w7+GfZoiiA8vD4kTfn0FhfW
	kBshk8IQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYuZD-0000000GZ2O-3a3a;
	Tue, 30 Jul 2024 21:39:35 +0000
Date: Tue, 30 Jul 2024 14:39:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_db: add a command to list xattrs
Message-ID: <ZqldlwKM2USQH2ee@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940662.1543753.5012484575185747390.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940662.1543753.5012484575185747390.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
