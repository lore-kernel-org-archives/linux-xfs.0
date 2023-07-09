Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C15EEB64DC
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Jul 2023 23:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjGIXFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Jul 2023 19:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjGIXFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jul 2023 19:05:12 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB6BEB
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 16:05:11 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-345f3e28082so13665115ab.1
        for <linux-xfs@vger.kernel.org>; Sun, 09 Jul 2023 16:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688943910; x=1691535910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7hA5cDvoP7y31R4xjXwJjuK9rvWTK7dv1I+QbqsPvM4=;
        b=C0/084aRMj3VL/vcteaxov65q1Wqvqr9l5D45C317XoBtLP63g9Fhqrp4ChMNble6R
         FDMRY85+Dw0SyvA10oiH3YJKcVsEih+KIdLtkYoJYfRfBSqoSSyf0wT6PFmqgiqR0fq2
         +54zXDOaqUoKOk9f9oM2oGm1S2r2KgiSmgOQYMPVKSHayKj9YUOT8xaCP7fkkiCzLr2L
         aLiqU5LtP12rtWGk0VV/LaG99K0D/Tl5xc0UJPrEeRZKKWiaSLfijBunc2M2SEFmdsyU
         Ca6ddPHZ6QGx97ZEpTBaNK/w/CgrHS70ihz+ypseeSOtNhEJH5ZBRyDHn4wJ1O2tssdY
         PdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688943910; x=1691535910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hA5cDvoP7y31R4xjXwJjuK9rvWTK7dv1I+QbqsPvM4=;
        b=c0jw4ALEKTL27Fu0vHGFO753k7OWGp9/CGGI6Ko1DmX4xrngjX54L5TGx6zuxeRJH1
         TavL+mFm9OOXRvnwjkzAbzUxciKhNl3L5iXE10aUApAZGvPoM4g+b8vIUlUZNNar7Wm4
         zQYOnuiTveHyvfOvjfLne0/bubiaUs4hUF6C+tYCE3QMv5cL+GL2IEsKacq+y9bj1Gt+
         1kmJ9g3H5utwcunQr0ilflgjdKK3OcVjqXs2GOHEyNOxAsGb5dLHtEj8niM2UiCryV2g
         WdOCxNsOPrWSzlp0nGT+8YFi+jAn0jrv9JcQxWP9BqwObdAKlWiA9ml1CgYktWdBLLfg
         mRVg==
X-Gm-Message-State: ABy/qLaUh7cDT7YSUDcaW9NBBLlnzW36FVIR3cBCek8z1SEgYTXO9PTM
        cXNq6yUuraOExFkmb9qxf93d0GTTOyHB2Px/eXg=
X-Google-Smtp-Source: APBJJlHJa7WbYUl2Vs9Z9mU+dAoMNpijOGLMimC/HcoVYFQ7ZR4D8jJRJlI4KbqKBYYinspwlNrX2Q==
X-Received: by 2002:a05:6e02:80c:b0:32a:b644:af65 with SMTP id u12-20020a056e02080c00b0032ab644af65mr10662890ilm.7.1688943910298;
        Sun, 09 Jul 2023 16:05:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a08c800b00263e4dc33aasm4786951pjn.11.2023.07.09.16.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 16:05:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qIdSj-004Ags-14;
        Mon, 10 Jul 2023 09:05:05 +1000
Date:   Mon, 10 Jul 2023 09:05:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: rewrite xfs_icache_inode_is_allocated
Message-ID: <ZKs9Iekhlvkw5rAB@dread.disaster.area>
References: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
 <168506057960.3730229.15857132833000582560.stgit@frogsfrogsfrogs>
 <ZJPITz0lNOaAdIS5@dread.disaster.area>
 <20230706003737.GX11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706003737.GX11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 05, 2023 at 05:37:37PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 22, 2023 at 02:04:31PM +1000, Dave Chinner wrote:
> > On Thu, May 25, 2023 at 05:51:34PM -0700, Darrick J. Wong wrote:
> > >  
> > > -	*inuse = !!(VFS_I(ip)->i_mode);
> > > -	xfs_irele(ip);
> > > -	return 0;
> > > +	/* get the perag structure and ensure that it's inode capable */
> > > +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> > > +	if (!pag) {
> > > +		/* No perag means this inode can't possibly be allocated */
> > > +		return -EINVAL;
> > > +	}
> > 
> > Probably should be xfs_perag_grab/rele in this function.
> 
> Why?  Is it because we presuppose that the caller holds the AGI buffer
> and hence we only need a passive reference?

Right, there's nothing in this function to guarantee that the perag
is valid and active, so it might be in the process of being torn
down by, say, shrink or memory reclaim. And while we are using the
perag, we want to ensure that nothing can start a teardown
operation...

> > > +	spin_lock(&ip->i_flags_lock);
> > > +	if (ip->i_ino != ino)
> > > +		goto out_skip;
> > > +
> > > +	trace_xfs_icache_inode_is_allocated(ip);
> > > +
> > > +	/*
> > > +	 * We have an incore inode that matches the inode we want, and the
> > > +	 * caller holds the AGI buffer.
> > > +	 *
> > > +	 * If the incore inode is INEW, there are several possibilities:
> > > +	 *
> > > +	 * For a file that is being created, note that we allocate the ondisk
> > > +	 * inode before allocating, initializing, and adding the incore inode
> > > +	 * to the radix tree.
> > > +	 *
> > > +	 * If the incore inode is being recycled, the inode has to be allocated
> > > +	 * because we don't allow freed inodes to be recycled.
> > > +	 *
> > > +	 * If the inode is queued for inactivation, it should still be
> > > +	 * allocated.
> > > +	 *
> > > +	 * If the incore inode is undergoing inactivation, either it is before
> > > +	 * the point where it would get freed ondisk (in which case i_mode is
> > > +	 * still nonzero), or it has already been freed, in which case i_mode
> > > +	 * is zero.  We don't take the ILOCK here, but difree and dialloc
> > > +	 * require the AGI, which we do hold.
> > > +	 *
> > > +	 * If the inode is anywhere in the reclaim mechanism, we know that it's
> > > +	 * still ok to query i_mode because we don't allow uncached inode
> > > +	 * updates.
> > 
> > Is it? We explicitly consider XFS_IRECLAIM inodes as in the process
> > of being freed, so there is no guarantee that anything in them is
> > valid anymore. Indeed, there's a transient state in recycling an
> > inode where we set XFS_IRECLAIM, then re-initialise the inode (which
> > trashes i_mode) and then restore i_mode to it's correct value before
> > clearing XFS_IRECLAIM.
> > 
> > Hence I think that if XFS_IRECLAIM is set, we can't make any safe
> > judgement of the state of i_mode here with just a rcu_read_lock()
> > being held.
> 
> I wrote this much too long ago, back when reclaim actually could write
> inode clusters to disk.
> 
> At this point the comment and the code are both wrong -- if the inode is
> in IRECLAIM, then it's either being recycled or reclaimed.  Neither of
> those things modify the ondisk buffers anymore, so we actually could
> return ENODATA here because all three callers of this function use that
> as a signal to read i_mode from the icluster buffer.

OK.

> 
> > > +	 *
> > > +	 * If the incore inode is live (i.e. referenced from the dcache), the
> > > +	 * ondisk inode had better be allocated.  This is the most trivial
> > > +	 * case.
> > > +	 */
> > > +#ifdef DEBUG
> > > +	if (ip->i_flags & XFS_INEW) {
> > > +		/* created on disk already or recycling */
> > > +		ASSERT(VFS_I(ip)->i_mode != 0);
> > > +	}
> > 
> > I don't think this is correct. In xfs_iget_cache_miss() when
> > allocating a new inode, we set XFS_INEW and we don't set i_mode
> > until we call xfs_init_new_inode() after xfs_iget() on the newly
> > allocated inode returns.  Hence there is a long period where
> > XFS_INEW can be set and i_mode is zero and the i_flags_lock is not
> > held.
> 
> I think you're referring to the situation where an icreate calls
> xfs_iget_cache_miss in the (v5 && IGET_CREATE && !ikeep) scenario,
> in which case we don't get around to setting i_mode until
> xfs_init_new_inode?

Yes, that is one example I can think of.

> The icreate transaction holds the AGI all the way to the end, so a
> different thread calling _is_allocated shouldn't find any inodes in this
> state as long as it holds the AGI buffer, right?

Yes, I think that is correct.

> > Remember, if this is a generic function (which by placing it in
> > fs/xfs/xfs_icache.c is essentially asserting that it is) then the
> > inode state is only being serialised by RCU. Hence the debug code
> > here cannot assume that it has been called with the AGI locked to
> > serialise it against create/free operations, nor that there aren't
> > other operations being performed on the inode as the lookup is done.
> 
> How about I stuff it into fs/xfs/scrub/ instead?  The only reason it's
> in xfs_icache.c is because I wanted to keep the rcu lock and radix tree
> lookup stuff in there... but yes I agree it's dangerous to let anyone
> else see this weird function.
> 
> Plus then I can require the caller pass in a valid AGI buffer to prove
> they've serialized against icreate/ifree. :)

That's fine by me. If we need it at a later date as generic
functionality, we can sort out the semantics then. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
