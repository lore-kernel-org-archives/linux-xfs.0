Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E6fwwl234111 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 00:41:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FB92164D02
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:42:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gOyaWdXirOA7AFBy for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:42:55 -0800 (PST)
Date: Thu, 14 Jan 2010 01:42:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: xfs_swap_extents needs to handle dynamic fork
	offsets
Message-ID: <20100114064255.GB29458@infradead.org>
References: <1263432836-13368-1-git-send-email-david@fromorbit.com>
	<1263432836-13368-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263432836-13368-2-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2010 at 12:33:54PM +1100, Dave Chinner wrote:
> When swapping extents, we can corrupt inodes by swapping data forks
> that are in incompatible formats.  This is caused by the two indoes
> having different fork offsets due to the presence of an attribute
> fork on an attr2 filesystem.  xfs_fsr tries to be smart about
> setting the fork offset, but the trick it plays only works on attr1
> (old fixed format attribute fork) filesystems.
> 
> Changing the way xfs_fsr sets up the attribute fork will prevent
> this situation from ever occurring, so in the kernel code we can get
> by with a preventative fix - check that the data fork in the
> defragmented inode is in a format valid for the inode it is being
> swapped into.  This will lead to files that will silently and
> potentially repeatedly fail defragmentation, so issue a warning to
> the log when this particular failure occurs to let us know that
> xfs_fsr needs updating/fixing.
> 
> To help identify how to improve xfs_fsr to avoid this issue, add
> trace points for the inodes being swapped so that we can determine
> why the swap was rejected and to confirm that the code is making the
> right decisions and modifications when swapping forks.
> 
> A further complication is even when the swap is allowed to proceed
> when the fork offset is different between the two inodes then value
> for the maximum number of extents the data fork can hold can be
> wrong. Make sure these are also set correctly after the swap occurs.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_dfrag.c |  106 ++++++++++++++++++++++++++++++++++++++++++++--------

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
