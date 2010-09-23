Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NAgYZP121891 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 05:42:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E9E81E6DEB5
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:43:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id B9VAb9aW8x1Y4H8y for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:43:29 -0700 (PDT)
Date: Thu, 23 Sep 2010 06:43:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: force background CIL push under sustained load
Message-ID: <20100923104327.GB16984@infradead.org>
References: <1285208863-31489-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285208863-31489-1-git-send-email-david@fromorbit.com>
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

On Thu, Sep 23, 2010 at 12:27:43PM +1000, Dave Chinner wrote:
> The fix is to start blocking background pushes once the threshold has been
> exceeded by 50%. This is still only 37.5% of log space at worst, so keeps us
> well short of the limit a transaction must not exceed.


Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

> + * the background push threshold to 1/8th (12.5%) the size of the log, and then start

if you can please shorten this line a bit for the final version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
