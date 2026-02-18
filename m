Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA14B33F389
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 15:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771429091; cv=none; b=OZcMD3cyXLaeig/k6HZ0Lgjx6vwhB0t8WaLTQw7iqxIsj62eBFzBYov5JelEdzBH7t3qa3TYMwlO9uu4nfGKmmjmVwY7+YHl4qzFaj3G6wt52c8yzKn/gr5SGZN6xCvD72u5ji02EjcSsA+By9peYkbyXr9bm06nlHRCncONqUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771429091; c=relaxed/simple;
	bh=z3juJ2SlP8qY4SclGcvg8DCUEuZenH19njTBDryHy0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IBkvdj+11IzkBcY4Ljrz/OnnKBLwRxil2SZPwI8L8dI6fmCs5GEuVw//qBQfqHtu1FwBV5ixSoP0WXeWP4t6Yyw+sDX5L+rhRy+R3CJlptgKr/6nbDbif1qzkXbmX9yHvQttm3u2p+zDr0lErlNjrEIRBRxZEU114oGWFEqO85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=duv5EfN/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="duv5EfN/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771429089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oGs/+jFNnvuI7VQc9EOSjYg5S/COZ79HWvSik5xW2ds=;
	b=duv5EfN/LblU/B2Fw8Zr59n6XKmcPPMQit9Qg1Kzux6aAJ/S5pld307C3SAUf+77QVceKN
	uVxlRjSQ8S20RdY/5KjtN2PeW6YEg8G++F70D2VgLXyZ4rDGR8fbQ33hDnN1iHPK9ubEwk
	E75WYHjPj6k4Ts5b3jUtfeQPMcRxpss=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-VJXc0r1DNY-l79Lf6nf_aQ-1; Wed,
 18 Feb 2026 10:38:04 -0500
X-MC-Unique: VJXc0r1DNY-l79Lf6nf_aQ-1
X-Mimecast-MFC-AGG-ID: VJXc0r1DNY-l79Lf6nf_aQ_1771429083
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B7FA18004AD;
	Wed, 18 Feb 2026 15:38:03 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.38])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB8C9195410D;
	Wed, 18 Feb 2026 15:38:02 +0000 (UTC)
Date: Wed, 18 Feb 2026 10:37:54 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/5] xfs: only flush when COW fork blocks overlap data
 fork holes
Message-ID: <aZXc0vyT2zVcRXCp@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-5-bfoster@redhat.com>
 <37206076c486da01efe90b95f5dc61049cb2d141.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37206076c486da01efe90b95f5dc61049cb2d141.camel@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Feb 17, 2026 at 08:36:50PM +0530, Nirjhar Roy (IBM) wrote:
> On Thu, 2026-01-29 at 10:50 -0500, Brian Foster wrote:
> > The zero range hole mapping flush case has been lifted from iomap
> > into XFS. Now that we have more mapping context available from the
> > ->iomap_begin() handler, we can isolate the flush further to when we
> > know a hole is fronted by COW blocks.
> > 
> > Rather than purely rely on pagecache dirty state, explicitly check
> > for the case where a range is a hole in both forks. Otherwise trim
> > to the range where there does happen to be overlap and use that for
> > the pagecache writeback check. This might prevent some spurious
> > zeroing, but more importantly makes it easier to remove the flush
> > entirely.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_iomap.c | 36 ++++++++++++++++++++++++++++++------
> >  1 file changed, 30 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 0edab7af4a10..0e82b4ec8264 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1760,10 +1760,12 @@ xfs_buffered_write_iomap_begin(
> >  {
> >  	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
> >  						     iomap);
> > +	struct address_space	*mapping = inode->i_mapping;
> >  	struct xfs_inode	*ip = XFS_I(inode);
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> >  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
> > +	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
> >  	struct xfs_bmbt_irec	imap, cmap;
> >  	struct xfs_iext_cursor	icur, ccur;
> >  	xfs_fsblock_t		prealloc_blocks = 0;
> > @@ -1831,6 +1833,8 @@ xfs_buffered_write_iomap_begin(
> >  		}
> >  		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
> >  				&ccur, &cmap);
> > +		if (!cow_eof)
> > +			cow_fsb = cmap.br_startoff;
> >  	}
> >  
> >  	/* We never need to allocate blocks for unsharing a hole. */
> > @@ -1845,17 +1849,37 @@ xfs_buffered_write_iomap_begin(
> >  	 * writeback to remap pending blocks and restart the lookup.
> >  	 */
> >  	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> > -		if (filemap_range_needs_writeback(inode->i_mapping, offset,
> > -						  offset + count - 1)) {
> > +		loff_t start, end;
> 
> Nit: Tab between data type and identifier?
> 

Sure.

> > +
> > +		imap.br_blockcount = imap.br_startoff - offset_fsb;
> > +		imap.br_startoff = offset_fsb;
> > +		imap.br_startblock = HOLESTARTBLOCK;
> > +		imap.br_state = XFS_EXT_NORM;
> > +
> > +		if (cow_fsb == NULLFILEOFF) {
> > +			goto found_imap;
> > +		} else if (cow_fsb > offset_fsb) {
> > +			xfs_trim_extent(&imap, offset_fsb,
> > +					cow_fsb - offset_fsb);
> > +			goto found_imap;
> > +		}
> > +
> > +		/* COW fork blocks overlap the hole */
> > +		xfs_trim_extent(&imap, offset_fsb,
> > +			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
> > +		start = XFS_FSB_TO_B(mp, imap.br_startoff);
> > +		end = XFS_FSB_TO_B(mp,
> > +				   imap.br_startoff + imap.br_blockcount) - 1;
> 
> So, we are including the bytes in the block number (imap.br_startoff + imap.br_blockcount - 1)th,
> right? That is why a -1 after XFS_FSB_TO_B()? 

Not sure I follow what you mean by the "bytes in the block number"
phrasing..? Anyways, the XFS_FSB_TO_B() here should return the starting
byte offset of the first block beyond the range (exclusive). The -1
changes that to the last byte offset of the range we're interested in
(inclusive), which I believe is what the filemap api wants..

Brian

> --NR
> > +		if (filemap_range_needs_writeback(mapping, start, end)) {
> >  			xfs_iunlock(ip, lockmode);
> > -			error = filemap_write_and_wait_range(inode->i_mapping,
> > -						offset, offset + count - 1);
> > +			error = filemap_write_and_wait_range(mapping, start,
> > +							     end);
> >  			if (error)
> >  				return error;
> >  			goto restart;
> >  		}
> > -		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
> > -		goto out_unlock;
> > +
> > +		goto found_imap;
> >  	}
> >  
> >  	/*
> 

