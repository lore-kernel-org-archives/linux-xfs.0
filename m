Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0XCtk106087 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:33:12 -0500
Subject: Re: [PATCH 7/9] xfs: do not do pointer arithmetics on extent records
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150712.651478046@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150712.651478046@bombadil.infradead.org>
Date: Tue, 24 May 2011 19:31:47 -0500
Message-ID: <1306283507.2823.96.camel@doink>
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

On Wed, 2011-05-11 at 11:04 -0400, Christoph Hellwig wrote:
> We need to call xfs_iext_get_ext for the previous extent to get a valid
> pointer, and can't just do pointer arithmetics as they might be in
> different pages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Wow, that one's nasty.  Did someone find this by hitting it?

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-11 10:16:58.847733078 +0200
> +++ xfs/fs/xfs/xfs_bmap.c	2011-05-11 10:17:04.803235692 +0200
> @@ -5145,9 +5145,12 @@ xfs_bunmapi(
>  				 */
>  				ASSERT(bno >= del.br_blockcount);
>  				bno -= del.br_blockcount;
> -				if (bno < got.br_startoff) {
> -					if (--lastx >= 0)
> -						xfs_bmbt_get_all(--ep, &got);
> +				if (got.br_startoff > bno) {
> +					if (--lastx >= 0) {
> +						ep = xfs_iext_get_ext(ifp,
> +								      lastx);
> +						xfs_bmbt_get_all(ep, &got);
> +					}
>  				}
>  				continue;
>  			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
