Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42387 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750944AbcJMHLT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Oct 2016 03:11:19 -0400
Date: Thu, 13 Oct 2016 08:49:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/9] xfs: optimize writes to reflink files
Message-ID: <20161013064925.GB10579@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de> <1476106685-29048-6-git-send-email-hch@lst.de> <20161012141232.GA56019@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161012141232.GA56019@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Oct 12, 2016 at 10:12:34AM -0400, Brian Foster wrote:
> > +		if (xfs_is_reflink_inode(ip)) {
> > +			bool		shared;
> > +
> > +			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
> > +					maxbytes_fsb);
> > +			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
> > +			error = xfs_reflink_reserve_cow(ip, &got, &shared);
> > +			if (error)
> > +				goto out_unlock;
> 
> All in all this seems fine, but I don't see why we need to get all the
> way down through xfs_reflink_reserve_cow() ->
> xfs_reflink_trim_around_shared() to handle the basic delalloc overwrite
> case on a reflink inode. Could we enhance the is_reflink_inode() helper
> or create a new one that can consider whether the data fork extent is a
> hole or delalloc?

Do you mean delalloc non-overwrite?  We could skip non-overwrite extents
by factoring out a helper that checks for extent types that don't need to
be overwritten.  But this would defeat the COW fork speculative
preallocation logic, which causes additional COW operations even for
extents we would not nessecarily have to COW.  So we'll always have to
look at the COW fork first if we already have an allocation to implement
that scheme (and we should probably document it better).

xfs_reflink_trim_around_shared does a check for the non-COWable extent
types as the very first thing, so that's where we are done with the COW
overhead for a non-overwrite that doesn't have a speculative
preallocation in the COW fork.
