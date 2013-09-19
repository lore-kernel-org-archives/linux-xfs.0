Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE35929DFB
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 18:48:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E154AC002
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:48:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	G7G2An3hI8B9O82o for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 16:48:03 -0700 (PDT)
Date: Fri, 20 Sep 2013 09:47:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] xfs: push down inactive transaction mgmt for
	truncate
Message-ID: <20130919234725.GQ9901@dastard>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
	<1379618121-35105-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379618121-35105-3-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 19, 2013 at 03:15:19PM -0400, Brian Foster wrote:
> Create the new xfs_inactive_truncate() function to handle the
> truncate portion of xfs_inactive(). Push the locking and
> transaction management into the new function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 117 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 68 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 30db70e..33bb9be 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1663,6 +1663,58 @@ xfs_release(
>  }
>  
>  /*
> + * xfs_inactive_truncate
> + *
> + * Called to perform a truncate when an inode becomes unlinked.
> + */
> +STATIC int
> +xfs_inactive_truncate(
> +	struct xfs_inode *ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> +
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	if (error) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		goto error_trans_cancel;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	/*
> +	 * Log the inode size first to prevent stale data exposure in the event
> +	 * of a system crash before the truncate completes. See the related
> +	 * comment in xfs_setattr_size() for details.
> +	 */
> +	ip->i_d.di_size = 0;
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> +	if (error)
> +		goto error_unlock;
> +
> +	ASSERT(ip->i_d.di_nextents == 0);
> +
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	if (error)
> +		goto error_unlock;

Same again - no cancel on commit error, just fall through and return
the error....

> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return 0;
> +
> +error_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +error_trans_cancel:
> +	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);

Same again w.r.t. unlock/cancel. FWIW, see xfs_free_file_space() for
an example of how the ordering is supposed to work.

And, note:

> -	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> -	resp = truncate ? &M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
> -
> -	error = xfs_trans_reserve(tp, resp, 0, 0);
> -	if (error) {
> -		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> -		xfs_trans_cancel(tp, 0);

Different flags :)

> @@ -1831,13 +1854,9 @@ xfs_inactive(
>  	 * Release the dquots held by inode, if any.
>  	 */
>  	xfs_qm_dqdetach(ip);
> -out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
>  	return VN_INACTIVE_CACHE;
> -out_cancel:
> -	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
> -	goto out_unlock;

And the ordering of the previous code... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
