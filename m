Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C54AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 05:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhLIFp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 00:45:26 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37214 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232157AbhLIFpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 00:45:25 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B070F8688E6;
        Thu,  9 Dec 2021 16:41:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mvCBh-000sdl-8J; Thu, 09 Dec 2021 16:41:49 +1100
Date:   Thu, 9 Dec 2021 16:41:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/2] xfs: only run COW extent recovery when there are no
 live extents
Message-ID: <20211209054149.GN449541@dread.disaster.area>
References: <163900530491.374528.3847809977076817523.stgit@magnolia>
 <163900531629.374528.14641806907962114873.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163900531629.374528.14641806907962114873.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61b1971f
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=xnGX_mindpNQCRvscnUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 08, 2021 at 03:15:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As part of multiple customer escalations due to file data corruption
> after copy on write operations, I wrote some fstests that use fsstress
> to hammer on COW to shake things loose.  Regrettably, I caught some
> filesystem shutdowns due to incorrect rmap operations with the following
> loop:
> 
> mount <filesystem>				# (0)
> fsstress <run only readonly ops> &		# (1)
> while true; do
> 	fsstress <run all ops>
> 	mount -o remount,ro			# (2)
> 	fsstress <run only readonly ops>
> 	mount -o remount,rw			# (3)
> done
> 
> When (2) happens, notice that (1) is still running.  xfs_remount_ro will
> call xfs_blockgc_stop to walk the inode cache to free all the COW
> extents, but the blockgc mechanism races with (1)'s reader threads to
> take IOLOCKs and loses, which means that it doesn't clean them all out.
> Call such a file (A).
> 
> When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
> walks the ondisk refcount btree and frees any COW extent that it finds.
> This function does not check the inode cache, which means that incore
> COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
> one of those former COW extents are allocated and mapped into another
> file (B) and someone triggers a COW to the stale reservation in (A), A's
> dirty data will be written into (B) and once that's done, those blocks
> will be transferred to (A)'s data fork without bumping the refcount.
> 
> The results are catastrophic -- file (B) and the refcount btree are now
> corrupt.  In the first patch, we fixed the race condition in (2) so that
> (A) will always flush the COW fork.  In this second patch, we move the
> _recover_cow call to the initial mount call in (0) for safety.
> 
> As mentioned previously, xfs_reflink_recover_cow walks the refcount
> btree looking for COW staging extents, and frees them.  This was
> intended to be run at mount time (when we know there are no live inodes)
> to clean up any leftover staging events that may have been left behind
> during an unclean shutdown.  As a time "optimization" for readonly
> mounts, we deferred this to the ro->rw transition, not realizing that
> any failure to clean all COW forks during a rw->ro transition would
> result in catastrophic corruption.
> 
> Therefore, remove this optimization and only run the recovery routine
> when we're guaranteed not to have any COW staging extents anywhere,
> which means we always run this at mount time.  While we're at it, move
> the callsite to xfs_log_mount_finish because any refcount btree
> expansion (however unlikely given that we're removing records from the
> right side of the index) must be fed by a per-AG reservation, which
> doesn't exist in its current location.
> 
> Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c     |   23 ++++++++++++++++++++++-
>  fs/xfs/xfs_mount.c   |   10 ----------
>  fs/xfs/xfs_reflink.c |    5 ++++-
>  fs/xfs/xfs_super.c   |    9 ---------
>  4 files changed, 26 insertions(+), 21 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 89fec9a18c34..c17344fc1275 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_inode.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trans.h"
> @@ -20,6 +21,7 @@
>  #include "xfs_sysfs.h"
>  #include "xfs_sb.h"
>  #include "xfs_health.h"
> +#include "xfs_reflink.h"
>  
>  struct kmem_cache	*xfs_log_ticket_cache;
>  
> @@ -847,9 +849,28 @@ xfs_log_mount_finish(
>  	/* Make sure the log is dead if we're returning failure. */
>  	ASSERT(!error || xlog_is_shutdown(log));
>  
> -	return error;
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Recover any CoW staging blocks that are still referenced by the
> +	 * ondisk refcount metadata.  During mount there cannot be any live
> +	 * staging extents as we have not permitted any user modifications.
> +	 * Therefore, it is safe to free them all right now, even on a
> +	 * read-only mount.
> +	 */
> +	error = xfs_reflink_recover_cow(mp);
> +	if (error) {
> +		xfs_err(mp, "Error %d recovering leftover CoW allocations.",
> +				error);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	return 0;
>  }

THis is after we've emitted an "Ending recovery ...." log message.
I kinda expected you to move this up to just after the
evict_inodes() call before we force the log, push the AIL, drain
the buffers used during recovery and potentially turn the
"filesystem is read-only" flag back on.

i.e. if this is a recovery operation, it should be done before we
finish recovery....

Other than that, the change is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
