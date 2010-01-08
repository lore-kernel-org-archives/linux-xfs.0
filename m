Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08AJnn4029267 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 04:19:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1BDC1C3B563
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 02:20:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id f6O1qTH1552SyWFA for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 02:20:42 -0800 (PST)
Date: Fri, 8 Jan 2010 05:20:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: reclaim inodes under a write lock
Message-ID: <20100108102042.GA16640@infradead.org>
References: <1262819125-27083-1-git-send-email-david@fromorbit.com>
	<1262819125-27083-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262819125-27083-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 07, 2010 at 10:05:24AM +1100, Dave Chinner wrote:
> Make the inode tree reclaim walk exclusive to avoid races with
> concurrent sync walkers and lookups. This is a version of
> a patch posted by Christoph Hellwig that avoids all the code
> duplication.

I don't like the write_lock flag very much, but given that the other
option is duplication we might have to live it.

> -	/*
> -	 * If we can't get a reference on the inode, it must be in reclaim.
> -	 * Leave it for the reclaim code to flush. Also avoid inodes that
> -	 * haven't been fully initialised.
> -	 */
> +	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
> +	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)) {
> +		read_unlock(&pag->pag_ici_lock);
> +		return ENOENT;
> +	}
> +
> +	/* If we can't get a reference on the inode, it must be in reclaim. */
>  	if (!igrab(inode)) {
>  		read_unlock(&pag->pag_ici_lock);
>  		return ENOENT;
>  	}
>  	read_unlock(&pag->pag_ici_lock);
>  
> -	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
> +	if (is_bad_inode(inode)) {
>  		IRELE(ip);
>  		return ENOENT;

That's an unrelated change and should be a separate patch.

> @@ -791,12 +779,22 @@ xfs_reclaim_inode_now(
>  	struct xfs_perag	*pag,
>  	int			flags)
>  {
> +	/*
> +	 * The radix tree lock here protects a thread in xfs_iget from racing
> +	 * with us starting reclaim on the inode.  Once we have the
> +	 * XFS_IRECLAIM flag set it will not touch us.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
> +	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
> +		/* ignore as it is already under reclaim */
> +		spin_unlock(&ip->i_flags_lock);
> +		write_unlock(&pag->pag_ici_lock);
>  		return 0;
>  	}
> +	__xfs_iflags_set(ip, XFS_IRECLAIM);
> +	spin_unlock(&ip->i_flags_lock);
> +	write_unlock(&pag->pag_ici_lock);
>  
>  	return xfs_reclaim_inode(ip, flags);

Once you move things around please merge xfs_reclaim_inode_now and
xfs_reclaim_inode into a single function.

And yes, all this currently doesn't apply against the XFS tree or
mainline, but you know that already.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
