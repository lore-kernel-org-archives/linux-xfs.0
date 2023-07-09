Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BC2EB64DC
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Jul 2023 23:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjGIXYC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Jul 2023 19:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGIXYB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jul 2023 19:24:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD43106
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 16:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD90360C4F
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 23:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EC3C433C8;
        Sun,  9 Jul 2023 23:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688945039;
        bh=NUCT2FUj9PYtRTKNlo1IbXtAixD1tr86Cms9Qqfn6Ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cviRC4gcoSHJW8u+VclbjZo0L33lUhe5Cy9inqc8/GbxGYE5oYaiYD+IPKX7rBeJN
         QBlcAlOpTXRO2zxLcf2JBjmZ8bHQTshzTbkQMXxRuUv3l0OcUUFsGIR3q7fvZZAcF0
         Zrzz/2IV0twrYbxy0gGuNH1NDSfkMwavZeqx7cz44kbZVX7o6Pfs3uk73E9T9RivpU
         +7aBeiQm0yofQzBhqhR0w0qHDXdkCLPwwyzEj0yT+Pg4jqnfPidl81mhsqot8umEv4
         VdGpzZkozYUsYpxuIZClwdThcK9zs8DyFLKbCY/DCxAuSrZdG6eoqlwdqwExbXt0qC
         vL4iBIjXROKLQ==
Date:   Sun, 9 Jul 2023 16:23:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: rewrite xfs_icache_inode_is_allocated
Message-ID: <20230709232358.GD11456@frogsfrogsfrogs>
References: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
 <168506057960.3730229.15857132833000582560.stgit@frogsfrogsfrogs>
 <ZJPITz0lNOaAdIS5@dread.disaster.area>
 <20230706003737.GX11441@frogsfrogsfrogs>
 <ZKs9Iekhlvkw5rAB@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKs9Iekhlvkw5rAB@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 09:05:05AM +1000, Dave Chinner wrote:
> On Wed, Jul 05, 2023 at 05:37:37PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 22, 2023 at 02:04:31PM +1000, Dave Chinner wrote:
> > > On Thu, May 25, 2023 at 05:51:34PM -0700, Darrick J. Wong wrote:
> > > >  
> > > > -	*inuse = !!(VFS_I(ip)->i_mode);
> > > > -	xfs_irele(ip);
> > > > -	return 0;
> > > > +	/* get the perag structure and ensure that it's inode capable */
> > > > +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> > > > +	if (!pag) {
> > > > +		/* No perag means this inode can't possibly be allocated */
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > Probably should be xfs_perag_grab/rele in this function.
> > 
> > Why?  Is it because we presuppose that the caller holds the AGI buffer
> > and hence we only need a passive reference?
> 
> Right, there's nothing in this function to guarantee that the perag
> is valid and active, so it might be in the process of being torn
> down by, say, shrink or memory reclaim. And while we are using the
> perag, we want to ensure that nothing can start a teardown
> operation...
> 
> > > > +	spin_lock(&ip->i_flags_lock);
> > > > +	if (ip->i_ino != ino)
> > > > +		goto out_skip;
> > > > +
> > > > +	trace_xfs_icache_inode_is_allocated(ip);
> > > > +
> > > > +	/*
> > > > +	 * We have an incore inode that matches the inode we want, and the
> > > > +	 * caller holds the AGI buffer.
> > > > +	 *
> > > > +	 * If the incore inode is INEW, there are several possibilities:
> > > > +	 *
> > > > +	 * For a file that is being created, note that we allocate the ondisk
> > > > +	 * inode before allocating, initializing, and adding the incore inode
> > > > +	 * to the radix tree.
> > > > +	 *
> > > > +	 * If the incore inode is being recycled, the inode has to be allocated
> > > > +	 * because we don't allow freed inodes to be recycled.
> > > > +	 *
> > > > +	 * If the inode is queued for inactivation, it should still be
> > > > +	 * allocated.
> > > > +	 *
> > > > +	 * If the incore inode is undergoing inactivation, either it is before
> > > > +	 * the point where it would get freed ondisk (in which case i_mode is
> > > > +	 * still nonzero), or it has already been freed, in which case i_mode
> > > > +	 * is zero.  We don't take the ILOCK here, but difree and dialloc
> > > > +	 * require the AGI, which we do hold.
> > > > +	 *
> > > > +	 * If the inode is anywhere in the reclaim mechanism, we know that it's
> > > > +	 * still ok to query i_mode because we don't allow uncached inode
> > > > +	 * updates.
> > > 
> > > Is it? We explicitly consider XFS_IRECLAIM inodes as in the process
> > > of being freed, so there is no guarantee that anything in them is
> > > valid anymore. Indeed, there's a transient state in recycling an
> > > inode where we set XFS_IRECLAIM, then re-initialise the inode (which
> > > trashes i_mode) and then restore i_mode to it's correct value before
> > > clearing XFS_IRECLAIM.
> > > 
> > > Hence I think that if XFS_IRECLAIM is set, we can't make any safe
> > > judgement of the state of i_mode here with just a rcu_read_lock()
> > > being held.
> > 
> > I wrote this much too long ago, back when reclaim actually could write
> > inode clusters to disk.
> > 
> > At this point the comment and the code are both wrong -- if the inode is
> > in IRECLAIM, then it's either being recycled or reclaimed.  Neither of
> > those things modify the ondisk buffers anymore, so we actually could
> > return ENODATA here because all three callers of this function use that
> > as a signal to read i_mode from the icluster buffer.
> 
> OK.
> 
> > 
> > > > +	 *
> > > > +	 * If the incore inode is live (i.e. referenced from the dcache), the
> > > > +	 * ondisk inode had better be allocated.  This is the most trivial
> > > > +	 * case.
> > > > +	 */
> > > > +#ifdef DEBUG
> > > > +	if (ip->i_flags & XFS_INEW) {
> > > > +		/* created on disk already or recycling */
> > > > +		ASSERT(VFS_I(ip)->i_mode != 0);
> > > > +	}
> > > 
> > > I don't think this is correct. In xfs_iget_cache_miss() when
> > > allocating a new inode, we set XFS_INEW and we don't set i_mode
> > > until we call xfs_init_new_inode() after xfs_iget() on the newly
> > > allocated inode returns.  Hence there is a long period where
> > > XFS_INEW can be set and i_mode is zero and the i_flags_lock is not
> > > held.
> > 
> > I think you're referring to the situation where an icreate calls
> > xfs_iget_cache_miss in the (v5 && IGET_CREATE && !ikeep) scenario,
> > in which case we don't get around to setting i_mode until
> > xfs_init_new_inode?
> 
> Yes, that is one example I can think of.
> 
> > The icreate transaction holds the AGI all the way to the end, so a
> > different thread calling _is_allocated shouldn't find any inodes in this
> > state as long as it holds the AGI buffer, right?
> 
> Yes, I think that is correct.
> 
> > > Remember, if this is a generic function (which by placing it in
> > > fs/xfs/xfs_icache.c is essentially asserting that it is) then the
> > > inode state is only being serialised by RCU. Hence the debug code
> > > here cannot assume that it has been called with the AGI locked to
> > > serialise it against create/free operations, nor that there aren't
> > > other operations being performed on the inode as the lookup is done.
> > 
> > How about I stuff it into fs/xfs/scrub/ instead?  The only reason it's
> > in xfs_icache.c is because I wanted to keep the rcu lock and radix tree
> > lookup stuff in there... but yes I agree it's dangerous to let anyone
> > else see this weird function.
> > 
> > Plus then I can require the caller pass in a valid AGI buffer to prove
> > they've serialized against icreate/ifree. :)
> 
> That's fine by me. If we need it at a later date as generic
> functionality, we can sort out the semantics then. :)

Ok.  Even better, the xfs_perag_grab/get thing becomes irrelevant, since
scrub already got its own reference and we can just use it here in
xchk_inode_is_allocated. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
