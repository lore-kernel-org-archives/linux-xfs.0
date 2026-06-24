Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9015D2DC350
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308564; cv=none; b=oSFX5W10E9F164KRwknMbV/+HZFe+IaQGXy16I/RIj266UStv8n0rCyn8ihdHPY4GUFxv1nr1AL4Q2I0gmS5IdnYWAGn0BBKdPFofL5liEHz/T2Goqee7ZOoF7D2kUa+GmCGqg3E+oCW99fD0hoWijwFnrG7m+iQWrUF+JFkxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308564; c=relaxed/simple;
	bh=qlidassdCUz/P75EBspwSD76H0FEobTEOJAA5kKC3Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hen9lEOjxdxyZmm5o47E122qtrH+oo4q/hLS1Jr2YqTCpPURqnN7c6hmQMNLRxNtKgV2xaPPF/14TuSKEMvXFxN48XSi9MbifKGfMbcfwbK9K+YaAHgYfDCBTQmqEQlmgim1OXdzLBhqRzG6DDJbZMSjESKTU/ffVL83H4lpLNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gTYCRz+4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gTYCRz+4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zYLh9AbbNm3hv683OJIkTAFm5beWnSMcgUp3WC0YiGc=; b=gTYCRz+4OKKkNPl3PgXcy7ri0r
	W1R8+YQjdJ40cU9N/AVjA+xEPCueO7nWZber9gdSq1Fx9szo5lcqURRv0ohB/r9bDfdC/f3M9NFX7
	j5dCNeacXXpDX/GAWl7F9BH2X638pztOFIwCaSiM+1DzFa5JqOkcS89IJTCVx6/3UVzwrm7L3pQaV
	0LBenLKW3mC8ZOZo+3T5meid5v34fLzJ1t6v6bE4kFtQ/g/tsfjyffB1qOtiq67Fa+k/Rs1ly/+4t
	Yk/twV266oG/hJx5ZZvLR4ITLfbbRG18jiEi8Toi+SGzsdD7YDCeQltyrhOCMjCNM25KVzfqIFmTM
	RON/3Q0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcNsH-00000007q6b-3djh;
	Wed, 24 Jun 2026 13:42:41 +0000
Date: Wed, 24 Jun 2026 06:42:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: caina <caina@uniontech.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2] xfs: clean up spelling and grammar errors in comments
Message-ID: <ajve0YCxD_u62phh@infradead.org>
References: <20260616020912.11409-1-caina@uniontech.com>
 <20260617055052.7271-1-caina@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617055052.7271-1-caina@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 17, 2026 at 01:50:52PM +0800, caina wrote:
>  /*
>   * Set up an in-memory buffer cache so that we can use the xfbtree.  Allocating
> - * a shmem file might take loks, so we cannot be in transaction context.  Park
> + * a shmem file might take looks, so we cannot be in transaction context.  Park

I think this should be locks, not looks.

