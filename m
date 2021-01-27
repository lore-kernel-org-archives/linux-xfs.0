Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4528EC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 06:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0701420679
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 06:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhA0Gcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhA0DJv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 22:09:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4747205F4;
        Wed, 27 Jan 2021 03:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611716950;
        bh=1GsdYjcMFbKLBHIKhoUaESHfPOMyJrRTdFk5njDsJq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DTnHmh+luEPCvdFxdLeCuNAH9jFv+ZMYdecU+I5jOWvkebd32RHsYaHZw9eOC4/93
         whNK4+6HWkUKOprLimrOPbh66S9lRqtwJp7IIoNlhLLQklN0As+2xxgvbdt3qH8Z9O
         rtnvlWv+f3t9p22I1qItcm06hWu0ndaSZumFOy0MncIQoRX1uMTXZQAlynhGWniWdQ
         LZCJNovuLGNp5eWyxD97CZT67DPHQ4/q6Bo74PtY6gv3h5R265rj2M7c1s5sclzliB
         UJsW7bBgyshIccUNWCBXbsi52qrzvo9NWJZXZgS8Ftv5UiSSjyku5jHaSDiER7pE9Z
         CAGvFoEGyMy5Q==
Date:   Tue, 26 Jan 2021 19:09:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210127030909.GD7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142793080.2171939.11486862758521454210.stgit@magnolia>
 <20210125181406.GH2047559@bfoster>
 <20210125195446.GD7698@magnolia>
 <20210126131451.GA2158252@bfoster>
 <20210126183452.GZ7698@magnolia>
 <20210126200309.GA2515451@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126200309.GA2515451@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 03:03:09PM -0500, Brian Foster wrote:
> On Tue, Jan 26, 2021 at 10:34:52AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 26, 2021 at 08:14:51AM -0500, Brian Foster wrote:
> > > On Mon, Jan 25, 2021 at 11:54:46AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Jan 25, 2021 at 01:14:06PM -0500, Brian Foster wrote:
> > > > > On Sat, Jan 23, 2021 at 10:52:10AM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > > 
> > > > > > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > > > > > We'd much rather the background scanner keep moving.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > > ---
> > > > > >  fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
> > > > > >  1 file changed, 18 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > > index c71eb15e3835..89f9e692fde7 100644
> > > > > > --- a/fs/xfs/xfs_icache.c
> > > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > > @@ -1605,17 +1605,31 @@ xfs_inode_free_cowblocks(
> > > > > >  	void			*args)
> > > > > >  {
> > > > > >  	struct xfs_eofblocks	*eofb = args;
> > > > > > +	bool			wait;
> > > > > >  	int			ret = 0;
> > > > > >  
> > > > > > +	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> > > > > > +
> > > > > >  	if (!xfs_prep_free_cowblocks(ip))
> > > > > >  		return 0;
> > > > > >  
> > > > > >  	if (!xfs_inode_matches_eofb(ip, eofb))
> > > > > >  		return 0;
> > > > > >  
> > > > > > -	/* Free the CoW blocks */
> > > > > > -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > > > > > -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > > > > > +	/*
> > > > > > +	 * If the caller is waiting, return -EAGAIN to keep the background
> > > > > > +	 * scanner moving and revisit the inode in a subsequent pass.
> > > > > > +	 */
> > > > > > +	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > > > > > +		if (wait)
> > > > > > +			return -EAGAIN;
> > > > > > +		return 0;
> > > > > > +	}
> > > > > > +	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
> > > > > > +		if (wait)
> > > > > > +			ret = -EAGAIN;
> > > > > > +		goto out_iolock;
> > > > > > +	}
> > > > > 
> > > > > Hmm.. I'd be a little concerned over this allowing a scan to repeat
> > > > > indefinitely with a competing workload because a restart doesn't carry
> > > > > over any state from the previous scan. I suppose the
> > > > > xfs_prep_free_cowblocks() checks make that slightly less likely on a
> > > > > given file, but I more wonder about a scenario with a large set of
> > > > > inodes in a particular AG with a sufficient amount of concurrent
> > > > > activity. All it takes is one trylock failure per scan to have to start
> > > > > the whole thing over again... hm?
> > > > 
> > > > I'm not quite sure what to do here -- xfs_inode_free_eofblocks already
> > > > has the ability to return EAGAIN, which (I think) means that it's
> > > > already possible for the low-quota scan to stall indefinitely if the
> > > > scan can't lock the inode.
> > > > 
> > > 
> > > Indeed, that is true.
> > > 
> > > > I think we already had a stall limiting factor here in that all the
> > > > other threads in the system that hit EDQUOT will drop their IOLOCKs to
> > > > scan the fs, which means that while they loop around the scanner they
> > > > can only be releasing quota and driving us towards having fewer inodes
> > > > with the same dquots and either blockgc tag set.
> > > > 
> > > 
> > > Yeah, that makes sense for the current use case. There's a broader
> > > sequence involved there that provides some throttling and serialization,
> > > along with the fact that the workload is imminently driving into
> > > -ENOSPC.
> > > 
> > > I think what had me a little concerned upon seeing this is whether the
> > > scanning mechanism is currently suitable for the broader usage
> > > introduced in this series. We've had related issues in the past with
> > > concurrent sync eofblocks scans and iolock (see [1], for example).
> > > Having made it through the rest of the series however, it looks like all
> > > of the new scan invocations are async, so perhaps this is not really an
> > > immediate problem.
> > > 
> > > I think it would be nice if we could somehow assert that the task that
> > > invokes a sync scan doesn't hold an iolock, but I'm not sure there's a
> > > clean way to do that. We'd probably have to define the interface to
> > > require an inode just for that purpose. It may not be worth that
> > > weirdness, and I suppose if code is tested it should be pretty obvious
> > > that such a scan will never complete..
> > 
> > Well... in theory it would be possible to deal with stalls (A->A
> > livelock or otherwise) if we had that IWALK_NORETRY flag I was talking
> > about that would cause xfs_iwalk to exit with EAGAIN instead of
> > restarting the scan at inode 0.  The caller could detect that a
> > synchronous scan didn't complete, and then decide if it wants to call
> > back to try again.
> > 
> > But, that might be a lot of extra code to deal with a requirement that
> > xfs_blockgc_free_* callers cannot hold an iolock or an mmaplock.  Maybe
> > that's the simpler course of action?
> > 
> 
> Yeah, I think we should require that callers drop all such locks before
> invoking a sync scan, since that may livelock against the lock held by
> the current task (or cause similar weirdness against concurrent sync
> scans, as the code prior to the commit below[1] had demonstrated).  The
> async scans used throughout this series seem reasonable to me..

Ok, will update the code comment for xfs_blockgc_free_quota to say that
callers cannot hold any inode IO/MMAP/ILOCKs for sync scans.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > [1] c3155097ad89 ("xfs: sync eofblocks scans under iolock are livelock prone")
> > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > >  
> > > > > >  	/*
> > > > > >  	 * Check again, nobody else should be able to dirty blocks or change
> > > > > > @@ -1625,6 +1639,7 @@ xfs_inode_free_cowblocks(
> > > > > >  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> > > > > >  
> > > > > >  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > > > > > +out_iolock:
> > > > > >  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> > > > > >  
> > > > > >  	return ret;
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
