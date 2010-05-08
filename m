Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o48HDZA2197447 for <xfs@oss.sgi.com>; Sat, 8 May 2010 12:13:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 184461078DCF
	for <xfs@oss.sgi.com>; Sat,  8 May 2010 10:15:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id whVbNHPIOaAi99Lc for
	<xfs@oss.sgi.com>; Sat, 08 May 2010 10:15:55 -0700 (PDT)
Date: Sat, 8 May 2010 13:15:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] xfs: Improve scalability of busy extent tracking
Message-ID: <20100508171544.GA10971@infradead.org>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273210860-23414-8-git-send-email-david@fromorbit.com>
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

Looks good, but a couple minor comments below:


Reviewed-by: Christoph Hellwig <hch@lst.de>

> diff --git a/fs/xfs/linux-2.6/xfs_quotaops.c b/fs/xfs/linux-2.6/xfs_quotaops.c
> index 1947514..2e73688 100644
> --- a/fs/xfs/linux-2.6/xfs_quotaops.c
> +++ b/fs/xfs/linux-2.6/xfs_quotaops.c
> @@ -19,6 +19,7 @@
>  #include "xfs_dmapi.h"
>  #include "xfs_sb.h"
>  #include "xfs_inum.h"
> +#include "xfs_log.h"
>  #include "xfs_ag.h"
>  #include "xfs_mount.h"
>  #include "xfs_quota.h"

This hunk is not needed.

> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -18,9 +18,6 @@
>  #ifndef	__XFS_LOG_H__
>  #define __XFS_LOG_H__
>  
> -/* transaction ID type */
> -typedef __uint32_t xlog_tid_t;
> -


> --- a/fs/xfs/xfs_types.h
> +++ b/fs/xfs/xfs_types.h
> @@ -75,6 +75,8 @@ typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
>  
>  typedef __uint16_t	xfs_prid_t;	/* prid_t truncated to 16bits in XFS */
>  
> +typedef __uint32_t	xlog_tid_t;	/* transaction ID type */

This should be in the patch introducing xfs_log_get_trans_ident.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
