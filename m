Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0034C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 07:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiCDHwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Mar 2022 02:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236655AbiCDHwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Mar 2022 02:52:23 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E3D7190C34
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 23:51:36 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 31899533B17;
        Fri,  4 Mar 2022 18:51:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nQ2ir-001LEO-TE; Fri, 04 Mar 2022 18:51:33 +1100
Date:   Fri, 4 Mar 2022 18:51:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 14/17] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220304075133.GJ59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-15-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6221c507
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=Dkvl6jrkKj0T9ZNS6bYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:35PM +0530, Chandan Babu R wrote:
> This commit upgrades inodes to use 64-bit extent counters when they are read
> from disk. Inodes are upgraded only when the filesystem instance has
> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c       |  5 ++---
>  fs/xfs/libxfs/xfs_inode_fork.c | 37 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  fs/xfs/xfs_bmap_item.c         |  3 ++-
>  fs/xfs/xfs_bmap_util.c         | 10 ++++-----
>  fs/xfs/xfs_dquot.c             |  2 +-
>  fs/xfs/xfs_iomap.c             |  5 +++--
>  fs/xfs/xfs_reflink.c           |  5 +++--
>  fs/xfs/xfs_rtalloc.c           |  2 +-
>  10 files changed, 58 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 23523b802539..03a358930d74 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -774,7 +774,8 @@ xfs_attr_set(
>  		return error;
>  
>  	if (args->value || xfs_inode_hasattr(dp)) {
> -		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +		error = xfs_trans_inode_ensure_nextents(&args->trans, dp,
> +				XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));

hmmmm.

>  		if (error)
>  			goto out_trans_cancel;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index be7f8ebe3cd5..3a3c99ef7f13 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4523,14 +4523,13 @@ xfs_bmapi_convert_delalloc(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, whichfork,
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_trans_ijoin(tp, ip, 0);
> -
>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>  	    bma.got.br_startoff > offset_fsb) {
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a3a3b54f9c55..d1d065abeac3 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -757,3 +757,40 @@ xfs_iext_count_may_overflow(
>  
>  	return 0;
>  }
> +
> +/*
> + * Ensure that the inode has the ability to add the specified number of
> + * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
> + * the transaction.  Upon return, the inode will still be in this state
> + * upon return and the transaction will be clean.
> + */
> +int
> +xfs_trans_inode_ensure_nextents(
> +	struct xfs_trans	**tpp,
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	int			nr_to_add)

Ok, xfs_trans_inode* is a namespace that belongs to
fs/xfs/xfs_trans_inode.c, not fs/xfs/libxfs/xfs_inode_fork.c. So my
second observation is that the function needs either be renamed or
moved.

My first observation was that the function name didn't really make
any sense to me when read in context. xfs_iext_count_may_overflow()
makes sense because it's telling me that it's checking that the
extent count hasn't overflowed. xfs_trans_inode_ensure_nextents()
conveys none of that certainty.

What does it ensure? "ensure" doesn't imply we are goign to change
anything - it could just mean "check and abort if wrong" when read
as "ensure we haven't overflowed". And if we already have nrext64
and we've overflowed that then it will still fail, meaning we
haven't "ensured" anything.

This would make much more sense if written as:

	error = xfs_iext_count_may_overflow();
	if (error && error != -EOVERFLOW)
		goto out_trans_cancel;

	if (error == -EOVERFLOW) {
		error = xfs_inode_upgrade_extent_counts();
		if (error)
			goto out_trans_cancel;
	}

Because it splits the logic into a "do we need to do something"
part and a "do an explicit modification" part.


> +{
> +	int			error;
> +
> +	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> +	if (!error)
> +		return 0;
> +
> +	/*
> +	 * Try to upgrade if the extent count fields aren't large
> +	 * enough.
> +	 */
> +	if (!xfs_has_nrext64(ip->i_mount) ||
> +	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
> +		return error;

Oh, that's tricky, too. The first check returns if there's no error,
the second check returns the error of the first function. Keeping
the initial overflow check in the caller gets rid of this, too.

> +
> +	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> +	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> +
> +	error = xfs_trans_roll(tpp);
> +	if (error)
> +		return error;

Why does this need to roll the transaction? We can just log the
inode core and return to the caller which will then commit the
change.

> +	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);

If the answer is so we don't cancel a dirty transaction here, then
I think this check needs to be more explicit - don't even try to do
the upgrade if the number of extents we are adding will cause an
overflow anyway.

As it is, wouldn't adding 2^47 - 2^31 extents in a single hit be
indicative of a bug? We can only modify the extent count by a
handful of extents (10, maybe 20?) at most in a single transaction,
so why do we even need this check?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
