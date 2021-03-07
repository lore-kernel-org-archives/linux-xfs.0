Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0ABC433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 23:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DEFD65159
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 23:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhCGXDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 18:03:43 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:54509 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232266AbhCGXDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Mar 2021 18:03:12 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id A537C645AD;
        Mon,  8 Mar 2021 10:03:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJ2Op-0022Tx-Op; Mon, 08 Mar 2021 10:01:23 +1100
Date:   Mon, 8 Mar 2021 10:01:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 3/4] xfs: force log and push AIL to clear pinned inodes
 when aborting mount
Message-ID: <20210307230123.GY4662@dread.disaster.area>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514875722.698643.971171271199400538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514875722.698643.971171271199400538.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 12:25:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we allocate quota inodes in the process of mounting a filesystem but
> then decide to abort the mount, it's possible that the quota inodes are
> sitting around pinned by the log.  Now that inode reclaim relies on the
> AIL to flush inodes, we have to force the log and push the AIL in
> between releasing the quota inodes and kicking off reclaim to tear down
> all the incore inodes.  Do this by extracting the bits we need from the
> unmount path and reusing them.
> 
> This was originally found during a fuzz test of metadata directories
> (xfs/1546), but the actual symptom was that reclaim hung up on the quota
> inodes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_mount.c |  100 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 54 insertions(+), 46 deletions(-)

Seems reasonable.

> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 52370d0a3f43..556ce373145f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -634,6 +634,57 @@ xfs_check_summary_counts(
>  	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
>  }
>  
> +/*
> + * Force the log contents and checkpoint them into the filesystem, the reclaim
> + * inodes in preparation to unmount.

"then reclaim"

Ignoring the typo, the comment doesn't add anything useful - you're
saying what the function does, not why. I'd prefer you lift all the
comments in the code up into the header, explaining why each step
is needed/taken. Something like:

/*
 * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
 * internal inode structures can be sitting in the CIL and AIL at this point, so
 * we need to unpin them, write them back and/or reclaim them before unmount can
 * proceed.
 *
 * An inode cluster that has been freed can have its buffer still pinned in
 * memory because the transaction is still sitting in a iclog. The stale inodes
 * on that buffer will be pinned to the buffer until the transaction hits the
 * disk and the callbacks run. Pushing the AIL will skip the stale inodes and
 * may never see the pinned buffer, so nothing will push out the iclog and unpin
 * the buffer.
 *
 * Hence we need to force the log to unpin everything first. However, log forces
 * don't wait for the discards they issue to complete, so we have to explicitly
 * wait for them to complete here as well.
 *
 * Then we can tell the world we are unmounting so that error handling knows
 * that the filesystem is going away and we should error out anything that we
 * have been retrying in the background.  This will prevent never-ending retries
 * in AIL pushing from hanging the unmount.
 *
 * Finally, we can push the AIL to clean all the remaining dirty objects, then
 * reclaim the remaining inodes that are still in memory at this point in
 * time.
 */
static void
xfs_unmount_flush_inodes(
	struct xfs_mount	*mp)
{
	xfs_log_force(mp, XFS_LOG_SYNC);
	xfs_extent_busy_wait_all(mp);
	flush_workqueue(xfs_discard_wq);

	mp->m_flags |= XFS_MOUNT_UNMOUNTING;

	xfs_ail_push_all_sync(mp->m_ail);
	cancel_delayed_work_sync(&mp->m_reclaim_work);
	xfs_reclaim_inodes(mp);
	xfs_health_unmount(mp);
}

Everything else looks fine.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
