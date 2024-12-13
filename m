Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28C31AF0BA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081394; cv=none; b=LcK1gLScLFgwD5hpXow/bZXXM2MPHFd7pdOb+Xp5jXjRUrnucFaURxCz6YEGIxrDlAdHPV3ZWXJsf+IcOk3Nvz5SnraBAOtNGBwv0tW1NXHXEYlILK+Dr01yLVkcjS6+KJMDo1oLPud11el55eZCMmXMjgP9ge+FNXBktvUu4Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081394; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGu7j9XL7sle0TiGsVSiI0XJNoW04XFENb1frooQ/KtcXrLnzF8rYpnEoyVrb7xXhHdv7O9CeYMhA1LPyaoAFiIVXYMxfd/j02/2/Pu2GwjFgkSNOmjYiQMKotzywp/71j+E7vVEzwmqndGzLmv/EhQzxTkv64g0EJ2sH3wUwGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZMOCxMed; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZMOCxMed"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZMOCxMedMWe5OM4yqGvQx+2QDg
	L4Lp2iUDONIavcBNVnv3zsMkldRpkU99p+++TZR1ms8szI4ndhCTY34NVtMODLepqAT3jbTg+6RNk
	U1a+HMWVjdyC1/7YcV/EVoTmCKka9xB+GfDSewylFdaGlc9d56Av/e2Xk1T79XOwrH2BknFBglRMm
	us7UhzATO8vhY3kFsa5yCKmDfeCzvOc5CX/3IF35+/8VI+Lzya9u8PJVTun4D1rZ3YbqC5RN/NPNB
	0Vomm3EOrcipv4BU7U0MOGFZU8SRWHa26trZ4wINd3yjtu9+iKVdok9sK0g9uvseIt51WSeT1XuHz
	QWjkuWqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1mi-00000003DMD-21rr;
	Fri, 13 Dec 2024 09:16:32 +0000
Date: Fri, 13 Dec 2024 01:16:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/43] xfs: apply rt extent alignment constraints to CoW
 extsize hint
Message-ID: <Z1v7cKWb0fXv7aLx@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124978.1182620.6573338923031492014.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124978.1182620.6573338923031492014.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

