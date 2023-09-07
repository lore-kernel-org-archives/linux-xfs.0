Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1481EC874D
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Sep 2023 18:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbjIGShX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjIGShV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 14:37:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D09CF
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 11:37:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919C7C433C8;
        Thu,  7 Sep 2023 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694111413;
        bh=knH1Ocg3yQpCN6QrtfSTTvAJxJ/MH1bB2EUgO5/Brr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UFV6k5UgREJLA2ov4dMxzme0m6F/oYm/L1wdQbdmrahBkN/CVAK6PZMjMJu5Xw5gn
         p4kYAN0xv9pT7+WGGxjZ8fgrQ2oKZBr5c9un7ud2Of8uUvHMdXiYb2GjSpccMAOUQ2
         tY95K1CYCKP3X9dPV+aY5uilH0et6ZjnEyumPE6jl5AYWzJwFOTH482hmnt+L179Oy
         ifMZ7wemTLsMXxa3Uqr+X08N43lIPkEOeYsvITWk+6it+U2NQTDFvO4Qu+9Y6iEvxe
         ePgA+2ACogyhbh329/FeZrVQnEp6iHo0sVEY+erwxyodQ8hyMPblmYi0+NnQM6i3GT
         +LXOlZ2d0Ebzw==
Date:   Thu, 7 Sep 2023 11:30:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: reload entire unlinked bucket lists
Message-ID: <20230907183012.GM28202@frogsfrogsfrogs>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375775896.3323693.9893712061608339722.stgit@frogsfrogsfrogs>
 <ZPl1dFZFlNtWIMpD@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPl1dFZFlNtWIMpD@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2023 at 05:02:12PM +1000, Dave Chinner wrote:
> On Sun, Sep 03, 2023 at 09:15:59AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The previous patch to reload unrecovered unlinked inodes when adding a
> > newly created inode to the unlinked list is missing a key piece of
> > functionality.  It doesn't handle the case that someone calls xfs_iget
> > on an inode that is not the last item in the incore list.  For example,
> > if at mount time the ondisk iunlink bucket looks like this:
> > 
> > AGI -> 7 -> 22 -> 3 -> NULL
> > 
> > None of these three inodes are cached in memory.  Now let's say that
> > someone tries to open inode 3 by handle.  We need to walk the list to
> > make sure that inodes 7 and 22 get loaded cold, and that the
> > i_prev_unlinked of inode 3 gets set to 22.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_export.c |    6 +++
> >  fs/xfs/xfs_inode.c  |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_inode.h  |    9 +++++
> >  fs/xfs/xfs_itable.c |    9 +++++
> >  fs/xfs/xfs_trace.h  |   20 ++++++++++
> >  5 files changed, 144 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> > index 1064c2342876..f71ea786a6d2 100644
> > --- a/fs/xfs/xfs_export.c
> > +++ b/fs/xfs/xfs_export.c
> > @@ -146,6 +146,12 @@ xfs_nfs_get_inode(
> >  		return ERR_PTR(error);
> >  	}
> >  
> > +	error = xfs_inode_reload_unlinked(ip);
> > +	if (error) {
> > +		xfs_irele(ip);
> > +		return ERR_PTR(error);
> > +	}
> 
> We don't want to be creating an empty transaction, locking the inode
> and then cancelling the transaction having done nothing on every
> NFS handle we have to resolve. We only want to do this if the link
> count is zero and i_prev_unlinked == 0, at which point we can then
> take the slow path (i.e call xfs_inode_reload_unlinked()) to reload
> the unlinked list. Something like:

Hmm.  Using an unlocked check here makes me nervous, since we could be
racing with another thread that is unlinking the inode.  OTOH, this code
doesn't start *changing* any incore state until it's taken ILOCK_SHARED
and locked the AGI buffer to stabilize @ip's unlinked list.

So.  I think it's ok to do the unlocked check here like you propose:

> 	if (xfs_inode_unlinked_incomplete(ip)) {
> 		error = xfs_inode_reload_unlinked(ip);
> 		if (error) {
> 			xfs_irele(ip);
> 			return ERR_PTR(error);
> 		}
> 	}

Though I want to add one more xfs_inode_unlinked_incomplete call inside
xfs_inode_reload_unlinked_bucket to skip the list walk if we take the
locks only to find that someone else fixed it up for us.

> Hmmmm.  if i_nlink is zero on ip and we call xfs_irele() on it, the
> it will be punted straight to inactivation, which will try to remove
> it from the unlinked list and free it. But we just failed to reload
> the unlinked list, so inactivation is going to go badly...
> 
> So on reload error, shouldn't we be shutting down the filesystem
> because we know we cannot safely remove this inode from the unlinked
> list and free it?

I think the iunlink lookup failure will take down the filesystem for
us when inactivation runs on @ip, but you're right, we should shut down
immediately so that the stack trace will show xfs_nfs_get_inode and not
just a background thread.

> > +
> >  	if (VFS_I(ip)->i_generation != generation) {
> >  		xfs_irele(ip);
> >  		return ERR_PTR(-ESTALE);
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 6cd2f29b540a..56f6bde6001b 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3607,3 +3607,103 @@ xfs_iunlock2_io_mmap(
> >  	if (ip1 != ip2)
> >  		inode_unlock(VFS_I(ip1));
> >  }
> > +
> > +/*
> > + * Reload the incore inode list for this inode.  Caller should ensure that
> > + * the link count cannot change, either by taking ILOCK_SHARED or otherwise
> > + * preventing other threads from executing.
> > + */
> > +int
> > +xfs_inode_reload_unlinked_bucket(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_buf		*agibp;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_perag	*pag;
> > +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> > +	xfs_agino_t		prev_agino, next_agino;
> > +	unsigned int		bucket;
> > +	bool			foundit = false;
> > +	int			error;
> > +
> > +	/* Grab the first inode in the list */
> > +	pag = xfs_perag_get(mp, agno);
> > +	error = xfs_ialloc_read_agi(pag, tp, &agibp);
> > +	xfs_perag_put(pag);
> > +	if (error)
> > +		return error;
> > +
> > +	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
> > +	agi = agibp->b_addr;
> > +
> > +	trace_xfs_inode_reload_unlinked_bucket(ip);
> > +
> > +	xfs_info_ratelimited(mp,
> > + "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating list recovery.",
> > +			agino, agno);
> > +
> > +	prev_agino = NULLAGINO;
> > +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> > +	while (next_agino != NULLAGINO) {
> > +		struct xfs_inode	*next_ip = NULL;
> > +
> > +		if (next_agino == agino) {
> > +			/* Found this inode, set its backlink. */
> > +			next_ip = ip;
> > +			next_ip->i_prev_unlinked = prev_agino;
> > +			foundit = true;
> > +		}
> > +		if (!next_ip) {
> > +			/* Inode already in memory. */
> > +			next_ip = xfs_iunlink_lookup(pag, next_agino);
> > +		}
> > +		if (!next_ip) {
> > +			/* Inode not in memory, reload. */
> > +			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
> > +					next_agino);
> > +			if (error)
> > +				break;
> > +
> > +			next_ip = xfs_iunlink_lookup(pag, next_agino);
> > +		}
> > +		if (!next_ip) {
> > +			/* No incore inode at all?  We reloaded it... */
> > +			ASSERT(next_ip != NULL);
> > +			error = -EFSCORRUPTED;
> > +			break;
> > +		}
> 
> Not a great fan of this logic construct, nor am I great fan of
> asking you to restructure code for vanity reasons. However, I do
> think a goto improves it quite a lot:
> 
> 	while (next_agino != NULLAGINO) {
> 		struct xfs_inode	*next_ip = NULL;
> 
> 		if (next_agino == agino) {
> 			/* Found this inode, set its backlink. */
> 			next_ip = ip;
> 			next_ip->i_prev_unlinked = prev_agino;
> 			foundit = true;
> 			goto next_inode;
> 		}
> 
> 		/* Try in-memory lookup first. */
> 		next_ip = xfs_iunlink_lookup(pag, next_agino);
> 		if (next_ip)
> 			goto next_inode;
> 
> 		/* Inode not in memory, try reloading it. */
> 		error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
> 				next_agino);
> 		if (error)
> 			break;
> 
> 		/* Grab the reloaded inode */
> 		next_ip = xfs_iunlink_lookup(pag, next_agino);
> 		if (!next_ip) {
> 			/* No incore inode at all, list must be corrupted. */
> 			ASSERT(next_ip != NULL);
> 			error = -EFSCORRUPTED;
> 			break;
> 		}
> next_inode:
> 		prev_agino = next_agino;
> 		next_agino = next_ip->i_next_unlinked;
> 	}
> 
> If you think it's better, feel free to use this. Otherwise I can
> live with the code until I have to touch this code again...
> 
> ......

I'll use it, thanks.  It /does/ make the loop body easier to understand
since there are fewer "uhh when *is* next_ip null?" questions.

> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index f225413a993c..ea38d69b9922 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -80,6 +80,15 @@ xfs_bulkstat_one_int(
> >  	if (error)
> >  		goto out;
> >  
> > +	if (xfs_inode_unlinked_incomplete(ip)) {
> > +		error = xfs_inode_reload_unlinked_bucket(tp, ip);
> > +		if (error) {
> > +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +			xfs_irele(ip);
> > +			return error;
> > +		}
> > +	}
> 
> Same question here about shutdown on error being necessary....

Will add a xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE) call here
too.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
