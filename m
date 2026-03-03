Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA745453495;
	Tue,  3 Mar 2026 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548870; cv=none; b=HuhOw7wgtIIh/RAthionVgYcfpQCH8isWRTZ+xtReC0DFUKxV/5ekSwKriMCnEm5nvF02d4QIm70cLynz3w/MzsgjWRSkRRG7+7yE1vifN5ZMZCgLV8isi8Au2RdKLSkTFOYyb8iL7cMbjrumtADjqjcgq69qADS8CM1hUDdFQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548870; c=relaxed/simple;
	bh=qAkVyjwYbzJi5kQakW5oNkK06/7PrCWOE0eDs0ho6qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aey7nnyU/1P24PoTRM5uMvHg79HGN66PEZXguT1PjQV1zNANLdlIY+wbYcH9HqmhXjSAWI7tgesIXcAghnZZ2fEnh2t49xU9LXB3pK1zJ3CzkOejGYykWmWx4WTfZ/rPH2LZt5DVU1SZJrpedpRKdd0lJ3NgYCiPPsz/gvkmHCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0IdsT7Uh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0IdsT7Uh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8NeFCwENkAmWhC/67ws8K4K4BtkENvOw1mq6ZDstmPg=; b=0IdsT7UhVUq8ezKUad9pbMkAu6
	FfhzMJlr1CinPFUNHLItSAqZ4fCgm6f+7mLWBBSieNQVkcCg3HqknCpZurNMq0OwKRq7ymSMlNaX+
	mi1jXujWbvWWTjEfM02R8vbg/H52xFjLrVWaSWULR+MjCNNENtofo+tUKsYK1mYCn2XQ7e7QgWer2
	jj/8aZrHqGByGbDzoB2MTnTfD5CigjSLd8SmRnHdp3Tti9soIOyoiHgn0l/MZLhbi/j1HeBqsweHn
	Z0yBLu2H/L2s2MnfTwpaGaSrVbBhFwTKMhsGS/pBfprnZRDrZ3b9U5/wlWQBHIH4cSaUnV6Vwcb3b
	B+ewfXXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQvr-0000000FLZU-0tns;
	Tue, 03 Mar 2026 14:41:07 +0000
Date: Tue, 3 Mar 2026 06:41:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: hongao <hongao@uniontech.com>
Cc: cem@kernel.org, djwong@kernel.org, sandeen@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove redundant NULL check after __GFP_NOFAIL
Message-ID: <aabzA-Wd8OECZFHD@infradead.org>
References: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 11:33:32AM +0800, hongao wrote:
> Remove redundant NULL check after kzalloc() with GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL.

Looks good.  Might also be worth to switching to kcalloc while you're at
it.

