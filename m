Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C65BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 04:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD6B65166
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 04:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhCHEqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 23:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232471AbhCHEpv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 23:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 524C865165;
        Mon,  8 Mar 2021 04:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615178751;
        bh=L4XYotDAeglDe4EpwcG2A3/ys09Rhr78cFZxRJ+ikXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPgPGpb2eSugvacSq2XqqYmpGBfAZJuqznChwu0zGXMzaaJrew91MaGtYn2LPAtVb
         I7IkY+Ah5edohjrvVomFAjTXqrHAJxAbdpY8/SDBJgKGf6VN/tzpXE2ZrXtitsNBp1
         kwYtLd2y4umaiEm/7PtdveiDEkJIEL8nFSm+A7pEjnysmriHqCId8JsGcfscn1CFJN
         VPKnhjJpcyon0ObQuyvQU3D+/ckj/70bwtLn21AYD8JHQv6BvoB0aoBk2idZwWcVoW
         g+yM7gPNGa/dRxp9gF3STLeB8lwhKGOPHKJnVu8n1gAw2iSUeQcS4HYjFnAcw3DWPq
         JlcpJfjr5YaQw==
Date:   Sun, 7 Mar 2021 20:45:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 4/4] xfs: drop freeze protection when running GETFSMAP
Message-ID: <20210308044551.GL3419940@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514876275.698643.12226309352552265069.stgit@magnolia>
 <20210307230555.GZ4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307230555.GZ4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 10:05:55AM +1100, Dave Chinner wrote:
> On Sun, Mar 07, 2021 at 12:26:02PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A recent log refactoring patchset from Brian Foster relaxed fsfreeze
> > behavior with regards to the buffer cache -- now freeze only waits for
> > pending buffer IO to finish, and does not try to drain the buffer cache
> > LRU.  As a result, fsfreeze should no longer stall indefinitely while
> > fsmap runs.  Drop the sb_start_write calls around fsmap invocations.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsmap.c |   14 +++++---------
> >  1 file changed, 5 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 9ce5e7d5bf8f..34f2b971ce43 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -904,14 +904,6 @@ xfs_getfsmap(
> >  	info.fsmap_recs = fsmap_recs;
> >  	info.head = head;
> >  
> > -	/*
> > -	 * If fsmap runs concurrently with a scrub, the freeze can be delayed
> > -	 * indefinitely as we walk the rmapbt and iterate over metadata
> > -	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
> > -	 * be emptied) and that won't happen while we're reading buffers.
> > -	 */
> > -	sb_start_write(mp->m_super);
> > -
> >  	/* For each device we support... */
> >  	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
> >  		/* Is this device within the range the user asked for? */
> > @@ -934,6 +926,11 @@ xfs_getfsmap(
> >  		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
> >  			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
> >  
> > +		/*
> > +		 * Grab an empty transaction so that we can use its recursive
> > +		 * buffer locking abilities to detect cycles in the rmapbt
> > +		 * without deadlocking.
> > +		 */
> >  		error = xfs_trans_alloc_empty(mp, &tp);
> >  		if (error)
> >  			break;
> 
> Took me a moment to work out that this is just adding a comment
> because it wasn't mentioned in the commit log. Somewhat unrelated to
> the bug fix but it's harmless so I don't see any need for you to
> do any extra work to respin this patch to remove it.

I'll add a sentence to the commit message explaining why we're adding a
seemingly random (but related!) comment:

"While we're cleaning things, add a comment to the xfs_trans_alloc_empty
call explaining why we're running around with empty transactions."

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
