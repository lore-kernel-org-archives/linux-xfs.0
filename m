Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDE007CA0
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:06:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A980F8F8037
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 08:06:20 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZZGLavuD9ozdGmKW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 08:06:18 -0700 (PDT)
Date: Tue, 6 Sep 2016 08:06:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/71] xfs: define the on-disk refcount btree format
Message-ID: <20160906150614.GF24287@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216798906.867.6348942755846510156.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216798906.867.6348942755846510156.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:33:09PM -0700, Darrick J. Wong wrote:
> [hch: allocate the cursor with KM_NOFS to quiet lockdep]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

feel free to drop mentioning this little fixlet..

> +/* Per-AG btree private information. */
> +union xfs_btree_cur_private {
> +	struct {
> +		unsigned long	nr_ops;		/* # record updates */
> +		int		shape_changes;	/* # of extent splits */
> +	} refc;
>  };
>  
>  /*
> @@ -247,6 +258,7 @@ typedef struct xfs_btree_cur
>  			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
>  			struct xfs_defer_ops *dfops;	/* deferred updates */
>  			xfs_agnumber_t	agno;	/* ag number */
> +			union xfs_btree_cur_private	priv;
>  		} a;

So we have a struct in a union in a struct in a union in a struct.
But I don't really see a good way around this..

But in general this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
