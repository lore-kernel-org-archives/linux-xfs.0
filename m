Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C57122083
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 05:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752472686; cv=none; b=VbWCOaXSHCxQL+2u4dNcBm0RWLi9jzrTsZL1Pwq07BbDJrq3p/qlJRMz2x2twDoyGaWOfxEFqjQVronX0bI87Oat8f71W9JdM4wLRfpu5ogPZ9jUMQNmMiEpeyibMGk4fTzdPLyMvDlL5mButSnCSwP0dKKWhCYVC5DNwmlx2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752472686; c=relaxed/simple;
	bh=4/4+X4Z5aKLBuS0lQXSjnxJ++a8A/6vNHZ0Dx1FfTsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdeUjw8fV3tXNiRpXM8kRSnloCbEsTpPLoTEN2MmIGrjgJVwLakg17KQ5GVENUwSBThg18IYk7156sA8ixwZPf3Y6Zv1JDBOEROfWxRomavayHGMbvnjP/IiJkJbOemWYhSrh4zCiCYwIb9Y8s+Ir/QW0fmnKGNBm5W/WhphSXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hkntMo7O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hkntMo7O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pT/MT5FN3YmzQaCGDd+lQ2wzTibCgtBStaYy8DwITic=; b=hkntMo7OYu4d81GFRr6/hUcaGd
	yGfpRPviujtNi2Zpid39Ri9d3I4b/FeX4QH1XWYxGTa2yRYwP27KZGqY3qCvZxDXb1yelIjxCoWX+
	LsLvb8ca+iiEQJ0hVvRNYGRU1Ta41shOWadUKsXun1m06XH3NdBVfZvtl/Mj0BPhFHl1OM9lVooG4
	7vCSF7qNVcl8rWwUcHbeaQVlmI9SN1pa+SBK2MchSPy7Rirewgfp92n3WOaM5788G8vsVdbN+QKwW
	6WAj44r0D92qQxXs4ZPSz/KTWlvVIgJ11sSH835FNWT6VNzQ0gt6efVdPiIUddnjdnqWXbcgkrkNS
	wBgRwfBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubCCS-00000001GDr-1zoX;
	Mon, 14 Jul 2025 05:58:04 +0000
Date: Sun, 13 Jul 2025 22:58:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Priya PM <pmpriya@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Query: XFS reflink unique block measurement / snapshot accounting
Message-ID: <aHScbEVwQad_ryX5@infradead.org>
References: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jul 12, 2025 at 01:19:19PM +0530, Priya PM wrote:
> Hi,
> 
> I was using reflinks to create snapshots of an XFS filesystem;
> however, I’m looking for ways to determine the unique snapshot usage
> or perform snapshot accounting.

Can you explain what you are trying to measure?  How many blocks in a
given file are refcounted blocks with other users?  Or the difference
between i_blocks for all files combined vs actual space usage?

There isn't really such a thing as snapshot accouting in XFS.

