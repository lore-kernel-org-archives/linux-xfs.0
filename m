Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A651EB64DA
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 00:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjGFAhm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 20:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjGFAhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 20:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C830FE57
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 17:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32005617D5
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 00:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9FBC433C8;
        Thu,  6 Jul 2023 00:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688603858;
        bh=E45RA7hKHkDG2DA0IuqYDLE8qKRl8XjmULgz2A2Q12s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u+itgAKtHUQzYRAm+BsxQoj2BBvW6TshsiWogEHN8OMzO5/7owwSOy1d3aOB5dYwz
         mT5d2MXe8Lv8zUjIuaxgKYe4JSYJh5LpvzgQAkxXInI0WcNVju5QyjCLWozxwyv4i+
         96j7eWzBctBP1uJOK0ps9K65cfQop3qDv30Ib9RaW1Wo447kXgllGEHZyPAC21aJ8N
         Bg4c68NPo6bRsEdMD5vAy0skQq8oQobSpZ9+ex7cAUovjoohYZsjvsPqt5kWDcLWNs
         QJ+TOOCMDAt5rlutPcDnKL0EC0rnb2rlVks/2sjJmC8Rvc6bFuVeRoMmfTGAJOBvJP
         z4wsUikDsnJ4Q==
Date:   Wed, 5 Jul 2023 17:37:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: rewrite xfs_icache_inode_is_allocated
Message-ID: <20230706003737.GX11441@frogsfrogsfrogs>
References: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
 <168506057960.3730229.15857132833000582560.stgit@frogsfrogsfrogs>
 <ZJPITz0lNOaAdIS5@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJPITz0lNOaAdIS5@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 02:04:31PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:51:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Back in the mists of time[1], I proposed this function to assist the
> > inode btree scrubbers in checking the inode btree contents against the
> > allocation state of the inode records.  The original version performed a
> > direct lookup in the inode cache and returned the allocation status if
> > the cached inode hadn't been reused and wasn't in an intermediate state.
> > Brian thought it would be better to use the usual iget/irele mechanisms,
> > so that was changed for the final version.
> > 
> > Unfortunately, this hasn't aged well -- the IGET_INCORE flag only has
> > one user and clutters up the regular iget path, which makes it hard to
> > reason about how it actually works.  Worse yet, the inode inactivation
> > series silently broke it because iget won't return inodes that are
> > anywhere in the inactivation machinery, even though the caller is
> > already required to prevent inode allocation and freeing.  Inodes in the
> > inactivation machinery are still allocated, but the current code's
> > interactions with the iget code prevent us from being able to say that.
> > 
> > Now that I understand the inode lifecycle better than I did in early
> > 2017, I now realize that as long as the cached inode hasn't been reused
> > and isn't actively being reclaimed, it's safe to access the i_mode field
> > (with the AGI, rcu, and i_flags locks held), and we don't need to worry
> > about the inode being freed out from under us.
> > 
> > Therefore, port the original version to modern code structure, which
> > fixes the brokennes w.r.t. inactivation.  In the next patch we'll remove
> > IGET_INCORE since it's no longer necessary.
> > 
> > [1] https://lore.kernel.org/linux-xfs/149643868294.23065.8094890990886436794.stgit@birch.djwong.org/
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |  127 +++++++++++++++++++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_trace.h  |   22 +++++++++
> >  2 files changed, 129 insertions(+), 20 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 0f60e301eb1f..0048a8b290bc 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -782,23 +782,23 @@ xfs_iget(
> >  }
> >  
> >  /*
> > - * "Is this a cached inode that's also allocated?"
> > + * Decide if this is this a cached inode that's also allocated.  The caller
> > + * must hold the AGI buffer lock to prevent inodes from being allocated or
> > + * freed.
> >   *
> > - * Look up an inode by number in the given file system.  If the inode is
> > - * in cache and isn't in purgatory, return 1 if the inode is allocated
> > - * and 0 if it is not.  For all other cases (not in cache, being torn
> > - * down, etc.), return a negative error code.
> > + * Look up an inode by number in the given file system.  If the inode number
> > + * is invalid, return -EINVAL.  If the inode is not in cache, return -ENODATA.
> > + * If the inode is in an intermediate state (new, being reclaimed, reused) then
> > + * return -EAGAIN.
> >   *
> > - * The caller has to prevent inode allocation and freeing activity,
> > - * presumably by locking the AGI buffer.   This is to ensure that an
> > - * inode cannot transition from allocated to freed until the caller is
> > - * ready to allow that.  If the inode is in an intermediate state (new,
> > - * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
> > - * inode is not in the cache, -ENOENT will be returned.  The caller must
> > - * deal with these scenarios appropriately.
> > + * Otherwise, the incore inode is the one we want, and it is either live,
> > + * somewhere in the inactivation machinery, or reclaimable.  The inode is
> > + * allocated if i_mode is nonzero.  In all three cases, the cached inode will
> > + * be more up to date than the ondisk inode buffer, so we must use the incore
> > + * i_mode.
> >   *
> > - * This is a specialized use case for the online scrubber; if you're
> > - * reading this, you probably want xfs_iget.
> > + * This is a specialized use case for the online fsck; if you're reading this,
> > + * you probably want xfs_iget.
> >   */
> >  int
> >  xfs_icache_inode_is_allocated(
> > @@ -808,15 +808,102 @@ xfs_icache_inode_is_allocated(
> >  	bool			*inuse)
> >  {
> >  	struct xfs_inode	*ip;
> > +	struct xfs_perag	*pag;
> > +	xfs_agino_t		agino;
> >  	int			error;
> >  
> > -	error = xfs_iget(mp, tp, ino, XFS_IGET_INCORE, 0, &ip);
> > -	if (error)
> > -		return error;
> > +	/* reject inode numbers outside existing AGs */
> > +	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
> > +		return -EINVAL;
> 
> xfs_verify_ino(mp, ino)

Fixed, though the other iget functions still open code this.

> >  
> > -	*inuse = !!(VFS_I(ip)->i_mode);
> > -	xfs_irele(ip);
> > -	return 0;
> > +	/* get the perag structure and ensure that it's inode capable */
> > +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> > +	if (!pag) {
> > +		/* No perag means this inode can't possibly be allocated */
> > +		return -EINVAL;
> > +	}
> 
> Probably should be xfs_perag_grab/rele in this function.

Why?  Is it because we presuppose that the caller holds the AGI buffer
and hence we only need a passive reference?

> > +	agino = XFS_INO_TO_AGINO(mp, ino);
> > +
> > +	rcu_read_lock();
> > +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> > +	if (!ip) {
> > +		/* cache miss */
> > +		error = -ENODATA;
> > +		goto out_pag;
> > +	}
> > +
> > +	/*
> > +	 * If the inode number doesn't match, the incore inode got reused
> > +	 * during an RCU grace period and the radix tree hasn't been updated.
> > +	 * This isn't the inode we want.
> > +	 */
> > +	error = -ENODATA;
> 
> move this up to before the rcu_read_lock(), and it can be removed
> from the !ip branch above, too.

Fixed.

> > +	spin_lock(&ip->i_flags_lock);
> > +	if (ip->i_ino != ino)
> > +		goto out_skip;
> > +
> > +	trace_xfs_icache_inode_is_allocated(ip);
> > +
> > +	/*
> > +	 * We have an incore inode that matches the inode we want, and the
> > +	 * caller holds the AGI buffer.
> > +	 *
> > +	 * If the incore inode is INEW, there are several possibilities:
> > +	 *
> > +	 * For a file that is being created, note that we allocate the ondisk
> > +	 * inode before allocating, initializing, and adding the incore inode
> > +	 * to the radix tree.
> > +	 *
> > +	 * If the incore inode is being recycled, the inode has to be allocated
> > +	 * because we don't allow freed inodes to be recycled.
> > +	 *
> > +	 * If the inode is queued for inactivation, it should still be
> > +	 * allocated.
> > +	 *
> > +	 * If the incore inode is undergoing inactivation, either it is before
> > +	 * the point where it would get freed ondisk (in which case i_mode is
> > +	 * still nonzero), or it has already been freed, in which case i_mode
> > +	 * is zero.  We don't take the ILOCK here, but difree and dialloc
> > +	 * require the AGI, which we do hold.
> > +	 *
> > +	 * If the inode is anywhere in the reclaim mechanism, we know that it's
> > +	 * still ok to query i_mode because we don't allow uncached inode
> > +	 * updates.
> 
> Is it? We explicitly consider XFS_IRECLAIM inodes as in the process
> of being freed, so there is no guarantee that anything in them is
> valid anymore. Indeed, there's a transient state in recycling an
> inode where we set XFS_IRECLAIM, then re-initialise the inode (which
> trashes i_mode) and then restore i_mode to it's correct value before
> clearing XFS_IRECLAIM.
> 
> Hence I think that if XFS_IRECLAIM is set, we can't make any safe
> judgement of the state of i_mode here with just a rcu_read_lock()
> being held.

I wrote this much too long ago, back when reclaim actually could write
inode clusters to disk.

At this point the comment and the code are both wrong -- if the inode is
in IRECLAIM, then it's either being recycled or reclaimed.  Neither of
those things modify the ondisk buffers anymore, so we actually could
return ENODATA here because all three callers of this function use that
as a signal to read i_mode from the icluster buffer.

> > +	 *
> > +	 * If the incore inode is live (i.e. referenced from the dcache), the
> > +	 * ondisk inode had better be allocated.  This is the most trivial
> > +	 * case.
> > +	 */
> > +#ifdef DEBUG
> > +	if (ip->i_flags & XFS_INEW) {
> > +		/* created on disk already or recycling */
> > +		ASSERT(VFS_I(ip)->i_mode != 0);
> > +	}
> 
> I don't think this is correct. In xfs_iget_cache_miss() when
> allocating a new inode, we set XFS_INEW and we don't set i_mode
> until we call xfs_init_new_inode() after xfs_iget() on the newly
> allocated inode returns.  Hence there is a long period where
> XFS_INEW can be set and i_mode is zero and the i_flags_lock is not
> held.

I think you're referring to the situation where an icreate calls
xfs_iget_cache_miss in the (v5 && IGET_CREATE && !ikeep) scenario,
in which case we don't get around to setting i_mode until
xfs_init_new_inode?

The icreate transaction holds the AGI all the way to the end, so a
different thread calling _is_allocated shouldn't find any inodes in this
state as long as it holds the AGI buffer, right?

> Remember, if this is a generic function (which by placing it in
> fs/xfs/xfs_icache.c is essentially asserting that it is) then the
> inode state is only being serialised by RCU. Hence the debug code
> here cannot assume that it has been called with the AGI locked to
> serialise it against create/free operations, nor that there aren't
> other operations being performed on the inode as the lookup is done.

How about I stuff it into fs/xfs/scrub/ instead?  The only reason it's
in xfs_icache.c is because I wanted to keep the rcu lock and radix tree
lookup stuff in there... but yes I agree it's dangerous to let anyone
else see this weird function.

Plus then I can require the caller pass in a valid AGI buffer to prove
they've serialized against icreate/ifree. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
