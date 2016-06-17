Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0EE87CEE
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:52:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A36D230404E
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:52:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9Y0LXDzysA1v9YGG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:52:07 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:52:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 008/119] xfs: separate freelist fixing into a separate
	helper
Message-ID: <20160617115204.GG19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632363.12839.15504324533944246285.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612632363.12839.15504324533944246285.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

> +/* Ensure that the freelist is at full capacity. */
> +int
> +xfs_free_extent_fix_freelist(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_buf		**agbp)
>  {
> -	xfs_alloc_arg_t	args;
> -	int		error;
> +	xfs_alloc_arg_t		args;

Use struct xfs_alloc_arg if you change this anyway.

> +	int			error;
>  
> -	ASSERT(len != 0);
>  	memset(&args, 0, sizeof(xfs_alloc_arg_t));

Same here.

> -	if (args.agbno + len >
> -			be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length)) {
> -		error = -EFSCORRUPTED;
> -		goto error0;
> -	}
> +	XFS_WANT_CORRUPTED_GOTO(mp,
> +			agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
> +			err);

This introduces an overly long line.

But except for these nitpicks this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
