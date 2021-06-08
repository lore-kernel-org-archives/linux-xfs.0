Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CF8C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1E961285
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFHPd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhFHPd6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 11:33:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BC5461002;
        Tue,  8 Jun 2021 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623166325;
        bh=AH50cGBOsVSK+LqZLvtbIERNmL3FH/UMWjc8Ju6Y0yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HS5OsHyP9dbdpDjPRQzO4WzSAP9cTng51zNhl0CNgaBw2ow2HqoNaWLdkGJ2fACdC
         ugCxPncl0gJTfex0FRB7k04zykkshrkkyGr1kAYgDyoaklEKh2V/zA7gx0ZwyqRWA7
         twiNEeqqvRiIRWB8UnhPo4wLpNpdMh8e72tVKlurwlmRZxNk9xkxpNtB38ve4jhpSH
         EgbkFRANYj45um5cCR3sN0dPTMOz7/mlI6VgPUP+MzCvAaGDaMX9XoNYt7FfgImaTb
         CtQ6gZ93atbZ2hM6Z6fgjD6hE6Uqod63XTqq6iSUef0quRB20KZCswiWz5zNmnfVMt
         9ED4RyJZSqQxQ==
Date:   Tue, 8 Jun 2021 08:32:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/9] xfs: force inode garbage collection before fallocate
 when space is low
Message-ID: <20210608153204.GS2945738@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310472140.3465262.3509717954267805085.stgit@locust>
 <20210608012605.GI664593@dread.disaster.area>
 <YL9Y9YM6VtxSnq+c@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL9Y9YM6VtxSnq+c@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 07:48:05AM -0400, Brian Foster wrote:
> On Tue, Jun 08, 2021 at 11:26:05AM +1000, Dave Chinner wrote:
> > On Mon, Jun 07, 2021 at 03:25:21PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Generally speaking, when a user calls fallocate, they're looking to
> > > preallocate space in a file in the largest contiguous chunks possible.
> > > If free space is low, it's possible that the free space will look
> > > unnecessarily fragmented because there are unlinked inodes that are
> > > holding on to space that we could allocate.  When this happens,
> > > fallocate makes suboptimal allocation decisions for the sake of deleted
> > > files, which doesn't make much sense, so scan the filesystem for dead
> > > items to delete to try to avoid this.
> > > 
> > > Note that there are a handful of fstests that fill a filesystem, delete
> > > just enough files to allow a single large allocation, and check that
> > > fallocate actually gets the allocation.  These tests regress because the
> > > test runs fallocate before the inode gc has a chance to run, so add this
> > > behavior to maintain as much of the old behavior as possible.
> > 
> > I don't think this is a good justification for the change. Just
> > because the unit tests exploit an undefined behaviour that no
> > filesystem actually guarantees to acheive a specific layout, it
> > doesn't mean we always have to behave that way.
> > 
> > For example, many tests used to use reverse sequential writes to
> > exploit deficiencies in the allocation algorithms to generate
> > fragmented files. We fixed that problem and the tests broke because
> > they couldn't fragment files any more.
> > 
> > Did we reject those changes because the tests broke? No, we didn't
> > because the tests were exploiting an observed behaviour rather than
> > a guaranteed behaviour.
> > 
> > So, yeah, "test does X to make Y happen" doesn't mean "X will always
> > make Y happen". It just means the test needs to be made more robust,
> > or we have to provide a way for the test to trigger the behaviour it
> > needs.
> > 
> 
> Agree on all this..
> 
> > Indeed, I think that the way to fix these sorts of issues is to have
> > the tests issue a syncfs(2) after they've deleted the inodes and have
> > the filesystem run a inodegc flush as part of the sync mechanism.
> > 
> 
> ... but it seems a bit of a leap to equate exploitation of a
> historically poorly handled allocation pattern in developer tests with
> adding a new requirement (i.e. sync) to achieve optimal behavior of a
> fairly common allocation pattern (delete a file, use the space for
> something else).
> 
> IOW, how to hack around test regressions aside (are the test regressions
> actual ENOSPC failures or something else, btw?), what's the impact on

They're not ENOSPC failures, they're fallocate layout tests that assume
that you can format the fs with a stripe alignment, fragment the free
space so that it isn't possible to obtain stripe-aligned blocks, delete
80% of the file(s) you used to fragment the free space, and fallocate a
stripe-aligned extent from the newly freed space in one go after the
last unlink() returns.  Unfortunately, I don't remember which test it
was that tripped over this.

IOWs, tests that confirm the historic behavior of XFS (and presumably
other filesystems) even though we don't guarantee anything about file
layout and never have.  This is a similar issue to the one Dave
complains about a few patches ago about needing to kick the inodegc
workers so that df reporting behavior stays the same as it has been on
xfs for ages.

We /might/ have figured out a solution to some of that nastiness.

> users/workloads that might operate under these conditions? I guess
> historically we've always recommended to not consistently operate in
> <20% free space conditions, so to some degree there is an expectation
> for less than optimal behavior if one decides to constantly bash an fs
> into ENOSPC. Then again with large enough files, will/can we put the
> filesystem into that state ourselves without any indication to the user?
> 
> I kind of wonder if unless/until there's some kind of efficient feedback
> between allocation and "pending" free space, whether deferred
> inactivation should be an optimization tied to some kind of heuristic
> that balances the amount of currently available free space against
> pending free space (but I've not combed through the code enough to grok
> whether this already does something like that).

Ooh!  You mentioned "efficient feedback", and one sprung immediately to
mind -- if the AG is near full (or above 80% full, or whatever) we
schedule the per-AG inodegc worker immediately instead of delaying it.

--D

> 
> Brian
> 
> > Then we don't need to do.....
> > 
> > > +/*
> > > + * If the target device (or some part of it) is full enough that it won't to be
> > > + * able to satisfy the entire request, try to free inactive files to free up
> > > + * space.  While it's perfectly fine to fill a preallocation request with a
> > > + * bunch of short extents, we prefer to slow down preallocation requests to
> > > + * combat long term fragmentation in new file data.
> > > + */
> > > +static int
> > > +xfs_alloc_consolidate_freespace(
> > > +	struct xfs_inode	*ip,
> > > +	xfs_filblks_t		wanted)
> > > +{
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	struct xfs_perag	*pag;
> > > +	struct xfs_sb		*sbp = &mp->m_sb;
> > > +	xfs_agnumber_t		agno;
> > > +
> > > +	if (!xfs_has_inodegc_work(mp))
> > > +		return 0;
> > > +
> > > +	if (XFS_IS_REALTIME_INODE(ip)) {
> > > +		if (sbp->sb_frextents * sbp->sb_rextsize >= wanted)
> > > +			return 0;
> > > +		goto free_space;
> > > +	}
> > > +
> > > +	for_each_perag(mp, agno, pag) {
> > > +		if (pag->pagf_freeblks >= wanted) {
> > > +			xfs_perag_put(pag);
> > > +			return 0;
> > > +		}
> > > +	}
> > 
> > ... really hurty things (e.g. on high AG count fs) on every fallocate()
> > call, and we have a simple modification to the tests that allow them
> > to work as they want to on both old and new kernels....
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
