Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8IZOQV157944 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 12:35:24 -0600
Date: Thu, 8 Dec 2011 12:35:47 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 03/19] xfs: remove the lid_size field in struct
	log_item_desc
Message-ID: <20111208183547.GT29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215853.103470363@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215853.103470363@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:09PM -0500, Christoph Hellwig wrote:
> Outside the now removed nodelaylog code this field is only used for
> asserts and can be safely removed now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> Index: xfs/fs/xfs/xfs_inode_item.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode_item.c	2011-12-06 15:26:35.150334172 +0100
> +++ xfs/fs/xfs/xfs_inode_item.c	2011-12-06 15:36:07.963678127 +0100
> @@ -437,7 +437,6 @@ xfs_inode_item_format(
>  	 * Assert that no attribute-related log flags are set.
>  	 */
>  	if (!XFS_IFORK_Q(ip)) {
> -		ASSERT(nvecs == lip->li_desc->lid_size);
>  		iip->ili_format.ilf_size = nvecs;
>  		ASSERT(!(iip->ili_format.ilf_fields &
>  			 (XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
> @@ -521,7 +520,6 @@ xfs_inode_item_format(
>  		break;
>  	}
>  
> -	ASSERT(nvecs == lip->li_desc->lid_size);

These two look like they might have been useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
