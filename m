Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBHNWeUG133239 for <xfs@oss.sgi.com>; Sat, 17 Dec 2011 17:32:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	z3gOO58HFIenB1ql for <xfs@oss.sgi.com>;
	Sat, 17 Dec 2011 15:32:39 -0800 (PST)
Date: Sat, 17 Dec 2011 18:32:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] xfs: remove duplication in transaction buffer
	operations
Message-ID: <20111217233238.GD2383@infradead.org>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
	<1323238703-13198-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323238703-13198-13-git-send-email-david@fromorbit.com>
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

> @@ -213,8 +147,6 @@ xfs_trans_get_buf_irec(
>  	struct xfs_buf		*bp;
>  	struct xfs_buf_log_item	*bip;
>  
> -	ASSERT_ALWAYS(nmaps == 1);
> -

Shouldn't this have been removed as soon as actual multiple buffer
support was introduced?

> @@ -528,8 +303,6 @@ xfs_trans_read_buf_irec(
>  	xfs_buf_log_item_t	*bip;
>  	int			error;
>  
> -	ASSERT_ALWAYS(nmaps == 1);
> -

Same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
