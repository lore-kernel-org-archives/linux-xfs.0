Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9D1A5B9E;
	Tue,  7 Jul 2026 06:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405362; cv=none; b=F2O5LGW1atI19iOFrphaFmUWLIlWoIIMfm7p/1inQMfleR1G/D8kagjahCAVZbCxh6UyHeN4u+4x/UtDa0bj8FaOwqNRZ4C6CuNn1sWn3/0HVd1ddZ5omhWW9QfoNouvoWFTxaAWo9FBhJFUrgUkV4vyPppCM4WVEMbxwCiO/zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405362; c=relaxed/simple;
	bh=Yzg4aBlbECE8VfBnkYY8UUb9ZY4/YQBi8Xtp2KomfiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1ppaRs5xHP7+QZ6lEcp6vwoBh+1V4EKXKeT29ZB99t5n+3sA50ORsF9Qk0L4QEf1gNoUJNzwcXSnFvfIqV7hwR1n2rOHDFpEg8ONyj2AsSd+hqGbOh4pgAmTt9xZSUZN2mT85js8mh7ceV4EsLIFbT5E+Qti1QiXdFDWQooIMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=009saE9w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="009saE9w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=4fdRQ940ITSfdxaImPyI+kZnUXdvI5OwT6MhqFhki8Q=; b=009saE9wpY/exxAAfsqMTyCdxv
	X/cb8PjP3ymCT8/GOpLOt3iy4hccFZDXgEWHnezkm8fuLKWINsqt6Vw2lEz0R4cMkjm8Dq4SkSnt3
	qTDRjAWPeV3QLedCumtuvoWzTC4aFifS+qm61kirjk9bmw3UTkna0EcPhB9VY/DryAud2koItS3Rz
	p0mn2R2g+L8PhYJK6FKitrL6XOWnHIun1mxMlHQsj93ROn1H47j4bNEfHLxEJTWCsti7ZtglEF5xY
	d6LiTohoLWgBb4q6jUWFeGDYo1jqy+OYw/suvehQP20ipVpbLNR56rgKnACIivNvvqFkXpC3LVaRP
	IKyE2zSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgzCY-0000000ECcs-0ofk;
	Tue, 07 Jul 2026 06:22:38 +0000
Date: Mon, 6 Jul 2026 23:22:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: hch@infradead.org, ritesh.list@gmail.com, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, david@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, stable@vger.kernel.org, vbabka@kernel.org,
	vbabka@suse.com, willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <akybLlAsw7Yv1Xmb@infradead.org>
References: <ajvc7fSDngyx0X5j@infradead.org>
 <20260625091039.24501-1-dipiets@amazon.it>
 <aj0bDijqj1-Bjxq1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aj0bDijqj1-Bjxq1@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 25, 2026 at 05:11:58AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 09:10:37AM +0000, Salvatore Dipietro wrote:
> > Yes — all the patches in the result table are shared within this thread:
> > 
> > v1 (original, iomap caller): The original PATCH 1/1 in this series
> > Ritesh's suggestion (mm/filemap.c): Shared in Ritesh's reply on May 3rd [1]
> > Matthew's suggestion (mm/filemap.c): Shared in Matthew's reply on April 4th [2]
> > kcompactd background (mm/page_alloc.c): Shared in my reply on May 6th [3]
> 
> The page_alloc.c change definitively seems like the right thing to do from
> the high-level POV.  It would also be nice to find a way to centralize
> the logic for which flags to set in a central place as we have quite a
> few other places that want to allocate large folios optimistically.

Can you submit a formal patch for this?  I.e. proper commit log,
fixes tag, separate thread, etc.

