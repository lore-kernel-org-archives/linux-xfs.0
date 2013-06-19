Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63BFD7F76
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 04:40:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D401304032
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 02:40:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 64LqLS9dZ8kixKQi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 02:40:28 -0700 (PDT)
Date: Wed, 19 Jun 2013 02:40:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 29/60] xfs: consolidate xfs_utils.c
Message-ID: <20130619094028.GA19573@infradead.org>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-30-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371617468-32559-30-git-send-email-david@fromorbit.com>
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

> +/*
> + * Allocates a new inode from disk and return a pointer to the
> + * incore copy. This routine will internally commit the current
> + * transaction and allocate a new one if the Space Manager needed
> + * to do an allocation to replenish the inode free-list.
> + *
> + * This routine is designed to be called from xfs_create and
> + * xfs_create_dir.

xfs_create_dir is long gone.  I suspect it's best to just kill that
sentence.

> +/*
> + * Decrement the link count on an inode & log the change.
> + * If this causes the link count to go to zero, initiate the
> + * logging activity required to truncate a file.
> + */
> +int				/* error */
> +xfs_droplink(

Can be static now.

> +/*
> + * Increment the link count on an inode & log the change.
> + */
> +int
> +xfs_bumplink(

Same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
