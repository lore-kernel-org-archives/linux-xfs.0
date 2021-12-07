Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD11C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 21:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhLGVgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 16:36:51 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:35903 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231451AbhLGVgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 16:36:51 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 28B67607C82;
        Wed,  8 Dec 2021 08:33:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mui5M-000LvH-Bp; Wed, 08 Dec 2021 08:33:16 +1100
Date:   Wed, 8 Dec 2021 08:33:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, wen.gang.wang@oracle.com
Subject: Re: [PATCH 1/2] xfs: remove all COW fork extents when remounting
 readonly
Message-ID: <20211207213316.GK449541@dread.disaster.area>
References: <163890213974.3375879.451653865403812137.stgit@magnolia>
 <163890214556.3375879.16529642634341350231.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163890214556.3375879.16529642634341350231.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61afd31f
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=HjNMyqVRm6hUVNxRfpMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 07, 2021 at 10:35:45AM -0800, Darrick J. Wong wrote:
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
> corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
> synchronously, which causes xfs_icwalk to return to inodes that were
> skipped because the blockgc code couldn't take the IOLOCK.  This is safe
> to do here because the VFS has already prohibited new writer threads.
> 
> Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Looks good, I went through the analysis yesterday when you mentioned
it on #xfs. Minor nit below, otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e21459f9923a..0c07a4aef3b9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1765,7 +1765,10 @@ static int
>  xfs_remount_ro(
>  	struct xfs_mount	*mp)
>  {
> -	int error;
> +	struct xfs_icwalk	icw = {
> +		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
> +	};
> +	int			error;
>  
>  	/*
>  	 * Cancel background eofb scanning so it cannot race with the final
> @@ -1773,8 +1776,13 @@ xfs_remount_ro(
>  	 */
>  	xfs_blockgc_stop(mp);
>  
> -	/* Get rid of any leftover CoW reservations... */
> -	error = xfs_blockgc_free_space(mp, NULL);
> +	/*
> +	 * Clean out all remaining COW staging extents.  This extra step is
> +	 * done synchronously because the background blockgc worker could have
> +	 * raced with a reader thread and failed to grab an IOLOCK.  In that
> +	 * case, the inode could still have post-eof and COW blocks.
> +	 */

Rather than describe how inodes might be skipped here, the
constraint we are operating under should be described. That is:

	/*
	 * We need to clear out all remaining COW staging extents so
	 * that we don't leave inodes requiring modifications during
	 * inactivation and reclaim on a read-only mount. We must
	 * check and process every inode currently in memory, hence
	 * this requires a synchronous inode cache scan to be
	 * executed.
	 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
