Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALLWFNf011090 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:32:15 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7C1D15BFB4F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 13:32:14 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id XtQxpCmpKytY5V9f for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2008 13:32:14 -0800 (PST)
Message-ID: <49271D93.6000108@sandeen.net>
Date: Fri, 21 Nov 2008 14:44:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: fix error handling in xlog_recover_process_one_iunlink
References: <20081112114351.GA15216@infradead.org>
In-Reply-To: <20081112114351.GA15216@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> If we fail after xfs_iget we have to drop the reference count, spotted
> by Dave Chinner.  Also remove some useless asserts and stop trying to
> deal with di_mode == 0 inodes because never gets those without passing
> the IGET_CREATE flag to xfs_iget.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me.

-Eric

> Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-11-12 11:05:22.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-11-12 11:05:54.000000000 +0100
> @@ -3147,13 +3147,12 @@ xlog_recover_process_one_iunlink(
>  	/*
>  	 * Get the on disk inode to find the next inode in the bucket.
>  	 */
> -	ASSERT(ip != NULL);
>  	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, XFS_BUF_LOCK);
>  	if (error)
> -		goto fail;
> +		goto fail_iput;
>  
> -	ASSERT(dip != NULL);
>  	ASSERT(ip->i_d.di_nlink == 0);
> +	ASSERT(ip->i_d.di_mode != 0);
>  
>  	/* setup for the next pass */
>  	agino = be32_to_cpu(dip->di_next_unlinked);
> @@ -3165,18 +3164,11 @@ xlog_recover_process_one_iunlink(
>  	 */
>  	ip->i_d.di_dmevmask = 0;
>  
> -	/*
> -	 * If this is a new inode, handle it specially.  Otherwise, just
> -	 * drop our reference to the inode.  If there are no other
> -	 * references, this will send the inode to xfs_inactive() which
> -	 * will truncate the file and free the inode.
> -	 */
> -	if (ip->i_d.di_mode == 0)
> -		xfs_iput_new(ip, 0);
> -	else
> -		IRELE(ip);
> +	IRELE(ip);
>  	return agino;
>  
> + fail_iput:
> +	IRELE(ip);
>   fail:
>  	/*
>  	 * We can't read in the inode this bucket points to, or this inode
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
