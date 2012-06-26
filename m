Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QL6wE8145786 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 16:06:58 -0500
Date: Tue, 26 Jun 2012 17:06:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: synchronously write the superblock on unmount
Message-ID: <20120626210655.GA16140@infradead.org>
References: <20120626160051.364635296@sgi.com>
	<20120626160102.898671754@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120626160102.898671754@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

>  /*
> - * xfs_log_sbcount
> + * xfs_write_sbcount

Please drop these function name comment line in anything you touch.

>   *
>   * Sync the superblock counters to disk.
>   *
> - * Note this code can be called during the process of freezing, so
> - * we may need to use the transaction allocator which does not
> - * block when the transaction subsystem is in its frozen state.
>   */

Can you add a little commt here on why we write it out synchronously?
Basically a shortened version of the commit message.

>  	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
> -		return 0;
> +	return 0;

As mentioned by carlos the indendation here got messed up a bit.

> -extern int	xfs_log_sbcount(xfs_mount_t *);
> +extern int
> +xfs_write_sbcount(
> +	struct xfs_mount *mp);
>  extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);

For the header I'd suggest to keep the simple indentation style.

Otherwise the changes look good to, thanks a lot!


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
