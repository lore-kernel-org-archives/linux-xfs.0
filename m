Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E09C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 03:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131B7619CB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 03:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhCXDfF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 23:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235045AbhCXDeo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 23:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A470B619D3;
        Wed, 24 Mar 2021 03:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616556868;
        bh=nsh91RXGeZ1+dsY4GU/yuAcl+RHH9v5DrFtju57UVlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khl4yD+N7/sGyKedUw2UunTFymhziJQq8kj/vBFEB0TvSWesxxvzc54r61Qm7k+rB
         jLny8bez3lZDYZOqlfIKhNaUlM35WHgWVaodOXi7u8bkYBiPeo8CUD3KicEYtC3j8S
         usC5ASD/EzCq/t5DyryHnrEtkzPw2AcD07apFHsOf8/YTxpl0sBXryau6NqGW2Fci3
         YjYktog5A261mftTFeP9AdYEV86CT7Ejdule54niJIjSA5wmHT3A+KwLk4+n50HLOn
         rPrBIcqCFhHzTskcbBOGDLt6J00x58t43gpHb2o8dHpVZV0bWFAnRNfDQFEDIv4bk3
         ujug42JStdDhg==
Date:   Tue, 23 Mar 2021 20:34:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: create a polled function to force inode
 inactivation
Message-ID: <20210324033428.GR22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543200190.1947934.3117722394191799491.stgit@magnolia>
 <20210323223158.GI63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323223158.GI63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:31:58AM +1100, Dave Chinner wrote:
> On Wed, Mar 10, 2021 at 07:06:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a polled version of xfs_inactive_force so that we can force
> > inactivation while holding a lock (usually the umount lock) without
> > tripping over the softlockup timer.  This is for callers that hold vfs
> > locks while calling inactivation, which is currently unmount, iunlink
> > processing during mount, and rw->ro remount.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   38 +++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_icache.h |    1 +
> >  fs/xfs/xfs_mount.c  |    2 +-
> >  fs/xfs/xfs_mount.h  |    5 +++++
> >  fs/xfs/xfs_super.c  |    3 ++-
> >  5 files changed, 46 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index d5f580b92e48..9db2beb4e732 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -25,6 +25,7 @@
> >  #include "xfs_ialloc.h"
> >  
> >  #include <linux/iversion.h>
> > +#include <linux/nmi.h>
> 
> This stuff goes in fs/xfs/xfs_linux.h, not here.
> 
> >  
> >  /*
> >   * Allocate and initialise an xfs_inode.
> > @@ -2067,8 +2068,12 @@ xfs_inodegc_free_space(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_eofblocks	*eofb)
> >  {
> > -	return xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
> > +	int			error;
> > +
> > +	error = xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
> >  			xfs_inactive_inode, eofb, XFS_ICI_INACTIVE_TAG);
> > +	wake_up(&mp->m_inactive_wait);
> > +	return error;
> >  }
> >  
> >  /* Try to get inode inactivation moving. */
> > @@ -2138,6 +2143,37 @@ xfs_inodegc_force(
> >  	flush_workqueue(mp->m_gc_workqueue);
> >  }
> >  
> > +/*
> > + * Force all inode inactivation work to run immediately, and poll until the
> > + * work is complete.  Callers should only use this function if they must
> > + * inactivate inodes while holding VFS locks, and must be prepared to prevent
> > + * or to wait for inodes that are queued for inactivation while this runs.
> > + */
> > +void
> > +xfs_inodegc_force_poll(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_perag	*pag;
> > +	xfs_agnumber_t		agno;
> > +	bool			queued = false;
> > +
> > +	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
> > +		queued |= xfs_inodegc_force_pag(pag);
> > +	if (!queued)
> > +		return;
> > +
> > +	/*
> > +	 * Touch the softlockup watchdog every 1/10th of a second while there
> > +	 * are still inactivation-tagged inodes in the filesystem.
> > +	 */
> > +	while (!wait_event_timeout(mp->m_inactive_wait,
> > +				   !radix_tree_tagged(&mp->m_perag_tree,
> > +						      XFS_ICI_INACTIVE_TAG),
> > +				   HZ / 10)) {
> > +		touch_softlockup_watchdog();
> > +	}
> > +}
> 
> This looks like a deadlock waiting to be tripped over. As long as
> there is something still able to queue inodes for inactivation,
> that radix tree tag check will always trigger and put us back to
> sleep.

Yes, I know this is a total livelock vector.  This ugly function exists
to avoid stall warnings when the VFS has called us with s_umount held
and there are a lot of inodes to process.

As the function comment points out, callers must prevent anyone else
from inactivating inodes or be prepared to deal with the consequences,
which the current callers are prepared to do.

I can't think of a better way to handle this, since we need to bail out
of the workqueue flush periodically to make the softlockup thing happy.
Alternately we could just let the stall warnings happen and deal with
the people who file a bug for every stack trace they see the kernel emit.

> Also, in terms of workqueues, this is a "sync flush" i because we
> are waiting for it. e.g. the difference between cancel_work() and
> cancel_work_sync() is that the later waits for all the work in
> progress to complete before returning and the former doesn't wait...

Yeah, I'll change all the xfs_inodegc_force-* -> xfs_inodegc_flush_*.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
