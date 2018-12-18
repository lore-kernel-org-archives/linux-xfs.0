Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49970 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLRT2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 14:28:09 -0500
Date: Tue, 18 Dec 2018 11:28:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: clear XFS_ILOG_[AD]OWNER for non-btree formats
Message-ID: <20181218192804.GG27208@magnolia>
References: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
 <31aaeb46-8fb5-79f5-66bd-d594b9a6cc89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31aaeb46-8fb5-79f5-66bd-d594b9a6cc89@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 18, 2018 at 01:09:40PM -0600, Eric Sandeen wrote:
> If an inode had been in btree format and had a data fork owner change
> logged, that flag must be cleared if the inode changes format to
> non-btree.  Otherwise we hit the old ASSERT (now changed to
> corruption detection) in xfs_recover_inode_owner_change() which
> enforces that if XFS_ILOG_[AD]OWNER is set, XFS_ILOG_[AD]BROOT
> must be as well.
> 
> (Or, put more plainly, changing the fork owner is nonsensical
> for inodes which have no such fork.)

...and now I learn why not to review a series until all the patches show
up. :(

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index fa1c4fe2ffbf..82a13b7ad321 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -144,7 +144,8 @@ xfs_inode_item_format_data_fork(
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		iip->ili_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
> +			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> +			  XFS_ILOG_DEV | XFS_ILOG_DOWNER);

So ... existing kernels could accidentally log an inode with an extents
format data fork and (DOWNER | DBROOT).  If a kernel encounters such a
log item, it would assert and kaboom, and now it'll fail the rest of log
recovery, which forces the admin to zap the log.

However, if the data fork is in extents format there isn't any work
required to change the owner anyway, so why do we have to abort the log
recovery in that case?

IOWs, why doesn't the previous patch do:

/*
 * Some old kernels mistakenly log inode items with DOWNER set on a
 * inode with a non-btree format data fork.  DBROOT won't be set in this
 * non-btree case, but since the work that DOWNER does is only required
 * for the btree case we can safely ignore this one weird combination.
 */
if ((ili_fields & DOWNER) && di_format == FMT_BTREE) {
	if (!(ili_fields & DBROOT))
		return -EFSCORRUPTED;
	error = xfs_bmbt_change_owner(...);
}

--D

>  
>  		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
>  		    ip->i_d.di_nextents > 0 &&
> @@ -185,7 +186,8 @@ xfs_inode_item_format_data_fork(
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
>  		iip->ili_fields &=
> -			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
> +			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
> +			  XFS_ILOG_DEV | XFS_ILOG_DOWNER);
>  		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
>  			/*
> @@ -206,7 +208,8 @@ xfs_inode_item_format_data_fork(
>  		break;
>  	case XFS_DINODE_FMT_DEV:
>  		iip->ili_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEXT);
> +			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> +			  XFS_ILOG_DEXT | XFS_ILOG_DOWNER);
>  		if (iip->ili_fields & XFS_ILOG_DEV)
>  			ilf->ilf_u.ilfu_rdev = sysv_encode_dev(VFS_I(ip)->i_rdev);
>  		break;
> @@ -229,7 +232,7 @@ xfs_inode_item_format_attr_fork(
>  	switch (ip->i_d.di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		iip->ili_fields &=
> -			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
> +			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AOWNER);
>  
>  		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
>  		    ip->i_d.di_anextents > 0 &&
> @@ -268,7 +271,7 @@ xfs_inode_item_format_attr_fork(
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
>  		iip->ili_fields &=
> -			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
> +			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT | XFS_ILOG_AOWNER);
>  
>  		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
> 
