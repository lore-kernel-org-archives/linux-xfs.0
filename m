Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48673C00140
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 00:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiHAAGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 20:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHAAGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 20:06:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A68295B4
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 17:06:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-20-138.pa.nsw.optusnet.com.au [49.195.20.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C0A0510C8A46;
        Mon,  1 Aug 2022 10:06:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oIIxF-007gKP-QO; Mon, 01 Aug 2022 10:06:41 +1000
Date:   Mon, 1 Aug 2022 10:06:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: check return codes when flushing block devices
Message-ID: <20220801000641.GZ3600936@dread.disaster.area>
References: <YuasRCKeYsKlCgPM@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuasRCKeYsKlCgPM@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62e71913
        a=cxZHBGNDieHvTKNp/pucQQ==:117 a=cxZHBGNDieHvTKNp/pucQQ==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QSdvR6El54khIaCTkrMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 31, 2022 at 09:22:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a block device cache flush fails, fsync needs to report that to upper
> levels.  If the log can't flush the data device, we should shut it down
> immediately because we've just violated an invariant.  Hence, check the
> return value of blkdev_issue_flush.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c |   15 ++++++++++-----
>  fs/xfs/xfs_log.c  |    7 +++++--
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5a171c0b244b..88450c33ab01 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -163,9 +163,11 @@ xfs_file_fsync(
>  	 * inode size in case of an extending write.
>  	 */
>  	if (XFS_IS_REALTIME_INODE(ip))
> -		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> +		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> -		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> +		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * Any inode that has dirty modifications in the log is pinned.  The
> @@ -173,8 +175,11 @@ xfs_file_fsync(
>  	 * that happen concurrently to the fsync call, but fsync semantics
>  	 * only require to sync previously completed I/O.
>  	 */
> -	if (xfs_ipincount(ip))
> +	if (xfs_ipincount(ip)) {
>  		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> +		if (error)
> +			return error;
> +	}

Shouldn't we still try to flush the data device if necessary, even
if the log flush failed?

>  	/*
>  	 * If we only have a single device, and the log force about was
> @@ -185,9 +190,9 @@ xfs_file_fsync(
>  	 */
>  	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
>  	    mp->m_logdev_targp == mp->m_ddev_targp)
> -		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> +		return blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
>  
> -	return error;
> +	return 0;
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4b1c0a9c6368..8a767f4145f0 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1926,8 +1926,11 @@ xlog_write_iclog(
>  		 * by the LSN in this iclog is on stable storage. This is slow,
>  		 * but it *must* complete before we issue the external log IO.
>  		 */
> -		if (log->l_targ != log->l_mp->m_ddev_targp)
> -			blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
> +		if (log->l_targ != log->l_mp->m_ddev_targp &&
> +		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> +			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> +			return;
> +		}

That seems pretty drastic, though I'm not sure what else apart from
ignoring the data device flush error can be done here. Also, it's
not actually a log IO error - it's a data device IO error so it's a
really a metadata writeback problem. Hence the use of
SHUTDOWN_LOG_IO_ERROR probably needs a comment to explain why it
needs to be used here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
