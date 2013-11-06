Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1768E7F94
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 16:41:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94046AC005
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 14:41:52 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xLVsLrOsjPu84g58 for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 14:41:50 -0800 (PST)
Date: Thu, 7 Nov 2013 09:41:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix unlock in xfs_bmap_add_attrfork
Message-ID: <20131106224145.GH6188@dastard>
References: <20131106211618.754470168@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106211618.754470168@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 03:14:58PM -0600, Mark Tinguely wrote:
> xfs_trans_ijoin() activates the inode in a transaction and
> also can specify which lock to free when the transaction is
> committed or canceled.
> 
> xfs_bmap_add_attrfork call locks and add the lock to the
> transaction but also manually removes the lock. Change the
> routine to not add the lock to the transaction and manually
> remove lock on completion.
> 
> While here, clean up the xfs_trans_cancel flags and goto names.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

All good, except for:

> @@ -1242,14 +1244,15 @@ xfs_bmap_add_attrfork(
>  
>  	error = xfs_bmap_finish(&tp, &flist, &committed);
>  	if (error)
> -		goto error2;
> -	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> -error2:
> +		goto bmap_cancel;
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	goto unlock_return;
> +bmap_cancel:
>  	xfs_bmap_cancel(&flist);
> -error1:
> +trans_cancel:
> +	xfs_trans_cancel(tp, cancel_flags);
> +unlock_return:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -error0:
> -	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
>  	return error;
>  }

This hunk. It ends up looking like this:

	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
	goto unlock_return;
bmap_cancel:
	xfs_bmap_cancel(&flist);
trans_cancel:
	xfs_trans_cancel(tp, cancel_flags);
unlock_return:
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	return error;
}

Which jumps over error handling cases on a successful completion.
The conventional way of doing this is having the successful return
case run straight through to the return, and having the error stack
either jump back into it like so:

	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
unlock_return:
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	return error;

bmap_cancel:
	xfs_bmap_cancel(&flist);
trans_cancel:
	xfs_trans_cancel(tp, cancel_flags);
	goto unlock_return;
}

or do an additional unlock and return directly in the error stack
and let the compiler optimise it appropriately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
