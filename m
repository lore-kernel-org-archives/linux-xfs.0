Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A4AC433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D923864DA9
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343553AbhA0RVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhA0RUf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jan 2021 12:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 533DD64D99;
        Wed, 27 Jan 2021 17:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611767994;
        bh=E7HoDvLDBIPU0YObMTnIEYMs8EIMFfjSFRfGVZYpsgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WEsGN1mBPg5al0hQp2ZgIraLsGmNOzFMiMUgYCPWCkI2NQIo36rXxHukAOA3/X9/i
         SPifMU0Ia5UTxfgdXovxrGhZtjtBxayPmIbgAsmEh3wNDwTjUxkc+bpF8eEqkgk0oz
         IFn4DGs+FO0GMbzqfLIJL20EqIxoWZZGu4pOPeTghExD7CtBa4a6i4Kd386T4rexGO
         von7MsmI8d15HXoO3tU4XLJRJdMLA3Py24H6rIFEieRUnroP5/iXRCg4RQ+CzfiujW
         heJVE01itl571Q6nx8GrDubV2aC2nyx7SxaqXAA7w5QcXzZImtW+AuPc5aJXNwMcaB
         oLN+68Gh4UnSQ==
Date:   Wed, 27 Jan 2021 09:19:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210127171953.GJ7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142795294.2171939.2305516748220731694.stgit@magnolia>
 <20210124093953.GC670331@infradead.org>
 <20210125181623.GL2047559@bfoster>
 <20210125185735.GB7698@magnolia>
 <20210126132600.GB2158252@bfoster>
 <20210126211259.GB7698@magnolia>
 <20210127141910.GA2549435@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127141910.GA2549435@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 09:19:10AM -0500, Brian Foster wrote:
> On Tue, Jan 26, 2021 at 01:12:59PM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 26, 2021 at 08:26:00AM -0500, Brian Foster wrote:
> > > On Mon, Jan 25, 2021 at 10:57:35AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Jan 25, 2021 at 01:16:23PM -0500, Brian Foster wrote:
> > > > > On Sun, Jan 24, 2021 at 09:39:53AM +0000, Christoph Hellwig wrote:
> > > > > > > +	/* We only allow one retry for EDQUOT/ENOSPC. */
> > > > > > > +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> > > > > > > +		*retry = false;
> > > > > > > +		return error;
> > > > > > > +	}
> > > > > > 
> > > > > > > +	/* Release resources, prepare for scan. */
> > > > > > > +	xfs_trans_cancel(*tpp);
> > > > > > > +	*tpp = NULL;
> > > > > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > > > +
> > > > > > > +	/* Try to free some quota for this file's dquots. */
> > > > > > > +	*retry = true;
> > > > > > > +	xfs_blockgc_free_quota(ip, 0);
> > > > > > > +	return 0;
> > > > > > 
> > > > > > I till have grave reservations about this calling conventions.  And if
> > > > > > you just remove the unlock and th call to xfs_blockgc_free_quota here
> > > > > > we don't equire a whole lot of boilerplate code in the callers while
> > > > > > making the code possible to reason about for a mere human.
> > > > > > 
> > > > > 
> > > > > I agree that the retry pattern is rather odd. I'm curious, is there a
> > > > > specific reason this scanning task has to execute outside of transaction
> > > > > context in the first place?
> > > > 
> > > > Dave didn't like the open-coded retry and told me to shrink the call
> > > > sites to:
> > > > 
> > > > 	error = xfs_trans_reserve_quota(...);
> > > > 	if (error)
> > > > 		goto out_trans_cancel;
> > > > 	if (quota_retry)
> > > > 		goto retry;
> > > > 
> > > > So here we are, slowly putting things almost all the way back to where
> > > > they were originally.  Now I have a little utility function:
> > > > 
> > > > /*
> > > >  * Cancel a transaction and try to clear some space so that we can
> > > >  * reserve some quota.  The caller must hold the ILOCK; when this
> > > >  * function returns, the transaction will be cancelled and the ILOCK
> > > >  * will have been released.
> > > >  */
> > > > int
> > > > xfs_trans_cancel_qretry(
> > > > 	struct xfs_trans	*tp,
> > > > 	struct xfs_inode	*ip)
> > > > {
> > > > 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > > > 
> > > > 	xfs_trans_cancel(tp);
> > > > 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > 
> > > > 	return xfs_blockgc_free_quota(ip, 0);
> > > > }
> > > > 
> > > > Which I guess reduces the amount of call site boilerplate from 4 lines
> > > > to two, only now I've spent half of last week on this.
> > > > 
> > > > > Assuming it does because the underlying work
> > > > > may involve more transactions or whatnot, I'm wondering if this logic
> > > > > could be buried further down in the transaction allocation path.
> > > > > 
> > > > > For example, if we passed the quota reservation and inode down into a
> > > > > new variant of xfs_trans_alloc(), it could acquire the ilock and attempt
> > > > > the quota reservation as a final step (to avoid adding an extra
> > > > > unconditional ilock cycle). If quota res fails, iunlock and release the
> > > > > log res internally and perform the scan. From there, perhaps we could
> > > > > retry the quota reservation immediately without logres or the ilock by
> > > > > saving references to the dquots, and then only reacquire logres/ilock on
> > > > > success..? Just thinking out loud so that might require further
> > > > > thought...
> > > > 
> > > > Yes, that's certainly possible, and probably a good design goal to have
> > > > a xfs_trans_alloc_quota(tres, ip, whichfork, nblks, &tp) that one could
> > > > call to reserve a transaction, lock the inode, and reserve the
> > > > appropriate amounts of quota to handle mapping nblks into an inode fork.
> > > > 
> > > > However, there are complications that don't make this a trivial switch:
> > > > 
> > > > 1. Reflink and (new) swapext don't actually know how many blocks they
> > > > need to reserve until after they've grabbed the two ILOCKs, which means
> > > > that the wrapper is of no use here.
> > > > 
> > > 
> > > IMO, it's preferable to define a clean/usable interface if we can find
> > > one that covers the majority of use cases and have to open code a
> > > handful of outliers than define a cumbersome interface that must be used
> > > everywhere to accommodate the outliers. Perhaps we'll find cleaner ways
> > > to deal with open coded outliers over time..?
> > 
> > Sure, we might, but let's not delay this cleanup, since these are the
> > last two pieces that I need to get merged before I can send out deferred
> > inode inactivation for review.  Deferred inode inactivation adds yet
> > another button that we can push to reclaim free space when something hits
> > EDQUOT/ENOSPC.
> > 
> 
> Not sure I see the need to rush in a particular interface that multiple
> reviewers have expressed reservations about just because there are more
> patches coming built on top. That just creates more churn and cleanup
> work for later, which means more review/test cycles and more work
> indirectly for people who might have to deal with backports, etc. I'm
> not dead set against what this patch does if there's no better
> alternative, but IMO it's better to get it right than get it fast so we
> should at least give fair consideration to some alternatives if ideas
> are being presented.
> 
> > FWIW I did start down the path of building a better interface last week,
> > but quickly became mired in (1) how do we allocate rt quota with a new
> > interface and (2) do we care?  And then I started looking at what rt
> > allocations do wrt quota and decided that fixing that (or even removing
> > it) would be an entire patchset.
> > 
> > Hence I'm trying to constrain this patchset to updating the existing
> > callsites to do the scan+retry, and no more.
> > 
> 
> Ok, well I think that helps me understand the situation, but I'm still
> not really following if/how that conflicts with any of the previous
> suggestions (which is why I was asking for example code to consider).
> 
> > > Perhaps (at least in the
> > > reflink case) we could attempt a worst case quota reservation with the
> > > helper, knowing that it will have invoked the scan on -EDQUOT, and then
> > > fall back to a more accurate open-coded xfs_trans_reserve_() call (that
> > > will no longer fall into retry loops on failure)..?
> > 
> > Making a worst case reservation and backing off creates more ways for
> > things to fail unnecessarily.
> > 
> > For a remap operation, the worst case is if the source file range has an
> > allocated mapping and the destination file range is a hole, because we
> > have to increment quota by the size of that allocated mapping.  If we
> > run out of quota we'll have to flush the fs and try again.  If we fail
> > the quota reservation a second time, the whole operation fails.
> > 
> 
> Right...
> 
> > This is not good behavior for all the other cases -- if both mappings
> > are holes or both allocated, we just failed an operation that would have
> > made no net change to the quota allocations.  If the source file range
> > is a hole and the destination range is allocated, we actually would have
> > /decreased/ the quota usage, but instead we fail with EDQUOT.
> > 
> 
> But that wasn't the suggestion. The suggestion was to do something along
> the lines of the following in the reflink case:
> 
> 	error = xfs_trans_alloc_quota(..., ip, resblks, worstqres, ...);
> 	if (error == -EDQUOT) {
> 		worstqres = 0;
> 		error = xfs_trans_alloc(..., resblks, ...);
> 		...
> 	}

OH.  I misread that sentence with "fall back to a more accurate reserve
call", and totally thought that your suggestion was to use
xfs_trans_alloc_quota on its own, then later when we know how much quota
we really want, using xfs_trans_reserve_quota to adjust the transaction.

I am totally ok with doing it this way.

> 	if (!worstqres) {
> 		worstqres = <calculate actual quota res>
> 		error = xfs_trans_reserve_quota(...);
> 		if (error)
> 			return error;
> 	}
> 
> 	...
> 
> ... where the initial transaction allocation failure would have failed
> on the worst case qres, but also would have run the internal reclaim
> scan and retried before it returned. Therefore, we could still attempt
> the open coded non-worst case reservation and either proceed or return
> -EDQUOT with generally similar scan->retry semantics as this patch, just
> without the open coded goto loops everywhere we attach quota reservation
> to a transaction. This of course assumes that the
> xfs_trans_alloc_quota() interface works well enough for the majority of
> other cases without need for open coded reservation...

I think it will.

> > Right now the remap code handles those cases just fine, at a cost of
> > open coded logic.
> > 
> > > > 2. For the remaining quota reservation callsites, you have to deal with
> > > > the bmap code that computes qblocks for reservation against the realtime
> > > > device.  This is opening a huge can of worms because:
> > > > 
> > > > 3. Realtime and quota are not supported, which means that none of that
> > > > code ever gets properly QA'd.  It would be totally stupid to rework most
> > > > of the quota reservation callsites and still leave that logic bomb.
> > > > This gigantic piece of technical debt needs to be paid off, either by
> > > > fixing the functionality and getting it under test, or by dropping rt
> > > > quota support completely and officially.
> > > > 
> > > 
> > > I'm not following what you're referring to here. Can you point to
> > > examples in the code for reference, please?
> > 
> > If you format a filesystem with realtime and mount it with -oquota, xfs
> > will ignore the 'quota' mount option completely.  Some code exists to
> > do rt quota accounting (xfs_alloc_file_space and xfs_iomap_write_direct
> > are examples) but since we never allow rt+quota, the code coverage on
> > that is 0%.
> > 
> 
> Ok, but how is that any different for what this patch does?

In the end there isn't any practical difference; I had to get over my
reluctance to fiddle around with code that can't ever be run.  Whatever
the state of rt quota, at least users can't get to it.

With that... between the long delivery delays and replies arriving out
of order and with unpredictable lag time, it might just be time for me
to tidy up my patchsets and send a v5.

--D

> Brian
> 
> > I've also noticed that those functions seem to have this odd behavior
> > where for rt files, they'll reserve quota for the allocated blocks
> > themselves but not the bmbt blocks; but for regular files, they reserve
> > quota for both the allocated blocks and the bmbt blocks.  The quota code
> > makes various allowances for transactions that try to commit quota count
> > updates but have zero quota reservation attached to the transaction,
> > which I /think/ could have been an attempt to work around that quirk.
> > 
> > I also just noticed that xfs_bmapi_reserve_delalloc only works with
> > non-rt files.  I guess that's fine since rt files don't use the delalloc
> > mechanism anyway (and I think the  reason they don't is that xfs can't
> > currently do write-around to handle rextsize>1 filesystems) but that's
> > another mess to sort.
> > 
> > (FWIW I'm slowly working through all those rt issues as part of maturing
> > the rt reflink patchset, but that's at the far end of my dev tree...)
> > 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > My guess is that fixing rt quota is probably going to take 10-15
> > > > patches, and doing more small cleanups to convert the callsites will be
> > > > another 10 or so.
> > > > 
> > > > 4. We're already past -rc5, and what started as two cleanup patchsets of
> > > > 13 is now four patchsets of 27 patches, and I /really/ would just like
> > > > to get these patches merged without expanding the scope of work even
> > > > further.
> > > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > 
> > > 
> > 
> 
