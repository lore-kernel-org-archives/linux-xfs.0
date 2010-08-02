Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o729UDB1181641 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 04:30:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CBE715CE763
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 02:38:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Z4V5JPN1Lna0HyeB for
	<xfs@oss.sgi.com>; Mon, 02 Aug 2010 02:38:23 -0700 (PDT)
Date: Mon, 2 Aug 2010 05:30:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] dio: track and serialise unaligned direct IO
Message-ID: <20100802093024.GA7612@infradead.org>
References: <1280733945-16231-1-git-send-email-david@fromorbit.com>
	<1280733945-16231-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280733945-16231-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

> +DEFINE_SPINLOCK(dio_zero_block_lock);
> +LIST_HEAD(dio_zero_block_list);

These two should be static.

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
