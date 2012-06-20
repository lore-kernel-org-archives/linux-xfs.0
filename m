Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6irVP251425 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:44:53 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	e0fjUWeQpVbqSP9H (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 23:44:52 -0700 (PDT)
Date: Wed, 20 Jun 2012 02:44:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfs: separate buffer indexing from block map
Message-ID: <20120620064451.GB14760@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339133914-11148-2-git-send-email-david@fromorbit.com>
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

On Fri, Jun 08, 2012 at 03:38:26PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To support discontiguous buffers in the buffer cache, we need to
> separate the cache index variables from the I/O map. While this is
> currently a 1:1 mapping, discontiguous buffer support will break
> this relationship.
> 
> However, for caching purposes, we can still treat them the same as a
> contiguous buffer - the block number of the first block and the
> length of the buffer - as that is still a unique representation.
> Also, the only way we will ever access the discontiguous regions of
> buffers is via bulding the complete buffer in the first place, so
> using the initial block number and entire buffer length is a sane
> way to index the buffers.
> 
> Add a block mapping vector construct to the xfs_buf and use it in
> the places where we are doing IO instead of the current
> b_bn/b_length variables.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c |   21 ++++++++++++---------
>  fs/xfs/xfs_buf.h |   17 +++++++++++++----
>  2 files changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a4beb42..90c5b6a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -199,9 +199,11 @@ xfs_buf_alloc(
>  	 * most cases but may be reset (e.g. XFS recovery).
>  	 */
>  	bp->b_length = numblks;
> +	bp->b_map.bm_len = numblks;
>  	bp->b_io_length = numblks;
>  	bp->b_flags = flags;
>  	bp->b_bn = blkno;
> +	bp->b_map.bm_bn = blkno;

nipick: any reason not to initialize the two fields of b_map next
to each other?

> -	bp->b_io_length = bp->b_length;
> -

oh, I just mentioned that we can remove this in reply to Jan's patch,
so this is already taken care of, too.

>  #ifdef XFS_BUF_LOCK_TRACKING
>  	int			b_last_holder;
>  #endif
> @@ -233,8 +242,8 @@ void xfs_buf_stale(struct xfs_buf *bp);
>  #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
>  #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
>  
> -#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
> -#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
> +#define XFS_BUF_ADDR(bp)		((bp)->b_map.bm_bn)
> +#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_map.bm_bn = (xfs_daddr_t)(bno))

It's not really obvious why XFS_BUF_SET_ADDR should not set b_bn from
it's defintion.  Looking at the callers it seems because it's only used
for uncached buffers, which never use b_bn, but it's still confusing.

I'm fine with keeping it for now bith a big comment to get this series
in, but XFS_BUF_SET_ADDR and b_io_length probably should go away ASAP in
favor or a variant of xfs_buf_iorequest that takes a bn/len pair .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
