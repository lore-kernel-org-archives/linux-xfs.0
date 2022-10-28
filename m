Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6581FA3741
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 23:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJ1Xty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 19:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJ1Xtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 19:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9826926AF8
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 16:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E83662AF7
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 23:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA0EC433C1;
        Fri, 28 Oct 2022 23:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667000977;
        bh=lt79nZOYbRDGaKEGuxgLYdw6gIKpMhzrraVpKJUs+yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jopC7JpHjqlzLQ6l28GywmY5MkvhME2P7EBUun6GAIcA+9P/6L0qdGcu64E7oi/Oa
         NUU9ULTtlqpkiPMOMtwtmXR00lMoj3QA8ZTGPw8AHo7mYog139IdTJ5qiHXWHaW9nq
         Di4Bd25Qmi+7HJrRWoTr+P8dmHc6Mneu1h86T2an2eqv5gHWAZUdGlqD2H3J9Djhsj
         TOOAzAsQZ2+7AgySzT8Py4oVDLJsbdPF+izimFbTse64P1r3FyKNbd4YTy2ZBzDacz
         3u6vJDU3Q+sjw7KE9O2o3pM7wkfjIMVduu7quZS8AjyPxbTbM6PeX3vqvhUbmneE6z
         y7NWn/uuYD5GQ==
Date:   Fri, 28 Oct 2022 16:49:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <Y1xqkT1vZ9OmzDmH@magnolia>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
 <Y1we59XylviZs+Ry@bfoster>
 <20221028213014.GD3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028213014.GD3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 29, 2022 at 08:30:14AM +1100, Dave Chinner wrote:
> On Fri, Oct 28, 2022 at 02:26:47PM -0400, Brian Foster wrote:
> > On Fri, Oct 28, 2022 at 09:11:09AM -0400, Brian Foster wrote:
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Here's a quick prototype of "option 3" described in my previous mail.
> > > This has been spot tested and confirmed to prevent the original stale
> > > data exposure problem. More thorough regression testing is still
> > > required. Barring unforeseen issues with that, however, I think this is
> > > tentatively my new preferred option. The primary reason for that is it
> > > avoids looking at extent state and is more in line with what iomap based
> > > zeroing should be doing more generically.
> > > 
> > > Because of that, I think this provides a bit more opportunity for follow
> > > on fixes (there are other truncate/zeroing problems I've come across
> > > during this investigation that still need fixing), cleanup and
> > > consolidation of the zeroing code. For example, I think the trajectory
> > > of this could look something like:
> > > 
> > > - Genericize a bit more to handle all truncates.
> > > - Repurpose iomap_truncate_page() (currently only used by XFS) into a
> > >   unique implementation from zero range that does explicit zeroing
> > >   instead of relying on pagecache truncate.
> > > - Refactor XFS ranged zeroing to an abstraction that uses a combination
> > >   of iomap_zero_range() and the new iomap_truncate_page().
> > > 
> > 
> > After playing with this and thinking a bit more about the above, I think
> > I managed to come up with an iomap_truncate_page() prototype that DTRT
> > based on this. Only spot tested so far, needs to pass iomap_flags to the
> > other bmbt_to_iomap() calls to handle the cow fork, undoubtedly has
> > other bugs/warts, etc. etc. This is just a quick prototype to
> > demonstrate the idea, which is essentially to check dirty state along
> > with extent state while under lock and transfer that state back to iomap
> > so it can decide whether it can shortcut or forcibly perform the zero.
> > 
> > In a nutshell, IOMAP_TRUNC_PAGE asks the fs to check dirty state while
> > under lock and implies that the range is sub-block (single page).
> > IOMAP_F_TRUNC_PAGE on the imap informs iomap that the range was in fact
> > dirty, so perform the zero via buffered write regardless of extent
> > state.
> 
> I'd much prefer we fix this in the iomap infrastructure - failing to
> zero dirty data in memory over an unwritten extent isn't an XFS bug,
> so we shouldn't be working around it in XFS like we did previously.

Hmm, I think I agree, given that this is really a bug in cache handling.
Or so I gather; reading on...

> I don't think this should be call "IOMAP_TRUNC_PAGE", though,
> because that indicates the caller context, not what we are asking
> the internal iomap code to do. What we are really asking is for
> iomap_zero_iter() to do is zero the page cache if it exists in
> memory, otherwise ignore unwritten/hole pages.  Hence I think a name
> like IOMAP_ZERO_PAGECACHE is more appropriate,

I don't even like ZERO_PAGECACHE -- in my mind that implies that it
unconditionally zeroes any page it finds, whereas we really only want it
to zero dirty cache contents.  IOMAP_ZERO_DIRTY_CACHE?

> > 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 91ee0b308e13..14a9734b2838 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -899,7 +899,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  	loff_t written = 0;
> >  
> >  	/* already zeroed?  we're done. */
> > -	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> > +	if ((srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) &&
> > +	    !(srcmap->flags & IOMAP_F_TRUNC_PAGE))
> >  		return length;
> 
> Why even involve the filesystem in this? We can do this directly
> in iomap_zero_iter() with:
> 
> 	if ((srcmap->type == IOMAP_HOLE)
> 		return;
> 	if (srcmap->type == IOMAP_UNWRITTEN) {
> 		if (!(iter->flags & IOMAP_ZERO_PAGECACHE))
> 			return;
> 		if (!filemap_range_needs_writeback(inode->i_mapping,
> 			    iomap->offset, iomap->offset + iomap->length))
> 			return;
> 	}
> 
> It probably also warrants a coment that a clean folio over EOF on an
> unwritten extent already contains zeros, so we're only interested in
> folios that *have been dirtied* over this extent. If it's under
> writeback, we should still be zeroing because it will shortly
> contain real data on disk and so it needs to be zeroed and
> redirtied....

Yes, please.  I think we've screwed up eofpage handling enough in the
past to warrant good documentation of these corner cases.

> 
> > @@ -916,6 +917,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  		if (bytes > folio_size(folio) - offset)
> >  			bytes = folio_size(folio) - offset;
> >  
> > +		trace_printk("%d: ino 0x%lx offset 0x%lx bytes 0x%lx\n",
> > +			__LINE__, folio->mapping->host->i_ino, offset, bytes);
> >  		folio_zero_range(folio, offset, bytes);
> >  		folio_mark_accessed(folio);
> >  
> > @@ -933,6 +936,17 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  	return written;
> >  }
> >  
> > +static int
> > +__iomap_zero_range(struct iomap_iter *iter, bool *did_zero,
> > +		   const struct iomap_ops *ops)
> > +{
> > +	int ret;
> > +
> > +	while ((ret = iomap_iter(iter, ops)) > 0)
> > +		iter->processed = iomap_zero_iter(iter, did_zero);
> > +	return ret;
> > +}
> 
> I'd just leave this simple loop open coded in the two callers.
> 
> > +
> >  int
> >  iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
> >  		const struct iomap_ops *ops)
> > @@ -943,11 +957,8 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
> >  		.len		= len,
> >  		.flags		= IOMAP_ZERO,
> >  	};
> > -	int ret;
> >  
> > -	while ((ret = iomap_iter(&iter, ops)) > 0)
> > -		iter.processed = iomap_zero_iter(&iter, did_zero);
> > -	return ret;
> > +	return __iomap_zero_range(&iter, did_zero, ops);
> >  }
> >  EXPORT_SYMBOL_GPL(iomap_zero_range);
> >  
> > @@ -957,11 +968,17 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> >  {
> >  	unsigned int blocksize = i_blocksize(inode);
> >  	unsigned int off = pos & (blocksize - 1);
> > +	struct iomap_iter iter = {
> > +		.inode		= inode,
> > +		.pos		= pos,
> > +		.len		= blocksize - off,
> > +		.flags		= IOMAP_ZERO | IOMAP_TRUNC_PAGE,
> > +	};
> >  
> >  	/* Block boundary? Nothing to do */
> >  	if (!off)
> >  		return 0;
> > -	return iomap_zero_range(inode, pos, blocksize - off, did_zero, ops);
> > +	return __iomap_zero_range(&iter, did_zero, ops);
> >  }
> >  EXPORT_SYMBOL_GPL(iomap_truncate_page);
> >  
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 07da03976ec1..16d9b838e82d 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -915,6 +915,7 @@ xfs_buffered_write_iomap_begin(
> >  	int			allocfork = XFS_DATA_FORK;
> >  	int			error = 0;
> >  	unsigned int		lockmode = XFS_ILOCK_EXCL;
> > +	u16			iomap_flags = 0;
> >  
> >  	if (xfs_is_shutdown(mp))
> >  		return -EIO;
> > @@ -942,6 +943,10 @@ xfs_buffered_write_iomap_begin(
> >  	if (error)
> >  		goto out_unlock;
> >  
> > +	if ((flags & IOMAP_TRUNC_PAGE) &&
> > +	    filemap_range_needs_writeback(VFS_I(ip)->i_mapping, offset, offset))
> > +			iomap_flags |= IOMAP_F_TRUNC_PAGE;
> 
> As per above, I don't think we should be putting this check in the
> filesystem. That simplifies this a lot as filesystems don't need to
> know anything about how iomap manages the page cache for the
> filesystem...

I gather from the bug description that this appears to me to be a
problem with how we manage the page cache during a truncation when the
eofpage is backed by unwritten extents.  As such, I think that this
should be a fix within iomap.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
