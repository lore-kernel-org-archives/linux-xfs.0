Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8871C7F8B
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:37:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11776AC001
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:37:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8GRgpz4eOnqqOker for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:36:53 -0800 (PST)
Date: Mon, 9 Dec 2013 09:36:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] xfs: take the ilock around xfs_bmapi_read in
	xfs_zero_remaining_bytes
Message-ID: <20131208223646.GG31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.914019342@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203128.914019342@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:12PM -0800, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap_util.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-06 19:37:36.715162723 +0100
> +++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-06 19:38:45.643161309 +0100
> @@ -1175,9 +1175,15 @@ xfs_zero_remaining_bytes(
>  	xfs_buf_unlock(bp);
>  
>  	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
> +		uint lock_mode;
> +
>  		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  		nimap = 1;
> +
> +		lock_mode = xfs_ilock_data_map_shared(ip);
>  		error = xfs_bmapi_read(ip, offset_fsb, 1, &imap, &nimap, 0);
> +		xfs_iunlock(ip, lock_mode);
> +
>  		if (error || nimap < 1)
>  			break;
>  		ASSERT(imap.br_blockcount >= 1);

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
