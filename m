Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OFhAgp035198 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 09:43:10 -0600
Message-ID: <4F1ED190.7040809@sgi.com>
Date: Tue, 24 Jan 2012 09:43:12 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 07/12] xfs: add xlog_grant_head_init
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.689066888@bombadil.infradead.org>
In-Reply-To: <20111212141434.689066888@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
> ---
>   fs/xfs/xfs_log.c |   18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
>
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:24:39.502740565 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:28:15.334904636 +0100
> @@ -150,6 +150,15 @@ xlog_grant_add_space(
>   	} while (head_val != old);
>   }
>
> +STATIC void
> +xlog_grant_head_init(
> +	struct xlog_grant_head	*head)
> +{
> +	xlog_assign_grant_head(&head->grant, 1, 0);
> +	INIT_LIST_HEAD(&head->waiters);
> +	spin_lock_init(&head->lock);
> +}
> +

...

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
