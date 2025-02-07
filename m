Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FB2A1D8
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903711; cv=none; b=NC2k75veYmudkDfP/r3yJktfllAxRP2VlgNcEm+qiLIioOo2TziDFAbU6wkpa5wunHweEhuFdtMyn+x4LFh9T8cfKRpOrHZ6xVQ7CcnwVoJnryp6aCMhuxB6hnNRFD0YQ0+pYfnzZ9KD3G7nztAP5KveE4HpXueca16DNjjRTZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903711; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCnQ60XodaBzUuoOIXI/DkRW4CcUk5pGpOvM6dBUA4O6NQ5evwmhi7a32BZHdNkFmrSgLOSsvuBLKTCrPOUlqkJmZmv+9f/xzVb+usuLq1WgqzVe3VwnZooKMXmsMbrPMm1Y1BIwsymyJVLAETx2nx3u+nDMj5CZGHvK+WVE25I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zShtBjVg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zShtBjVg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zShtBjVgG6PVenewoHE56n0xMf
	7JzT2XqqopS4i7LDH4q1Pe1X4UWSKb9QhCkIXOC2EXzl6HiStg8uQOYOkZx0KPWcVgA1ZhKxW+Fze
	KuSbAU0j9C4AmonEOGooBtI5hkdHjF977DlWWiTMKsoIjoo5CfK/6moTh35POKD/QBdpB5OjCmYqp
	R0CGSX5lUGcOcBd8Z0GnI8RGFYAMMuqUZXdUcCRtG3O/zNaUP0xZFmbDLb32QBa6M1do4Mqa2zziT
	FNWfdYOaNo7ReSr0kv9NhkOozJfwEab6iAs4gQ29CoZlRVxOnGx7P+PjvbCmUQtVrfKnd+If+9WVK
	MIWDajZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGI1-00000008Jlk-28wS;
	Fri, 07 Feb 2025 04:48:29 +0000
Date: Thu, 6 Feb 2025 20:48:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs_scrub: try harder to fill the bulkstat array
 with bulkstat()
Message-ID: <Z6WQnU2Vn9W22B8c@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086317.2738568.6808179914591920294.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086317.2738568.6808179914591920294.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

