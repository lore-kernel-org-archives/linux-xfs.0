Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70DE37A4A1
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768892790; cv=none; b=CfRJqBS/c7/KznBwy6LRmncNyEFM0wRvQoktKKzMSfIfxys1Od5wLAJ2w1GmLear1qnhxBfsrLnerupIu0d4Qlka44RNEydGW9pk7sUTQXe9mLz6T4U9Wvyr9FO9XGukYUHFGAr4H43kU22BtQd5QolpZzWcRjYBOGCsmOwU67o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768892790; c=relaxed/simple;
	bh=T4ufNFHQelfxcYUqHw8AlNuU2OCO52hL72m+7Z12kaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoTii+MOV0Y43nasWtEc9lBw+NTQvrIPBwDAmv/lS+wE2+wf0PRjKoZHzbB5K2QWB57W9P51DX931kjnK/0qCJJ0gKN6NkMgfdvo4RodiZouhSvRRAnjpJgnVLgA+JMtDq55ixb+y95Uy2+bE4/LL6ULwDW0I9MkZ0BPUVTnEsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2E4F5227AAD; Tue, 20 Jan 2026 08:06:15 +0100 (CET)
Date: Tue, 20 Jan 2026 08:06:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <20260120070615.GB3954@lst.de>
References: <20260119153156.4088290-1-hch@lst.de> <20260119153156.4088290-4-hch@lst.de> <20260120023918.GG15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120023918.GG15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 19, 2026 at 06:39:18PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 19, 2026 at 04:31:37PM +0100, Christoph Hellwig wrote:
> > The per-AG buffer hashes were added when all buffer lookups took a
> > per-hash look.  Since then we've made lookups entirely lockless and
> > removed the need for a hash-wide lock for inserts and removals as
> > well.  With this there is no need to sharding the hash, so reduce the
> > used resources by using a per-buftarg hash for all buftargs.
> 
> Hey, not having all the per-ag buffer cache sounds neat!
> 
> > Long after writing this initially, syzbot found a problem in the
> > buffer cache teardown order, which this happens to fix as well.
> 
> What did we get wrong, specifically?

Dave has a really good analysis here:

https://lore.kernel.org/linux-xfs/aLeUdemAZ5wmtZel@dread.disaster.area/

> Also: Is there a simpler fix for this bug that we can stuff into old lts
> kernels?

I can't really think of anything much simpler, just different.  It would
require some careful reordering of the unmount path, which is always
hairy.

> Or is this fix independent of the b_hold and lockref changes
> in the previous patches?

In theory it is, except that the old tricks with the refcount would
make it very difficult.  I tried to reorder this twice and failed
both times.

