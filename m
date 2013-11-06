Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F3B27F92
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 23:40:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 26F0C8F8087
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 21:39:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZAKTE72drsEK4Pot for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 21:39:56 -0800 (PST)
Date: Wed, 6 Nov 2013 16:39:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix unlock in xfs_bmap_add_attrfork
Message-ID: <20131106053951.GC6188@dastard>
References: <20131105202719.667077352@eagdhcp-232-150.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131105202719.667077352@eagdhcp-232-150.americas.sgi.com>
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

On Tue, Nov 05, 2013 at 02:27:07PM -0600, Mark Tinguely wrote:
> xfs_trans_ijoin() activates the inode in a transaction and
> also can specify which lock to free when the transaction is
> committed or canceled.
> 
> xfs_bmap_add_attrfork adds the XFS_ILOCK_EXCL flag when calling
> xfs_trans_ijoin() so it wrong to also free this lock before doing
> a xfs_trans_cancel. Add the unlock to the error case before the
> xfs_trans_ijoin and remove the unlock from the error recovery.
> While here, clean up the goto names.

Definitely a bug, but I suspect it is the wrong fix. This is a
permanent log transaction, which means there are multiple commits
before the final commit, and xfs_trans_ijoin(XFS_ILOCK_EXCL) means
we will unlock the inode at the first commit that is made after the
join, not after the modifications are completed. Hence someone else
can come in and lock and modify the inode before we've finish all
the work in this function.

Hence I suspect the right fix is to make this code use
xfs_trans_ijoin(0) and do manual unlocking of the inode after the
last commit/cancel is done, similar to how it is done in 
xfs_iomap_write_allocate/direct...

Coupl eof other minor things:

> ===================================================================
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -1137,9 +1137,11 @@ xfs_bmap_add_attrfork(
>  	int			committed;	/* xaction was committed */
>  	int			logflags;	/* logging flags */
>  	int			error;		/* error return value */
> +	int			cancel_flags;
>  
>  	ASSERT(XFS_IFORK_Q(ip) == 0);
>  
> +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT;
>  	mp = ip->i_mount;
>  	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
> @@ -1148,18 +1150,20 @@ xfs_bmap_add_attrfork(
>  		tp->t_flags |= XFS_TRANS_RESERVE;
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
>  	if (error)
> -		goto error0;
> +		goto trans_cancel;

No reservation exists, so xfs_trans_cancel(tp, 0) is appropriate
here. i.e. cancel_flags gets initialised to 0, and after we have a
reservation we do:

	cancel_flags |= XFS_TRANS_RELEASE_LOG_RES;

>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
>  			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
>  			XFS_QMOPT_RES_REGBLKS);
>  	if (error) {
> +		cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
> -		return error;
> +		goto trans_cancel;
> +	}

Now we potentially have dirty objects in the transaction, so

	cancel_flags |= XFS_TRANS_ABORT;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
