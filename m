Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU0SGck016758 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 18:28:19 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 136F113A76C1
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 16:28:10 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	NxtJLdtJIIeJ2DSB for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2008 16:28:10 -0800 (PST)
Date: Tue, 30 Dec 2008 11:11:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] directory offset overflows in 2.6.28
Message-ID: <20081230001117.GA5220@disturbed>
References: <20081229220745.GA12966@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081229220745.GA12966@infradead.org>
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
Cc: John Stanley <jpsinthemix@verizon.net>, xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 05:07:45PM -0500, Christoph Hellwig wrote:
> The patch below is a dumb version of just putting back the masking,
> to make sure we have the same behavior as in 2.6.27 and earlier.
> I think we should at least hide it in a macro that is well-commented,
> but I suspect we also need to make sure that we never ever get bigger
> offsets in directories in some way.

I think we need that macro sooner rather than later ;)

> Index: xfs/fs/xfs/xfs_dir2_block.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_block.c	2008-12-29 21:25:29.680613664 +0100
> +++ xfs/fs/xfs/xfs_dir2_block.c	2008-12-29 21:29:57.341627581 +0100
> @@ -517,9 +517,9 @@ xfs_dir2_block_getdents(
>  		/*
>  		 * If it didn't fit, set the final offset to here & return.
>  		 */
> -		if (filldir(dirent, dep->name, dep->namelen, cook,
> +		if (filldir(dirent, dep->name, dep->namelen, cook & 0x7fffffff,
>  			    ino, DT_UNKNOWN)) {
> -			*offset = cook;
> +			*offset = cook & 0x7fffffff;
>  			xfs_da_brelse(NULL, bp);
>  			return 0;
>  		}

In this case, you can do the masking at the time cook is
assigned. I haven't checked, but I suspect the rest will be the
same. That will make the patch less invasive and with a macro
somewhat cleaner...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
