Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3848A7D07
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 23:59:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1F318F8037
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 21:59:34 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id qktuBErbb5R0KrXC
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 21:59:31 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id n129so10141883wmn.1
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 21:59:31 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <a71e1aed74b2922e8ed6fb40404899e7@mail.gmail.com>
	<20160426224612.GE26977@dastard>
In-Reply-To: <20160426224612.GE26977@dastard>
MIME-Version: 1.0
Date: Wed, 27 Apr 2016 10:29:29 +0530
Message-ID: <cbaec1d0ddb8505a9d35084291d33f37@mail.gmail.com>
Subject: RE: [PATCH] xfs_buf_iodone_callbacks to force shutdown & resubmit buf
	in case of permanent failure
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

Hi Dave,

I am not sure how to do lock release in this code path. Is it possible
that you can take over this bug/patch? Thanks.

--Shyam

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: 27 April 2016 04:16
To: Shyam Kaushik
Cc: xfs@oss.sgi.com; Alex Lyakas
Subject: Re: [PATCH] xfs_buf_iodone_callbacks to force shutdown & resubmit
buf in case of permanent failure

On Tue, Apr 26, 2016 at 07:31:59PM +0530, Shyam Kaushik wrote:
> When XFS underlying disk fails, it could take several milliseconds for
the
> FS to be marked
> shutdown. xfs_buf_iodone_callbacks() retries buf upon first failure by
> submitting it once
> again. But if the buf fails 2nd time before FS is marked for shutdown,
it
> just releases the
> buf with xfs_buf_relse(). This is flawed that nobody is releasing the
> XFS_IFLOCK on the inode.
> Because of this AIL tasks repeated effort to xfs_inode_item_push() will
> see that xfs_iflock()
> cannot be acquired. This blocks XFS from being unmounted as
> xfs_ail_push_all_sync() will keep
> looping without progress.

Patch formatting first: commit messages should wrap at 68-72
columns...

> Fix this by marking the FS for shutdown if we have a permanent failure &
> resubmit the buf.
> xfs_buf_submit() will see FS marked for shutdown & invoke the callback
> which releases
> XFS_IFLOCK.
>
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1a6c9b9..6f73ee0 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1100,7 +1100,12 @@ xfs_buf_iodone_callbacks(
>                                        XBF_DONE | XBF_WRITE_FAIL;
>                         xfs_buf_submit(bp);
>                 } else {
> -                       xfs_buf_relse(bp);
> +                       /*
> +                       * if we have the buf fail 2nd time, force a FS
> shutdown & resubmit
> +                       * the buf for it to be failed back immediately
> +                       */
> +                       xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> +                       xfs_buf_submit(bp);
>                 }
>
>                 return;

... and patches should not be wrapped or have tabs converted to
spaces. See Documentation/SubmittingPatches.

Ok, so yes, it would seem there is a bug here, but I don't think
this is correct solution: this will shut down the filesystem
immediately on inode write IO errors. As i've said *many* times
before: this is might seem like a fix, but it is incorrect behaviour
as it does not give transient failures (e.g. multipath failover
causing timeouts) a chance to be resolved before shutting down the
filesystem.

That's the reason for all the retry behaviour on XFS metadata - the
system can continue to run logging new changes even if it can't
write back the changes immediately. As long as the log writes
continue to work, the filesystem can continue to function correctly.
Hence shutting down the filesystem immediately on any metadata write
error (other than a journal write) is premature and will lead to
spurious errors causing shutdowns rather than just logging a
warning.

We are in the process of making this error behaviour configurable -
Carlos is going to finish off the patchset I originally wrote to do
this, so the "shutdown immediately" option will be avaialable
through that set of interfaces. We'll still need to fix the unlock
case for retry here, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
