Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:47347 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933277AbcJMT03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2016 15:26:29 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9DIUxC6002597
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2016 18:30:59 GMT
Date: Thu, 13 Oct 2016 11:28:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/9] xfs: optimize writes to reflink files
Message-ID: <20161013182850.GM22379@birch.djwong.org>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
 <1476106685-29048-6-git-send-email-hch@lst.de>
 <20161012141232.GA56019@bfoster.bfoster>
 <20161013064925.GB10579@lst.de>
 <20161013132604.GA9339@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161013132604.GA9339@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Oct 13, 2016 at 09:26:05AM -0400, Brian Foster wrote:
> On Thu, Oct 13, 2016 at 08:49:25AM +0200, Christoph Hellwig wrote:
> > On Wed, Oct 12, 2016 at 10:12:34AM -0400, Brian Foster wrote:
> > > > +		if (xfs_is_reflink_inode(ip)) {
> > > > +			bool		shared;
> > > > +
> > > > +			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
> > > > +					maxbytes_fsb);
> > > > +			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
> > > > +			error = xfs_reflink_reserve_cow(ip, &got, &shared);
> > > > +			if (error)
> > > > +				goto out_unlock;
> > > 
> > > All in all this seems fine, but I don't see why we need to get all the
> > > way down through xfs_reflink_reserve_cow() ->
> > > xfs_reflink_trim_around_shared() to handle the basic delalloc overwrite
> > > case on a reflink inode. Could we enhance the is_reflink_inode() helper
> > > or create a new one that can consider whether the data fork extent is a
> > > hole or delalloc?
> > 
> > Do you mean delalloc non-overwrite?  We could skip non-overwrite extents
> > by factoring out a helper that checks for extent types that don't need to
> > be overwritten.  But this would defeat the COW fork speculative
> > preallocation logic, which causes additional COW operations even for
> > extents we would not nessecarily have to COW.  So we'll always have to
> > look at the COW fork first if we already have an allocation to implement
> > that scheme (and we should probably document it better).
> > 
> 
> Either way... delalloc into a hole or overwrite of an existing (data
> fork) delalloc, will fall out of xfs_reflink_reserve_cow() so long as
> nothing is in the cow fork, right?
> 
> But regardless, I see your point now. For whatever reason the comment
> update in xfs_reflink_reserve_cow() went right over my head. IIUC, the
> idea is that cow delalloc writes can include preallocation and thus have
> delalloc for blocks that might not actually be shared in the data fork.
> Therefore, we have to query the cow fork first and cannot reliably use
> the data fork shared state to determine whether cow fork blocks actually
> exist. A clarification of the comment is probably fine.. thanks for the
> explanation.

Yep, that's correct.  We can promote non-CoW writes to CoW as a strategy
to try to reduce fragmentation.  I'll clarify that aspect in the docs.

--D

> 
> Brian
> 
> > xfs_reflink_trim_around_shared does a check for the non-COWable extent
> > types as the very first thing, so that's where we are done with the COW
> > overhead for a non-overwrite that doesn't have a speculative
> > preallocation in the COW fork.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
