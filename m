Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7636A7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 02:55:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56DF48F8035
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 00:55:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WIkR2mRXPEqIbnTY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 00:55:55 -0800 (PST)
Date: Mon, 8 Feb 2016 00:55:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] repair: parallelise phase 7
Message-ID: <20160208085555.GD5534@infradead.org>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454627108-19036-2-git-send-email-david@fromorbit.com>
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

> +	irec = findfirst_inode_rec(agno);
> +
> +	while (irec != NULL)  {
> +		for (j = 0; j < XFS_INODES_PER_CHUNK; j++)  {
> +			ASSERT(is_inode_confirmed(irec, j));
> +
> +			if (is_inode_free(irec, j))
> +				continue;
> +
> +			ASSERT(no_modify || is_inode_reached(irec, j));
> +
> +			nrefs = num_inode_references(irec, j);
> +			ASSERT(no_modify || nrefs > 0);
> +
> +			if (get_inode_disk_nlinks(irec, j) != nrefs)
> +				update_inode_nlinks(wq->mp,
> +					XFS_AGINO_TO_INO(wq->mp, agno,
> +						irec->ino_startnum + j),
> +					nrefs);
> +		}
> +		irec = next_ino_rec(irec);

Wouldn't this look be slightly cleaner as:

	for (irec = findfirst_inode_rec(agno);
	     irec;
	     irec = next_ino_rec(irec)) {

?

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
