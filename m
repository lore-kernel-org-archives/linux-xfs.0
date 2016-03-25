Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4AF37CA0
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 13:07:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87F1E304064
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 11:07:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FDmSuvVXHc6pAv9F (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Mar 2016 11:07:20 -0700 (PDT)
Date: Fri, 25 Mar 2016 11:07:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: mute some sparse warnings
Message-ID: <20160325180719.GA4500@infradead.org>
References: <1458929042-23991-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458929042-23991-1-git-send-email-guaneryu@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs@oss.sgi.com

> @@ -478,7 +478,8 @@ xfs_inode_item_unpin(
>  STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
> -	struct list_head	*buffer_list)
> +	struct list_head	*buffer_list) __releases(&lip->li_ailp->xa_lock)
> +					      __acquires(&lip->li_ailp->xa_lock)

Can you move these down a bit?  Something like:

	struct list_head	*buffer_list)
		__releases(&lip->li_ailp->xa_lock)
		__acquires(&lip->li_ailp->xa_lock)
{

?

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
