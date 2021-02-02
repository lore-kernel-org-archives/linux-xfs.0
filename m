Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A775FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 16:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B2464F72
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 16:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhBBQ4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 11:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236945AbhBBQyj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 11:54:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D85C64E9A;
        Tue,  2 Feb 2021 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284838;
        bh=LnlwFCD0mcOuCD4hOyuzXNpADb3VoFIkgV7Ir1BojhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nO+eRpTJAlECYdlM/Mfg7N4Ojp9TVqwoomuIV4FeHh/+qEB2dwh7Aq7x9iF42n/fY
         aHsUNl+U1kyPk9hwhbaE4ElYsWduQATGfCstLziICiaLvBZZxXF0i3J9B+IU97/EtT
         rUViWQlh7Gpxozg1QjNIv2C4qUkoO1Jt7pkc13w/qyAWpQj+CXkymkRcy+bOLsYjjb
         OWefQDDFDVPjmxIfUL3lBdo1lfCnzvga2EKkAr9aXXpYvafBd1GGpBXawL5dPzokrd
         9Rl6IYweJCxK3sYOT3qKNjUqBxSfOUlbMBsDSsC1xq2QH2LjEaiORJoRFVzfH73AAf
         Yk8KRCYwEkdbA==
Date:   Tue, 2 Feb 2021 08:53:58 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210202165358.GL7193@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214516600.140945.4401509001858536727.stgit@magnolia>
 <20210202153859.GG3336100@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202153859.GG3336100@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 10:38:59AM -0500, Brian Foster wrote:
> On Sun, Jan 31, 2021 at 06:06:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a fs modification (data write, reflink, xattr set, fallocate, etc.)
> > is unable to reserve enough quota to handle the modification, try
> > clearing whatever space the filesystem might have been hanging onto in
> > the hopes of speeding up the filesystem.  The flushing behavior will
> > become particularly important when we add deferred inode inactivation
> > because that will increase the amount of space that isn't actively tied
> > to user data.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> (FWIW, I'm reviewing the patches from your reclaim-space-harder-5.12
> branch as of this morning, which look like they have some deltas from
> the posted versions based on Christoph's feedback.)

Yes, it does. :(

I pushed the branches and had sent the first of the two patchsets
last night, and then the power went out so I gave up and went to bed.

But thanks for the review. :)

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  fs/xfs/xfs_reflink.c |    5 +++++
> >  fs/xfs/xfs_trans.c   |   10 ++++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 086866f6e71f..725c7d8e4438 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1092,6 +1092,11 @@ xfs_reflink_remap_extent(
> >  	 * count.  This is suboptimal, but the VFS flushed the dest range
> >  	 * before we started.  That should have removed all the delalloc
> >  	 * reservations, but we code defensively.
> > +	 *
> > +	 * xfs_trans_alloc_inode above already tried to grab an even larger
> > +	 * quota reservation, and kicked off a blockgc scan if it couldn't.
> > +	 * If we can't get a potentially smaller quota reservation now, we're
> > +	 * done.
> >  	 */
> >  	if (!quota_reserved && !smap_real && dmap_written) {
> >  		error = xfs_trans_reserve_quota_nblks(tp, ip,
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 466e1c86767f..f62c1c5f210f 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -23,6 +23,7 @@
> >  #include "xfs_inode.h"
> >  #include "xfs_dquot_item.h"
> >  #include "xfs_dquot.h"
> > +#include "xfs_icache.h"
> >  
> >  kmem_zone_t	*xfs_trans_zone;
> >  
> > @@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
> >  {
> >  	struct xfs_trans	*tp;
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	bool			retried = false;
> >  	int			error;
> >  
> > +retry:
> >  	error = xfs_trans_alloc(mp, resv, dblocks,
> >  			rblocks / mp->m_sb.sb_rextsize,
> >  			force ? XFS_TRANS_RESERVE : 0, &tp);
> > @@ -1065,6 +1068,13 @@ xfs_trans_alloc_inode(
> >  	}
> >  
> >  	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> > +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> > +		xfs_trans_cancel(tp);
> > +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +		xfs_blockgc_free_quota(ip, 0);
> > +		retried = true;
> > +		goto retry;
> > +	}
> >  	if (error)
> >  		goto out_cancel;
> >  
> > 
> 
