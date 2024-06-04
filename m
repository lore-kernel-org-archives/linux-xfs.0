Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA591D535;
	Tue,  4 Jun 2024 23:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717545234; cv=none; b=p5nBrAMbHK/7w4Cp1iL3toYnHH7k7GPz/rt1vwTDuxbjoXgZqXCEYyL+4x4ahhGnSbx1EiXxn8iwaU0OfXzgl7oTXOtAcQhP7Jv9to4WQu4+BUE2CQOQTQrIcUnp6J//dq8dJXt4590Wf9eXcLUm5PHoM1fUVafDo6+E4Ce5u4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717545234; c=relaxed/simple;
	bh=FZh/FIXyEigTjCFJyIyylMlixwHk6vrOpwsPnd7fovE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TaUR399c0U+wQmtq0ZSOzFnzU0q5KuDCKbJWYFsp8Ao5/TwCOBq7EwlWJVIej+EdHfqU88q2nrWFwB/+WUGuNbboCnMJhrsIszBOe61EuNde1TszDStuBxJ0sSwm5KXbCLEk5/prKbs99lnc9OY9o4+Sq85eM1+1AEq2sXe4hU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N63wcX3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N63wcX3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B05C2BBFC;
	Tue,  4 Jun 2024 23:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717545234;
	bh=FZh/FIXyEigTjCFJyIyylMlixwHk6vrOpwsPnd7fovE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N63wcX3KpIZBgWVJEQrRpqqETuhjgPOFNBBZwn3H2Tj+IYLlPO9ftmUGEWFMvzKQy
	 qacq6mf87l+Dayqb+cEM5KoEVGDV4pyolAC1E4S/zlDjz5ZB8fgTajzSC1FUbA9cYI
	 kYmHAZA/xi9Xd9LMCgwu1EK5Nsl5nswavO9aAYMNeNrY8kc6ANl43c9TLUMqs5LlCO
	 dzJeM8zRgt3zObsFYQ6j9z3DrGU28TH5HbmJHL8a67xVz1jRlHsQb8MAv1g4EBQHyv
	 325ISWJWBhwIcc/IeEkk5XXmrreTValL4m3LTGfKXiTrUfNO9AltXLjP6bq0srGuG8
	 Sq7MrWHYS6Fzw==
Date: Tue, 4 Jun 2024 16:53:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Zizhi Wo <wozizhi@huawei.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: Fix file creation failure
Message-ID: <20240604235353.GG52987@frogsfrogsfrogs>
References: <20240604071121.3981686-1-wozizhi@huawei.com>
 <Zl+cjKxrncOKbas7@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl+cjKxrncOKbas7@dread.disaster.area>

On Wed, Jun 05, 2024 at 09:00:28AM +1000, Dave Chinner wrote:
> On Tue, Jun 04, 2024 at 03:11:21PM +0800, Zizhi Wo wrote:
> > We have an xfs image that contains only 2 AGs, the first AG is full and
> > the second AG is empty, then a concurrent file creation and little writing
> > could unexpectedly return -ENOSPC error since there is a race window that
> > the allocator could get the wrong agf->agf_longest.
> > 
> > Write file process steps:
> > 1) Find the entry that best meets the conditions, then calculate the start
> > address and length of the remaining part of the entry after allocation.
> > 2) Delete this entry. Because the second AG is empty, the btree in its agf
> > has only one record, and agf->agf_longest will be set to 0 after deletion.
> > 3) Insert the remaining unused parts of this entry based on the
> > calculations in 1), and update the agf->agf_longest.
> > 
> > Create file process steps:
> > 1) Check whether there are free inodes in the inode chunk.
> > 2) If there is no free inode, check whether there has space for creating
> > inode chunks, perform the no-lock judgment first.
> > 3) If the judgment succeeds, the judgment is performed again with agf lock
> > held. Otherwire, an error is returned directly.
> > 
> > If the write process is in step 2) but not go to 3) yet, the create file
> > process goes to 2) at this time, it will be mistaken for no space,
> > resulting in the file system still has space but the file creation fails.
> > 
> > 	Direct write				Create file
> > xfs_file_write_iter
> >  ...
> >  xfs_direct_write_iomap_begin
> >   xfs_iomap_write_direct
> >    ...
> >    xfs_alloc_ag_vextent_near
> >     xfs_alloc_cur_finish
> >      xfs_alloc_fixup_trees
> >       xfs_btree_delete
> >        xfs_btree_delrec
> > 	xfs_allocbt_update_lastrec
> > 	// longest = 0 because numrec == 0.
> > 	 agf->agf_longest = len = 0
> > 					   xfs_create
> > 					    ...
> > 					     xfs_dialloc
> > 					      ...
> > 					      xfs_alloc_fix_freelist
> > 					       xfs_alloc_space_available
> > 					-> as longest=0, it will return
> > 					false, no space for inode alloc.
> 
> Ok, so this is a another attempt to address the problem Ye Bin
> attempted to fix here:
> 
> https://lore.kernel.org/linux-xfs/20240419061848.1032366-1-yebin10@huawei.com/
> 
> > Fix this issue by adding the bc_free_longest field to the xfs_btree_cur_t
> > structure to store the potential longest count that will be updated. The
> > assignment is done in xfs_alloc_fixup_trees() and xfs_free_ag_extent().
> 
> I outlined how this should be fixed in the above thread:
> 
> https://lore.kernel.org/linux-xfs/ZiWgRGWVG4aK1165@dread.disaster.area/
> 
> This is what I said:
> 
> | What we actually want is for pag->pagf_longest not to change
> | transiently to zero in xfs_alloc_fixup_trees(). If the delrec that
> | zeroes the pagf_longest field is going to follow it up with an
> | insrec that will set it back to a valid value, we really should not
> | be doing the zeroing in the first place.
> | 
> | Further, the only btree that tracks the right edge of the btree is
> | the by-count allocbt. This isn't "generic" functionality, even
> | though it is implemented through the generic btree code. If we lift
> | ->update_lastrec from the generic code and do it directly in
> | xfs_alloc.c whenever we are finished with a by-count tree update
> | and the cursor points to a record in the right-most leaf of the
> | tree, then we run the lastrec update directly at that point. 
> | By decoupling the lastrec updates from the individual record
> | manipulations, we can make the transients disappear completely.
> 
> I'm not sure if this patch is an attempt to implement this - there
> is no reference in the commit description to this previous attempt
> to fix the issue, nor is the any discussion of why this particular
> solution was chosen.
> 
> In future, when you are trying to fix an issue that has previously
> been discussed/presented on the list, please reference it and
> provide a link to the previous discussions in the changelog for the
> new version of the patchset fixing the issue.

Aha, that's why this seemed oddly familiar.

--D

> > Reported by: Ye Bin <yebin10@huawei.com>
> > Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c       | 14 ++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc_btree.c |  9 ++++++++-
> >  fs/xfs/libxfs/xfs_btree.h       |  1 +
> >  3 files changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 6c55a6e88eba..86ba873d57a8 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -577,6 +577,13 @@ xfs_alloc_fixup_trees(
> >  		nfbno2 = rbno + rlen;
> >  		nflen2 = (fbno + flen) - nfbno2;
> >  	}
> > +
> > +	/*
> > +	 * Record the potential maximum free length in advance.
> > +	 */
> > +	if (nfbno1 != NULLAGBLOCK || nfbno2 != NULLAGBLOCK)
> > +		cnt_cur->bc_ag.bc_free_longest = XFS_EXTLEN_MAX(nflen1, nflen2);
> > +
> 
> Why do we store the length of a random extent being freed here?
> nflen1/2 almost always have nothing to do with the longest free
> space extent in the tree, they are just the new free space extents
> we are insering into a random location in the free space tree.
> 
> >  	/*
> >  	 * Delete the entry from the by-size btree.
> >  	 */
> > @@ -2044,6 +2051,13 @@ xfs_free_ag_extent(
> >  	 * Now allocate and initialize a cursor for the by-size tree.
> >  	 */
> >  	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> > +	/*
> > +	 * Record the potential maximum free length in advance.
> > +	 */
> > +	if (haveleft)
> > +		cnt_cur->bc_ag.bc_free_longest = ltlen;
> > +	if (haveright)
> > +		cnt_cur->bc_ag.bc_free_longest = gtlen;
> 
> That doesn't look correct. At this point in the code, ltlen/gtlen
> are the sizes of the physically adjacent freespace extents that we
> are going to merge the newly freed extent with. i.e. the new
> freespace extent is going to have one of 4 possible values:
> 
> 	no merge: len
> 	left merge: ltlen + len
> 	right merge: gtlen + len
> 	both merge: ltlen + gtlen + len
> 
> So regardless of anything else, this code isn't setting the longest
> freespace extent in teh AGF to the lenght of the longest freespace
> extent in the filesystem.
> 
> Which leads me to ask: how did you test this code? This bug should
> have been triggering verifier, repair and scrub failures quite
> quickly with fstests....
> 
> >  	/*
> >  	 * Have both left and right contiguous neighbors.
> >  	 * Merge all three into a single free block.
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index 6ef5ddd89600..8e7d1e0f1a63 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -161,7 +161,14 @@ xfs_allocbt_update_lastrec(
> >  			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
> >  			len = rrp->ar_blockcount;
> >  		} else {
> > -			len = 0;
> > +			/*
> > +			 * Update in advance to prevent file creation failure
> > +			 * for concurrent processes even though there is no
> > +			 * numrec currently.
> > +			 * And there's no need to worry as the value that no
> > +			 * less than bc_free_longest will be inserted later.
> > +			 */
> > +			len = cpu_to_be32(cur->bc_ag.bc_free_longest);
> >  		}
> 
> So this is in the LASTREC_DELREC case when the last record is
> removed from the btree. This is what causes the transient state
> as we do this when deleting a record to trim it and then re-insert
> the remainder back into the by-count btree.
> 
> Writing some random transient value into the AGF *and journalling
> it* means we creating a transient on-disk format structure
> corruption and potentially writing it to persistent storage (i.e.
> the journal). The structure is, at least, not consistent in memory
> because the free space tree is empty at this point in time, whilst
> the agf->longest field says it has a free space available. This
> could trip verifiers, be flagged as corruption by xfs_scrub/repair,
> etc.
> 
> Now, this *might be safe* because we *may* clean it up later in the
> transaction, but if this really is the last extent being removed
> from the btree and a cursor has previously been used to do other
> insert and free operations that set this field, then we trip over
> this stale inforamtion and write a corrupt structure to disk. That's
> not good.
> 
> As I said above, this "last record tracking" needs to be ripped out
> of the generic btree code because only the by-count btree uses it.
> Then it can be updated at the end of the by-count btree update
> process in the allocation code (i.e. after all record manipulations
> are done in the transaction) and that avoids this transient caused
> by updating the last record on every btree record update that is
> done.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
