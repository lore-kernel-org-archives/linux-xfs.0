Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121FE376
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068887; cv=none; b=BZpusdxywrUiG69eqlh2y7D8HA7rdXdD95wnnPvBoup5EBQpg+q3m+VhuIs7O11Tdbwh/HtAEC5CGAXCxriuHlnv5ErI6SS4zgB/hE5I1FTDGEs5ZKcFPYy4a9c6REP7f190p35Gwg+Rah7c71i/gDMxpfozlS1JB3lf+MgH5Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068887; c=relaxed/simple;
	bh=Tfsu5YW64xh13JgbN37VmNIPIwHd5kRU1cOy8BsN4jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfSnFMhYY9+sj54bJXZeGqVhOD/Xt5BYHe83tTSMC/RvdcJYyavU9b6/6UGvXNxDBK6fvj81nO6YAom/yzUMvv093BFZC0dUR7Lnc/d63wCcSeUDcOTVBByxu/OL7n0XaODSz29mudzeZRbjV4eLLlqw1ZnuK5Z7mbEatpCCnGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=b8ClKKeP; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="b8ClKKeP"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6bee809b8so1393331b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068885; x=1711673685; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNhQP7qY4nVNzbP5b0BNWF0AlMHrMu99w3/tRtuxQNw=;
        b=b8ClKKePix8gtnWOs86f70VsZS6+/v/LFtd0zBk7DkAR8p6NmTCbp1Qpj7vMO0MdDE
         2hvwO/E8n0sWEIR3NFrMMFF/QfMpEObR4PZ8j6bB1f3RVNj91okt1ArmG0LlLlg2zPl8
         cV8tRgwwMtklRoCGCXQUGsfeLS7BRevZt5EZGxe3/MH2lVriPuFZ1UY6WGV/uaEg81Zu
         XlgM6G8E3z/qDxrc0cwBgKkKtPKMNfVo3VW/9D6VowmIlPexalSpr/9LspvpodcbTLRX
         iFjZd9B+kYfYAQEJzOAK/gHV4i1zGkNWh+Zf23AGtWWSrbdoPsVk0Oxz5KAIzTjZIbN5
         X2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068885; x=1711673685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dNhQP7qY4nVNzbP5b0BNWF0AlMHrMu99w3/tRtuxQNw=;
        b=sxL6+FaHD41teceIenN9x9vAGyZtTuSCxADiUMZcBnH7Aa3jvSWsZ0zuWXZdQZH9yR
         f28gqAVE1ezOIRATEPocxHu5uEc7uh7/sb8wC8Ya9mj2en+yhkXYiJXaYutWY6sLeImT
         chwBlmBYnnw3Gb38C0OmT/V/bZ6FTCDZ+c1Ng8mwpYE6VDGLocovC84MgbDAcc9ii4IK
         RhsLycWjVTD+AdOyopq6RLifMdn1XNxKlOi6uxZtVzZz630Scj3o1fFYcOzjl/fLo1OR
         1GjxUuaJ4MPd7SIhUhlRp9ra2ID5C6bOHOv5yx8m99aYWIvLqE+Z5+rcmx16Fl70iYRb
         ozpA==
X-Gm-Message-State: AOJu0Yxa08HYwNeZjs1qE9ifNNE89ajUqfIaCwq2SSZNgC3JukWbSz2Q
	PkWrbJuHngyR1jvjRPHvqiOtwCG0QFvskXfPBVZJuu8YQO71YpNkZkTOFmZe/KtpD9N4il8zRp6
	x
X-Google-Smtp-Source: AGHT+IEoqIUqr/a7QY1vXulQ7jlOvXdrW+qQEiC5GkI7xodQF/gcZRoNaukpr3m/Oh4UrR4AM3DU7w==
X-Received: by 2002:a05:6a00:9298:b0:6e7:4604:9c96 with SMTP id jw24-20020a056a00929800b006e746049c96mr1288646pfb.20.1711068884977;
        Thu, 21 Mar 2024 17:54:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7808a000000b006e73508485bsm451805pff.100.2024.03.21.17.54.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:54:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTBB-005TYp-39
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:54:42 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:54:41 +1100
Resent-Message-ID: <ZfzW0UoU+WZODLDc@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 08:55:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <ZfoJtlzGbLOYZdvL@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319172909.GP1927156@frogsfrogsfrogs>

On Tue, Mar 19, 2024 at 10:29:09AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 19, 2024 at 09:45:54AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have the buffer cache using the folio API, we can extend
> > the use of folios to allocate high order folios for multi-page
> > buffers rather than an array of single pages that are then vmapped
> > into a contiguous range.
> > 
> > This creates two types of buffers: single folio buffers that can
> > have arbitrary order, and multi-folio buffers made up of many single
> > page folios that get vmapped. The latter is essentially the existing
> > code, so there are no logic changes to handle this case.
> > 
> > There are a few places where we iterate the folios on a buffer.
> > These need to be converted to handle the high order folio case.
> > Luckily, this only occurs when bp->b_folio_count == 1, and the code
> > for handling this case is just a simple application of the folio API
> > to the operations that need to be performed.
> > 
> > The code that allocates buffers will optimistically attempt a high
> > order folio allocation as a fast path. If this high order allocation
> > fails, then we fall back to the existing multi-folio allocation
> > code. This now forms the slow allocation path, and hopefully will be
> > largely unused in normal conditions.
> > 
> > This should improve performance of large buffer operations (e.g.
> > large directory block sizes) as we should now mostly avoid the
> > expense of vmapping large buffers (and the vmap lock contention that
> > can occur) as well as avoid the runtime pressure that frequently
> > accessing kernel vmapped pages put on the TLBs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 141 ++++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 110 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 832226385154..7d9303497763 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -80,6 +80,10 @@ xfs_buf_is_vmapped(
> >  	return bp->b_addr && bp->b_folio_count > 1;
> >  }
> >  
> > +/*
> > + * See comment above xfs_buf_alloc_folios() about the constraints placed on
> > + * allocating vmapped buffers.
> > + */
> >  static inline int
> >  xfs_buf_vmap_len(
> >  	struct xfs_buf	*bp)
> > @@ -352,14 +356,63 @@ xfs_buf_alloc_kmem(
> >  		bp->b_addr = NULL;
> >  		return -ENOMEM;
> >  	}
> > -	bp->b_offset = offset_in_page(bp->b_addr);
> >  	bp->b_folios = bp->b_folio_array;
> >  	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
> > +	bp->b_offset = offset_in_folio(bp->b_folios[0], bp->b_addr);
> >  	bp->b_folio_count = 1;
> >  	bp->b_flags |= _XBF_KMEM;
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Allocating a high order folio makes the assumption that buffers are a
> > + * power-of-2 size so that ilog2() returns the exact order needed to fit
> > + * the contents of the buffer. Buffer lengths are mostly a power of two,
> > + * so this is not an unreasonable approach to take by default.
> > + *
> > + * The exception here are user xattr data buffers, which can be arbitrarily
> > + * sized up to 64kB plus structure metadata. In that case, round up the order.
> 
> So.... does that mean a 128K folio for a 68k xattr remote value buffer?

Yes. I figured that >64kB metadata is a rare corner case, and so
the extra memory usage isn't that big a deal. If it does ever become
a problem, we can skip straight to vmalloc for such buffers...

> I've been noticing the 4k merkle tree blobs consume 2 fsb in the xattr
> tree, which isn't awesome.

Yup, that's because we have headers in remote xattr blocks for
holding identifying information and CRCs.

> I haven't figured out a good way to deal
> with that, since the verity code uses a lot of blkno/byte shifting and
> 2k merkle tree blocks suck.

I really wish that the verity code just asked us to store individual
{key,value} tuples rather than large opaque blocks of fixed size
data. Then we could store everything efficiently as individual
btree records in the attr fork dabtree, and verity could still
implement it's page sized opaque block storage for all the other
filesystems behind that....

> > @@ -1551,28 +1617,28 @@ xfs_buf_ioapply_map(
> >  
> >  next_chunk:
> >  	atomic_inc(&bp->b_io_remaining);
> > -	nr_pages = bio_max_segs(total_nr_pages);
> > +	nr_folios = bio_max_segs(total_nr_folios);
> >  
> > -	bio = bio_alloc(bp->b_target->bt_bdev, nr_pages, op, GFP_NOIO);
> > +	bio = bio_alloc(bp->b_target->bt_bdev, nr_folios, op, GFP_NOIO);
> >  	bio->bi_iter.bi_sector = sector;
> >  	bio->bi_end_io = xfs_buf_bio_end_io;
> >  	bio->bi_private = bp;
> >  
> > -	for (; size && nr_pages; nr_pages--, page_index++) {
> > -		int	rbytes, nbytes = PAGE_SIZE - offset;
> > +	for (; size && nr_folios; nr_folios--, folio_index++) {
> > +		struct folio	*folio = bp->b_folios[folio_index];
> > +		int		nbytes = folio_size(folio) - offset;
> >  
> >  		if (nbytes > size)
> >  			nbytes = size;
> >  
> > -		rbytes = bio_add_folio(bio, bp->b_folios[page_index], nbytes,
> > -				      offset);
> 
> Um, bio_add_folio returns a bool, maybe that's why hch was complaining
> about hangs with only the first few patches applied?

Good spot - entirely possible this is the problem...

> Annoying if the kbuild robots don't catch that.  Either way, with hch's
> replies to this and patch 2 dealt with,
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
