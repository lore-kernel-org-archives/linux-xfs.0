Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E1EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 20:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiCUUtx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiCUUtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 16:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C56220EE
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 13:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB99AB819C7
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 20:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B039C340ED;
        Mon, 21 Mar 2022 20:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647895702;
        bh=IK/9vLkWlFxIFDR995nPWdOwnDfdWZis0jQX6nQsgfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cLyxTOezckdIGGp/gORxGB86Y6MEtogsHuu5fvjD4FZt7+bxD5vnAoxNCFTkUEEjC
         1goWpxiEefhzMeRBbJRhjHWs4V7iJ/cVYvDMLKxGr6dLKy84JPXKqYGqlPfNFEJ9n0
         xUPoDp2RqmWqrxMK6hnK+NtR7YlvABjQ/5XMgQs7hvwkE9utiCF7/tdDEWbR/6XR0T
         eOC9Sjx18O2cVTDmCODb07rZbcbwCTx3dHQC85saWZ1wdHeBeA4im1BS4fqz2tlijZ
         xdy2mPCSZ2Mgc+UWJx8I1DPAmnfl/zMyRqay8ygleM+isjHJdDFdDfddbwiXf/mQcF
         gJpT3dEjFetXQ==
Date:   Mon, 21 Mar 2022 13:48:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 5/6] xfs: don't report reserved bnobt space as available
Message-ID: <20220321204822.GJ8224@magnolia>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779463505.550479.1031616651852906518.stgit@magnolia>
 <YjiYUtamN6db+hFa@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjiYUtamN6db+hFa@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 11:22:58AM -0400, Brian Foster wrote:
> On Sun, Mar 20, 2022 at 09:43:55AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On a modern filesystem, we don't allow userspace to allocate blocks for
> > data storage from the per-AG space reservations, the user-controlled
> > reservation pool that prevents ENOSPC in the middle of internal
> > operations, or the internal per-AG set-aside that prevents ENOSPC.
> 
> We can prevent -ENOSPC now? Neat! :)

Heh, that was a bad sentence.

I'll update the end of that to read:

"...or the internal per-AG set-aside that prevents unwanted filesystem
shutdowns due to ENOSPC during a bmap btree split."

> > Since we now consider free space btree blocks as unavailable for
> > allocation for data storage, we shouldn't report those blocks via statfs
> > either.
> > 
> 
> Might be worth a sentence or two that document the (intentional) side
> effects of this from a user perspective. I.e., that technically the
> presented free space will be a conservative estimate of actual free
> space (since allocbt blocks free up as free extents are consumed, etc.).

Ok.  Added the following at the end of the commit log:

"This makes the numbers that we return via the statfs f_bavail and
f_bfree fields a more conservative estimate of actual free space."

--D

> 
> Otherwise with that sort of commit log tweak:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsops.c |    2 +-
> >  fs/xfs/xfs_super.c |    3 ++-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 615334e4f689..863e6389c6ff 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -347,7 +347,7 @@ xfs_fs_counts(
> >  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
> >  	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
> >  	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> > -						mp->m_alloc_set_aside;
> > +						xfs_fdblocks_unavailable(mp);
> >  
> >  	spin_lock(&mp->m_sb_lock);
> >  	cnt->freertx = mp->m_sb.sb_frextents;
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d84714e4e46a..54be9d64093e 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -815,7 +815,8 @@ xfs_fs_statfs(
> >  	spin_unlock(&mp->m_sb_lock);
> >  
> >  	/* make sure statp->f_bfree does not underflow */
> > -	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
> > +	statp->f_bfree = max_t(int64_t, 0,
> > +				fdblocks - xfs_fdblocks_unavailable(mp));
> >  	statp->f_bavail = statp->f_bfree;
> >  
> >  	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> > 
> 
