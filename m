Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C761D7CA4
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 09:54:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4AC21AC003
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 07:54:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Di3cgS6Li3gx79b1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 07:54:49 -0700 (PDT)
Date: Tue, 6 Sep 2016 07:54:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/71] xfs: define tracepoints for refcount btree
	activities
Message-ID: <20160906145446.GB24287@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216796400.867.3093949883691867882.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216796400.867.3093949883691867882.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

> +#ifndef XFS_REFCOUNT_IREC_PLACEHOLDER
> +#define XFS_REFCOUNT_IREC_PLACEHOLDER
> +/* Placeholder definition to avoid breaking bisectability. */
> +struct xfs_refcount_irec {
> +	xfs_agblock_t	rc_startblock;	/* starting block number */
> +	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
> +	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
> +};
> +#endif

I didn't really understand the point earlier either - why can't
you just merge the patch adding the tracepoints into that defining
the structures and calling the tracepoints?  That would avoid that
whole exercise.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
