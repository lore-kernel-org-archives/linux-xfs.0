Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLiONZ244085 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:44:25 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	G20C7XBRvM0XbkRw (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:45:56 -0700 (PDT)
Date: Thu, 11 Oct 2012 17:45:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/19] xfs: verify inode buffers as they are read from disk
Message-ID: <20121011214555.GH6346@infradead.org>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349754670-32009-9-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> +						XFS_ERRTAG_ITOBP_INOTOBP,
> +						XFS_RANDOM_ITOBP_INOTOBP))) {
> +			xfs_buf_ioerror(bp, EFSCORRUPTED);
> +			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
> +					     mp, dip);
> +#ifdef DEBUG
> +			xfs_emerg(mp,
> +				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> +				(unsigned long long)bp->b_bn, i,
> +				be16_to_cpu(dip->di_magic));
> +			ASSERT(0);
> +#endif

Is there any point in having this additional output in addition to the
high error level corruption report above?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
