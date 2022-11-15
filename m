Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85221C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 03:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiKODfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiKODfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 22:35:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D74A468
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF4ECB8165D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 03:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB3CC433D7;
        Tue, 15 Nov 2022 03:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668483288;
        bh=F/hIa0cVQXtMDfTmADqYzO8mJGw9iXKWGqNLa5zfySo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rvfu3ZqlDjOi69URv0JKTcprWsOY9Q69Xa471MK6d34TuZzb+2np+X9VlDFa86nsQ
         EKgBFttb8LRf8gaI2FnEjPFzZJpoDWekV9QxprQV6tqZrlEfNtM9zP9DD4RA5lJj7t
         nkdAN7UCvFsixfE9NI8UFF4yLpNUIBp9WKoqiEEJLj7ON81DohBM+MT392D6hl0c4x
         iUsbIh/h0iWB8kEvbKSz+VeQo6+qxvL5rQsjv8SBVX6qHiCvLecOKiACPMzV+YuEbs
         /rmf05K8+Tadj74tdvHXtCGb9GjhOlNi+HJGWVgGrisETqzrm9s2KTyHD/BsBaYiyd
         XLp22zUde0U6Q==
Date:   Mon, 14 Nov 2022 19:34:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: manage inode DONTCACHE status at irele time
Message-ID: <Y3MI16WzYnZF2CTd@magnolia>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482943.1084685.12751834399982118437.stgit@magnolia>
 <20221115031318.GW3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115031318.GW3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 02:13:18PM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Right now, there are statements scattered all over the online fsck
> > codebase about how we can't use XFS_IGET_DONTCACHE because of concerns
> > about scrub's unusual practice of releasing inodes with transactions
> > held.
> > 
> > However, iget is the wrong place to handle this -- the DONTCACHE state
> > doesn't matter at all until we try to *release* the inode, and here we
> > get things wrong in multiple ways:
> > 
> > First, if we /do/ have a transaction, we must NOT drop the inode,
> > because the inode could have dirty pages, dropping the inode will
> > trigger writeback, and writeback can trigger a nested transaction.
> > 
> > Second, if the inode already had an active reference and the DONTCACHE
> > flag set, the icache hit when scrub grabs another ref will not clear
> > DONTCACHE.  This is sort of by design, since DONTCACHE is now used to
> > initiate cache drops so that sysadmins can change a file's access mode
> > between pagecache and DAX.
> > 
> > Third, if we do actually have the last active reference to the inode, we
> > can set DONTCACHE to avoid polluting the cache.  This is the /one/ case
> > where we actually want that flag.
> > 
> > Create an xchk_irele helper to encode all that logic and switch the
> > online fsck code to use it.  Since this now means that nearly all
> > scrubbers use the same xfs_iget flags, we can wrap them too.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Ok, I can see what needs to be done here. It seems a bit fragile,
> but I don't see a better way at the moment.
> 
> That said...
> 
> > diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> > index ab182a5cd0c0..38ea04e66468 100644
> > --- a/fs/xfs/scrub/parent.c
> > +++ b/fs/xfs/scrub/parent.c
> > @@ -131,7 +131,6 @@ xchk_parent_validate(
> >  	xfs_ino_t		dnum,
> >  	bool			*try_again)
> >  {
> > -	struct xfs_mount	*mp = sc->mp;
> >  	struct xfs_inode	*dp = NULL;
> >  	xfs_nlink_t		expected_nlink;
> >  	xfs_nlink_t		nlink;
> > @@ -168,7 +167,7 @@ xchk_parent_validate(
> >  	 * -EFSCORRUPTED or -EFSBADCRC then the parent is corrupt which is a
> >  	 *  cross referencing error.  Any other error is an operational error.
> >  	 */
> > -	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
> > +	error = xchk_iget(sc, dnum, &dp);
> >  	if (error == -EINVAL || error == -ENOENT) {
> >  		error = -EFSCORRUPTED;
> >  		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
> > @@ -253,7 +252,7 @@ xchk_parent_validate(
> >  out_unlock:
> >  	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
> >  out_rele:
> > -	xfs_irele(dp);
> > +	xchk_irele(sc, dp);
> >  out:
> >  	return error;
> >  }
> 
> Didn't you miss a couple of cases here? THe current upstream code
> looks like:
> 
> .......
> 237         /* Drat, parent changed.  Try again! */
> 238         if (dnum != dp->i_ino) {
> 239                 xfs_irele(dp);
> 240                 *try_again = true;
> 241                 return 0;
> 242         }
> 243         xfs_irele(dp);
> 244
> 245         /*
> 246          * '..' didn't change, so check that there was only one entry
> 247          * for us in the parent.
> 248          */
> 249         if (nlink != expected_nlink)
> 250                 xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> 251         return error;
> 252
> 253 out_unlock:
> 254         xfs_iunlock(dp, XFS_IOLOCK_SHARED);
> 255 out_rele:
> 256         xfs_irele(dp);
> 257 out:
> 258         return error;
> 259 }
> 
> So it looks like you missed the conversion at lines 239 and 243. Of
> course, these may have been removed in a prior patchset I've looked
> at and forgotten about, but on the surface this looks like missed
> conversions.

Actually, I probably missed it because one of the follow-on fixpatches
in the v23.1 patchbomb removes it entirely:
https://lore.kernel.org/linux-xfs/166473483278.1084804.14032671424392139245.stgit@magnolia/

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
