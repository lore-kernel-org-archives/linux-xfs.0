Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LIjCBb166664 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 13:45:12 -0500
Subject: Re: [PATCH 1/4] libxfs: handle read errors in libxfs_trans_read_buf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110920220030.204339904@bombadil.infradead.org>
References: <20110920215917.508421839@bombadil.infradead.org>
	<20110920220030.204339904@bombadil.infradead.org>
Date: Wed, 21 Sep 2011 13:45:07 -0500
Message-ID: <1316630707.5872.13.camel@doink>
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
Cc: xfs@oss.sgi.com

On Tue, 2011-09-20 at 17:59 -0400, Christoph Hellwig wrote:
> Libxfs_readbuf may return a NULL buffer to indicate that an error happend
> during the read, but we currently ignore that if libxfs_trans_read_buf
> is called with a NULL transaction pointer.  Fix this by copying the
> relevant code from the kernel version of the routine, and also tidy
> the code up a bit by using a common exit label.
> 
> This fixes a regression that was introduced in xfsprogs 3.0.0 by commit
> 
> 	"Implement buffer and inode caching in libxfs, groundwork for a
> 	 parallel version of xfs_repair."
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Probably wouldn't hurt to initialize b_fsprivate2 even
if the transaction pointer is null.  Looks good though.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .
> @@ -510,6 +516,7 @@ libxfs_trans_read_buf(
>  
>  	/* initialise b_fsprivate2 so we can find it incore */
>  	XFS_BUF_SET_FSPRIVATE2(bp, tp);
> +done:
>  	*bpp = bp;
>  	return 0;
>  }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
