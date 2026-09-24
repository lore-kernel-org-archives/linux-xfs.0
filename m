Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138F440EBB1;
	Thu, 24 Sep 2026 05:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229077; cv=none; b=cn4wkt4rCCIyVyZ7h/xdS+uwQvsxMWrWgjHwvt/5bGyWCKmX0LvKdhwxqFKAFvoFuFtsHUMoeAb6JXE+fzDZAasSBwEH2/PG81NUSMhbYKQ3dIHwT6LfRloz8bszimh2nahwI0piRrmu/uBHILVjUP55p9jS1ErjVaCsBrnlDi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229077; c=relaxed/simple;
	bh=eH5Fn+FbfARHm357vBQ8aiDPR8ceCAoiu7E6zFNDO0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9Us0aYTGRErm+ngAP+jmX/pE9GelO9eazsJyCL3qJgNw/LXCQnTez0u/ZQgOBaycGd+uXXFG89wgt9qrnTPP9qNhq5NK33srMTFIxlX+lEDjOyynF5fcZdLUYkQ6MCM7MAiUicsqy1Qdv3Vbzn8iBXMJ2erISACAN5Af2sePUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mkhORSS0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mkhORSS0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I95q+yaqD9Vj0sa9JUQLpa2FY1V4KixFTjOu2Y1AncQ=; b=mkhORSS0ORnkF9qSPS/w5FfEcf
	OUv7yy8WckT2oHdYBCIRIvMjvOkHQn+XfPMWH76FQmPAEsNrV1W/zS1E/ejilTWpBKn7yLYr/SpPc
	IRI6jMSw3EMp93KiXVnHIUsixVXbN1VirS2sIhmeNbJS80Ubt58BmGCYr3f+lkK5qjv/YFfA9TLZo
	mKgTDmYDrXzhynRyqV5LIQjhlkdDI3y8/LDa+IsxAfrQW6TZPXi/iVc8agAXTD8dwfO0sQf4zJtv7
	ooh185ASS+i4z/K3dM/57Tlzq48i1wnDsPCeyMAahqtTymPnjYxS2mqQN55j522bwG9FEk1DrDNXx
	zhDiYsog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cMV-0000000A5Mu-2ExQ;
	Thu, 24 Sep 2026 05:51:15 +0000
Date: Wed, 23 Sep 2026 22:51:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: fix integer overflow problem when setting
 large free areas
Message-ID: <arS6U6GRYEQaSBIZ@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159671.1875436.8939376627577757057.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159671.1875436.8939376627577757057.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:02:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that the min_t comparison in xrep_rtbitmap_mark_free
> operates on a 64-bit bitmap word offset quantity and a 32-bit
> words-per-block ratio.  Unfortunately, I should have done the comparison
> with the (64-bit) xrep_wordoff_t type, but used the 32-bit word count
> type.  Oops.

I don't think we'll see rtbitmaps beyond 32-bits in our lifetimes, but
the fix still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
