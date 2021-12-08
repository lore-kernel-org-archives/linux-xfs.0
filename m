Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC9CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 01:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhLHBln (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 20:41:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhLHBln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 20:41:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78113B81F40
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 01:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD98C341C5;
        Wed,  8 Dec 2021 01:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638927490;
        bh=hxQCazOEwTvsDwJaQQ9EjHOhUleet3cykC0Qwl8ZW20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vtdd0DR/hm/jgWPzqnnhgCO0qkZXoUdarNlCLs2b9CS0Bg9OL1xRYheOVcqx8pRYv
         /X3mmRLb6DXKfYADzbzLZ3bbR1J0ySHHnmfglPFBjgavoVrkVf19/qB26BuPwi8EXB
         A1JxCBG+Vr5nyNvhjtehRP5bbjFy1Pxlpi76jveljy2DHsLNTJ0G0w/re5XEutf2JB
         OtFKExBG+e6+ZhPkzx7CBY6QGe5d1zjhlM5gW8fJGcLq5/KWT/X35O3OCd797IP7Oy
         MpapHj+fqlBTIoO5Bw+jSdslNEzAPb3xg9tToZqkACvspg7MH2FbApXw6JXmjOI/0q
         +bAa4U/E32E+Q==
Date:   Tue, 7 Dec 2021 17:38:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, wen.gang.wang@oracle.com
Subject: Re: [PATCH 1/2] xfs: remove all COW fork extents when remounting
 readonly
Message-ID: <20211208013809.GR8467@magnolia>
References: <163890213974.3375879.451653865403812137.stgit@magnolia>
 <163890214556.3375879.16529642634341350231.stgit@magnolia>
 <20211207213316.GK449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207213316.GK449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 08, 2021 at 08:33:16AM +1100, Dave Chinner wrote:
> On Tue, Dec 07, 2021 at 10:35:45AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > As part of multiple customer escalations due to file data corruption
> > after copy on write operations, I wrote some fstests that use fsstress
> > to hammer on COW to shake things loose.  Regrettably, I caught some
> > filesystem shutdowns due to incorrect rmap operations with the following
> > loop:
> > 
> > mount <filesystem>				# (0)
> > fsstress <run only readonly ops> &		# (1)
> > while true; do
> > 	fsstress <run all ops>
> > 	mount -o remount,ro			# (2)
> > 	fsstress <run only readonly ops>
> > 	mount -o remount,rw			# (3)
> > done
> > 
> > When (2) happens, notice that (1) is still running.  xfs_remount_ro will
> > call xfs_blockgc_stop to walk the inode cache to free all the COW
> > extents, but the blockgc mechanism races with (1)'s reader threads to
> > take IOLOCKs and loses, which means that it doesn't clean them all out.
> > Call such a file (A).
> > 
> > When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
> > walks the ondisk refcount btree and frees any COW extent that it finds.
> > This function does not check the inode cache, which means that incore
> > COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
> > one of those former COW extents are allocated and mapped into another
> > file (B) and someone triggers a COW to the stale reservation in (A), A's
> > dirty data will be written into (B) and once that's done, those blocks
> > will be transferred to (A)'s data fork without bumping the refcount.
> > 
> > The results are catastrophic -- file (B) and the refcount btree are now
> > corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
> > synchronously, which causes xfs_icwalk to return to inodes that were
> > skipped because the blockgc code couldn't take the IOLOCK.  This is safe
> > to do here because the VFS has already prohibited new writer threads.
> > 
> > Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_super.c |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> Looks good, I went through the analysis yesterday when you mentioned
> it on #xfs. Minor nit below, otherwise:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for the review!

> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index e21459f9923a..0c07a4aef3b9 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1765,7 +1765,10 @@ static int
> >  xfs_remount_ro(
> >  	struct xfs_mount	*mp)
> >  {
> > -	int error;
> > +	struct xfs_icwalk	icw = {
> > +		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
> > +	};
> > +	int			error;
> >  
> >  	/*
> >  	 * Cancel background eofb scanning so it cannot race with the final
> > @@ -1773,8 +1776,13 @@ xfs_remount_ro(
> >  	 */
> >  	xfs_blockgc_stop(mp);
> >  
> > -	/* Get rid of any leftover CoW reservations... */
> > -	error = xfs_blockgc_free_space(mp, NULL);
> > +	/*
> > +	 * Clean out all remaining COW staging extents.  This extra step is
> > +	 * done synchronously because the background blockgc worker could have
> > +	 * raced with a reader thread and failed to grab an IOLOCK.  In that
> > +	 * case, the inode could still have post-eof and COW blocks.
> > +	 */
> 
> Rather than describe how inodes might be skipped here, the
> constraint we are operating under should be described. That is:
> 
> 	/*
> 	 * We need to clear out all remaining COW staging extents so
> 	 * that we don't leave inodes requiring modifications during
> 	 * inactivation and reclaim on a read-only mount. We must
> 	 * check and process every inode currently in memory, hence
> 	 * this requires a synchronous inode cache scan to be
> 	 * executed.
> 	 */

I will shorten this to:

	/*
	 * Clear out all remaining COW staging extents and speculative
	 * post-EOF preallocations so that we don't leave inodes
	 * requiring inactivation cleanups during reclaim on a read-only
	 * mount.  We must process every cached inode, so this requires
	 * a synchronous cache scan.
	 */

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
