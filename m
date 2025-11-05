Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C94E2222A0
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762356603; cv=none; b=bSXyYOv7w3U8QCS7txoCYWGZAttsGDQ2rkGzdXMaT3JZRInndXBeER40mIKCDIUjd/vKQ69zeEr+fG+FA5EgZB7UZocSVG8EGOV2R9Pwf0RPoaO+SS/oLdORL63kKjDfhsbbmg5HsAN+s+BONvF3bXwS9kRY9f0j18ywQ3dY5Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762356603; c=relaxed/simple;
	bh=7cUNMKsjvauMVU1hKnLcdZdiUsNtjytp9rxPdMfNcps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OW1EFiBY1QdXufvRk0phHqFIVh0nd6JbDz7nFmtVvfVVZ2bP1WBW7f86358Kc0Q0U9XqE6hjFY/XeuOHDLSqNuCAAIKBw/wRKTRoSwQaIJOR0z/kX/0PAz1Mr1C7zlhKzxL2wy1aC5oB7E2wORP0xKNmuZutBNUtqHMw7qr5xeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdGXvEeu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdGXvEeu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762356600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=saQftPy6Ee7T13PU0SmdxbZdndk5kz3SiIUEfliij6Q=;
	b=CdGXvEeuQmlT9YAfjbgnzBHiI7O0FFs1yl4YC1vcgiVa+H+ZAtKnTCCfhZR9kxj7DjPtPs
	5yoiGX3IKYJTZomENrHdGY2VXLxoSrJtHIRqvWfUrg7sSR8MudXIdJmx/KAF+WiBZ6rR1T
	MHG6hn1OgjzDwjtNKmCfUdGb+scQArc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-BoJleAWaPmWuhAYWXCGLCw-1; Wed,
 05 Nov 2025 10:29:59 -0500
X-MC-Unique: BoJleAWaPmWuhAYWXCGLCw-1
X-Mimecast-MFC-AGG-ID: BoJleAWaPmWuhAYWXCGLCw_1762356598
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F6AF180122B;
	Wed,  5 Nov 2025 15:29:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.135])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98C78300018D;
	Wed,  5 Nov 2025 15:29:57 +0000 (UTC)
Date: Wed, 5 Nov 2025 10:34:26 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: flush eof folio before insert range size update
Message-ID: <aQtughoBHt6LRTUx@bfoster>
References: <20251016190303.53881-1-bfoster@redhat.com>
 <20251016190303.53881-4-bfoster@redhat.com>
 <20251105001445.GW196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105001445.GW196370@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 04, 2025 at 04:14:45PM -0800, Darrick J. Wong wrote:
> On Thu, Oct 16, 2025 at 03:03:00PM -0400, Brian Foster wrote:
> > The flush in xfs_buffered_write_iomap_begin() for zero range over a
> > data fork hole fronted by COW fork prealloc is primarily designed to
> > provide correct zeroing behavior in particular pagecache conditions.
> > As it turns out, this also partially masks some odd behavior in
> > insert range (via zero range via setattr).
> > 
> > Insert range bumps i_size the length of the new range, flushes,
> > unmaps pagecache and cancels COW prealloc, and then right shifts
> > extents from the end of the file back to the target offset of the
> > insert. Since the i_size update occurs before the pagecache flush,
> > this creates a transient situation where writeback around EOF can
> > behave differently.
> 
> Why not flush the file from @offset to EOF, flush the COW
> preallocations, extend i_size, and only then start shifting extents?
> That would seem a lot more straightforward to me.
> 

I agree. I noted in the cover letter that I started with this approach
of reordering the existing sequence of operations, but the factoring
looked ugly enough that I stopped and wanted to solicit input.

The details of that fell out of my brain since I posted this,
unfortunately. I suspect it may have been related to layering or
something wrt the prepare_shift factoring, but I'll take another look in
that direction for v2 and once I've got some feedback on the rest of the
series.. Thanks.

Brian

> --D
> 
> > This appears to be corner case situation, but if happens to be
> > fronted by COW fork speculative preallocation and a large, dirty
> > folio that contains at least one full COW block beyond EOF, the
> > writeback after i_size is bumped may remap that COW fork block into
> > the data fork within EOF. The block is zeroed and then shifted back
> > out to post-eof, but this is unexpected in that it leads to a
> > written post-eof data fork block. This can cause a zero range
> > warning on a subsequent size extension, because we should never find
> > blocks that require physical zeroing beyond i_size.
> > 
> > To avoid this quirk, flush the EOF folio before the i_size update
> > during insert range. The entire range will be flushed, unmapped and
> > invalidated anyways, so this should be relatively unnoticeable.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 5b9864c8582e..cc3a9674ad40 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1226,6 +1226,23 @@ xfs_falloc_insert_range(
> >  	if (offset >= isize)
> >  		return -EINVAL;
> >  
> > +	/*
> > +	 * Let writeback clean up EOF folio state before we bump i_size. The
> > +	 * insert flushes before it starts shifting and under certain
> > +	 * circumstances we can write back blocks that should technically be
> > +	 * considered post-eof (and thus should not be submitted for writeback).
> > +	 *
> > +	 * For example, a large, dirty folio that spans EOF and is backed by
> > +	 * post-eof COW fork preallocation can cause block remap into the data
> > +	 * fork. This shifts back out beyond EOF, but creates an expectedly
> > +	 * written post-eof block. The insert is going to flush, unmap and
> > +	 * cancel prealloc across this whole range, so flush EOF now before we
> > +	 * bump i_size to provide consistent behavior.
> > +	 */
> > +	error = filemap_write_and_wait_range(inode->i_mapping, isize, isize);
> > +	if (error)
> > +		return error;
> > +
> >  	error = xfs_falloc_setsize(file, isize + len);
> >  	if (error)
> >  		return error;
> > -- 
> > 2.51.0
> > 
> > 
> 

