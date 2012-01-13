Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DJ7Iar155625 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 13:07:19 -0600
Date: Fri, 13 Jan 2012 13:07:16 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/11] xfs: make i_flags an unsigned long
Message-ID: <20120113190716.GA6271@sgi.com>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.348628833@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155918.348628833@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Dec 08, 2011 at 10:58:00AM -0500, Christoph Hellwig wrote:
> To be used for bit wakeup i_flags needs to be an unsigned long or we'll
> run into trouble on big endian systems.  Beause of the 1-byte i_update
					   Because
> field right after it this actually causes a fairly large size increase
> on its own (4 or 8 bytes), but that increase will be more than offset
> by the next two patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.  But I could go for a thorough explanation of 'trouble
on big endian systems'.

Reviewed-by: Ben Myers <bpm@sgi.com>

> 
> ---
>  fs/xfs/xfs_inode.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 12:58:58.449770178 +0100
> +++ xfs/fs/xfs/xfs_inode.h	2011-11-30 12:59:05.013067955 +0100
> @@ -242,7 +242,7 @@ typedef struct xfs_inode {
>  	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>  	/* Miscellaneous state. */
> -	unsigned short		i_flags;	/* see defined flags below */
> +	unsigned long		i_flags;	/* see defined flags below */
>  	unsigned char		i_update_core;	/* timestamps/size is dirty */
>  	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
