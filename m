Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n482v6Yj247632 for <xfs@oss.sgi.com>; Thu, 7 May 2009 21:57:07 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D70914810AD
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 20:01:20 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id WBgedN47IjEhnCJE for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 20:01:20 -0700 (PDT)
Message-ID: <4A039F85.8010506@sandeen.net>
Date: Thu, 07 May 2009 21:57:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix double unlock in xfs_swap_extents()
References: <1241745202-7452-1-git-send-email-felixb@sgi.com>
In-Reply-To: <1241745202-7452-1-git-send-email-felixb@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org, a.beregalov@gmail.com, xfs@oss.sgi.com

Felix Blyakher wrote:
> Regreesion from commit ef8f7fc, which rearranged the code in
> xfs_swap_extents() leading to double unlock of xfs inode iolock.
> That resulted in xfs_fsr deadlocking itself on platforms, which
> don't handle double unlock of rw_semaphore nicely. It caused the
> count go negative, which represents the write holder, without
> really having one. ia64 is one of the platforms where deadlock
> was easily reproduced and the fix was tested.
> 
> Signed-off-by: Felix Blyakher <felixb@sgi.com>

Also-written-by: Eric Sandeen <sandeen@sandeen.net>
Independently-arrived-at-by: Eric Sandeen <sandeen@sandeen.net>

;)

But seriously ...

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/xfs_dfrag.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> index e6d839b..7465f9e 100644
> --- a/fs/xfs/xfs_dfrag.c
> +++ b/fs/xfs/xfs_dfrag.c
> @@ -347,13 +347,15 @@ xfs_swap_extents(
>  
>  	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
>  
> -out_unlock:
> -	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> -	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>  out:
>  	kmem_free(tempifp);
>  	return error;
>  
> +out_unlock:
> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	goto out;
> +
>  out_trans_cancel:
>  	xfs_trans_cancel(tp, 0);
>  	goto out_unlock;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
