Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847BEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 01:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345532AbhLKB2I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 20:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhLKB2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 20:28:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52A7C061714
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 17:24:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6F3EB82A82
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 01:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470E3C00446;
        Sat, 11 Dec 2021 01:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639185869;
        bh=Qj5rNmllKwFEPAEXPZZi5doiwqRxezkS5sy3nY83sIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OBJKuW/Vaq4cuy/6bfCQ12WlAOSX2fnALFjbiwX5Tq9lrXCeuNMDS4FZhWkjQ0pc4
         FCVS4whzWdlDei+eSZUN2Pk/73NGLD4+Bvm0BmOs8wwgVJk1V2LHyE4ZOx7P9UJsA5
         wt9bIeoLZLqT2qG5c5vFpE4entFvOCC47vATZH0tv6CkEdLflzSku2e2dr79lboyTy
         epzPhBTmTMPFHn8D3HpVTebfz/KApq36iXkBtUo5cmHLuqY+UICWniVV7IDV9WAwPp
         QHffVjTCPfCVEIYtUbdyIBZkcwXQYZHk9qX+qFjvgVviJytn2YCDzYxs3gslE22BZN
         wBELNY9Ho6/4w==
Date:   Fri, 10 Dec 2021 17:24:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/2] xfs: only run COW extent recovery when there are no
 live extents
Message-ID: <20211211012428.GE1218082@magnolia>
References: <163900530491.374528.3847809977076817523.stgit@magnolia>
 <163900531629.374528.14641806907962114873.stgit@magnolia>
 <20211209054149.GN449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209054149.GN449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 09, 2021 at 04:41:49PM +1100, Dave Chinner wrote:
> On Wed, Dec 08, 2021 at 03:15:16PM -0800, Darrick J. Wong wrote:
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
> > corrupt.  In the first patch, we fixed the race condition in (2) so that
> > (A) will always flush the COW fork.  In this second patch, we move the
> > _recover_cow call to the initial mount call in (0) for safety.
> > 
> > As mentioned previously, xfs_reflink_recover_cow walks the refcount
> > btree looking for COW staging extents, and frees them.  This was
> > intended to be run at mount time (when we know there are no live inodes)
> > to clean up any leftover staging events that may have been left behind
> > during an unclean shutdown.  As a time "optimization" for readonly
> > mounts, we deferred this to the ro->rw transition, not realizing that
> > any failure to clean all COW forks during a rw->ro transition would
> > result in catastrophic corruption.
> > 
> > Therefore, remove this optimization and only run the recovery routine
> > when we're guaranteed not to have any COW staging extents anywhere,
> > which means we always run this at mount time.  While we're at it, move
> > the callsite to xfs_log_mount_finish because any refcount btree
> > expansion (however unlikely given that we're removing records from the
> > right side of the index) must be fed by a per-AG reservation, which
> > doesn't exist in its current location.
> > 
> > Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_log.c     |   23 ++++++++++++++++++++++-
> >  fs/xfs/xfs_mount.c   |   10 ----------
> >  fs/xfs/xfs_reflink.c |    5 ++++-
> >  fs/xfs/xfs_super.c   |    9 ---------
> >  4 files changed, 26 insertions(+), 21 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 89fec9a18c34..c17344fc1275 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -10,6 +10,7 @@
> >  #include "xfs_log_format.h"
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> > +#include "xfs_inode.h"
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> >  #include "xfs_trans.h"
> > @@ -20,6 +21,7 @@
> >  #include "xfs_sysfs.h"
> >  #include "xfs_sb.h"
> >  #include "xfs_health.h"
> > +#include "xfs_reflink.h"
> >  
> >  struct kmem_cache	*xfs_log_ticket_cache;
> >  
> > @@ -847,9 +849,28 @@ xfs_log_mount_finish(
> >  	/* Make sure the log is dead if we're returning failure. */
> >  	ASSERT(!error || xlog_is_shutdown(log));
> >  
> > -	return error;
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Recover any CoW staging blocks that are still referenced by the
> > +	 * ondisk refcount metadata.  During mount there cannot be any live
> > +	 * staging extents as we have not permitted any user modifications.
> > +	 * Therefore, it is safe to free them all right now, even on a
> > +	 * read-only mount.
> > +	 */
> > +	error = xfs_reflink_recover_cow(mp);
> > +	if (error) {
> > +		xfs_err(mp, "Error %d recovering leftover CoW allocations.",
> > +				error);
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +
> > +	return 0;
> >  }
> 
> THis is after we've emitted an "Ending recovery ...." log message.
> I kinda expected you to move this up to just after the
> evict_inodes() call before we force the log, push the AIL, drain
> the buffers used during recovery and potentially turn the
> "filesystem is read-only" flag back on.
> 
> i.e. if this is a recovery operation, it should be done before we
> finish recovery....
> 
> Other than that, the change is fine.

It's a recovery function, albeit one that we always run during mount,
even if the log didn't require recovery.  That's a behavior change,
which is beyond the scope of a fix patch.  Not to mention it causes a
hang in xfs/434, which means now I have to withdraw this until I sort
out why we stall forever in xfs_buftarg_drain, and ftrace isn't helpful
in this regard.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
