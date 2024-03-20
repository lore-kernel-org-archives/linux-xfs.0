Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D7376
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068908; cv=none; b=NQMyNaFCQlQ4h4RbPa+jog9fKNb8Sjxx1MNX97F2rnRIdXJ0tlzVny3p8G+Pe1LKu9i8zpxuxX9kGbkLWz2NdH8/Og1eag/OwruuAm0+RRaxR+LNW7Q1k+SsWF4D/YrUebE8sFhjCF/LpnbwJQSZaGHTVyeT2GF5yrXkovKYcPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068908; c=relaxed/simple;
	bh=UYsZgAppRJ68aELHgvYQ+TNop1c4UB+V6AWZYK0PBcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVGjWleP72uHpM/Y25aod1/PEPhIeFiVCg7schvXog8ykkCL7/QlVEeiXDAu74Ruv1AwIZQtv0Wcalmow03dN/kJrMZf8rw/napan4S70zve29K0IfJn5P8YWdDQ1Ib8AjqtmrGIMN3hAFdYa0xkSB76xUS87a4QOOEPVhMh2EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=h2j17cdt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="h2j17cdt"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e04ac200a6so12028305ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068906; x=1711673706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=2OmO2z+EEjUvisePGh3u49up1ULGPz8m3aq3RAQEabk=;
        b=h2j17cdt/Ah8Vd951VUawKRCG3cqWvqdxUrtR1LGrHBTQUtgJh2FhtsTQ923zKSCVJ
         sqETyPyj1TAJJ8zlUCYWYzmgTeA2/WbDbSJf/EsKvYoh7D+W4DtVBEGW3tlvfJETUaMJ
         At7Pyb9u3rpu4nsJgFFjN3nnxhGKZaEk3lU83ppcSmWGs4XY/zP9lGSSUv/rGHDw5qq1
         YmEH2IPYQ9I5+FyymnxwXufn6XKM9zCbmD7IRzxFopni8jr3mjF/vgvctipQmp+DnAVq
         0aaM9s5g5Khe3QgU2cJeXHQTC7/0WCWxi4vatW0D8p7CqXoX75bLNDOQJMOhfw+HGxm9
         oimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068906; x=1711673706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2OmO2z+EEjUvisePGh3u49up1ULGPz8m3aq3RAQEabk=;
        b=Dx4GsJtQUIkZNGgKwICANQtYLG4mQwPBqAHxZmdlXpRVQP5an9SAnI4iUmiiBcbpWn
         Qwdr1K4HyfQSjOKjv9ABRv/guHGTp7yPmCaslis1K+GhQcwj5qQgCVzYMQ2Keghu8sfP
         +Vy+YJhFMhbfNCYpZEM8YgQi3so7iWgsYb0KrzB8rJMvUGsYwqjUN29z3mzzknlCgZaY
         oUAL149q3alrJXD1sJlIyvZYbwGrR7P0wjksi0q0ZdDZkThh7/FcFd1lwmXv9vRA7krz
         bO0LkaOwyorw8xjfpa06tiWWlI1SgtQssQC+xBsJbyCTQ4qrVSkUyA5Gdb9rx2qnzrMQ
         kY2w==
X-Gm-Message-State: AOJu0YzPkF/kQHY7XnTvFxy7N6E0vPDd6iQbLDNC9S4sv8SMPaZnZ+em
	C0XWT6AyE4n0o12Xb9C0QhWTNd7JvkvnbnDd4/pNvMAZqPubeadXj9BrMq3UQYwILikoBEk4ddb
	k
X-Google-Smtp-Source: AGHT+IFe2sVmq526RaEk+cyHK+OaGx+VM2rUeHZ6lAZkSvy3XPIJ4zUvNJ+lPtfpfVjePh3ONIjuag==
X-Received: by 2002:a17:902:f7c1:b0:1dd:a3e2:de77 with SMTP id h1-20020a170902f7c100b001dda3e2de77mr671831plw.20.1711068905545;
        Thu, 21 Mar 2024 17:55:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902ce8700b001dd72cc822bsm494909plg.201.2024.03.21.17.55.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:55:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTBW-005Tdl-2Z
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:55:02 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:55:02 +1100
Resent-Message-ID: <ZfzW5nGZHnPnJqe1@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 11:20:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: use vmalloc for multi-folio buffers
Message-ID: <ZfortpehJBhja0Cf@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-9-david@fromorbit.com>
 <20240319174819.GU1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319174819.GU1927156@frogsfrogsfrogs>

On Tue, Mar 19, 2024 at 10:48:19AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 19, 2024 at 09:45:59AM +1100, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Instead of allocating the folios manually using the bulk page
> > allocator and then using vm_map_page just use vmalloc to allocate
> > the entire buffer - vmalloc will use the bulk allocator internally
> > if it fits.
> > 
> > With this the b_folios array can go away as well as nothing uses it.
> > 
> > [dchinner: port to folio based buffers.]
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c     | 164 ++++++++++++-------------------------------
> >  fs/xfs/xfs_buf.h     |   2 -
> >  fs/xfs/xfs_buf_mem.c |   9 +--
> >  3 files changed, 45 insertions(+), 130 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 303945554415..6d6bad80722e 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -282,29 +282,6 @@ _xfs_buf_alloc(
> >  	return 0;
> >  }
> >  
> > -static void
> > -xfs_buf_free_folios(
> > -	struct xfs_buf	*bp)
> > -{
> > -	uint		i;
> > -
> > -	ASSERT(bp->b_flags & _XBF_FOLIOS);
> > -
> > -	if (xfs_buf_is_vmapped(bp))
> > -		vm_unmap_ram(bp->b_addr, bp->b_folio_count);
> > -
> > -	for (i = 0; i < bp->b_folio_count; i++) {
> > -		if (bp->b_folios[i])
> > -			__folio_put(bp->b_folios[i]);
> > -	}
> > -	mm_account_reclaimed_pages(bp->b_folio_count);
> > -
> > -	if (bp->b_folios != bp->b_folio_array)
> > -		kfree(bp->b_folios);
> > -	bp->b_folios = NULL;
> > -	bp->b_flags &= ~_XBF_FOLIOS;
> > -}
> > -
> >  static void
> >  xfs_buf_free_callback(
> >  	struct callback_head	*cb)
> > @@ -323,13 +300,22 @@ xfs_buf_free(
> >  
> >  	ASSERT(list_empty(&bp->b_lru));
> >  
> > -	if (xfs_buftarg_is_mem(bp->b_target))
> > +	if (xfs_buftarg_is_mem(bp->b_target)) {
> >  		xmbuf_unmap_folio(bp);
> > -	else if (bp->b_flags & _XBF_FOLIOS)
> > -		xfs_buf_free_folios(bp);
> > -	else if (bp->b_flags & _XBF_KMEM)
> > -		kfree(bp->b_addr);
> > +		goto free;
> > +	}
> >  
> > +	if (!(bp->b_flags & _XBF_KMEM))
> > +		mm_account_reclaimed_pages(bp->b_folio_count);
> 
> Echoing hch's statement about the argument being passed to
> mm_account_reclaimed_pages needing to be fed units of base pages, not
> folios.
> 
> > +
> > +	if (bp->b_flags & _XBF_FOLIOS)
> > +		__folio_put(kmem_to_folio(bp->b_addr));
> 
> Is it necessary to use folio_put instead of the __ version like hch said
> earlier?

Both fixed.

> 
> > +	else
> > +		kvfree(bp->b_addr);
> > +
> > +	bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;
> 
> Shouldn't this be:
> 
> 	bp->b_flags &= ~(_XBF_KMEM | _XBF_FOLIOS); ?

Yes. Good catch.

> > @@ -377,14 +361,15 @@ xfs_buf_alloc_folio(
> >  	struct xfs_buf	*bp,
> >  	gfp_t		gfp_mask)
> >  {
> > +	struct folio	*folio;
> >  	int		length = BBTOB(bp->b_length);
> >  	int		order = get_order(length);
> >  
> > -	bp->b_folio_array[0] = folio_alloc(gfp_mask, order);
> > -	if (!bp->b_folio_array[0])
> > +	folio = folio_alloc(gfp_mask, order);
> > +	if (!folio)
> >  		return false;
> >  
> > -	bp->b_folios = bp->b_folio_array;
> > +	bp->b_addr = folio_address(folio);
> >  	bp->b_folio_count = 1;
> >  	bp->b_flags |= _XBF_FOLIOS;
> >  	return true;
> > @@ -400,15 +385,11 @@ xfs_buf_alloc_folio(
> >   * contiguous memory region that we don't have to map and unmap to access the
> >   * data directly.
> >   *
> > - * The second type of buffer is the multi-folio buffer. These are *always* made
> > - * up of single page folios so that they can be fed to vmap_ram() to return a
> > - * contiguous memory region we can access the data through.
> > - *
> > - * We don't use high order folios for this second type of buffer (yet) because
> > - * having variable size folios makes offset-to-folio indexing and iteration of
> > - * the data range more complex than if they are fixed size. This case should now
> > - * be the slow path, though, so unless we regularly fail to allocate high order
> > - * folios, there should be little need to optimise this path.
> > + * The second type of buffer is the vmalloc()d buffer. This provides the buffer
> > + * with the required contiguous memory region but backed by discontiguous
> > + * physical pages. vmalloc() typically doesn't fail, but it can and so we may
> > + * need to wrap the allocation in a loop to prevent low memory failures and
> > + * shutdowns.
> 
> Where's the loop now?  Is that buried under __vmalloc somewhere?

I thought I'd added __GFP_NOFAIL to the __vmalloc() gfp mask to make
it loop. I suspect I lost it at some point when rebasing either this
or the (now merged) kmem.[ch] removal patchset.

Well spotted, I'll fix that up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
