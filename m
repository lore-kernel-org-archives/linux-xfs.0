Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA6777F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:14:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DAF748F8066
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:14:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 2NBebSJJyhNmheKP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:14:38 -0800 (PST)
Date: Fri, 13 Dec 2013 03:14:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/8] xfs: use xfs_icluster_size_fsb in
	xfs_ialloc_inode_init
Message-ID: <20131213111437.GA23546@infradead.org>
References: <52A96809.9020702@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A96809.9020702@oracle.com>
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

> +	 * Loop over the new block(s), filling in the inodes.  For small block
> +	 * sizes, manipulate the inodes in buffers  which are multiples of the
> +	 * blocks size.
>  	 */
> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
> +	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
> +	nbufs = length / blks_per_cluster;

I don't think there's a point to have the nbufs variable as it's used
just once as the loop termination condition.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
