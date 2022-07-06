Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D96EC43334
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jul 2022 00:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiGFAZ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 20:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiGFAZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 20:25:59 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BA521117E
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 17:25:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2E9E65ED0D8;
        Wed,  6 Jul 2022 10:25:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o8srb-00F2CY-Ea; Wed, 06 Jul 2022 10:25:55 +1000
Date:   Wed, 6 Jul 2022 10:25:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/3] xfs: replace inode fork size macros with functions
Message-ID: <20220706002555.GI227878@dread.disaster.area>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
 <YsTG/Juy45im6Wzv@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsTG/Juy45im6Wzv@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62c4d695
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=pHLYE6lbbWvfSOJN6q8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 04:19:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the shouty macros here with typechecked helper functions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

.....
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2badbf9bb80d..7ff828504b3c 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -102,6 +102,41 @@ xfs_ifork_ptr(
>  	}
>  }
>  
> +static inline unsigned int xfs_inode_fork_boff(struct xfs_inode *ip)
> +{
> +	return ip->i_forkoff << 3;
> +}
> +
> +static inline unsigned int xfs_inode_data_fork_size(struct xfs_inode *ip)
> +{
> +	if (xfs_inode_has_attr_fork(ip))
> +		return xfs_inode_fork_boff(ip);
> +
> +	return XFS_LITINO(ip->i_mount);
> +}
> +
> +static inline unsigned int xfs_inode_attr_fork_size(struct xfs_inode *ip)
> +{
> +	if (xfs_inode_has_attr_fork(ip))
> +		return XFS_LITINO(ip->i_mount) - xfs_inode_fork_boff(ip);
> +	return 0;
> +}
> +
> +static inline unsigned int
> +xfs_inode_fork_size(
> +	struct xfs_inode	*ip,
> +	int			whichfork)
> +{
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		return xfs_inode_data_fork_size(ip);
> +	case XFS_ATTR_FORK:
> +		return xfs_inode_attr_fork_size(ip);
> +	default:
> +		return 0;
> +	}
> +}

As an aside, one of the things I noticed when doing the 5.19 libxfs
sync was that there's some generic xfs_inode stuff in
fs/xfs/xfs_inode.h that is duplicated in include/xfs_inode.h in
userspace. I suspect all this new stuff here will end up being
duplicated, too.

Hence I'm wondering if these new functions should end up in
libxfs/xfs_inode_fork.h rather than xfs_inode.h?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
