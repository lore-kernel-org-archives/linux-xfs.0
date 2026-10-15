Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4F3F4DF3
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079598; cv=none; b=Qq8kSU3RYUSX9rsfw6RKs4swL/D1FlzryMSDjr6b0oqTZdU+U0G0/n5oTh5DHiJeEnNR2vatjXzo+udiMRjqzaUfsRkpxwcFYCuDHY+/+syWruhASW8FKKfAA3Y8iP0rCz817RAc7Um05CuV7Ffep2z1FJFI9FB+8NJ+DedR5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079598; c=relaxed/simple;
	bh=aTr0HLSxbsMgRFnIlSeHWUOzJIOXgE9OVHXMYWGX7Sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjoimxkSoTZ1+eqQy1vshpdXsyIpAExFGB8yPElecaQEydB33tM5XjclH5IACN/UPqyfUt7iuY4nCh35wt2JCYkAFl2dxqgvddCFkCKqY90oxOGfkc90JOl/DoF4dML8I0uPgO9SnI55bLaDvxqm2NPFW0D7EQkEZPdWbF+j7gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hOhIJ3sR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hOhIJ3sR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aTr0HLSxbsMgRFnIlSeHWUOzJIOXgE9OVHXMYWGX7Sg=; b=hOhIJ3sRtY52UnYEhifPnwmUjl
	Sba4voETwbKg5TX+Q5g/vT8JX+AZ9hF6B+u6UPZJ4bde/2Ltfq4xiGxRo3MFFm+mruERJx1O28SnB
	9Bih7CrvdYwYp5Qj8H4OfENatKQVqH1UbjWWqzdksapkNdrPysZz5IF2dcrHAuNCAUH4Oa9cr6tBU
	QIoB8fNflGtiAgIy5rSEfoWZO5tGDqE3dP3a6YqzcNnUNKY6wdSXBKtyy2324GIdxWtkwaYpl5bgj
	UaupsNgH/PMFq//7rb4e1lmivVfklPbu6uXMCXPdsN3SaL/6YsuV6Rhg/jANFr9YJty3z0BVG4MbV
	HyB5Nq5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHMqA-00000000S69-0LNj;
	Thu, 15 Oct 2026 14:53:54 +0000
Date: Thu, 15 Oct 2026 07:53:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix compilation errors
Message-ID: <atDpAkYMtqKPQlb0@infradead.org>
References: <20261014174442.GK2705364@frogsfrogsfrogs>
 <as_IydSHaWCYgnLJ@infradead.org>
 <20261014184212.GE1615495@frogsfrogsfrogs>
 <atBrJO9owC7yXsRb@infradead.org>
 <20261015144302.GO2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015144302.GO2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 15, 2026 at 07:43:02AM -0700, Darrick J. Wong wrote:
> Well if you really want I'll share my old debug patch that tries to
> enable as much of the kernel's W=3e as one can do sanely.

I'd rather go for roughly the same level as a normal kernel build :)

