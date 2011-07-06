Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663cOMD063845 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:38:24 -0500
Subject: Re: [PATCH 18/27] xfs: avoid usage of struct xfs_dir2_data
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094606.003170984@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.003170984@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:38:22 -0500
Message-ID: <1309923502.3381.35.camel@doink>
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> In most places we can simply pass around and use the struct xfs_dir2_data_hdr,
> which is the first and most important member of struct xfs_dir2_data instead
> of the full structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

In xfs_dir2_data_freescan() you get the address of the
dir2_data_t by forcibly casting the address of the
header to that type.  We all know that's fine, but
it's an unsavory practice.  Why don't you pass the
full dir2_data_t in that case where it's needed?
Are you simply trying to avoid passing *any* pointers
to variable-sized types?

I'm not worried about this, but just wondered
what you thought about this.

(Update: I think you eliminate that line in the next
patch anyway...)

In any case:

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .
		}
> Index: xfs/fs/xfs/xfs_dir2_data.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_data.c	2011-06-30 09:38:36.586734196 +0200
> +++ xfs/fs/xfs/xfs_dir2_data.c	2011-06-30 09:38:40.133400821 +0200

. . .
 
> @@ -325,9 +333,10 @@ xfs_dir2_data_freeremove(
>  void
>  xfs_dir2_data_freescan(
>  	xfs_mount_t		*mp,		/* filesystem mount point */
> -	xfs_dir2_data_t		*d,		/* data block pointer */
> +	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
>  	int			*loghead)	/* out: log data header */
>  {
> +	xfs_dir2_data_t		*d = (xfs_dir2_data_t *)hdr;
>  	xfs_dir2_block_tail_t	*btp;		/* block tail */
>  	xfs_dir2_data_entry_t	*dep;		/* active data entry */
>  	xfs_dir2_data_unused_t	*dup;		/* unused data entry */

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
