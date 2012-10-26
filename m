Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9Q8jiGK215705 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 03:45:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Gce3DQ8h2yl4LHi6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 01:47:30 -0700 (PDT)
Date: Fri, 26 Oct 2012 04:47:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/25] xfs: invalidate allocbt blocks moved to the free
	list
Message-ID: <20121026084728.GA3035@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-3-git-send-email-david@fromorbit.com>
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

> index f1647ca..f7876c6 100644
> --- a/fs/xfs/xfs_alloc_btree.c
> +++ b/fs/xfs/xfs_alloc_btree.c
> @@ -121,6 +121,8 @@ xfs_allocbt_free_block(
>  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> +
> +	xfs_trans_binval(cur->bc_tp, bp);
>  	return 0;

I'd be almost tempted to move this into the caller, as the bmap and
ialloc btrees do it and I always wondered how the alloc btree got away
without it.

Otherwise looks ok,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
