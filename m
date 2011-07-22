Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MJcQJ5102040 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:38:26 -0500
Subject: Re: [PATCH 03/12] xfs: Remove the macro XFS_BUF_ERROR and family
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722003254.21069.27101.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003254.21069.27101.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Fri, 22 Jul 2011 14:38:10 -0500
Message-ID: <1311363490.2771.98.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-07-21 at 17:32 -0700, Chandra Seetharaman wrote:
> Remove the definitions and usage of the macros XFS_BUF_ERROR,
> XFS_BUF_GETERROR and XFS_BUF_ISERROR.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Nice work on this.  It is clear it was thoughtfully
done.

I have two things that need to be fixed.  If you do that
you can consider this signed off by me.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
> index 837f311..e7e35fb 100644
> --- a/fs/xfs/quota/xfs_dquot.c
> +++ b/fs/xfs/quota/xfs_dquot.c
> @@ -403,7 +403,8 @@ xfs_qm_dqalloc(
>  			       dqp->q_blkno,
>  			       mp->m_quotainfo->qi_dqchunklen,
>  			       0);
> -	if (!bp || (error = XFS_BUF_GETERROR(bp)))
> +	error = xfs_buf_geterror(bp);
> +	if (error)
>  		goto error1;
>  	/*
>  	 * Make a chunk of dquots out of this buffer and log

This results in behavior that differs from before.
Previously, error would have value 0 following
the call to xfs_trans_get_buf() here, meaning that
(at error1:) xfs_qm_dqalloc() would return 0 in
this case.  Now it will return ENOMEM.

I think what you have done may be correct, but
since the change does more than the simple
macro transformation you intend, this change
should be done in a separate commit.

So either:
- post a new patch (preferably before this
  whole series) that makes this code return
  ENOMEM if xfs_trans_get_buf() returns a
  null pointer, then update this patch accordingly;
- or just change this patch to return 0 instead
  of  ENOMEM if xfs_trans_get_buf() returns a
  null pointer.

. . .

> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 88d1214..97daa35 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -83,7 +83,7 @@ xfs_readlink_bmap(
>  
>  		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
>  				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);

xfs_buf_read() can return NULL here, so to match
the existing behavior you should call xfs_buf_geterror()
here.

> -		error = XFS_BUF_GETERROR(bp);
> +		error = bp->b_error;
>  		if (error) {
>  			xfs_ioerror_alert("xfs_readlink",
>  				  ip->i_mount, bp, XFS_BUF_ADDR(bp));


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
