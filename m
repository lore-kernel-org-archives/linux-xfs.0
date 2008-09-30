Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 18:44:54 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U1io3q020591
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 18:44:51 -0700
Message-ID: <48E184E0.4020301@sgi.com>
Date: Tue, 30 Sep 2008 11:46:08 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Account for allocated blocks when expanding directories
References: <1222737924-18884-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1222737924-18884-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, kevin@kevinjamieson.com

Hi Dave,

by the looks of it, this is a proposed fix for the bug reported
by Kevin Jamieson (and others in the past) :

"xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c"

Do you (or Kevin or anyone) have a reliable test case to reproduce
this?

Cheers
-- Mark

Dave Chinner wrote:
> When we create a directory, we reserve a number of blocks for
> the maximum possible expansion of of the directory due to
> various btree splits, freespace allocation, etc. Unfortunately,
> each allocation is not reflected in the total number of blocks
> still available to the transaction, so the maximal reservation
> is used over and over again.
> 
> This leads to problems where an allocation group has only
> enough blocks for *some* of the allocations required for the
> directory modification. After the first N allocations, the
> remaining blocks in the allocation group drops below the total
> reservation, and subsequent allocations fail because the allocator
> will not allow the allocation to proceed if the AG does not have
> the enough blocks available for the entire allocation total.
> 
> This results in an ENOSPC occurring after an allocation has
> already occurred. This results in aborting the directory
> operation (leaving the directory in an inconsistent state)
> and cancelling a dirty transaction, which results in a filesystem
> shutdown.
> 
> Avoid the problem by reflecting the number of blocks allocated in
> any directory expansion in the total number of blocks available to
> the modification in progress. This prevents a directory modification
> from being aborted part way through with an ENOSPC.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_da_btree.c |    5 +++++
>  fs/xfs/xfs_dir2.c     |    6 ++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index 9e561a9..a11a839 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -1566,11 +1566,14 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
>  	int nmap, error, w, count, c, got, i, mapi;
>  	xfs_trans_t *tp;
>  	xfs_mount_t *mp;
> +	xfs_drfsbno_t	nblks;
>  
>  	dp = args->dp;
>  	mp = dp->i_mount;
>  	w = args->whichfork;
>  	tp = args->trans;
> +	nblks = dp->i_d.di_nblocks;
> +
>  	/*
>  	 * For new directories adjust the file offset and block count.
>  	 */
> @@ -1647,6 +1650,8 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
>  	}
>  	if (mapp != &map)
>  		kmem_free(mapp);
> +	/* account for newly allocated blocks in reserved blocks total */
> +	args->total -= dp->i_d.di_nblocks - nblks;
>  	*new_blkno = (xfs_dablk_t)bno;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index 80e0dc5..1afb122 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -525,11 +525,13 @@ xfs_dir2_grow_inode(
>  	xfs_mount_t	*mp;
>  	int		nmap;		/* number of bmap entries */
>  	xfs_trans_t	*tp;
> +	xfs_drfsbno_t	nblks;
>  
>  	xfs_dir2_trace_args_s("grow_inode", args, space);
>  	dp = args->dp;
>  	tp = args->trans;
>  	mp = dp->i_mount;
> +	nblks = dp->i_d.di_nblocks;
>  	/*
>  	 * Set lowest possible block in the space requested.
>  	 */
> @@ -622,7 +624,11 @@ xfs_dir2_grow_inode(
>  	 */
>  	if (mapp != &map)
>  		kmem_free(mapp);
> +
> +	/* account for newly allocated blocks in reserved blocks total */
> +	args->total -= dp->i_d.di_nblocks - nblks;
>  	*dbp = xfs_dir2_da_to_db(mp, (xfs_dablk_t)bno);
> +
>  	/*
>  	 * Update file's size if this is the data space and it grew.
>  	 */

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
