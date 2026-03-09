Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CF61E98E3
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 18:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773081096; cv=none; b=scqXu0oRjPRY7Brm5cnA2ZTwMyH7g+qaV5MqQO7V2Y6hc91mDifO6RaS4A6/S1pEWCNW2Br7qf32f+zLxrib1fz+lp1j0aB5Yg27G9xPMk0OBT3vX2GcNnOlB3TQs9POWAuVoqdqM7SDBjnEzKbmbvA6QGrWR5Dti2uowAwuM8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773081096; c=relaxed/simple;
	bh=lLLCHk4i98fIV7FcKxxGBbiMquec2aPQc7quNqJ4U0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2e2IIdAbbWIeIZL9QBLDcAdjtXnSZb1QSH8TARcc7ueAqd6J0lPAk/wFxP4Q5PTUpAs+T1IkmfhN1k/SHOyVaoNGocQCk9XZGsjtDYwcz+znkCpmWUiVI/+ne8Dlp0LMOyD3lZvoo/cpKLm77GuwG6GcS5ya3jgcSolDgoApUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4qm433L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4qm433L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773081094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3t0FTVb5TmCQZpwgtY6rFB/t/h/fM2tKdwSKVyTt1cI=;
	b=Z4qm433Lop97LtrXVQgmeFrS3ACiAPIqQNvTQdmQ6VvMwr0OSA7RxEcanw5WCtKzNcFNRh
	MA1l6o9anpDGGq2V4qpHyJ2rcO90dWkHzT9uEWe+sa7T/s3IShHru3e3slsd0Z7+dcIb1J
	w734HH6KyI3sgFKsdm+T46snjcgIT1Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-6HLORRaTNiSOABqPcomQVg-1; Mon,
 09 Mar 2026 14:31:33 -0400
X-MC-Unique: 6HLORRaTNiSOABqPcomQVg-1
X-Mimecast-MFC-AGG-ID: 6HLORRaTNiSOABqPcomQVg_1773081091
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD3AE195609F;
	Mon,  9 Mar 2026 18:31:31 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.107])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3021F19560A6;
	Mon,  9 Mar 2026 18:31:31 +0000 (UTC)
Date: Mon, 9 Mar 2026 14:31:28 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 8/8] xfs: report cow mappings with dirty pagecache for
 iomap zero range
Message-ID: <aa8SAIBCokWCjTWJ@bfoster>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-9-bfoster@redhat.com>
 <20260309175602.GR6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309175602.GR6033@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Mar 09, 2026 at 10:56:02AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 09:45:06AM -0400, Brian Foster wrote:
> > XFS has long supported the case where it is possible to have dirty
> > data in pagecache backed by COW fork blocks and a hole in the data
> > fork. This occurs for two reasons. On reflink enabled files, COW
> > fork blocks are allocated with preallocation to help avoid
> > fragmention. Second, if a mapping lookup for a write finds blocks in
> > the COW fork, it consumes those blocks unconditionally. This might
> > mean that COW fork blocks are backed by non-shared blocks or even a
> > hole in the data fork, both of which are perfectly fine.
> > 
> > This leaves an odd corner case for zero range, however, because it
> > needs to distinguish between ranges that are sparse and thus do not
> > require zeroing and those that are not. A range backed by COW fork
> > blocks and a data fork hole might either be a legitimate hole in the
> > file or a range with pending buffered writes that will be written
> > back (which will remap COW fork blocks into the data fork).
> > 
> > This "COW fork blocks over data fork hole" situation has
> > historically been reported as a hole to iomap, which then has grown
> > a flush hack as a workaround to ensure zeroing occurs correctly. Now
> > that this has been lifted into the filesystem and replaced by the
> > dirty folio lookup mechanism, we can do better and use the pagecache
> > state to decide how to report the mapping. If a COW fork range
> > exists with dirty folios in cache, then report a typical shared
> > mapping. If the range is clean in cache, then we can consider the
> > COW blocks preallocation and call it a hole.
> > 
> > This doesn't fundamentally change behavior, but makes mapping
> > reporting more accurate. Note that this does require splitting
> > across the EOF boundary (similar to normal zero range) to ensure we
> > don't spuriously perform post-eof zeroing. iomap will warn about
> > zeroing beyond EOF because folios beyond i_size may not be written
> > back.
> 
> Hrmm.  I wonder if IOMAP_REPORT should grow this new "expose dirty
> unwritten cow fork mappings over a data fork hole" behavior too?  I
> guess the only user of IOMAP_REPORT that might care is swapfile
> activation, but that fsyncs the whole file to disk before starting the
> iteration so I think it won't matter?
> 

I'd have to take a closer look at that and some of the other iomap ops.
I had similar thoughts in the past about whether this might help clean
up seek hole/data and whatnot as well. For here it's primarily just a
cleanup, but IMO it's better for iomap if it doesn't have to carry the
caveat of "is this hole really a hole?"

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> /me isn't sure he sees the point of doing this only for IOMAP_ZERO but
> you're right that it's weird to pass a folio batch and a hole mapping to
> iomap so
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 

Thanks.

Brian

> --D
> 
> > ---
> >  fs/xfs/xfs_iomap.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index df240931f07a..3bef5ea610bb 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1786,6 +1786,7 @@ xfs_buffered_write_iomap_begin(
> >  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> >  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
> >  	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
> > +	xfs_fileoff_t		eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> >  	struct xfs_bmbt_irec	imap, cmap;
> >  	struct xfs_iext_cursor	icur, ccur;
> >  	xfs_fsblock_t		prealloc_blocks = 0;
> > @@ -1868,7 +1869,8 @@ xfs_buffered_write_iomap_begin(
> >  	 * cache and fill the iomap batch with folios that need zeroing.
> >  	 */
> >  	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> > -		loff_t	start, end;
> > +		loff_t		start, end;
> > +		unsigned int	fbatch_count;
> >  
> >  		imap.br_blockcount = imap.br_startoff - offset_fsb;
> >  		imap.br_startoff = offset_fsb;
> > @@ -1883,15 +1885,32 @@ xfs_buffered_write_iomap_begin(
> >  			goto found_imap;
> >  		}
> >  
> > +		/* no zeroing beyond eof, so split at the boundary */
> > +		if (offset_fsb >= eof_fsb)
> > +			goto found_imap;
> > +		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
> > +			xfs_trim_extent(&imap, offset_fsb, eof_fsb - offset_fsb);
> > +
> >  		/* COW fork blocks overlap the hole */
> >  		xfs_trim_extent(&imap, offset_fsb,
> >  			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
> >  		start = XFS_FSB_TO_B(mp, imap.br_startoff);
> >  		end = XFS_FSB_TO_B(mp, imap.br_startoff + imap.br_blockcount);
> > -		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
> > +		fbatch_count = iomap_fill_dirty_folios(iter, &start, end,
> > +						       &iomap_flags);
> >  		xfs_trim_extent(&imap, offset_fsb,
> >  				XFS_B_TO_FSB(mp, start) - offset_fsb);
> >  
> > +		/*
> > +		 * Report the COW mapping if we have folios to zero. Otherwise
> > +		 * ignore the COW blocks as preallocation and report a hole.
> > +		 */
> > +		if (fbatch_count) {
> > +			xfs_trim_extent(&cmap, imap.br_startoff,
> > +					imap.br_blockcount);
> > +			imap.br_startoff = end_fsb;	/* fake hole */
> > +			goto found_cow;
> > +		}
> >  		goto found_imap;
> >  	}
> >  
> > @@ -1901,8 +1920,6 @@ xfs_buffered_write_iomap_begin(
> >  	 * unwritten extent.
> >  	 */
> >  	if (flags & IOMAP_ZERO) {
> > -		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> > -
> >  		if (isnullstartblock(imap.br_startblock) &&
> >  		    offset_fsb >= eof_fsb)
> >  			goto convert_delay;
> > -- 
> > 2.52.0
> > 
> > 
> 

