Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860D435957;
	Fri, 10 Oct 2025 05:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760073446; cv=none; b=H6T9YLL8czCBXcC4Af2M1vIV1yKtObxufDdxFI5+IjZqBr3U0aChHgigH8hpO0/NLzrI+fEzGar0xhwNf0wDG6/zTgLhW1gJHS8SH2cFFnfq9AwdQtWjB/9bh1zjiiJq+C6NKeUOHzdEXTPJS9pfGkT5eRn9mhjpggwRbEBP1ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760073446; c=relaxed/simple;
	bh=9Vh8lk+lR1y93KfcHP+uWP8NRG89UN/phcU1DDGze7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Td9ZdVT7Jz24zmK/OfxlNN1rs2AG+owEP7Gj6vBl474r2z/IMxPaX92HMnd1R/RdXPkZuDusQFo4gew/vc55NyMmPksDLZ5et9/+0OPPMzM0DKXMohAosFvRYaEANq5/B7Rf4pEQwyetxBD1zY+WjUJuNQNf4uiSjovY/bdLiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MP7wBmKH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MP7wBmKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=abbETGVm6GnVYpDK0/3pKaYOuRq5SCQFS58nsHOJFNs=; b=MP7wBmKHs5T/KEUepU65w9V1yu
	z1rnXSDjgCVeQ0R1Dn4K5ybGyGKIrQL/RaUCy9U3N0sImIv3F32qaqrQ6rhSMN/Q4oHonr9I6es37
	Z06i7EUG03ABQfISSWZfG1/9i1VH7lUzGFfYbkdB1fpnxc5c2cYYuaaiGr/noz9mSQl7Qo8im0aEG
	37F8XKwQeTbiCIgcN0teS19u5O1+8ORAeafD5DOaafXnfhzymd5vRfD5Bx4U2VM/NJszByuHBo1Pw
	66pA7O7iRow9eeHubMchcGjwfnJfK2V8zwyMtU71mtcnnLRH+RyoIimNHLwXKfOijd+7s63Texc/m
	7Xr8vI9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v75VH-00000007hTE-1OBD;
	Fri, 10 Oct 2025 05:17:19 +0000
Date: Thu, 9 Oct 2025 22:17:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <aOiW3_Z7e3vtJ2oe@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
> Specifically, xfs/078, xfs/216, and xfs/217 are failing for us
> on various machines with between 8 and 128 CPUS, due to the
> fundamental change in geometry that results from the new
> concurrency behavior, which makes any consistent golden
> output that involves geometry details quite difficult.

FYI, the zoned XFS CI has seen these fail as well, and I've never
been able to reproduce it locally.  The CI runs on a fairly beefy
box so I suspect it could be correlated.

