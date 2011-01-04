Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p045HiRl180311 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 23:17:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1042F9BB6C
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 21:19:50 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	aABl7LG7RwNY2sRV for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 21:19:50 -0800 (PST)
Date: Tue, 4 Jan 2011 16:19:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS handling of synchronous buffers in case of EIO error
Message-ID: <20110104051947.GI15179@dastard>
References: <AANLkTi=Tmh9m_Rwy-bUZQEzcZ3M+6X9tZxFMO-J2Rvec@mail.gmail.com>
	<20101230231353.GC15179@dastard>
	<AANLkTi=OK4uGx5476ro8W47icu685gvQea43rNHozPKS@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=OK4uGx5476ro8W47icu685gvQea43rNHozPKS@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 31, 2010 at 12:17:12PM +0530, Ajeet Yadav wrote:
> Dear Dave,
> 
> Our Kernel is 2.6.30.9 but XFS is backported from 2.6.34.
> But I have seen similar behaviour in another post related to process ls hang
> in 2.6.35.9
> *
> 
> http://oss.sgi.com/pipermail/xfs/2010-December/048691.html
> 
> *I have always seen the hang problem comes only if comes when b_relse !=
> NULL, and b_hold > 2
> 
> I have made below workaround it solved the problem in our case because when
> USB is removed we know we get EIO error.
> 
> But I think we need to review xfs_buf_error_relse() and xfs_buf_relse()
> considering  XBF_LOCK flow path.
> 
> @@ -1047,9 +1047,19 @@ xfs_buf_iodone_callbacks(
>                         /* We actually overwrite the existing b-relse
>                            function at times, but we're gonna be shutting
> down
>                            anyway. */
> -                       XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
> -                       XFS_BUF_DONE(bp);
> -                       XFS_BUF_FINISH_IOWAIT(bp);
> +                       if (XFS_BUF_GETERROR(bp) == EIO){
> +                               ASSERT(XFS_BUF_TARGET(bp) ==
> mp->m_ddev_targp);
> +                               XFS_BUF_SUPER_STALE(bp);
> +                               trace_xfs_buf_item_iodone(bp, _RET_IP_);
> +                               xfs_buf_do_callbacks(bp, lip);
> +                               XFS_BUF_SET_FSPRIVATE(bp, NULL);
> +                               XFS_BUF_CLR_IODONE_FUNC(bp);
> +                               xfs_biodone(bp);
> +                       } else {
> +
> XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
> +                               XFS_BUF_DONE(bp);
> +                               XFS_BUF_FINISH_IOWAIT(bp);
> +                       }
>                 }
>                 return;
>         }

This won't work reliably because it only handles one specific type
of error. We can get more than just EIO back from the lower layers,
and so if the superblock write gets a different error then we'll
still get the same hang.

Effectively what you are doing here is running the
xfs_buf_error_relse() callback directly in line. This will result in
the buffer being unlocked before the error is pulled off the buffer
after xfs_buf_iowait() completes. Essentially that means that some
other thread can reuse the buffer and clear the error before the
waiter has received the error.

I think the correct fix is to call the bp->b_relse function when the
waiter is woken to clear the error and unlock the buffer. I've just
posted a patch to do this for 2.6.38, but it won't trivially backport
to 2.6.34 or 2.6.30 as the synchronous write interfaces into the
buffer cache have been cleaned up and simplified recently. It should
still be relatively easy to handle, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
