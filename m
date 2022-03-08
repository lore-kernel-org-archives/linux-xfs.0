Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76E8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Mar 2022 22:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiCHWTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 17:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiCHWTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 17:19:55 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F17D6F1B
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 14:18:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 402D610E2442;
        Wed,  9 Mar 2022 09:18:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRiAS-0039c8-0D; Wed, 09 Mar 2022 09:18:56 +1100
Date:   Wed, 9 Mar 2022 09:18:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reserve quota for directory expansion when
 hardlinking files
Message-ID: <20220308221855.GC661808@dread.disaster.area>
References: <20220301025118.GG117732@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301025118.GG117732@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6227d651
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=3BAniVUdc8oPeBq_kggA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 06:51:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The XFS implementation of the linkat call does not reserve quota for the
> potential directory expansion.  This means that we don't reject the
> expansion with EDQUOT when we're at or near a hard limit, which means
> that one can use linkat() to exceed quota.  Fix this by adding a quota
> reservation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 04bf467b1090..6e556c9069e8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1249,6 +1249,10 @@ xfs_link(
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>  
> +	error = xfs_trans_reserve_quota_nblks(tp, tdp, resblks, 0, false);
> +	if (error)
> +		goto error_return;
> +
>  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
>  			XFS_IEXT_DIR_MANIP_CNT(mp));
>  	if (error)

Yup, ok, but doesn't xfs_remove have exactly the same problem? i.e.
removing a directory entry can punch a hole in the bmbt and require
new allocations for a BMBT split, thereby increasing the number of
blocks allocated to the directory? e.g. remove a single data block,
need to then allocate half a dozen BMBT blocks for the shape change.

If so, then both xfs_link() and xfs_remove() have exactly the same
dquot, inode locking and transaction setup code and requirements,
and probably should be factored out into xfs_trans_alloc_dir() (i.e.
equivalent of xfs_trans_alloc_icreate() used by all the inode create
functions).  That way we only have one copy of this preamble and
only need to fix the bug in one place?

Alternatively, fix the bug in both places first and add a followup
patch that factors out this code as per above.

Hmmm - looking further a callers of xfs_lock_two_inodes(), it would
appear that xfs_swap_extents() needs the same quota reservation
and also largely has the same transaction setup and inode locking
preamble as link and remove...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
