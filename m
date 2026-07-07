Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4824337E2FC;
	Tue,  7 Jul 2026 05:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783401023; cv=none; b=a1GJE14BUpKRCK4JIhQ7sBWv3Pja7EjyUgdWQUnFAVMnXzQK+3PfgPNq2JIISzdkq3YHbTHK0YN5xHibg93g/EJIknKBD0Ot1gXrJ+yc9uUFYesBBCfYSTuMi0B9HPwStrFoC36AE9LrFy6vpwwwywxVQS2XjlvvwkKj2zjB2Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783401023; c=relaxed/simple;
	bh=oxrhUP8seadluQZ+Hk4uzQ/4y3zEyWNkmIDMRYXjlcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7P2QtkcExc6V3d2dMJ4IzxrWnf8xltpiIuZ0Dp4vD2u4kWuT2ffUa7C4pxLre/b+4zLrVEzqhIF06VEFGTZUOXV+4ZMLmgs2kUeRhyIqRzRU5EtZ+1FhO9yeZuVEBF5eUNR82K4gDf2xdY7KnPKBFzSlBuccUzPAG8IVlpvR6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6D90168B05; Tue,  7 Jul 2026 07:10:16 +0200 (CEST)
Date: Tue, 7 Jul 2026 07:10:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@redhat.com,
	fstests@vger.kernel.org, hch@lst.de, djwong@kernel.org,
	yi.zhang@huawei.com, pankaj.raghav@linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
Message-ID: <20260707051015.GA13010@lst.de>
References: <20260703125422.3110429-1-p.raghav@samsung.com> <ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 11:08:39AM +0800, Zhang Yi wrote:
> > +# WRITE_ZEROES must leave the whole requested range backed by *written*
> > +# (zeroed) extents while preserving the out-of-range bytes of the partial
> > +# boundary units. The possible scenarios are: written_edges, hole_edges,
> > +# unwritten_edges and delalloc_edges.
> 
> unwritten_edges needs to distinguish between dirty and clean scenarios.
> The expected result for clean should be tmp.zero, while the expected
> result for dirty should be tmp.pattern.

Does it?  I'd expect everything in the range to be zeroed, and everything
outside to be left alone, as the dirty state is just an imlementation
detail not visible to the user.  Similar to other falloc operations,
I'd expect the file system to write back any boundary block first
to make the dirty state difference moot.

