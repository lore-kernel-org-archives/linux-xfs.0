Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD48C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 23:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiCIXeG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiCIXeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 18:34:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8EB25587
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 15:33:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D07B8B82233
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 23:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B50C340F5;
        Wed,  9 Mar 2022 23:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646868783;
        bh=Lt1QyWh4JL/z/A0bBhXw0vAta07k3rCjSxYbMLHh4og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VzZNQzHnl12XvwkuwSX1cb3GORp27mvbqDiIhRQfTFF62kcySpeEKqluQ1a/iGIKm
         q8VTQFilHSj8CuGW/o4hUk0lcGZVeRuBQE94rZQ17KpeDi8ru6AiogqKyxkxvldFHN
         P54W9II2vC0HnBwlAmfPHiL14y22PPEMFjdcfmUsz/QqbOTcUwyyFW7Pja5I5ytfnD
         HHSqIrSMHXDBTdgjIDgdqkPDHxE2jqcYcMMWGoLo4+6EeV3MIwV/RnlI3zFTbE6I31
         yxYHvk3mk6uVqbE3z2oe934lvIMjNEGJ8w/n8KBpMDkbTL9LVdSJpE13EvcSnGXCiI
         Ffr5ou5HRasow==
Date:   Wed, 9 Mar 2022 15:33:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: reserve quota for dir expansion when
 linking/unlinking files
Message-ID: <20220309233302.GE8224@magnolia>
References: <164685374120.495923.2523387358442198692.stgit@magnolia>
 <164685374682.495923.2923492909223420951.stgit@magnolia>
 <20220309214821.GH661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309214821.GH661808@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 08:48:21AM +1100, Dave Chinner wrote:
> On Wed, Mar 09, 2022 at 11:22:26AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS does not reserve quota for directory expansion when linking or
> > unlinking children from a directory.  This means that we don't reject
> > the expansion with EDQUOT when we're at or near a hard limit, which
> > means that unprivileged userspace can use link()/unlink() to exceed
> > quota.
> > 
> > The fix for this is nuanced -- link operations don't always expand the
> > directory, and we allow a link to proceed with no space reservation if
> > we don't need to add a block to the directory to handle the addition.
> > Unlink operations generally do not expand the directory (you'd have to
> > free a block and then cause a btree split) and we can defer the
> > directory block freeing if there is no space reservation.
> > 
> > Moreover, there is a further bug in that we do not trigger the blockgc
> > workers to try to clear space when we're out of quota.
> > 
> > To fix both cases, create a new xfs_trans_alloc_dir function that
> > allocates the transaction, locks and joins the inodes, and reserves
> > quota for the directory.  If there isn't sufficient space or quota,
> > we'll switch the caller to reservationless mode.  This should prevent
> > quota usage overruns with the least restriction in functionality.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c |   30 +++++-------------
> >  fs/xfs/xfs_trans.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_trans.h |    3 ++
> >  3 files changed, 97 insertions(+), 22 deletions(-)
> 
> Overall looks good, minor nits below:
> 
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 04bf467b1090..a131bbfe74e4 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1217,7 +1217,7 @@ xfs_link(
> >  {
> >  	xfs_mount_t		*mp = tdp->i_mount;
> >  	xfs_trans_t		*tp;
> > -	int			error;
> > +	int			error, space_error;
> >  	int			resblks;
> >  
> >  	trace_xfs_link(tdp, target_name);
> > @@ -1236,19 +1236,11 @@ xfs_link(
> >  		goto std_return;
> >  
> >  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
> > -	if (error == -ENOSPC) {
> > -		resblks = 0;
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
> > -	}
> > +	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
> > +			&tp, &space_error);
> 
> It's the nospace_error, isn't it? The code reads a lot better when
> it's called that, too.

Fixed.

> 
> >  	if (error)
> >  		goto std_return;
> >  
> > -	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
> > -
> > -	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> > -
> >  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> >  			XFS_IEXT_DIR_MANIP_CNT(mp));
> >  	if (error)
> > @@ -1267,6 +1259,8 @@ xfs_link(
> >  
> >  	if (!resblks) {
> >  		error = xfs_dir_canenter(tp, tdp, target_name);
> > +		if (error == -ENOSPC && space_error)
> > +			error = space_error;
> 
> This  would be better in the error_return stack, I think. That way
> the transformation only has to be done once, and it will be done for
> all functions that can potentially return ENOSPC.

Ok.

> >  		if (error)
> >  			goto error_return;
> >  	}
> > @@ -2755,6 +2749,7 @@ xfs_remove(
> >  	xfs_mount_t		*mp = dp->i_mount;
> >  	xfs_trans_t             *tp = NULL;
> >  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
> > +	int			dontcare;
> >  	int                     error = 0;
> >  	uint			resblks;
> >  
> > @@ -2781,22 +2776,13 @@ xfs_remove(
> >  	 * block from the directory.
> >  	 */
> >  	resblks = XFS_REMOVE_SPACE_RES(mp);
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
> > -	if (error == -ENOSPC) {
> > -		resblks = 0;
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
> > -				&tp);
> > -	}
> > +	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
> > +			&tp, &dontcare);
> >  	if (error) {
> >  		ASSERT(error != -ENOSPC);
> >  		goto std_return;
> >  	}
> 
> So we just ignore -EDQUOT when it is returned in @dontcare? I'd like
> a comment to explain why we don't care about EDQUOT here, because
> the next time I look at this I will have forgotten all about this...

Ok.  How about:

	/*
	 * We try to get the real space reservation first, allowing for
	 * directory btree deletion(s) implying possible bmap insert(s).
	 * If we can't get the space reservation then we use 0 instead,
	 * and avoid the bmap btree insert(s) in the directory code by,
	 * if the bmap insert tries to happen, instead trimming the LAST
	 * block from the directory.
	 *
	 * Ignore EDQUOT and ENOSPC being returned via nospace_error
	 * because the directory code can handle a reservationless
	 * update and we don't want to prevent a user from trying to
	 * free space by deleting things.
	 */
	error = xfs_trans_alloc_dir(...);

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
