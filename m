Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201E168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807894; cv=none; b=qkCnfYYJc8ZJ8+01wscwKieXPdOWEOVPRfOiDlTTN6BqGrcplykZeBvhZKiyiznvmlx24ewOKduRDVUUXO3Qvg8bkyLJj+LPd6PgEsEFzefKZgPv+ICaLIY+VxDgXNNsOZc59jAOiAfUTUkKG03gNCvGNKFKjU7CRg/YuC4t75M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807894; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCMVIar9STM+4FyfGeFKMbZBIrMO8xQTKMSJLmw/B6iAU7CWXZIcVRNe65MUpntoU/Y/NFhzG0wktkaIr9lsAdMyXrgf6DyyjBUHLQd5D3220+ApDCpSH8Xu8puPlaoyBkDXxcJnSRE3BzkcoK4OpRP3YNb9/CsiE1YKXg2RRpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hn6OArD/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hn6OArD/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hn6OArD/Wxdd+AO/vK7o45K26d
	FCMvaitIcLV0g5BKmWsZwzhPXIxcvuDf0ZlK/v34bfhDITjIo9doqDRNQ8LKx4zd6fXiurdOvVPez
	eFEd9Zg0AMBtIXgBKrwMzcyNR0rTSudlYQrXICYWPUW8zCmQCnc+zvwPutrnYzuD7ZiR+zSGm1J0i
	J4kU4rXPxWr04ofM4wZu53VsPazZijUHiSSSrGRtWSConme3WWD9l+pI6Et806coXYBT/ziBC0RfE
	m+K+gk0ljvLGfCrXBju2DtReyydhdKgOOQkg2pJrK6q3ty6dG7Gjww9RsZkOv7mTUxLPF0U8Tyorm
	puSqi1SA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsdQ-0000000AGMB-28u9;
	Tue, 10 Dec 2024 05:18:12 +0000
Date: Mon, 9 Dec 2024 21:18:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/41] xfs_repair: pass private data pointer to
 scan_lbtree
Message-ID: <Z1fPFB7Ua8kdukEt@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748725.122992.1994741139588590565.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748725.122992.1994741139588590565.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

