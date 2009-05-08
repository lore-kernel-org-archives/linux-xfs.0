Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n481Hkx8241862 for <xfs@oss.sgi.com>; Thu, 7 May 2009 20:17:46 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5EF7AC002
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 18:17:50 -0700 (PDT)
Message-Id: <A84486DD-0769-45A8-B858-63082457D497@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A038651.5010202@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Date: Thu, 7 May 2009 20:17:49 -0500
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<4A036FBC.9020201@sandeen.net> <4A037503.1070904@sandeen.net>
	<ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
	<4A038651.5010202@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com


On May 7, 2009, at 8:09 PM, Eric Sandeen wrote:

> Felix Blyakher wrote:
>
>> I've been chasing this as well, and I found the double xfs iolock
>> unlock which is causing xfs_fsr deadlock itself. I have a fix tested.
>> The patch is coming.
>>
>> Felix
>>
> Oh :)  I just sent this one to the list ...  :)

Oh :) And I did as well.

And guess what, the fix is exactly the same.
Great minds think alike :)

Felix

>
>
> XFS: Fix double unlock of inodes in xfs_swap_extents()
>
> commit ef8f7fc549bf345d92f396f5aa7b152b4969cbf7 had an error
> where we would try to re-unlock the inodes after they had been
> committed in the transaction; this double unlock caused a
>
> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> xfs_fsr/1459 is trying to release lock (&(&ip->i_iolock)->mr_lock) at:
> [<e248dedb>] xfs_iunlock+0x2c/0x92 [xfs]
> but there are no more locks to release!
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>
> Index: linux-2.6/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_dfrag.c
> +++ linux-2.6/fs/xfs/xfs_dfrag.c
> @@ -347,13 +347,15 @@ xfs_swap_extents(
>
> 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
>
> -out_unlock:
> -	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> -	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> out:
> 	kmem_free(tempifp);
> 	return error;
>
> +out_unlock:
> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	goto out;
> +
> out_trans_cancel:
> 	xfs_trans_cancel(tp, 0);
> 	goto out_unlock;
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
