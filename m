Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 371037F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:25:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF3FBAC03C
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 09:25:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WPqsZc8I1EMzYXUn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 09:25:19 -0800 (PST)
Date: Tue, 25 Feb 2014 09:25:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] repair: BMBT prefetch needs to be CRC aware
Message-ID: <20140225172518.GA12871@infradead.org>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393223369-4696-11-git-send-email-david@fromorbit.com>
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

>  	/*
>  	 * do some validation on the block contents
>  	 */
> -	if ((be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) ||
> +	if ((block->bb_magic != cpu_to_be32(XFS_BMAP_MAGIC) &&
> +	     block->bb_magic != cpu_to_be32(XFS_BMAP_CRC_MAGIC)) ||
>  			(be16_to_cpu(block->bb_level) != level))

Seems like this should be factored into a well-documented helper
function.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
