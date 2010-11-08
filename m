Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8NI1V8123729 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:18:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60EAD139C804
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:19:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MVpoEOC2RnKaF9LD for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 15:19:29 -0800 (PST)
Date: Mon, 8 Nov 2010 18:19:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/16] xfs: add a lru to the XFS buffer cache
Message-ID: <20101108231928.GA20647@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-11-git-send-email-david@fromorbit.com>
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

> @@ -471,6 +546,8 @@ _xfs_buf_find(
>  		/* the buffer keeps the perag reference until it is freed */
>  		new_bp->b_pag = pag;
>  		spin_unlock(&pag->pag_buf_lock);
> +
> +		xfs_buf_lru_add(new_bp);

Why do we add the buffer to the lru when we find it?  Normally we
would remove it here (unless we want a lazy lru scheme), and potentially
increment b_lru_ref - although that seems to be done by the callers
in the next patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
