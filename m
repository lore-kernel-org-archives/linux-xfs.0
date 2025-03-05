Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1DB1E7C20
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 23:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217744; cv=none; b=hGV8tXqpjmQpmTYnmIXDvE47o5FbFxcE54ULMMdQK+Vz1piv52R6E16kGtEdeGTfeR0LXetW5kMfyNX91J6YX9VwqBcxm3Su5L3nVvWi/lSaFNQI06U+oOR9w9oKR6KP6DJEkFAo+ESHT5HhbqQF7SJc/cv/2xIg209QVJZI59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217744; c=relaxed/simple;
	bh=qLfNJ1cw0Ba2wcW49TQIZp25+9MjLik68grOamogZwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwikfY1xYmYMZm5zraNS2x1llGd7ZUL4L5uFQjBnfMZ7VHnn3NgZRpTtrVKQREQVXUvKCeYiIL45pmwUf/Me259HyajxJ4JPZOUGFZsFE5TgQKN+gKxPkm9sfKxik2RqHrtDBEvI3DAHhq4Rc9kuBvEZmn8Twdm0it4HIrR6Tkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3257368BEB; Thu,  6 Mar 2025 00:35:37 +0100 (CET)
Date: Thu, 6 Mar 2025 00:35:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for
 buffer backing memory
Message-ID: <20250305233536.GC613@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-11-hch@lst.de> <Z8jACLtp5X98ShBR@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jACLtp5X98ShBR@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 08:20:08AM +1100, Dave Chinner wrote:
> > +		__bio_add_page(bio, virt_to_page(bp->b_addr),
> > +				BBTOB(bp->b_length),
> > +				offset_in_page(bp->b_addr));
> >  	}
> 
> How does offset_in_page() work with a high order folio? It can only
> return a value between 0 and (PAGE_SIZE - 1).

Yes.

> i.e. shouldn't this
> be:
> 
> 		folio = kmem_to_folio(bp->b_addr);
> 
> 		bio_add_folio_nofail(bio, folio, BBTOB(bp->b_length),
> 				offset_in_folio(folio, bp->b_addr));
> 

That is also correct, but does a lot more work underneath as the
bio_vecs work in terms of pages.  In the long run this should use
a bio_add_virt that hides all that (and the bio_vecs should move to
store physical addresses).  For now the above is the simplest and
most efficient version.

