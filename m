Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C163B7F7B
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:45:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A4D728F804B
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 12:45:59 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	34HlYr1t0DEdWV5V for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 12:45:58 -0800 (PST)
Date: Fri, 6 Dec 2013 07:45:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: use xfs_ilock_map_shared in xfs_qm_dqiterate
Message-ID: <20131205204538.GC29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.506063990@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205155951.506063990@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 05, 2013 at 07:58:33AM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2013-11-18 14:39:01.967589998 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2013-12-05 12:32:36.623617997 +0100
> @@ -1193,16 +1193,18 @@ xfs_qm_dqiterate(
>  	lblkno = 0;
>  	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
>  	do {
> +		uint		lock_mode;
> +
>  		nmaps = XFS_DQITER_MAP_SIZE;
>  		/*
>  		 * We aren't changing the inode itself. Just changing
>  		 * some of its data. No new blocks are added here, and
>  		 * the inode is never added to the transaction.
>  		 */
> -		xfs_ilock(qip, XFS_ILOCK_SHARED);
> +		lock_mode = xfs_ilock_map_shared(qip);
>  		error = xfs_bmapi_read(qip, lblkno, maxlblkcnt - lblkno,
>  				       map, &nmaps, 0);
> -		xfs_iunlock(qip, XFS_ILOCK_SHARED);
> +		xfs_iunlock_map_shared(qip, lock_mode);
>  		if (error)
>  			break;

There's no bug here - this comes from quotacheck, which is
guaranteed to have exclusive access to the filesystem at this point.
Hence there's no-one to race with reading the extent list. Still, it
doesn't hurt.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
