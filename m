Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F50C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 22:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiBHWxR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiBHWxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 17:53:14 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2AF2C07D910
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 14:50:32 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E454C10C6C64;
        Wed,  9 Feb 2022 09:50:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nHZJf-009j3D-28; Wed, 09 Feb 2022 09:50:31 +1100
Date:   Wed, 9 Feb 2022 09:50:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only bother with sync_filesystem during readonly
 remount
Message-ID: <20220208225031.GK59729@dread.disaster.area>
References: <20220208200908.GD8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208200908.GD8313@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6202f3b8
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=4mXSMA3tjP24DM85IOYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 08, 2022 at 12:09:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
> into xfs_fs_remount.  The only time that we ever need to push dirty file
> data or metadata to disk for a remount is if we're remounting the
> filesystem read only, so this really could be moved to xfs_remount_ro.
> 
> Once we've moved the call site, actually check the return value from
> sync_filesystem.
> 
> Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4c0dee78b2f8..d84714e4e46a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1753,6 +1753,11 @@ xfs_remount_ro(
>  	};
>  	int			error;
>  
> +	/* Flush all the dirty data to disk. */
> +	error = sync_filesystem(mp->m_super);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Cancel background eofb scanning so it cannot race with the final
>  	 * log force+buftarg wait and deadlock the remount.
> @@ -1831,8 +1836,6 @@ xfs_fs_reconfigure(
>  	if (error)
>  		return error;
>  
> -	sync_filesystem(mp->m_super);
> -
>  	/* inode32 -> inode64 */
>  	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
>  		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
