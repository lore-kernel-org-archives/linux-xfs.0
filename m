Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33E187F54
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 02:33:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16E778F8052
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 00:33:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id ZFEgtAEJVhoyndDC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 00:33:14 -0700 (PDT)
Date: Tue, 3 Sep 2013 00:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: check magic numbers in dir3 leaf verifier first
Message-ID: <20130903073312.GA1422@infradead.org>
References: <1378119020-31299-1-git-send-email-david@fromorbit.com>
	<20130903000658.GJ12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130903000658.GJ12779@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> @@ -165,6 +165,7 @@ xfs_dir3_leaf_check_int(
>  	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
>  		return false;
>  
> +
>  	/* Check hash value order, count stale entries.  */

spurious new line..

>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> +		__uint16_t		magic3;
>  
> +		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
> +							 : XFS_DIR3_LEAFN_MAGIC;
>  
> +		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
> +			return false;
>  		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
>  			return false;
>  		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
>  			return false;
>  	} else {
> -		if (leafhdr.magic != magic)
> +		if (leaf->hdr.info.magic != cpu_to_be16(magic))
>  			return false;
>  	}

Looks good but I wonder if something like this should be factored into
a separate helper in the long run.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
