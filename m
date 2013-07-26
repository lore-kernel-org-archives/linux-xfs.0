Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4829129E21
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:18:42 -0500 (CDT)
Message-ID: <51F2CB91.3020801@sgi.com>
Date: Fri, 26 Jul 2013 14:18:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 24/49] xfs: kill xfs_vnodeops.[ch]
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-25-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:24, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now we have xfs_inode.c for holding kernel-only XFS inode
> operations, move all the inode operations from xfs_vnodeops.c to
> this new file as it holds another set of kernel-only inode
> operations. The name of this file traces back to the days of Irix
> and it's vnodes which we don't have anymore.
>
> Essentially this move consolidates the inode locking functions
> and a bunch of XFS inode operations into the one file. Eventually
> the high level functions will be merged into the VFS interface
> functions in xfs_iops.c.
>
> This leaves only internal preallocation, EOF block manipulation and
> hole punching functions in vnodeops.c. Move these to xfs_bmap_util.c
> where we are already consolidating various in-kernel physical extent
> manipulation and querying functions.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

As already mentioned, xfs_inode_fork.c still has a unwanted include of 
now removed xfs_vnodeops.h.

A xfs_qm_dqrele(pdqp) does not exist in the copied code:
> +int
> +xfs_create(
> +	xfs_inode_t		*dp,
> +	struct xfs_name		*name,
> +	umode_t			mode,
> +	xfs_dev_t		rdev,
> +	xfs_inode_t		**ipp)
> +{

...

> +	/*
> +	 * Attach the dquot(s) to the inodes and modify them incore.
> +	 * These ids of the inode couldn't have changed since the new
> +	 * inode has been locked ever since it was created.
> +	 */
> +	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
> +
> +	error = xfs_bmap_finish(&tp,&free_list,&committed);
> +	if (error)
> +		goto out_bmap_cancel;
> +
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	if (error)
> +		goto out_release_inode;
> +
> +	xfs_qm_dqrele(udqp);
> +	xfs_qm_dqrele(gdqp);

^^^ does not exist here,
> +
> +	*ipp = ip;
> +	return 0;
> +
> + out_bmap_cancel:
> +	xfs_bmap_cancel(&free_list);
> + out_trans_abort:
> +	cancel_flags |= XFS_TRANS_ABORT;
> + out_trans_cancel:
> +	xfs_trans_cancel(tp, cancel_flags);
> + out_release_inode:
> +	/*
> +	 * Wait until after the current transaction is aborted to
> +	 * release the inode.  This prevents recursive transactions
> +	 * and deadlocks from xfs_inactive.
> +	 */
> +	if (ip)
> +		IRELE(ip);
> +
> +	xfs_qm_dqrele(udqp);
> +	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
> +
> +	if (unlock_dp_on_error)
> +		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +	return error;
> +}
> +
>

> -
> -int
> -xfs_create(
> -	xfs_inode_t		*dp,
> -	struct xfs_name		*name,
> -	umode_t			mode,
> -	xfs_dev_t		rdev,
> -	xfs_inode_t		**ipp)
> -{

...
> -
> -	/*
> -	 * Attach the dquot(s) to the inodes and modify them incore.
> -	 * These ids of the inode couldn't have changed since the new
> -	 * inode has been locked ever since it was created.
> -	 */
> -	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
> -
> -	error = xfs_bmap_finish(&tp,&free_list,&committed);
> -	if (error)
> -		goto out_bmap_cancel;
> -
> -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> -	if (error)
> -		goto out_release_inode;
> -
> -	xfs_qm_dqrele(udqp);
> -	xfs_qm_dqrele(gdqp);
> -	xfs_qm_dqrele(pdqp);

exists here
> -
> -	*ipp = ip;
> -	return 0;
> -
> - out_bmap_cancel:
> -	xfs_bmap_cancel(&free_list);
> - out_trans_abort:
> -	cancel_flags |= XFS_TRANS_ABORT;
> - out_trans_cancel:
> -	xfs_trans_cancel(tp, cancel_flags);
> - out_release_inode:
> -	/*
> -	 * Wait until after the current transaction is aborted to
> -	 * release the inode.  This prevents recursive transactions
> -	 * and deadlocks from xfs_inactive.
> -	 */
> -	if (ip)
> -		IRELE(ip);
> -
> -	xfs_qm_dqrele(udqp);
> -	xfs_qm_dqrele(gdqp);
> -	xfs_qm_dqrele(pdqp);
> -
> -	if (unlock_dp_on_error)
> -		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -	return error;
> -}

The format for xfs_rename() in xfs_inode.h is funky.

Hopefully I caught everything.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
