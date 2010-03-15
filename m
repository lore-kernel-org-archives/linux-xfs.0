Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFHreD058827 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:17:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D6CF142E4B5
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:19:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JJdzFmxY7LSbFE9Z for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:19:28 -0700 (PDT)
Date: Mon, 15 Mar 2010 11:19:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't warn about page discards on shutdown
Message-ID: <20100315151927.GA6974@infradead.org>
References: <1268620595-11389-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1268620595-11389-1-git-send-email-david@fromorbit.com>
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

On Mon, Mar 15, 2010 at 01:36:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are doing a forced shutdown, we can get lots of noise about
> delalloc pages being discarded. This is happens by design during a
> forced shutdown, so don't spam the logs with these messages.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good, probably still a candiate for 2.6.34-rc.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
