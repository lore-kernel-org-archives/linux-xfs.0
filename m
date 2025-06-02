Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2158B65C;
	Mon,  2 Jun 2025 05:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748840821; cv=none; b=KFqxg3+ydIxUXjysvh6jYqb5ynXbPkv3q2k6qjVDzV5NazSPuLdbBW1bkvWkVHiULxG4BAVNt4oWO+InBRNaUa7Tmqz7V01o5da+VozYs74WjNV+3cqewmRO/9hQHuXUaG3cCDMfY+tkZoHTm6yDSQs4Pe4YFcTzWphj9ae0RqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748840821; c=relaxed/simple;
	bh=KBKvwrDtYOGJ3Sk5yGhweAEu1h06hJFpfgpPkIk4B3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+VT8YHOQ+0PGMcnfwv8ZvKH5OIjAMMaFgl/F0mNy/UJZ0Avs/DzIUmRkR8QDKCvU5xt86qBuOoUB8IIKnkgdsVeCMrcCLAfdbH7+sspEcwr6I0IGv5fRoqMNN8oRGTmOMDfLBN5U+h5QNdzEsnQxDKi+bb0G4EVYjbGiXwmhs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ijXA5isb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ijXA5isb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NryE9w5TNLfeM9L423ZI0Ib2QmGLwnVsc7lYeYfK/a0=; b=ijXA5isbaSV32frPGbUYV6bFoW
	Jgw8OAs/CGM9sZ6jTZ9WnV8EEoj50QIJyrW2RLGsGmcH7vdJC2jgckvR/ApdiCliut4vOj7KVFn0O
	Vr+PgdL/JUEkphrDeAhCOKjGKErQd4MBUoZxPZq8OcK/c7sDvqh1SunI1BnsRTC7bYhH6ag4BZIyr
	5KELzdzI/7Z0TRsihqgJDD995ElXAaazpVb75QZpvv92GWjzyoPgQ0VXCA+OIgrdgS4Cm0f89LoGE
	uWWlqemjLPrVW+WN/Xu+FE46+ojzVw/sXCn9VycImvhFwWDiz9/hWR13ivBF7iLXKmYBo2xO71AKP
	D+4HpW3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uLxO0-00000006jDe-19rD;
	Mon, 02 Jun 2025 05:07:00 +0000
Date: Sun, 1 Jun 2025 22:07:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/259: try to force loop device block size
Message-ID: <aD0xdHHKmfLmAOXb@infradead.org>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
 <aDAFRGWYESUaILZ6@infradead.org>
 <20250528222226.GB8303@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528222226.GB8303@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 28, 2025 at 03:22:26PM -0700, Darrick J. Wong wrote:
> Welll... the only reason I patched the loop driver to turn ovn directio
> by default is because writeback throttling for loop devices keeps
> getting turned on and off randomly.  At this point I have NFI if
> throttling is actually the desired behavior or not.  It makes fstests
> crawl really slowly.
> 
> On one hand it seems bogus that a loopbacked filesystem with enough
> dirty pages to trip the thresholds then gets throttled doing writeback
> to the pagecache of the loop file, but OTOH it /is/ more dirty
> pagecache.  Ultimately I think non-directio loop devices are stupid
> especially when there are filesystems on top of them, but I bet there's
> some user that would break if we suddenly started requiring directio
> alignments.
> 
> Maybe RWF_DONTCACHE will solve this whenever it stabilizes.

Well, I'm all for using direct I/O loop devices by default.  But having
non-standard kernel hacks for that is pretty silly.  Can we just make
xfstests use direct I/O by default so that everyone uses the same
configuration?

