Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23G0fdY021348 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 10:00:42 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 401F6169FD5
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 08:00:13 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Hl5FGeu8NtAXwPU9 for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2009 08:00:13 -0800 (PST)
Message-ID: <49AD5401.30803@sandeen.net>
Date: Tue, 03 Mar 2009 10:00:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: next-20090220: XFS: inconsistent lock state
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
	<20090224200740.GA9266@infradead.org>
In-Reply-To: <20090224200740.GA9266@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Feb 20, 2009 at 08:52:59PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> [ INFO: inconsistent lock state ]
>> 2.6.29-rc5-next-20090220 #2
>> ---------------------------------
>> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
>> kswapd0/324 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>  (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803ca60a>]
>> xfs_ilock+0xaa/0x120
>> {RECLAIM_FS-ON-W} state was registered at:
> 
> That's a false positive.  While the ilock can be taken in reclaim the
> allocation here is done before the inode is added to the inode cache.
> 
> The patch below should help avoiding the warning:

Seems ok to me.  I hate to see the BUG() added but I guess in this case
something truly bizarre would have to happen for the ilock to fail on
this inode.

on irc you sugggested ASSERT(0); instead of BUG(); I might prefer that
but either way:

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> 
> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2009-02-24 20:56:00.716027739 +0100
> +++ xfs/fs/xfs/xfs_iget.c	2009-02-24 20:56:46.089031360 +0100
> @@ -246,9 +246,6 @@ xfs_iget_cache_miss(
>  		goto out_destroy;
>  	}
>  
> -	if (lock_flags)
> -		xfs_ilock(ip, lock_flags);
> -
>  	/*
>  	 * Preload the radix tree so we can insert safely under the
>  	 * write spinlock. Note that we cannot sleep inside the preload
> @@ -259,6 +256,15 @@ xfs_iget_cache_miss(
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * Because the inode hasn't been added to the radix-tree yet it can't
> +	 * be found by another thread, so we can do the non-sleeping lock here.
> +	 */
> +	if (lock_flags) {
> +		if (!xfs_ilock_nowait(ip, lock_flags))
> +			BUG();
> +	}
> +
>  	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
>  	first_index = agino & mask;
>  	write_lock(&pag->pag_ici_lock);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
