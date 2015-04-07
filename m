Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 339C27F7C
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 17:20:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4798AC002
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 15:20:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	gGyJsQheu7BoQBv0 for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 15:20:07 -0700 (PDT)
Date: Wed, 8 Apr 2015 08:19:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: unlock i_mutex in xfs_break_layouts
Message-ID: <20150407221927.GD15810@dastard>
References: <1428420944-20965-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428420944-20965-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Apr 07, 2015 at 05:35:44PM +0200, Christoph Hellwig wrote:
> We want to drop all I/O path locks when recalling layouts, and that includes
> i_mutex for the write path.  Without this we get stuck processe when recalls
> take too long.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
>  		xfs_iunlock(ip, iolock);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 365dd57..981a657 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -31,7 +31,8 @@
>  int
>  xfs_break_layouts(
>  	struct inode		*inode,
> -	uint			*iolock)
> +	uint			*iolock,
> +	bool			with_imutex)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> @@ -40,8 +41,12 @@ xfs_break_layouts(
>  
>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
> +		if (with_imutex && (*iolock & XFS_IOLOCK_EXCL))
> +			mutex_unlock(&inode->i_mutex);
>  		error = break_layout(inode, true);
>  		*iolock = XFS_IOLOCK_EXCL;
> +		if (with_imutex)
> +			mutex_lock(&inode->i_mutex);
>  		xfs_ilock(ip, *iolock);
>  	}

That's kinda nasty, and it has no documentation explaining when or
why we'd need to drop the i_mutex. How are we supposed to know if we
need to drop the i_mutex or not? What happens if the upper VFS
layers change or we have a multiple call paths that have different
i_mutex contexts (i.e. one holds, another doesn't)?

Which makes me wonder - is this layout breaking stuff at the right
layer?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
