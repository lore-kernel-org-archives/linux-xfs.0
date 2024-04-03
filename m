Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4126F6AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712119189; cv=none; b=nwRKLpjBcktyWFCAK9dIRk3rGAKqhsHEM2LQxv0R4X3RNnRFlwnlue0rw/mQ0J76h1kvliwhKZvQneayBhSPGSm2M4KPzD2hllD9RgUe7MITCVdHLwuZsRVI/LTeZSZPmlAIbf0az8gAo1NbxfpF33cjIvu2zzPJDQYNF2pg9rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712119189; c=relaxed/simple;
	bh=elv3Ino/pPCJt+FLThS3N7gWLCeqkgN7C5M2CNpuu7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwGyVVwxpypBGyiH5RNwIAZIg16A5CSb+6bmhLuRdFtS79HwOH8yMAfGprN5KQsWajpDqdtA5ZieF985d09l6RPOxqwWHrmblCU0stNPgO/a1V3JfMiuJ1xSCGs45IoK4QUXzEXKXiH/cCi0VtDV9S3+wq1FOrxBBcEfYkczc3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=axwN128o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="axwN128o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SyhvBb2DsVIZkbAnbm32oG+o84qxysJ1Tg88iZkm/PA=; b=axwN128oMjIOmx4PZ9niXeIfld
	QFqmHcMn23PDxM4mh11BdNqim9z1VDweeOeRI/bDRHLFcls2Ne49icdH50oJTBgKUJA+bSbVTxRYS
	zp3fofO0jDfzGLrNl+2FAbPF8vwQmgCO2biwC1+F1jdR0ZEorVP/+TS8Zss02iGUOLfC3JWYt5oHz
	fGf1oA6fUm2Da1phAzS/4VUf4NTczSQiRZD7HbnjMazwAnh8VX7/Kxzc8EzkBRktw6Llew+LId9qg
	AYCtntrp0rwP8ij9w1fVi5tl9HGKy8w/AE7FFO+29ePYCI05qWwRN5X0hQqcGjreSPnRwyVctLbbA
	0qZzMBzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsPb-0000000DygO-2Qsi;
	Wed, 03 Apr 2024 04:39:47 +0000
Date: Tue, 2 Apr 2024 21:39:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 1/4] xfs: use kvmalloc for xattr buffers
Message-ID: <Zgzdk8GhHXGJpN5o@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 08:38:16AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Pankaj Raghav reported that when filesystem block size is larger
> than page size, the xattr code can use kmalloc() for high order
> allocations. This triggers a useless warning in the allocator as it
> is a __GFP_NOFAIL allocation here:

Can we just get the warning fixed in the MM code?

