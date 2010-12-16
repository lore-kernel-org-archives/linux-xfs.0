Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGLHB93126769 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 15:17:11 -0600
Subject: Re: [PATCH 3/4] xfs: refactor xlog_recover_commit_trans
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101201220710.454838485@bombadil.infradead.org>
References: <20101201220620.340188389@bombadil.infradead.org>
	<20101201220710.454838485@bombadil.infradead.org>
Date: Thu, 16 Dec 2010 15:18:15 -0600
Message-ID: <1292534295.2457.58.camel@doink>
Mime-Version: 1.0
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

On Wed, 2010-12-01 at 17:06 -0500, Christoph Hellwig wrote:
> 
> Merge the call to xlog_recover_reorder_trans and the loop over the
> recovery items from xlog_recover_do_trans into xlog_recover_commit_trans,
> and keep the switch statement over the log item types as a separate helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

I'm making a small change to this one patch though...

. . .
> @@ -2757,17 +2699,65 @@ xlog_recover_free_trans(
>  }
>  
>  STATIC int
> +xlog_recover_commit_item(
> +	struct log		*log,
> +	struct xlog_recover	*trans,
> +	xlog_recover_item_t	*item,
> +	int			pass)
> +{
> +	trace_xfs_log_recover_item_recover(log, trans, item, pass);
> +
> +	switch (ITEM_TYPE(item)) {
> +	case XFS_LI_BUF:
> +		return xlog_recover_do_buffer_trans(log, item, pass);
> +		break;

I have deleted this "break" statement.

> +	case XFS_LI_INODE:
> +		return xlog_recover_do_inode_trans(log, item, pass);
> +	case XFS_LI_EFI:
> +		return xlog_recover_do_efi_trans(log, item, trans->r_lsn, pass);
> +	case XFS_LI_EFD:
> +		xlog_recover_do_efd_trans(log, item, pass);
> +		return 0;
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
