Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F180F7F8B
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:39:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC2F68F8033
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:39:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	miu2nyiQ5bhN23Xa for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:38:57 -0800 (PST)
Date: Mon, 9 Dec 2013 09:38:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfs: use xfs_ilock_data_map_shared in
	xfs_qm_dqiterate
Message-ID: <20131208223826.GI31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203129.185131308@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203129.185131308@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:14PM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2013-12-06 17:20:27.491331600 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2013-12-06 19:39:27.251160455 +0100
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
> +		lock_mode = xfs_ilock_data_map_shared(qip);
>  		error = xfs_bmapi_read(qip, lblkno, maxlblkcnt - lblkno,
>  				       map, &nmaps, 0);
> -		xfs_iunlock(qip, XFS_ILOCK_SHARED);
> +		xfs_iunlock(qip, lock_mode);
>  		if (error)
>  			break;

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
