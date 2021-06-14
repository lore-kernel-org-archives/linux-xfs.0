Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3168DC4743C
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 17:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6F5613B9
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 17:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhFNR3j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 13:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235445AbhFNR3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 13:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6046023E;
        Mon, 14 Jun 2021 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623691655;
        bh=d2wWNvHs5j4CCE41+aIC6sJyvtmzG57Ukk37FcSjC7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kmkpESfj9BGQrnpPCAq1JDqvb4hoNodPRV9wCeWNpW0xS40np905HTb65+GiMN1dW
         BsC6fuZo2HC5Khtt7qyO0qVlr0s4dWxuLoLWvqiDiepRORUqvbR3l++nda76fU3Hgj
         jropqTfJPUHXbYGXOyIdiTFhkSaav0CZNoojpJfcYtoBAHeQqWTMgxD33eH4jpNDJx
         29O6xtrcBcoSb3qOPzpO5S20Vvtp9T7V+ivQoL7f0wdlhMB5diIyx4DYOkaoxYUDL8
         Zy1t7dhOwPgovlrS0Vv+6YlLJ2dOCPhfRhDFqFoHsiajIGUgaqncswIZVCqKsVBafm
         XUWT0wE+rkswA==
Date:   Mon, 14 Jun 2021 10:27:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 03/16] xfs: detach dquots from inode if we don't need to
 inactivate it
Message-ID: <20210614172735.GM2945738@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360481340.1530792.16718628800672012784.stgit@locust>
 <YMeAOGklQwQDZdSM@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMeAOGklQwQDZdSM@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 12:13:44PM -0400, Brian Foster wrote:
> On Sun, Jun 13, 2021 at 10:20:13AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we don't need to inactivate an inode, we can detach the dquots and
> > move on to reclamation.  This isn't strictly required here; it's a
> > preparation patch for deferred inactivation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Seems functional, but a little more explanation on why we're doing this
> might be helpful. Otherwise it's not really clear why we'd duplicate a
> bunch of this logic (as opposed to refactor it), if we want to leave
> around the obvious maintenance landmine, etc..?

<shrug> Dave asked me to break up the deferred inactivation patch so
that it would be shorter.  As you point out, this patch on its own is
unnecessary and a maintenance landmine, so there's really no
justification to keep it separate other than reviewer style comments.

I guess I could put /that/ in the commit message, though:

"If we don't need to inactivate an inode, we can detach the dquots and
move on to reclamation.  This isn't strictly required here; it's a
preparation patch for deferred inactivation per reviewer request[1] to
move the creation of xfs_inode_needs_inactivation into a separate
change.  Eventually this !need_inactive chunk will turn into the code
path for inodes that skip xfs_inactive and go straight to memory
reclaim.

"[1] https://lore.kernel.org/linux-xfs/20210609012838.GW2945738@locust/T/#mca6d958521cb88bbc1bfe1a30767203328d410b5"

--D

> Brian
> 
> >  fs/xfs/xfs_icache.c |    8 +++++++-
> >  fs/xfs/xfs_inode.c  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_inode.h  |    2 ++
> >  3 files changed, 62 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index a2d81331867b..7939eced3a47 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -338,8 +338,14 @@ xfs_inode_mark_reclaimable(
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_perag	*pag;
> > +	bool			need_inactive = xfs_inode_needs_inactive(ip);
> >  
> > -	xfs_inactive(ip);
> > +	if (!need_inactive) {
> > +		/* Going straight to reclaim, so drop the dquots. */
> > +		xfs_qm_dqdetach(ip);
> > +	} else {
> > +		xfs_inactive(ip);
> > +	}
> >  
> >  	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
> >  		xfs_check_delalloc(ip, XFS_DATA_FORK);
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 3bee1cd20072..85b2b11b5217 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1654,6 +1654,59 @@ xfs_inactive_ifree(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Returns true if we need to update the on-disk metadata before we can free
> > + * the memory used by this inode.  Updates include freeing post-eof
> > + * preallocations; freeing COW staging extents; and marking the inode free in
> > + * the inobt if it is on the unlinked list.
> > + */
> > +bool
> > +xfs_inode_needs_inactive(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> > +
> > +	/*
> > +	 * If the inode is already free, then there can be nothing
> > +	 * to clean up here.
> > +	 */
> > +	if (VFS_I(ip)->i_mode == 0)
> > +		return false;
> > +
> > +	/* If this is a read-only mount, don't do this (would generate I/O) */
> > +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > +		return false;
> > +
> > +	/* If the log isn't running, push inodes straight to reclaim. */
> > +	if (XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_NORECOVERY))
> > +		return false;
> > +
> > +	/* Metadata inodes require explicit resource cleanup. */
> > +	if (xfs_is_metadata_inode(ip))
> > +		return false;
> > +
> > +	/* Want to clean out the cow blocks if there are any. */
> > +	if (cow_ifp && cow_ifp->if_bytes > 0)
> > +		return true;
> > +
> > +	/* Unlinked files must be freed. */
> > +	if (VFS_I(ip)->i_nlink == 0)
> > +		return true;
> > +
> > +	/*
> > +	 * This file isn't being freed, so check if there are post-eof blocks
> > +	 * to free.  @force is true because we are evicting an inode from the
> > +	 * cache.  Post-eof blocks must be freed, lest we end up with broken
> > +	 * free space accounting.
> > +	 *
> > +	 * Note: don't bother with iolock here since lockdep complains about
> > +	 * acquiring it in reclaim context. We have the only reference to the
> > +	 * inode at this point anyways.
> > +	 */
> > +	return xfs_can_free_eofblocks(ip, true);
> > +}
> > +
> >  /*
> >   * xfs_inactive
> >   *
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 4b6703dbffb8..e3137bbc7b14 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -493,6 +493,8 @@ extern struct kmem_zone	*xfs_inode_zone;
> >  /* The default CoW extent size hint. */
> >  #define XFS_DEFAULT_COWEXTSZ_HINT 32
> >  
> > +bool xfs_inode_needs_inactive(struct xfs_inode *ip);
> > +
> >  int xfs_iunlink_init(struct xfs_perag *pag);
> >  void xfs_iunlink_destroy(struct xfs_perag *pag);
> >  
> > 
> 
