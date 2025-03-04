Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9451C54AA
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097450; cv=none; b=HRf8Y1AqPKu6+pd4Ow+eSRrtwqj4bWP8TfhCoUvK//55Xvzva75pLnAO2hE9nd7BXl/ZeP+SbqEdzc5UqEKa3TrCmr5GMGg5UUatzGJRRLb5CqUK66h+wQsVvLDxkFL2u8LxQRXPrTMZ4XWpum9TiPyCJeVtvPVuU8YetxqvzP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097450; c=relaxed/simple;
	bh=Ol5EMrdDH0FgrZs4VOpCF4CQHbQN4uvohbgJLA/YalY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSfDxoKxhHaaVY7Cl8Zae8WFW4B79zNVZWsgUZMil5RtMepuOE1ZfpbXP1diOLRNMQiA2fSlBUSzMYlTRM0w72ocj7RYwOCC40Eb5GPG+0vldlhEiYnpH1P9dg+yoUIWZ7dVmtzuTHNFVw7VDzPOr8YrErt087Nhi43ZybFtElY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D0DA68D05; Tue,  4 Mar 2025 15:10:44 +0100 (CET)
Date: Tue, 4 Mar 2025 15:10:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for
 buffer backing memory
Message-ID: <20250304141043.GC15778@lst.de>
References: <20250226155245.513494-1-hch@lst.de> <20250226155245.513494-11-hch@lst.de> <20250226180234.GT6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226180234.GT6242@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 26, 2025 at 10:02:34AM -0800, Darrick J. Wong wrote:
> >  		if (!bp->b_error && is_vmalloc_addr(bp->b_addr))
> >  			invalidate_kernel_vmap_range(bp->b_addr,
> > -					xfs_buf_vmap_len(bp));
> > +					DIV_ROUND_UP(BBTOB(bp->b_length),
> > +							PAGE_SIZE));
> 
> The second argument to invalidate_kernel_vmap_range is the number of
> bytes, right?

Yes.

> Isn't this BBTOB() without the DIV_ROUND_UP?  Or do you
> actually want roundup(BBTOB(b_length), PAGE_SIZE) here?

Yes.

> > -	if (bp->b_page_count == 1) {
> > -		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
> > -				offset_in_page(bp->b_addr));
> > -	} else {
> > -		for (p = 0; p < bp->b_page_count; p++)
> > -			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
> > -		bio->bi_iter.bi_size = size; /* limit to the actual size used */
> > +		bio = bio_alloc(bp->b_target->bt_bdev, size >> PAGE_SHIFT,
> 
> Is the second argument (size >> PAGE_SHIFT) supposed to be the number of
> pages that we're going to __bio_add_page to the bio?

Yes.

> In which case, shouldn't it be alloc_size ?

Yes.

> > +		} while (size);
> >  
> > -		if (is_vmalloc_addr(bp->b_addr))
> > -			flush_kernel_vmap_range(bp->b_addr,
> > -					xfs_buf_vmap_len(bp));
> > +		flush_kernel_vmap_range(bp->b_addr, alloc_size);
> 
> ...and this one is roundup(size, PAGE_SIZE) isn't it?

Yes.

