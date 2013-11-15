Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26B377F7B
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 11:03:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1913B304053
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 09:03:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id tKuIX8nvc0Fe7jGA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 09:03:27 -0800 (PST)
Date: Fri, 15 Nov 2013 09:03:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] xfs: introduce a new helper
	xfs_inobt_reada_chunk()
Message-ID: <20131115170325.GA16942@infradead.org>
References: <5281F509.7020105@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5281F509.7020105@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I like the factoring, but it could go a littler further.  Comments
below:

>  /*
> + * Loop over all clusters in a chunk for a given incore inode
> + * allocation btree record.  Do a readahead if there are any
> + * allocated inodes in that cluster.
> + */

Try to use the full 80 lines available to you for comment.

> +	xfs_agblock_t			agbno = XFS_AGINO_TO_AGBNO(mp,
> +						irec->ir_startino);
> +	int				nicluster, nbcluster;
> +	int				chunkidx;
> +
> +	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
> +		    mp->m_sb.sb_inopblock :
> +		    (XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
> +	nbcluster = nicluster >> mp->m_sb.sb_inopblog;

I'd prefer to factor this out even further. xfs_ialloc_inode_init and
xfs_ifree_cluster already have two pieces of code that calculate these
two (with more readable names) and an additional nuber buffers counter
we won't need here, it might make most sense to factor that into a
single common helper.

> +/*
> + * Lookup clusters in inode chunk for a given incore inobt record,
> + * do readahead if there are any allocated inodes in that cluster.
> + */
> +void xfs_inobt_reada_chunk(struct xfs_mount *mp, xfs_agnumber_t agno,
> +			   struct xfs_inobt_rec_incore *irec);

No need to duplicate the comment in the header.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
