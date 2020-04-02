Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156D9C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 21:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D206320737
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 21:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbgDBVzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 17:55:54 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34924 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbgDBVzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 17:55:54 -0400
Received: from dread.disaster.area (pa49-180-164-3.pa.nsw.optusnet.com.au [49.180.164.3])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4D50D7EA6D7;
        Fri,  3 Apr 2020 08:55:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jK7oT-0005AS-LZ; Fri, 03 Apr 2020 08:55:49 +1100
Date:   Fri, 3 Apr 2020 08:55:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402215549.GB21885@dread.disaster.area>
References: <20200402041705.GD80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402041705.GD80283@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=K0+o7W9luyMo1Ua2eXjR1w==:117 a=K0+o7W9luyMo1Ua2eXjR1w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=XESBqbC2DxrBUUkUzz0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 09:17:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reflink should force the log out to disk if the filesystem was mounted
> with wsync, the same as most other operations in xfs.
> 
> Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_file.c    |   21 +++++++++++++++++++--
>  fs/xfs/xfs_reflink.c |   15 ++++++++++++++-
>  fs/xfs/xfs_reflink.h |    3 ++-
>  3 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b8a4a3f29b36..17bdc5bbc2ae 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1029,8 +1029,10 @@ xfs_file_remap_range(
>  	struct inode		*inode_out = file_inode(file_out);
>  	struct xfs_inode	*dest = XFS_I(inode_out);
>  	struct xfs_mount	*mp = src->i_mount;
> +	xfs_lsn_t		sync_lsn = 0;
>  	loff_t			remapped = 0;
>  	xfs_extlen_t		cowextsize;
> +	bool			need_sync;
>  	int			ret;
>  
>  	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
> @@ -1068,13 +1070,28 @@ xfs_file_remap_range(
>  		cowextsize = src->i_d.di_cowextsize;
>  
>  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> -			remap_flags);
> +			remap_flags, &need_sync);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/*
> +	 * If this is a synchronous mount and xfs_reflink_update_dest didn't
> +	 * already take care of this, make sure that the transaction goes to
> +	 * disk before returning to the user.
> +	 */
> +	if (need_sync && xfs_ipincount(dest))
> +		sync_lsn = dest->i_itemp->ili_last_lsn;
>  
>  out_unlock:
>  	xfs_reflink_remap_unlock(file_in, file_out);
>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
> -	return remapped > 0 ? remapped : ret;
> +	if (remapped > 0) {
> +		if (sync_lsn)
> +			xfs_log_force_lsn(mp, sync_lsn, XFS_LOG_SYNC, NULL);
> +		return remapped;
> +	}
> +	return ret;

This seems pretty fragile compared to all the other WSYNC cases
which just set the last transaction as a sync transaction.

Why can't we just set the transaction sync at the appropriate time,
and if we have to do two sync commits for a reflink then we just
suck it up for now?

As it is, wsync is really only used for active/passive HA configs
these days, which means we've already given up on performance
because data integrity is an essential requirement in those
configs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
