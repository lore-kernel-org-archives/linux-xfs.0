Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFD31F759A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237584; cv=none; b=osAbl0dZqP/387eUqINypx/R+y6dMBo7X8bsm9QBkALZ/tYlRDVh3qCmYGrZwRrDxu3gwgVgUXYSQQ2M1NSKZcfD6EGJMhwsY2hQe46qVMdEa/R7DJHuQCUr2ZImGxavfiv4ZqAGsvsWETOXM6m2vByFOPl5xBiIUnCAZr9lzpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237584; c=relaxed/simple;
	bh=uh4KYeEtpNvronSDmfTkuelE2WK6c/xswmivq4GGhuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5GwESRxJy8Uj69nyIzN3kMrIW6GQU+nb7rlHxbQTjbB/vYjSzWGtsYnLu9ii+h7ObYPaVxNf0ReozaAE8bJeGAI9OSTlXiHu3iZdtDWmmW2ysQ2kAzN9IaxtyHixMBW7I40WYP0BHFa+VKbQ9PjW8hHj67AnZimbETLkjRPEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KQ95rEwx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KQ95rEwx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733237581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+FUPpooYulybvqbUxS4K8r0quoUiKiLNWzPu7AC86hM=;
	b=KQ95rEwxuDAgEr8kZqyVYkBQPxBX8dvnlLxqQHKApF7yNgvvO+r8OqA0louj5c47FZSuuC
	5GaFENfWfEWIvhmCwEAr6+HU59idULyJTuBBZqZ3GWuqhe84kRDGPY7ajGN46nUi0shv6j
	m1PkC9jK5UpeEWndVQdSYLqvQKOUoQM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-8nBH7FhZOj-nvoEFw7-_Ng-1; Tue,
 03 Dec 2024 09:52:59 -0500
X-MC-Unique: 8nBH7FhZOj-nvoEFw7-_Ng-1
X-Mimecast-MFC-AGG-ID: 8nBH7FhZOj-nvoEFw7-_Ng
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E41631955BFE;
	Tue,  3 Dec 2024 14:52:56 +0000 (UTC)
Received: from bfoster (unknown [10.22.65.140])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB49D1956054;
	Tue,  3 Dec 2024 14:52:54 +0000 (UTC)
Date: Tue, 3 Dec 2024 09:54:41 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v5 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Z08bsQ07cilOsUKi@bfoster>
References: <20241127063503.2200005-1-leo.lilong@huawei.com>
 <Z0sVkSXzxUDReow7@localhost.localdomain>
 <Z03RlpfdJgsJ_glO@bfoster>
 <Z05oJqT7983ifKqv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z05oJqT7983ifKqv@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Dec 03, 2024 at 01:08:38PM +1100, Dave Chinner wrote:
> On Mon, Dec 02, 2024 at 10:26:14AM -0500, Brian Foster wrote:
> > On Sat, Nov 30, 2024 at 09:39:29PM +0800, Long Li wrote:
> > > When performing fsstress test with this patch set, there is a very low probability of
> > > encountering an issue where isize is less than ioend->io_offset in iomap_add_to_ioend.
> > > After investigation, this was found to be caused by concurrent with truncate operations.
> > > Consider a scenario with 4K block size and a file size of 12K.
> > > 
> > > //write back [8K, 12K]           //truncate file to 4K
> > > ----------------------          ----------------------
> > > iomap_writepage_map             xfs_setattr_size
> 
> folio is locked here
> 
> > >   iomap_writepage_handle_eof
> > >                                   truncate_setsize
> > > 				    i_size_write(inode, newsize)  //update inode size to 4K
> 
...
> > > 
> > > It appears that in extreme cases, folios beyond EOF might be written back,
> > > resulting in situations where isize is less than pos. In such cases,
> > > maybe we should not trim the io_size further.
> > > 
> > 
> > Hmm.. it might be wise to characterize this further to determine whether
> > there are potentially larger problems to address before committing to
> > anything. For example, assuming truncate acquires ilock and does
> > xfs_itruncate_extents() and whatnot before this ioend submits/completes,
> 
> I don't think xfs_itruncate_extents() is the concern here - that
> happens after the page cache and writeback has been sorted out and
> the ILOCK has been taken and the page cache state should
> have already been sorted out. truncate_setsize() does that for us;
> it guarantees that all writeback in the truncate down range has
> been completed and the page cache invalidated.
> 

Ah this is what I was missing on previous read through.
truncate_inode_pages_range() waits on writeback in its second pass. I
was initially confused by what would have prevented removing a writeback
folio in the first pass, but that is handled a level down in
find_lock_entries() where it skips locked||writeback folios and thus
leaves them for the second pass.

> We hold the MMAP_LOCK (filemap_invalidate_lock()) so no new pages
> can be instantiated over the range whilst we are running
> xfs_itruncate_extents(). hence once truncate_setsize() returns, we
> are guaranteed that there will be no IO in progress or can be
> started over the range we are removing.
> 
> Really, the issue is that writeback mappings have to be able to
> handle the range being mapped suddenly appear to be beyond EOF.
> This behaviour is a longstanding writeback constraint, and is what
> iomap_writepage_handle_eof() is attempting to handle.
> 
> We handle this by only sampling i_size_read() whilst we have the
> folio locked and can determine the action we should take with that
> folio (i.e. nothing, partial zeroing, or skip altogether). Once
> we've made the decision that the folio is within EOF and taken
> action on it (i.e. moved the folio to writeback state), we cannot
> then resample the inode size because a truncate may have started
> and changed the inode size.
> 
> We have to complete the mapping of the folio to disk blocks - the
> disk block mapping is guaranteed to be valid for the life of the IO
> because the folio is locked and under writeback - and submit the IO
> so that truncate_pagecache() will unblock and invalidate the folio
> when the IO completes.
> 
> Hence writeback vs truncate serialisation is really dependent on
> only sampling the inode size -once- whilst the dirty folio we are
> writing back is locked.
> 

Not sure I see how this is a serialization dependency given that
writeback completion also samples i_size. But no matter, it seems a
reasonable implementation to me to make the submission path consistent
in handling eof.

I wonder if this could just use end_pos returned from
iomap_writepage_handle_eof()?

Brian

> I suspect that we can store and pass the sampled inode size through
> the block mapping and ioend management code so it is constant for
> the entire folio IO submission process, but whether we can do that
> and still fix the orginal issue that we are trying to fix is not
> something I've considered at this point....
> 
> > does anything in that submission or completion path detect and handle
> > this scenario gracefully? What if the ioend happens to be unwritten
> > post-eof preallocation and completion wants to convert blocks that might
> > no longer exist in the file..?
> 
> That can't happen because writeback must complete before
> truncate_setsize() will be allowed to remove the pages from the
> cache before xfs_itruncate_extents() can run.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

