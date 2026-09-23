Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8448F23D2A1
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 04:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790138373; cv=none; b=HEpA2IfvJ0yCKZ69ccN91ELwGr75D1OrashbqFd5M6jZZhmkZUljOHwLzXoCK/epU8vZMt1zXFsabbNRHd+jOBTea0O4+0hLOn3Z0UkEAqhZ8hPAV+WjQWZZtK1Oe43mIGOy74DFyO6SdOQb16MTyR78z6pgXTB/0sAMaS5JLg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790138373; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8CyLT3jCLWE3VKcfu5o78XH3pAT7vDM36EyrnjGxFzGelWXhzReu9rfmMRZZoOMeHbHLyetcq0rRW+0uXiwVLhAvRdVx2XzqhYS0+LrrMinA65oKddKzJ0w3tfbH0d6pLUYO852OcExJeGkcsiZsSRo62JLpv9p8GG2RGinW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XlO23Liy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XlO23Liy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XlO23LiyLNFp6RE6ebGuqQOt7q
	Jt+18R2Uily59lqfNHrn7ac7S0EQA3dUH8LWha7KuELsk0GpleMqM6Le5tsvmf6Cx3zGj02YvKkl8
	a1v8AagLXlwKjB5oGyZasMbgfMEdCk5puFbirwHNZH7nzxpFozYBdn39EQ4xKR8mnssRmf8MZs7PL
	qy1HH91QIGxqXKEzN71b+c9R9OJ78R8OawHV6SSzpMC/8VTi5i4gYkCBSn57tpQXrZfzQPeFto21r
	EHStMxQflC3x3jPcFrHl6/X5taIAsZchy2fwuh+2Ok0DYlEhN2bxaKLMiVzT3JiXXRJ9RQNnnz5fS
	P9XFgKKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9ElW-000000077e5-0Hti;
	Wed, 23 Sep 2026 04:39:30 +0000
Date: Tue, 22 Sep 2026 21:39:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: share the AG rmap btree with the rt rmap btree
Message-ID: <arNYAohFjwh44ekZ@infradead.org>
References: <20260922231845.3266784-1-sandeen@redhat.com>
 <20260922231845.3266784-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922231845.3266784-2-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

