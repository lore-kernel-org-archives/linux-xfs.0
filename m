Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfARSjS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jan 2019 13:39:18 -0500
Date: Fri, 18 Jan 2019 13:39:15 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190118183915.GB53532@bfoster>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118163132.GA6318@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 18, 2019 at 08:31:32AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 18, 2019 at 03:59:37AM -0800, Christoph Hellwig wrote:
> > xfs_bmapi_write will always do a xfs_iext_lookup_extent for the
> > passed in blocks anyway.  So this trimming logic should move into
> > xfs_bmapi_write to ensure it does the right thing, instead of papering
> > over the logic in xfs_bmapi_write in the caller with another lookup.
> > 
> > I think the improved XFS_BMAPI_DELALLOC handling in this patch:
> > 
> >    http://git.infradead.org/users/hch/xfs.git/commitdiff/553fed9ce7695df081779c6a9a205af4142b2a06
> > 
> > is the right answer, as writeback really should only ever convert
> > existing delalloc extents, and I'd much rather rely on that rather than
> > piling hacks of hacks to feed the right range into a function that must
> > do a lookup in the extent tree anyway.
> 
> FYI, here is a tree that rebases my patches on top of your (minus this
> one) and also drops the internal i_size checks, although it still keeps
> the initial one for the truncate fast path.  Testing is still ongoing,
> and for the writeback issue you probably only need the first three
> of my patches:
> 
> 	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation

This doesn't really seem all that different to me. Rather than firm up
the range in the caller, we turn XFS_BMAPI_DELALLOC into something that
seemingly behaves a bit more like CONVERT_ONLY.

A few notes/thoughts:

1. What's the purpose of the nimaps == 0 check in
xfs_iomap_write_allocate()? If we got to this point with the page lock
held, shouldn't we always expect to find something backing the current
page?

2. If so, then it also seems that the whole "eof:" thing in
xfs_map_blocks() should never happen for data forks. If that's the case,
the use of the eof label there seems gratuitous.

3. If the starting bno param to xfs_bmapi_write() lands in a hole (due
to racing with a hole punch for example) and it finds some subsequent
delalloc extent to convert in the requested range, the arithmetic in
xfs_bmapi_trim_map() actually fabricates physical blocks for the hole
portion of the range relative to the startblock of the converted
delalloc extent. I don't think that causes a problem with the writeback
code because the fabricated blocks are before the page offset, but those
semantics are insane. I think you need to do something like fix up
xfs_bmapi_write() to return the actual converted mapping and make sure
xfs_iomap_write_allocate() handles that it might start beyond
map_start_fsb.

Brian
