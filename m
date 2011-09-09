Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89Ntv98066534 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 18:55:57 -0500
Subject: Re: [PATCH 15/25] xfs: pass bmalloca structure to xfs_bmap_isaeof
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060643.660514652@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.660514652@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 18:55:56 -0500
Message-ID: <1315612556.1999.130.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> All the variables xfs_bmap_isaeof() is passed are contained within
> the xfs_bmalloca structure. Pass that instead.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks good.

Now that the transaction pointer is available in
xfs_bmap_isaeof(), it gets used in the call to
xfs_bmap_last_extent().  It looks to me like
this means btree block buffers will be added to
and removed from the transaction's item list
in xfs_bmap_read_extents(), and that list will
be scanned for these buffers in xfs_trans_read_buf()
(unlike before).

I don't question whether that's correct, but
is that desirable?  Would we be just as well
off *not* providing the transaction pointer?

Anyway:

Reviewed-by: Alex Elder <aelder@sgi.com>
 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:33.735424450 +0200
> +++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:35.358748989 +0200
> @@ -3869,17 +3869,16 @@ xfs_bmap_last_extent(
>   */
>  STATIC int
>  xfs_bmap_isaeof(
> -	struct xfs_inode	*ip,
> -	xfs_fileoff_t		off,
> -	int			whichfork,
> -	char			*aeof)
> +	struct xfs_bmalloca	*bma,
> +	int			whichfork)
>  {
>  	struct xfs_bmbt_irec	rec;
>  	int			is_empty;
>  	int			error;
>  
> -	*aeof = 0;
> -	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
> +	bma->aeof = 0;
> +	error = xfs_bmap_last_extent(bma->tp, bma->ip, whichfork, &rec,
> +				     &is_empty);

Here is the spot I'm referring to.

>  	if (error || is_empty)
>  		return error;
>  


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
