Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DC3829DFB
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 18:42:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83F75AC001
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:42:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8WdZZGqcaIjVrHmr for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 16:42:18 -0700 (PDT)
Date: Fri, 20 Sep 2013 09:42:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/4] xfs: push down inactive transaction mgmt for
	remote symlinks
Message-ID: <20130919234209.GP9901@dastard>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
	<1379618121-35105-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379618121-35105-2-git-send-email-bfoster@redhat.com>
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

On Thu, Sep 19, 2013 at 03:15:18PM -0400, Brian Foster wrote:
> Push down the transaction management for remote symlinks from
> xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
> cleaned up to avoid transaction management intended for the
> calling context (i.e., trans duplication, reservation, item
> attachment).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Couple of things....

> index f622a97..2ce31a5 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -424,8 +424,7 @@ xfs_symlink(
>   */
>  STATIC int
>  xfs_inactive_symlink_rmt(
> -	xfs_inode_t	*ip,
> -	xfs_trans_t	**tpp)
> +	xfs_inode_t	*ip)

struct xfs_inode

>  
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	if (error)
> +		goto error_trans_cancel;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);

Ok, here's where naming the jump labels sanely points out problems.
We've locked and joined the inode to the transaction. That means we
can't unlock the inode until *after* we've committed or aborted the
transaction. Unlocking it before the abort mens someone else can
lock it into a transaction and modify it before the abort is
processed....

That means the error handling stack is doing things the wrong way
around.

To fix it, I'd get rid of the error_trans_cancel label and
just cancel the transaction directly if xfs_trans_reserve() fails.
That doesn't need the abort flag, as nothing has been added to the
transaction at that point.

Then the "error_unlock" case can be converted to cancel the
transaction and then unlock the inode (maybe rename that case to
"error_trans_cancel").

> @@ -508,29 +515,16 @@ xfs_inactive_symlink_rmt(
>  	 * Mark it dirty so it will be logged and moved forward in the log as
>  	 * part of every commit.
>  	 */
> -	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	/*
> -	 * Get a new, empty transaction to return to our caller.
> -	 */
> -	ntp = xfs_trans_dup(tp);
> -	/*
>  	 * Commit the transaction containing extent freeing and EFDs.
> -	 * If we get an error on the commit here or on the reserve below,
> -	 * we need to unlock the inode since the new transaction doesn't
> -	 * have the inode attached.
>  	 */
> -	error = xfs_trans_commit(tp, 0);
> -	tp = ntp;
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (error) {
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> -		goto error0;
> +		goto error_trans_cancel;

There's not need to cancel a transaction on a commit error. An
error in the commit will run an abort/cancel before it returns, and
as such the transaction handle is always unusable on return from
xfs_trans_commit()...

> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return XFS_ERROR(EIO);
>  
> @@ -590,14 +572,19 @@ xfs_inactive_symlink(
>  		return XFS_ERROR(EFSCORRUPTED);
>  	}
>  
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);

You should lock before checking the size of the inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
