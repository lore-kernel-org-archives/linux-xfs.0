Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F137AA7D;
	Fri, 12 Jun 2026 08:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251319; cv=none; b=D6krPIRcA1EVN4HgQ6RcNDnft+ELztkruCfCvJggXzPxjWXHBOf01Y6oi/b5hk9Hzfo9swFZhQELC8PSBeQ7yfUkBoiKDoyQBVg+86JK4Y8WaC9PcYqxytfH/dh1q0mR+Tl2h9da3cKzoz8wj1dSZ8oe+TlC9bIejsrpoWEPnxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251319; c=relaxed/simple;
	bh=LuThkiNiCMWKZdkoI5tE3Y/39OXHX3h/X8fWTILJDJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmiQMxgJqN79E5qhLCvsJfyUZ744nbOMgZgWdXl3+i8+PI+Yf1iGb9R95t5MCVW/7NWAEPwZUMlQupVjhwEMOf9LtekZBoFzytZelfFLzgJRnaXqFojSBkIfuUz0a4+N8OSD841zTAAYSZCHBymiPFZLF8pcfAauie9Cf7cOw3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MjstcFXd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MjstcFXd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7jD/MDoTJEp59NIG3rOHJIeJwr7qwvbaSlX946skE5M=; b=MjstcFXdao1aRwyyZFKF/fflDR
	lS8zRrZghT1BIJVSgucqKLuxpgXsG51cbowL7H/i5TPiMX+lS24R8Hhv4bLFZRyH4D5UHo/oqHFnL
	9rHXGaFZ3mNjHKBJN0YUHK5NpAho622YfZCAKT22BxYNNsUjbNuOYOk+n0j2riY6HIJ6QKQREcvDx
	2bLjMEDy80oALtrFdQ5cbb8mSCd7wzNOi4LUgNKb5nLU0UTY3GW9iHH5nt7P+pbfQPN52dc9OKRl1
	pvJmARgZmdMVlnKnNYOnRQzsrNyRb1Ntr+IJ0VoLmjzTm3SORmeEyfibamTf9JZi5CWdNAauoBU3/
	+zbe4eoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXwps-0000000AXKq-0u6x;
	Fri, 12 Jun 2026 08:01:52 +0000
Date: Fri, 12 Jun 2026 01:01:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, yekelu1@huawei.com,
	jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <aiu88BAe1EqxpeOB@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
 <aiuw0QvFIhEWUPG-@infradead.org>
 <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 03:19:30PM +0800, Gao Xiang wrote:
> 
> 
> On 2026/6/12 15:10, Christoph Hellwig wrote:
> > On Fri, Jun 12, 2026 at 02:54:47PM +0800, Gao Xiang wrote:
> > > hmm, currently erofs could return block-sized iomap (if the chunk
> > > size is 4k) even it can be merged with the following chunks.
> > > 
> > > Previously it was fairly good since consecutive chunks will be
> > > added to the current bio if possible, but after this patch,
> > > there will be a lot of 4k bios.
> > > 
> > > But if iomap goes into this way, I could make iomap_begin maps
> > > more chunks in one shot, but that needs more changes in erofs,
> > > it's fine anyway.
> > > 
> > > ... I was thinking the following diff (space-damaged):
> > 
> > That should work too for your case.  But we definitively have various
> > cases where merging over iomaps is a bad idea.  You'll also end up with
> > other efficiency gains by merging consecutive entries, especially for
> > direct I/O and when using large folios.
> 
> Yes, optimizing erofs chunk mapping would be more
> efficient, will work out one soon, but Yifan can test
> your patch in parallel.
> 
> Also, if "iomap: submit read bio after each extent" is
> applied, I guess some merging condition in
> iomap_bio_read_folio_range() can be removed since they
> won't be reached in any case. (deadcode)

I guess we can't hit the sector check anymore indeed, assuming
we never get non-contiguos readeahead requests, which I think is
true.

