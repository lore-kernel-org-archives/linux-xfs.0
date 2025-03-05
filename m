Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F841FCD07
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 23:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217316; cv=none; b=ZFUbUbzNw8cRcGMuJmQRjenNZS/jlyyf/MnygUd+VGFKryrWOxjvfuojtemZR6WO8a4UscDmY3180ZMAkp59Tk3pXuVBmAvACF+Mia0dZNidijtvHplWQ2Byo9NjJYSkVvXYz1dlwqHnNRvvUqUhyE88q0epgeCMXfj/rynbVLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217316; c=relaxed/simple;
	bh=GuotUEdTdzd6EBJX01Srja4znm1zYonmGUZiB16PZMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejNc9L9yQO9kkCI4jltMh9swYCTf7aT5HIBq6vBafHyiBjDFz0otThKt53iLwNX4gWCInTx9sRB8F0Go+wDUo3DkQkKw9jFdwxla/tZ+4QYyZIxaER4Afw0LQNC1n/JgDZ3JWEc798FRNs7pjVxl7JaZsWmFRDY/UHEdi9squOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=GFry4HaZ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="GFry4HaZ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223cc017ef5so342005ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Mar 2025 15:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741217314; x=1741822114; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wL2Q7RiMVp9lPxvJ4ysXYxEXDzC1lyqdd5cwfIH0CYg=;
        b=GFry4HaZkHlqf8ml4sAhfMZackLMhLdWPt7Wdp4Qf/10O01yIA6mzxgEqb7Fgovsvr
         emZbaqJf/wv/IpwK/2FOfBBENjf4gFHEgsn7bUyYsuieSGhxhq/vsXEq3oNg+nd0vEwR
         gmIMfetNcz+U3ko+cEbUXlRiQHkEdqmTYvY0SsAseDJl/d5KFTavNwF7KuhgOYoM+KTT
         8Ffvja52pvHJEcuz73xAWKhfYIPpl27Dk+PwNhx3k2BQviNj2Ab3+CydwAGYlEnmAD3F
         9rw85xa4njskFkhEjMHZUcaE6IHPyZCalgd12NcC6KclGucWSaJPrwu3IQUJBsgBOM38
         b24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741217314; x=1741822114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wL2Q7RiMVp9lPxvJ4ysXYxEXDzC1lyqdd5cwfIH0CYg=;
        b=QLPr97c4+PH8YU53sz6iVcwnsDoWiFF5xVXTK+5TgFSw79qYHqM+QYxk5TwGTSeMqc
         cOYoG9lSKu2VpH4Bip37iby51VCOervRMswCUZisppdYp5B7RdNEw3mNtkENd4HbRVEU
         sY4zBDCOXv99eKTfI93cTOYW8shH0Nv+Ne+j7ZlW0TRwKayk01D0G32WpriO6tg5bpts
         WVrI3s+38A/RSnKD1e/IEK9rkheXjoeMoHjqKWocHeppwN4DBXFSHw37ZngdR7w/q/V6
         fiX6wWG520WHpTezZ6T3DUhF7gFa3bTKH5P0PLE5SDGLVRR4KgDhmft/KEUrbIOgI7mS
         UIGg==
X-Forwarded-Encrypted: i=1; AJvYcCXsGfYx6+lYQLds3YTFgVaTnZseQ6NQZT5i7YovLyhEC9cNLAwUZ3iSH6l1omOTZG4ytQGpm6b1Euo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRWW3jgmsavWhj8e2A3MINOucXFgn7NzSwSXq3bV6kOZNKySQo
	kyPuC+iCZXEjG1NODicbQ9LGE2LJMl8YP0RNmEhcNoPa5+Ntr1r9R1tvKxd1XTY=
X-Gm-Gg: ASbGncuwr1+xe2Ku7zZukK9KKfrbUvb3pKr4hmqPL5OMQkVBqg/Sff8ATG30S7TaAB/
	irbOyTlJXWIp1zOOKtVNSU2KBfjhcuZAaNvRbuSdMVKqPK6Oe8CfCWXCg/BRbIeLq37iGMjyDHd
	8W4flc3LN+qttfvNQWQ89C1sDQrZnj2Zrr1dSm0ImuRq6xMFb7HeSq+3djRyBaDQsITANv3pk0/
	Uo0mGXvPk2U+twd0GDGUuQw0ABdItu6gRXeG941oLnZ8EogGm5BOzFVOm6r2BZr1Fd8YIgXBSrN
	1onNZnzOO4wruLT1pK5eswneiKcRfFDmK/S7etir4gPPDmGKiNgQSzCxOiDFWRBpmlY7zgbmApt
	ahbIVIeVmUFhH/eVCnxxw
X-Google-Smtp-Source: AGHT+IENQE37YRQ2jjX/wdc1l6lrPuXwLc6BhtqLGGsk+w2S0LOEexylx7RtO+aY17WsRKAV2IQE9g==
X-Received: by 2002:a17:903:22c7:b0:223:432b:593d with SMTP id d9443c01a7336-223f1d101ddmr81262575ad.42.1741217313687;
        Wed, 05 Mar 2025 15:28:33 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224101632d5sm48685ad.122.2025.03.05.15.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 15:28:33 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpyAA-00000009N7u-1qst;
	Thu, 06 Mar 2025 10:28:30 +1100
Date: Thu, 6 Mar 2025 10:28:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <Z8jeHjpn_VTjMFCg@dread.disaster.area>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-11-hch@lst.de>
 <Z8jACLtp5X98ShBR@dread.disaster.area>
 <20250305225407.GM2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305225407.GM2803749@frogsfrogsfrogs>

On Wed, Mar 05, 2025 at 02:54:07PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 06, 2025 at 08:20:08AM +1100, Dave Chinner wrote:
> > On Wed, Mar 05, 2025 at 07:05:27AM -0700, Christoph Hellwig wrote:
> > > The fallback buffer allocation path currently open codes a suboptimal
> > > version of vmalloc to allocate pages that are then mapped into
> > > vmalloc space.  Switch to using vmalloc instead, which uses all the
> > > optimizations in the common vmalloc code, and removes the need to
> > > track the backing pages in the xfs_buf structure.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > .....
> > 
> > > @@ -1500,29 +1373,43 @@ static void
> > >  xfs_buf_submit_bio(
> > >  	struct xfs_buf		*bp)
> > >  {
> > > -	unsigned int		size = BBTOB(bp->b_length);
> > > -	unsigned int		map = 0, p;
> > > +	unsigned int		map = 0;
> > >  	struct blk_plug		plug;
> > >  	struct bio		*bio;
> > >  
> > > -	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
> > > -			xfs_buf_bio_op(bp), GFP_NOIO);
> > > -	bio->bi_private = bp;
> > > -	bio->bi_end_io = xfs_buf_bio_end_io;
> > > +	if (is_vmalloc_addr(bp->b_addr)) {
> > > +		unsigned int	size = BBTOB(bp->b_length);
> > > +		unsigned int	alloc_size = roundup(size, PAGE_SIZE);
> > > +		void		*data = bp->b_addr;
> > >  
> > > -	if (bp->b_page_count == 1) {
> > > -		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
> > > -				offset_in_page(bp->b_addr));
> > > -	} else {
> > > -		for (p = 0; p < bp->b_page_count; p++)
> > > -			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
> > > -		bio->bi_iter.bi_size = size; /* limit to the actual size used */
> > > +		bio = bio_alloc(bp->b_target->bt_bdev, alloc_size >> PAGE_SHIFT,
> > > +				xfs_buf_bio_op(bp), GFP_NOIO);
> > > +
> > > +		do {
> > > +			unsigned int	len = min(size, PAGE_SIZE);
> > >  
> > > -		if (is_vmalloc_addr(bp->b_addr))
> > > -			flush_kernel_vmap_range(bp->b_addr,
> > > -					xfs_buf_vmap_len(bp));
> > > +			ASSERT(offset_in_page(data) == 0);
> > > +			__bio_add_page(bio, vmalloc_to_page(data), len, 0);
> > > +			data += len;
> > > +			size -= len;
> > > +		} while (size);
> > > +
> > > +		flush_kernel_vmap_range(bp->b_addr, alloc_size);
> > > +	} else {
> > > +		/*
> > > +		 * Single folio or slab allocation.  Must be contiguous and thus
> > > +		 * only a single bvec is needed.
> > > +		 */
> > > +		bio = bio_alloc(bp->b_target->bt_bdev, 1, xfs_buf_bio_op(bp),
> > > +				GFP_NOIO);
> > > +		__bio_add_page(bio, virt_to_page(bp->b_addr),
> > > +				BBTOB(bp->b_length),
> > > +				offset_in_page(bp->b_addr));
> > >  	}
> > 
> > How does offset_in_page() work with a high order folio? It can only
> > return a value between 0 and (PAGE_SIZE - 1). i.e. shouldn't this
> > be:
> > 
> > 		folio = kmem_to_folio(bp->b_addr);
> > 
> > 		bio_add_folio_nofail(bio, folio, BBTOB(bp->b_length),
> > 				offset_in_folio(folio, bp->b_addr));
> 
> I think offset_in_folio() returns 0 in the !kmem && !vmalloc case
> because we allocate the folio and set b_addr to folio_address(folio);
> and we never call the kmem alloc code for sizes greater than PAGE_SIZE.

Yes, but that misses my point: this is a folio conversion, whilst
this treats a folio as a page. We're trying to get rid of this sort
of page/folio type confusion (i.e. stuff like "does offset_in_page()
work correctly on large folios"). New code shouldn't be adding
new issues like these, especially when there are existing
folio-based APIs that are guaranteed to work correctly and won't
need fixing in future before pages and folios can be fully
separated.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
