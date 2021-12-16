Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD51C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 04:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhLPE4M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 23:56:12 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49039 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhLPE4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 23:56:12 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EB88C8A5280;
        Thu, 16 Dec 2021 15:56:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxioL-003dWb-KZ; Thu, 16 Dec 2021 15:56:09 +1100
Date:   Thu, 16 Dec 2021 15:56:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: take the ILOCK when accessing the inode core
Message-ID: <20211216045609.GY449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696098.3129691.10143704907338536631.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961696098.3129691.10143704907338536631.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61bac6eb
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=MmoQOcPe6RBsDS8DVY0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I was poking around in the directory code while diagnosing online fsck
> bugs, and noticed that xfs_readdir doesn't actually take the directory
> ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> the data fork mappings

Yup, that is pretty much guaranteed. If the inode is extent or btree form as the
extent count will be non-zero, hence we can only get to the
xfs_dir2_isblock() check if the inode has moved from local to block
form between the open and xfs_dir2_isblock() get in the getdents
code.

> and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> we're protected against writer threads, but we really need to follow the
> locking model like we do in other places.  The same applies to the
> shortform getdents function.

Locking rules should be the same as xfs_dir_lookup().....


> While we're at it, clean up the somewhat strange structure of this
> function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_dir2_readdir.c |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 8310005af00f..25560151c273 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -507,8 +507,9 @@ xfs_readdir(
>  	size_t			bufsize)
>  {
>  	struct xfs_da_args	args = { NULL };
> -	int			rval;
> -	int			v;
> +	unsigned int		lock_mode;
> +	int			error;
> +	int			isblock;
>  
>  	trace_xfs_readdir(dp);
>  
> @@ -522,14 +523,19 @@ xfs_readdir(
>  	args.geo = dp->i_mount->m_dir_geo;
>  	args.trans = tp;
>  
> -	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> -		rval = xfs_dir2_sf_getdents(&args, ctx);
> -	else if ((rval = xfs_dir2_isblock(&args, &v)))
> -		;
> -	else if (v)
> -		rval = xfs_dir2_block_getdents(&args, ctx);
> -	else
> -		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
> +	lock_mode = xfs_ilock_data_map_shared(dp);
> +	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
> +		xfs_iunlock(dp, lock_mode);
> +		return xfs_dir2_sf_getdents(&args, ctx);
> +	}
>  
> -	return rval;
> +	error = xfs_dir2_isblock(&args, &isblock);
> +	xfs_iunlock(dp, lock_mode);
> +	if (error)
> +		return error;
> +
> +	if (isblock)
> +		return xfs_dir2_block_getdents(&args, ctx);
> +
> +	return xfs_dir2_leaf_getdents(&args, ctx, bufsize);

Yeah, nah.

The ILOCK has to be held for xfs_dir2_block_getdents() and
xfs_dir2_leaf_getdents() for the same reason that it needs to be
held for xfs_dir2_isblock(). They both need to do BMBT lookups to
find the physical location of directory blocks in the directory, so
technically need to lock out modifications to the BMBT tree while
they are doing those lookups.

Yup, I know, VFS holds i_rwsem, so directory can't be modified while
xfs_readdir() is running, but if you are going to make one of these
functions have to take the ILOCK, then they all need to. See
xfs_dir_lookup()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
