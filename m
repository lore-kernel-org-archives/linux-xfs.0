Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LHlCuR018282 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 12:47:13 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 07/14] repair: use single prefetch queue
Date: Wed, 21 Oct 2009 12:48:35 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADEC@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175840.934778714@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> We don't need two prefetch queues as we guarantee execution in order anyway.
> 
> XXX: description could use some more details.
> 
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One nit-picky comment below, but looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfsprogs-dev/repair/prefetch.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:14:08.000000000 +0000
> +++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:16:01.000000000 +0000

. . .

The following hunk doesn't really do anything but change whitespace.
It'd be nice if those changes (when there's a bunch like this) were
limited to a separate no-op patch.

> @@ -440,21 +442,22 @@
>  		 */
>  		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
>  		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
> -			XFS_BUF_SIZE(bplist[num-1]);
> +						XFS_BUF_SIZE(bplist[num-1]);
>  		while (last_off - first_off > pf_max_bytes) {
>  			num--;
> -			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
> -				XFS_BUF_SIZE(bplist[num-1]);
> +			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(
> +				bplist[num-1])) + XFS_BUF_SIZE(bplist[num-1]);
>  		}
> -		if (num < ((last_off - first_off) >> (mp->m_sb.sb_blocklog + 3))) {
> +		if (num < ((last_off - first_off) >>
> +						(mp->m_sb.sb_blocklog + 3))) {
>  			/*
>  			 * not enough blocks for one big read, so determine
>  			 * the number of blocks that are close enough.
>  			 */
>  			last_off = first_off + XFS_BUF_SIZE(bplist[0]);
>  			for (i = 1; i < num; i++) {
> -				next_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) +
> -						XFS_BUF_SIZE(bplist[i]);
> +				next_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(
> +					bplist[i])) + XFS_BUF_SIZE(bplist[i]);
>  				if (next_off - last_off > pf_batch_bytes)
>  					break;
>  				last_off = next_off;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
