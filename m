Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2DB057F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 10:36:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2F55304043
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 08:36:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id R7yIKy0lBlsZQf52 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 08:36:39 -0700 (PDT)
Date: Wed, 23 Apr 2014 08:36:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 03/10] xfs: consolidate xfs_inumbers
Message-ID: <20140423153639.GB3326@infradead.org>
References: <535078B2.8010601@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078B2.8010601@oracle.com>
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

On Fri, Apr 18, 2014 at 08:58:26AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> To fetch the file system number tables, we currently just ignore the
> errors and proceed to loop over the next AG or bump agino to the next
> chunk in case of btree operations failed, that is not properly because
> those errors might hint us potential file system problems.
> 
> This patch rework xfs_inumbers() to handle the btree operation errors
> as well as the loop conditions.  Also, add pre-checkups for the given
> inode, we can save alloc/free the format buffer once against an invalid
> inode number.

The patch looks mostly good to me, but I really think it should be
split into two patches: one to do the formatting changes and code
consolidation, and then one that does the actual logic changes for
better error handling.  It's not easy to understand and verify with
these two different changes combined.

>  xfs_inumbers_fmt(
>  	void			__user *ubuffer, /* buffer to write to */
> -	const xfs_inogrp_t	*buffer,	/* buffer to read from */
> +	const struct xfs_inogrp	*buffer,	/* buffer to read from */
>  	long			count,		/* # of elements to read */
>  	long			*written)	/* # of bytes written */
>  {
>  	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
> -		return -EFAULT;
> +		return XFS_ERROR(EFAULT);

xfs_inumbers_fmt_compat will need the same treatment.

>  	*count = 0;
> +	if (agno >= mp->m_sb.sb_agcount ||
> +	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
> +		return 0;

Where is the lastino check coming from?

>  	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
> +	bufidx = error = 0;

Why not initialize bufidx and error at declaration time?

> +		error = xfs_inobt_get_rec(cur, &r, &stat);
> +		if (error || !stat)
> +			break;

The old code moved on to the next AG here, why has this changed?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
