Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82203FJ224547 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 21:00:13 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 961438F80D9
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 19:01:00 -0700 (PDT)
Message-Id: <E18ED380-8735-46C6-90E4-EC8E2E6CC9AF@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090901235655.GA15321@infradead.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs: un-static xfs_inobt_lookup
Date: Tue, 1 Sep 2009 20:37:56 -0500
References: <20090901235655.GA15321@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Sep 1, 2009, at 6:56 PM, Christoph Hellwig wrote:

>
> xfs_inobt_lookup is also used in xfs_itable.c, remove the STATIC  
> modifier
> from it's declaration to fix non-debug builds.

Argh! I think, this or similar thing bit us once in past.

>
>
> This was already fixed in my git tree vs the version last posted to  
> the
> list.

Applying it quickly to the oss as well.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: xfs/fs/xfs/xfs_ialloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_ialloc.c	2009-09-01 20:47:28.515468366 -0300
> +++ xfs/fs/xfs/xfs_ialloc.c	2009-09-01 20:47:33.867913011 -0300
> @@ -59,7 +59,7 @@ xfs_ialloc_cluster_alignment(
> /*
>  * Lookup a record by ino in the btree given by cur.
>  */
> -STATIC int				/* error */
> +int					/* error */
> xfs_inobt_lookup(
> 	struct xfs_btree_cur	*cur,	/* btree cursor */
> 	xfs_agino_t		ino,	/* starting inode of chunk */
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
