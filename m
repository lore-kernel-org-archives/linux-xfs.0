Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058341F4183
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010589; cv=none; b=Jp/l3J/qBRQ4ZfqNG1bEPOJbll3gzTdcF2eVs3/o2SpT9sAc97tOp2PGfEZLqSM9cwzkicvRuAm7ATOTbAkE5eeVk+9JkNn9t+EW9ZAlMpWG+5t1Yx8WHRLFNz0vSYZKlvsg0Hj1p6hbtmTFjJlC//w4wgm/8OubYvj/391w9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010589; c=relaxed/simple;
	bh=L6R6WBty1hBvRATTmdVsJ9ktaV/OTMZvn82iNnFQdco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A94Cd6c2uyV5kuSDWqVyLoyXZpn/oW/l1nz6kA4rQcANzixUuFuOrwxOq0CJoFDGAg4/GRzbEmcoBR39BGLFzHCzRzMIHntE3GkuZFn6QXQkRH1kmgsZQv1UQH26pqINtz5HhDO9Muk9NFGKXW6sPLyP39Ewekr4Ap/pbDwCfeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OozOFTWP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OozOFTWP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9BX7bb6YX3ah0snAmO3LMsLf7ixd1dnLhF73Ifcoya4=; b=OozOFTWP5a8p0dljrkg6Eq09ZJ
	c2oRoqzXNPlN8l4teI10UbHZAPi8lxeOFvgjzzeMs8mBxvXMiqyq9V5idCi6JUfOuJ6ir3E6BrGnv
	DUz+8aY9Y3Q9O0LlefgYqv7IbenklAxQyXmp44as/bisWh/uen9JD/JfUw0sVDH/B33GoYsxgrJi8
	N2q9WyvkqlKMe65VSM1Q2l2kfvxwK9WrETMDypZHUu7tUHTVZwRfIF+rOiE7PKNdeOQpdcDMmtoHs
	wXyPTNNTjQsIWJOEJVNUD0OEHavH+qnmS/rym4eZRUewcpplT3RpLe21jhBW+OSUt285nscZfXBGE
	ugKqbGHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tp6Nv-000000010wM-0UFV;
	Mon, 03 Mar 2025 14:03:07 +0000
Date: Mon, 3 Mar 2025 06:03:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Slow deduplication
Message-ID: <Z8W2m8U9uniM8AAc@infradead.org>
References: <20250302084710.3g5ipnj46xxhd33r@sesse.net>
 <Z8TPPX3g9rA5XND_@dread.disaster.area>
 <20250302214933.dkp743wxlo624aj7@sesse.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302214933.dkp743wxlo624aj7@sesse.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Mar 02, 2025 at 10:49:33PM +0100, Steinar H. Gunderson wrote:
> On Mon, Mar 03, 2025 at 08:35:57AM +1100, Dave Chinner wrote:
> > This does comparison one folio at a time and does no readahead.
> > Hence if the data isn't already in cache, it is doing synchronous
> > small reads and waiting for every single one of them. This really
> > should use an internal interface that is capable of issuing
> > readahead...
> 
> Yes, I noticed that if I do dummy read() of each extent first,
> it becomes _massively_ faster. I'm not sure if I trust posix_fadvise()
> to just to MADV_WILLNEED given the manpage; would it work (and give
> roughly the same readahead that read() seems to be doing)?

The right thing to do it to just issue readahead in
vfs_dedupe_file_range_compare.  The ractl structure is a bit odd so
it'll need slightky more careful thoughts than just a hacked up
one-liner, but it should still be realtively simple.  I can look into
it once I find a little time if no one beats me to it.

