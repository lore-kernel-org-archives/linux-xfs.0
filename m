Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfARQbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 11:31:33 -0500
Date: Fri, 18 Jan 2019 08:31:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190118163132.GA6318@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118115937.GD7807@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 18, 2019 at 03:59:37AM -0800, Christoph Hellwig wrote:
> xfs_bmapi_write will always do a xfs_iext_lookup_extent for the
> passed in blocks anyway.  So this trimming logic should move into
> xfs_bmapi_write to ensure it does the right thing, instead of papering
> over the logic in xfs_bmapi_write in the caller with another lookup.
> 
> I think the improved XFS_BMAPI_DELALLOC handling in this patch:
> 
>    http://git.infradead.org/users/hch/xfs.git/commitdiff/553fed9ce7695df081779c6a9a205af4142b2a06
> 
> is the right answer, as writeback really should only ever convert
> existing delalloc extents, and I'd much rather rely on that rather than
> piling hacks of hacks to feed the right range into a function that must
> do a lookup in the extent tree anyway.

FYI, here is a tree that rebases my patches on top of your (minus this
one) and also drops the internal i_size checks, although it still keeps
the initial one for the truncate fast path.  Testing is still ongoing,
and for the writeback issue you probably only need the first three
of my patches:

	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation
