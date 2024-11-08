Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD371803A
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077799; cv=none; b=IpomYdkD7/NOo68g/qT5I4JZ6DGcEhW6XHJUCquNF3Ue2mqQzDyXZZOf5kmZjDsfjiQF6+gg+4affO5U3HZVItcc7ufpJylyQVn0Hwrcd/NfzTgrL8VwgDGjSOWIjX3fFUQJc4hkolF8Ggk/9mb1p702gVUwri5np5A83iFspCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077799; c=relaxed/simple;
	bh=Z581WTidmOvp9xGspH41e/CE3NjTQFo7u02mmWOTdmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W599VFco56YjUWaZw5axyWI1MwtOz3zsQO0r4LBXCeeHIiw6xnV5qk3iMCQaEa+4GBY7mJN201kt3nyXRuDqNuvk6tV13p7TvNxkLICi0IIQ55Ay1+aSI73VgeM8qJbn2cTeuulY1J0VNQj56f7OC8tj0Ltd4R8adWiCzyBQCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4DYkiTbJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4DYkiTbJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z581WTidmOvp9xGspH41e/CE3NjTQFo7u02mmWOTdmM=; b=4DYkiTbJEH1U/mFI7iqA3ZbRxQ
	yHaZ74VbgEW33dnUy31i9RCRevzijgdBscQZIOLwzxebX7tuz3gQTOkr1ooLTNVi/O9vx94b29og0
	5CJuMjzjeEwC2CPiTCNneIQRMKRpBn62gVKvCcOpZA8H2XitG/MPyCldG88X6klRrXh3ausyopBHk
	p2Cbxt85NwzW+hX4SruCKbnTqvdo09qyVKT8qiEZlBHVaBMKAt1tq+V3y/qG8mFEBqAQbavdw0Rux
	7AKWNe1qWqovoTmgqAZl3BX07ChvEQDr/TnJWEC0Uvi0C2N5FM80hRIrTT+UT2pvfGSQJL201QaJF
	yc7SSyDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t9QPb-0000000AvWp-3IF4;
	Fri, 08 Nov 2024 14:56:35 +0000
Date: Fri, 8 Nov 2024 06:56:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org
Subject: Re: slab warning: kmem_cache of name 'dm_bufio_buffer' already exists
Message-ID: <Zy4mo1X41yQU2i3-@infradead.org>
References: <9c3fecc3-19dc-42d4-6c89-4a48e9ad19cc@redhat.com>
 <5a1e67c3-481e-4c6e-8507-5a8ea0bd9f28@suse.cz>
 <27ba7473-9255-2407-8e4e-e5c3cafc25c4@redhat.com>
 <e7fca292-7c79-4f97-a90c-d68178d8ca59@suse.cz>
 <58fce0d4-9074-3d98-5a1b-970371f0c23c@redhat.com>
 <dae2f548-cc2d-42ac-9a01-7382958001a7@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dae2f548-cc2d-42ac-9a01-7382958001a7@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 08, 2024 at 11:08:40AM +0100, Vlastimil Babka wrote:
> Right, IIRC xfs was one of the usecases that prompted us towards defining
> the kmalloc alignment guarantees, which was around 2019.
> So today, kmalloc() allocations will not cross a page boundary if the
> requested size is lower than page size, and it's a power-of-two value. Even
> if SLUB debugging is enabled (before the alignment became guaranteed, it
> would happen naturally, and only be violated by either using SLOB, or
> enabling SLUB debugging).
> xfs_buf_alloc_kmem() could be thus simplified.

I'm not sure we'll want to fully trust future allocator changes, but
maybe switching the fallback logic to an assert or WARN_ON might be
wortwhile.

