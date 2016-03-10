Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 516C57CA2
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 08:19:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2CA1AC006
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:19:15 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Vb48mlKzEoOtg7iz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:19:13 -0800 (PST)
Date: Thu, 10 Mar 2016 06:19:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20160310141913.GC29058@infradead.org>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<1457410578-30233-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457410578-30233-6-git-send-email-david@fromorbit.com>
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

On Tue, Mar 08, 2016 at 03:16:07PM +1100, Dave Chinner wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> For the rmap btree to work, we have to fed the extent owner

s/fed/feed/

> +/*
> + * Ownership info for an extent.  This is used to create reverse-mapping
> + * entries.
> + */
> +#define XFS_RMAP_INO_ATTR_FORK	(1)
> +#define XFS_RMAP_BMBT_BLOCK	(2)

These are OR-able flags - it might make sense to define them as:

#define XFS_RMAP_INO_ATTR_FORK	(1 << 0)
#define XFS_RMAP_BMBT_BLOCK	(1 << 1)

to make this more obvious.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
