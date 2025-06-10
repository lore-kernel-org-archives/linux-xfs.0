Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A828FAB6
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 12:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749558032; cv=none; b=mTn6ezGNqJyX5tm9tXciQ+8r1dSRWALEZZY2DkkWEc+yDpavdP0k0qESz25ZBMw2uD4tH3aL0o5nhMGVB+t1K0ltmuOIXKpLiTHcTKQhfm2xIuTOEbPgMG1lUjmhl7ccSQq5vH/g5p4fu/xEvyH/GvtQNffvUxnleoUYNMg6U7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749558032; c=relaxed/simple;
	bh=Pgja4/lvNe3fMquzwA9FrxB76V11940z2mHUfLJY+PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s41c8lbLvp/mZGnw8UyvI6Sl67ZMuQzxAqf84Jb1iWxPzNFpcTHQ1kPv2mRcdGQZkOCiOKX6J4mXIDSjEsBon6o5gPXtn2TrdhXbVi/c42eITbFA063BOJvmSly4Tv0U28u7HGkbFS4VLejs6jFCIRC6R6SvX/4jypBGSzBXbqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BsINyOon; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsINyOon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749558030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mMeA1vnnlvCC2BQWETMgH4IdWWhMpmY5D4WQM/9Lup4=;
	b=BsINyOondVxgTs0qvMi9hHZ5bWFme8gG0kjbd9KHvJM7wqQ09PaEUnBGRNasmcQI9ZtKco
	mi4oINnAbRDsSOWNFu5u4EsFnQgHo87aCZGLM+cvk3WrAoOim0juh0/HYtronFW8QHQCPR
	By/tvvbXYcrE4U11ax0DHg3zEM/AZNk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-tbOnSrmQMlKk49LSq1BdZA-1; Tue,
 10 Jun 2025 08:20:27 -0400
X-MC-Unique: tbOnSrmQMlKk49LSq1BdZA-1
X-Mimecast-MFC-AGG-ID: tbOnSrmQMlKk49LSq1BdZA_1749558026
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A8E1800291;
	Tue, 10 Jun 2025 12:20:25 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3306D30001B1;
	Tue, 10 Jun 2025 12:20:25 +0000 (UTC)
Date: Tue, 10 Jun 2025 08:24:00 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 5/7] xfs: fill dirty folios on zero range of unwritten
 mappings
Message-ID: <aEgj4J0d1AppDCuH@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-6-bfoster@redhat.com>
 <20250609161219.GE6156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609161219.GE6156@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jun 09, 2025 at 09:12:19AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 05, 2025 at 01:33:55PM -0400, Brian Foster wrote:
> > Use the iomap folio batch mechanism to select folios to zero on zero
> > range of unwritten mappings. Trim the resulting mapping if the batch
> > is filled (unlikely for current use cases) to distinguish between a
> > range to skip and one that requires another iteration due to a full
> > batch.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_iomap.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index b5cf5bc6308d..63054f7ead0e 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
...
> > @@ -1769,6 +1772,26 @@ xfs_buffered_write_iomap_begin(
> >  		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
> >  			end_fsb = eof_fsb;
> >  
> > +		/*
> > +		 * Look up dirty folios for unwritten mappings within EOF.
> > +		 * Providing this bypasses the flush iomap uses to trigger
> > +		 * extent conversion when unwritten mappings have dirty
> > +		 * pagecache in need of zeroing.
> > +		 *
> > +		 * Trim the mapping to the end pos of the lookup, which in turn
> > +		 * was trimmed to the end of the batch if it became full before
> > +		 * the end of the mapping.
> > +		 */
> > +		if (imap.br_state == XFS_EXT_UNWRITTEN &&
> > +		    offset_fsb < eof_fsb) {
> > +			loff_t len = min(count,
> > +					 XFS_FSB_TO_B(mp, imap.br_blockcount));
> > +
> > +			end = iomap_fill_dirty_folios(iter, offset, len);
> 
> ...though I wonder, does this need to happen in
> xfs_buffered_write_iomap_begin?  Is it required to hold the ILOCK while
> we go look for folios in the mapping?  Or could this become a part of
> iomap_write_begin?
> 

Technically it does not need to be inside ->iomap_begin(). The "dirty
check" just needs to be before the fs drops its own locks associated
with the mapping lookup to maintain functional correctness, and that
includes doing it before the callout in the first place (i.e. this is
how the filemap_range_needs_writeback() logic works). I have various
older prototype versions of that work that tried to do things a bit more
generically in that way, but ultimately they seemed less elegant for the
purpose of zero range.

WRT zero range, the main reason this is in the callback is that it's
only required to search for dirty folios when the underlying mapping is
unwritten, and we don't know that until the filesystem provides the
mapping (and doing at after the fs drops locks is racy).

That said, if we eventually use this for something like buffered writes,
that is not so much of an issue and we probably want to instead
lookup/allocate/lock each successive folio up front. That could likely
occur at the iomap level (lock ordering issues and whatnot
notwithstanding).

The one caveat with zero range is that it's only really used for small
ranges in practice, so it may not really be that big of a deal if the
folio lookup occurred unconditionally. I think the justification for
that is tied to broader using of batching in iomap, however, so I don't
really want to force the issue unless it proves worthwhile. IOW what I'm
trying to say is that if we do end up with a few more ops using this
mechanism, it wouldn't surprise me if we just decided to deduplicate to
the lowest common denominator implementation at that point (and do the
lookups in iomap iter or something). We're just not there yet IMO.

Brian

> --D
> 
> > +			end_fsb = min_t(xfs_fileoff_t, end_fsb,
> > +					XFS_B_TO_FSB(mp, end));
> > +		}
> > +
> >  		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
> >  	}
> >  
> > -- 
> > 2.49.0
> > 
> > 
> 

