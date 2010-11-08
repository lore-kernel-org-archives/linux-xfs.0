Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA89MPOU091050 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 03:22:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 148F71399048
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 01:23:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NRRTx1Clb1gKZCzV for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 01:23:52 -0800 (PST)
Date: Mon, 8 Nov 2010 04:23:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/16] xfs: fix per-ag reference counting in inode
	reclaim tree walking
Message-ID: <20101108092352.GB2806@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-2-git-send-email-david@fromorbit.com>
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

> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -853,6 +853,7 @@ restart:
>  		if (trylock) {
>  			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
>  				skipped++;
> +				xfs_perag_put(pag);
>  				continue;
>  			}
>  			first_index = pag->pag_ici_reclaim_cursor;

One way to make this loop more maintainable is to split the guts of it
into a xfs_reclaim_inodes_ag helper, and make the existing function a
wrapper around it (and remove the incorrect _ag prefix), but that's .38
material.

For .37 the patch looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
