Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B35471D0B;
	Wed,  7 Oct 2026 13:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378435; cv=none; b=l5KDQUe9/E0nHkkOzpXkPs91esPpdjVp0qlRb2SnCFG8EaIOcZmzIccnIh5icJEEYEeFJa9ONWnN6knIUifndFicUE57KvynEk78g63jT2qLn1U0CV52zodd7G8RDAURmHoZN25BzszEU3bVs7/ukRMkhi/gnSHw4FODFrSJnag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378435; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMDuElLVQsPun+4AXPVXt0+nWzlHiC4fBSjhZ2TULR4a00WQyyLk+EDy2xzQv7DV5OwJrvODpt4YnGiovAloBMxE0rLDZEvvfbv4wZ3kImD4LnecrBkDfHBPZgFUBFU7ZicYt3qw4Fc96BEj0LkylFhCx4DoHWWVPQ3IOBlL9f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MeRJrQl5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MeRJrQl5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MeRJrQl54aanmieaMF0AREZZ06
	CmUrfgM3VsVlWo+0U759mnDM0g/5iT5zWUNxPe4sGU0lolms8M84ymTj3vJB+L3189Sv5RvMWsYOC
	ThuchyUB8L3wMeku7BwLlrtcDOyFRQsw3UOJB0pU/Y51OA8wfxzF3gRLWEGb33E4RPEs1zXPiWU0j
	ZPqvYKPNpzat9p0Ng8FHCjLwbtPlaBR3TfsWhAWSfw0XQPONWIZeZhvIqR5L3DCD4I9f8s+aO4VXW
	a6mi4jH+c4QcD7IPuuTsB7Q5rCj8volxQSQmthHwSqfazMKD1jWx2M379/Sgnti0RxHtDQ9c69uzz
	/sZspxWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERMR-00000002VQt-0tOV;
	Wed, 07 Oct 2026 13:07:07 +0000
Date: Wed, 7 Oct 2026 06:07:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: always forget cached ACLs if the attr fork
 swap succeeds
Message-ID: <asZD-9A-u701lwpl@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965267.614350.7711860069277357124.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965267.614350.7711860069277357124.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
