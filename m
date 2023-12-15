Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E4C566C
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 04:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E/+vE6xU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hrjjSNKlIhpnbX8N2TreBbEH1qSPbSIfr9F/85WmEIw=; b=E/+vE6xUe/n7T1KupDgUQZEucJ
	T+pV8ws1klJhOiljixoNjZl5Fl0EFyRLAB5rf44qqT2o/qiIhs7WMGqkgPsH06Jx6FDB7pyJeG6JQ
	anoOuQTysBLPaNqcnY5F335w3nzkKX3v5WN3i9qww7hd437BpcsHPVS1IGxM341kfv13OcFBvxBAb
	gncuSD4R5JrGFvYLyCrkwv1dwt+CMC27dP7bvS4Ko/pPwCMPRP2dOV8YBZo2h18fKm6X6G+ojb3wH
	ppH7lMNVj3AfPAUnVpM7gg6XdZHFjKYGyjN+0TBeOBG8m5WhLv/aizezF3tjB+PMoBugd3aulJR7u
	wr//RaHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDzTF-001xDr-0N;
	Fri, 15 Dec 2023 04:06:41 +0000
Date: Thu, 14 Dec 2023 20:06:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Message-ID: <ZXvQ0YDfHBuvLXbY@infradead.org>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214213502.GI361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 14, 2023 at 01:35:02PM -0800, Darrick J. Wong wrote:
> I'm kinda surprised you don't just turn on alwayscow mode, use an
> iomap_funshare-like function to read in and dirty pagecache (which will
> hopefully create a new large cow fork mapping) and then flush it all
> back out with writeback.  Then you don't need all this state tracking,
> kthreads management, and copying file data through the buffer cache.
> Wouldn't that be a lot simpler?

Yes, although with a caveat or two.

We did that for the zoned XFS project, where a 'defragmentation' like
this which we call garbage collection is an essential part of the
operation to free entire zones.  I ended up initially implementing it
using iomap_file_unshare as that is page cache coherent and a nicely
available library function.  But it turns out iomap_file_unshare sucks
badly as it will read the data sychronously one block at a time.

I ended up coming up with my own duplication of iomap_file_unshare
that doesn't do it which is a bit hack by solves this problem.
I'd love to eventually merge it back into iomap_file_unshare, for
which we really need to work on our writeback iterators.

The relevant commit or the new helper is here:


   http://git.infradead.org/users/hch/xfs.git/commitdiff/cc4a639e3052fefb385f63a0db5dfe07db4e9d58

which also need a hacky readahead helper:

    http://git.infradead.org/users/hch/xfs.git/commitdiff/f6d545fc00300ddfd3e297d17e4f229ad2f15c3e

The code using this for zoned GC is here:

    http://git.infradead.org/users/hch/xfs.git/blob/refs/heads/xfs-zoned:/fs/xfs/xfs_zone_alloc.c#l764

It probably would make sense to be able to also use this for a regular
fs for the online defrag use case, although the wire up would be a bit
different.

