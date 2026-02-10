Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D8D2D3A89
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770751121; cv=none; b=bMqlvqpctTFoWgsuSlUfjGJT3r9ZECvvt5gSLvomJioIbJvg0OwhNR2uR7jwnyJWpaTxz99fuzVPbRAOqTxlbknX3Uza5DhQsqV7/MofRpmjdhEfWSoJlxLzsqxpWTWzVF0TDIPRgh0j3gGjQI9ugqucj2tuzQWiBV36NJn83j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770751121; c=relaxed/simple;
	bh=dnZZvWwXZUBrCl/6MKB+K2mXreh80L6ACPzliKltb90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sp3MuFN361ooYb7MhwKMuUOjiOYqFbQZnbW3MAk91MEkJf3j0x7BBOKvuSMfTDOxBLUZ+S5B7ORHIx/dGiaSKq/tslrmlKFrNUklHgZ8qA93yK7uypCw3pHlXng4eM+b0765Jqh0Pc8GGF4Hyk734j/k8vYjJ73wKlrRXRUbJNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+8TvGG0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+8TvGG0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770751119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tCERRDgex6DYs3HXLWd06iiayI1hSzOwCWYtEqUVKqA=;
	b=M+8TvGG0z5blUZgwZ0E3HvZtuWlTEZrFl1HJEihRO+Sg1atE8yhG94tfyLhBzLgVw9Su1B
	/0InbcQuZJeZRynwwWd1ZFjkTcg3pFCniP7MzwAuLJhGgHGIZx64gtoX1G+DgVMPwntK4P
	rxZQbbGxdAaHaotJ4HYkwTnofuSFgeI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-m-0tpEIGPDerk4EOnL2iSg-1; Tue,
 10 Feb 2026 14:18:38 -0500
X-MC-Unique: m-0tpEIGPDerk4EOnL2iSg-1
X-Mimecast-MFC-AGG-ID: m-0tpEIGPDerk4EOnL2iSg_1770751117
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39AB118005BC;
	Tue, 10 Feb 2026 19:18:37 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.28])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91806180066F;
	Tue, 10 Feb 2026 19:18:36 +0000 (UTC)
Date: Tue, 10 Feb 2026 14:18:33 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/5] xfs: only flush when COW fork blocks overlap data
 fork holes
Message-ID: <aYuEiS3WKBuquDVx@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-5-bfoster@redhat.com>
 <aYtafWEg11UBZwge@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtafWEg11UBZwge@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Feb 10, 2026 at 08:19:09AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 29, 2026 at 10:50:27AM -0500, Brian Foster wrote:
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
...
> > @@ -1845,17 +1849,37 @@ xfs_buffered_write_iomap_begin(
> >  	 * writeback to remap pending blocks and restart the lookup.
> >  	 */
> >  	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> > -		if (filemap_range_needs_writeback(inode->i_mapping, offset,
> > -						  offset + count - 1)) {
> > +		loff_t start, end;
> > +
> > +		imap.br_blockcount = imap.br_startoff - offset_fsb;
> > +		imap.br_startoff = offset_fsb;
> > +		imap.br_startblock = HOLESTARTBLOCK;
> > +		imap.br_state = XFS_EXT_NORM;
> > +
> > +		if (cow_fsb == NULLFILEOFF) {
> > +			goto found_imap;
> > +		} else if (cow_fsb > offset_fsb) {
> 
> No need for an else after a goto.
> 

I'll tweak that and send a new version with R-b tags if I don't hear
about anything from your zoned tests after a few days.

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder if at some point the zeroing logic should be split into a
> separate helper..
> 

Do you mean a standalone .iomap_begin() for zeroing ops? If so, I've had
a similar thought related to the comments on the next patch...

Brian

