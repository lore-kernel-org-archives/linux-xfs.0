Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E148593B;
	Mon,  5 Oct 2026 13:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791208408; cv=none; b=GUYjAxdJox8ESt1YxGRsDoMp2DSWWyV18OO2eQYE6TzPfu8qVN4vcyqfrJ6xCS1WoHAca8ZZR9xXGI4zPEGNtk/B+ZUG1ZLZYE5T/1JpFhAxSC1QUIpqHl8ra4mGzDp682GV6iTfLvIdAhbVr4CAkCYYFZJDO0Obl051BREuw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791208408; c=relaxed/simple;
	bh=jRbURmQeTvcvXzAeTy4qw0UvL1FfD0q+E/ejxMgIpRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdIuJCtkXN8wzJCtv4bVTW3LiW3KPA9gQsJH4G52QqrA+PDLwW5zkBUzM90el+J7k1EHUZBGgmR1H5dNZumuasD4EJgWJaMTBhw+Is3OP2ivCYUyVgnIZusAqtwpDxXlIv8Hfg2btMC17avn0J++X2hAMmZiwFP/jlfFZG2pOAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 335F868AFE; Mon,  5 Oct 2026 15:53:21 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:53:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <20261005135320.GA29829@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <arWpyhFyV3ouYAEx@dread> <20260925062710.GA3798@lst.de> <armf05yfzhSBUsUh@dread> <20260928052436.GA18925@lst.de> <arvHFOjF-CD5Vd3g@dread> <ary2PpSp1xTgrd3k@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ary2PpSp1xTgrd3k@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 30, 2026 at 05:11:58PM +1000, Dave Chinner wrote:
> My initial thought was that on disk format structures shouldn't be
> defined by the limitations of the OS memory allocation, but <shrug>.
> It kept nagging at me, though.

Well, it would be nice to be able to design without all the real-life
constraints around us, wouldn't it?  I'm trying to strike a balance
between what would be useful (go big) and what is feasible.  If we
want other values, we can always increase the support range for
newer kernels and tools.

> I looked more closely at what XFS_BLI_PREALLOC did to try to
> understand why it existed.  It triggers a max-sized CIL logvec
> structure for the buffer object. For a 32kB buffer logged as a
> single contiguous range, this ends up being about 32kB + a logvec
> header, plus a log iovec, plus a BLF, plus a couple of ophdrs. So
> it's about 32kB + 200-250 bytes.
> 
> That means the shadow buffer for a csum buffer is always considered
> a costly allocation by the MM subsystem.

It ends up using vmalloc exclusively based on tracing for me,
but that might be different on different systems.

> Hence for csum BLI, if a CIL flush happens on a partially filled
> buffer, a good amount of that shadow buffer will go unused. Then we
> allocate another (costly) shadow buffer on the next update. If CIL
> flushes happen frequently enough then we will be repeatedly doing
> costly allocations for shadow buffers that we don't actually use.

Yes.  But if we don't do this we realloc for every few blocks
written, which is a lot more costly.

> Not ideal - I think that means the original "sized for mm fast path"
> intent is really only valid for the read side of the csum
> algorithms as implemented by the patchset.

It is valid for the xfs_buf backing where we actually hit the folio
allocator.  Which is used both for read and write, but obviously
most workloads tend to hit reads a lot harder than writes.

> Ok, we have a solution to this problem. I created ordered buffers
> and one-shot log items to avoid the journalling overhead of static
> inode buffer initialisation back in 2013. The ICREATE log item is
> the one-shot log item that records a buffer should be initialised,
> and the ordered buffer allows the modified buffer to be passed
> through the journal to metadta writeback without it's contents being
> logged.
> 
> Given that csum updates are a small, known size, non-overlapping
> one-shot update to a buffer, they fit the same model that
> ICREAT+ordered implements. Adding a new CSUM log item made up of a
> format header and varible size csum payload region provides the
> equivalent of the ICREAT item for journalled inode buffer
> initialisation.

I initially looked into intent/done based csums, but we still end
with an allocation per log operation, and a memcpy both into that
and into the buffer, while adding a lot of new log items.

One thing I played with for a while until I realized that the simple
buf item actually provides good enough performance is special
xfs_log_vec that is not included in the main log vec / shadow allocation
but points to external memory.  This obviously only works for fixed
size non-overlapping regions, but then isn't too bad.  This is the
prep work for it, which I recently refreshed:

https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xlog-ophdr

These can work with the buf_item on-disk format, so I'd rather not
prematurely optimize it, as the prototype shows that I can go to that
any time I want.  And eventually I think I'd want to go there, as it
drastically reduces the memory usage if only the format header and
two ophrs need to be allocated ontop of the backing buffer.  But there's
plenty more important things on the plate for now.
