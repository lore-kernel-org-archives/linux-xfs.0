Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D53N6a194324 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 00:03:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5E991AD9775
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 22:05:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	F8tdLDuvNIWuK4KJ for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 22:05:16 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	20638386-1927428
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 14:35:15 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1O1YJF-0003Yf-Kz
	for xfs@oss.sgi.com; Tue, 13 Apr 2010 15:05:13 +1000
Date: Tue, 13 Apr 2010 15:05:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: more swap extent fixes for dynamic fork offsets
Message-ID: <20100413050513.GR2493@dastard>
References: <1270543984-20598-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270543984-20598-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

ping?

On Tue, Apr 06, 2010 at 06:53:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A new xfsqa test (226) with a prototype xfs_fsr change to try to
> handle dynamic fork offsets better triggers an assertion failure
> where the inode data fork is in btree format, yet there is room in
> the inode for it to be in extent format. The two inodes look like:
> 
> before: ino 0x101 (target), num_extents 11, Max in-fork extents 6, broot size 40, fork offset 96
> before: ino 0x115 (temp),  num_extents 5, Max in-fork extents 3, broot size 40, fork offset 56
> after: ino 0x101 (target), num_extents 5, Max in-fork extents 6, broot size 40, fork offset 96
> after: ino 0x115 (temp), num_extents 11, Max in-fork extents 3, broot size 40, fork offset 56
> 
> Basically the target inode ends up with 5 extents in btree format,
> but it had space for 6 extents in extent format, so ends up
> incorrect. Notably here the broot size is the same, and that is
> where the kernel code is going wrong - the btree root will fit, so
> it lets the swap go ahead.
> 
> The check should not allow the swap to take place if the number of
> extents while in btree format is less than the number of extents
> that can fit in the inode in extent format. Adding that check will
> prevent this swap and corruption from occurring.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_dfrag.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> index cd27c9d..5bba29a 100644
> --- a/fs/xfs/xfs_dfrag.c
> +++ b/fs/xfs/xfs_dfrag.c
> @@ -177,16 +177,26 @@ xfs_swap_extents_check_format(
>  	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > tip->i_df.if_ext_max)
>  		return EINVAL;
>  
> -	/* Check root block of temp in btree form to max in target */
> +	/*
> +	 * If we are in a btree format, check that the temp root block will fit
> +	 * in the target and that it has enough extents to be in btree format
> +	 * in the target.
> +	 *
> +	 * Note that we have to be careful to allow btree->extent conversions
> +	 * (a common defrag case) which will occur when the temp inode is in
> +	 * extent format...
> +	 */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> -	    XFS_IFORK_BOFF(ip) &&
> -	    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
> +	    ((XFS_IFORK_BOFF(ip) &&
> +	      tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip)) ||
> +	     XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <= ip->i_df.if_ext_max))
>  		return EINVAL;
>  
> -	/* Check root block of target in btree form to max in temp */
> +	/* Reciprocal target->temp btree format checks */
>  	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> -	    XFS_IFORK_BOFF(tip) &&
> -	    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
> +	    ((XFS_IFORK_BOFF(tip) &&
> +	      ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip)) ||
> +	     XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <= tip->i_df.if_ext_max))
>  		return EINVAL;
>  
>  	return 0;
> -- 
> 1.6.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
