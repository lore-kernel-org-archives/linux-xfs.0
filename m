Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38652D5936;
	Wed, 21 Jan 2026 06:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768978005; cv=none; b=Q+e7B4J8hlnA/vKV+gKstYa5qnwOl2LzKGBedUnW22oW6BII+tYhDAtE90D0aaE5y2cvZg+AxVoR7fjTgBEADUz4HqNFdXcbxosBKwArGefUduHKDOMr7I2rF/5OGzRcLA+N9TkhQii9CffRlvXshrH3wJE5/Np2MAfflZAzvcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768978005; c=relaxed/simple;
	bh=aA2jmLoOvqU3qLGnJU7DrGdRorUGFczckmNf6FTN5xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgM04X/cl5ymM4MYsdBAGEXKUOIhopg3gZZgZ0/eHi+QaFzm/oJtUXzeMO2z5jV4rBR4x9bzAAWXISFp6bdH41duOnum0Q9NCztrwXl1XQ+ZzmKAPYcjY6ETHqSa/qwKU//Uf63MCKGFqpunVb3O7Ji7MOEXbXy5MHSl44twDDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yhGeDWXV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yhGeDWXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CnhDpIsWKW5XYhbfn+aRQ5ZRT1AjiuyxQAPrkdLFV9E=; b=yhGeDWXVKZxOnRmXco4laRWQ2E
	p7vFyrH4BKmzdGxZq5ziT8sz0G+XZiJs/Z2tqaiENi84Dn7jZaOiXpW0FCjqDBefOVMBYA9NwiUBt
	/QR5xy9cNjlLZYu/ud7VBY8jcd8L1iVq5/WZ6g+DU1HXwDX6Dcr6TncVUzAi9FwgOiCFTerln6jTY
	RUPfdP0N+qNQxSv3z0JO/RNzZMWnHFEtS4+ZnCTQFAFgV6pJR/E6QCQHF0GxHRFG/j06YoR4qDZ3r
	HhndSEVyNWKhbijSY4wAVrXY61CseFRgwXBydAEpmf8CTAc4xK47QXdSilfC+1Xy8N4PooMHkGMUa
	CZ5cSlYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRzH-00000004xtJ-20g2;
	Wed, 21 Jan 2026 06:46:43 +0000
Date: Tue, 20 Jan 2026 22:46:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/614: fix test for parent pointers
Message-ID: <aXB2U3_bHQou4e64@infradead.org>
References: <20260121012700.GF15541@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121012700.GF15541@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 05:27:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Almost a decade ago, the initial rmap/reflink patches were merged with
> hugely overestimated log space reservations.  Although we adjusted the
> actual runtime reservations a few years ago, we left the minimum log
> size calculations in place to avoid compatibility problems between newer
> mkfs and older kernels.
> 
> With the introduction of parent pointers, we can finally use the more
> accurate reservations for minlog computations and mkfs can format
> smaller logs as a result.  This causes the output of this test to
> change, though it wasn't needed until parent pointers were enabled by
> default.

Yeah, this has been failing for me for a while and I've been wanting
to look into it, I'm glad I don't have to :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
