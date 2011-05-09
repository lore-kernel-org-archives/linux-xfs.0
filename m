Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p49EDgc6012736 for <xfs@oss.sgi.com>; Mon, 9 May 2011 09:13:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C59301E230C1
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 07:13:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HnMxX276f431tLc0 for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 07:13:41 -0700 (PDT)
Date: Mon, 9 May 2011 10:13:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: always push the AIL to the target
Message-ID: <20110509141341.GD12262@infradead.org>
References: <1304650448-28438-1-git-send-email-david@fromorbit.com>
	<1304650448-28438-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1304650448-28438-4-git-send-email-david@fromorbit.com>
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

On Fri, May 06, 2011 at 12:54:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent conversion of the xfsaild functionality to a work queue
> introduced a hard-to-hit log space grant hang. One of the problems
> discovered is a target mismatch between the item pushing loop and
> the target itself.
> 
> The push trigger checks for the target increasing (i.e. new target >
> current) while the push loop only pushes items that have a LSN <
> current. As a result, we can get the situation where the push target
> is X, the items at the tail of the AIL have LSN X and they don't get
> pushed. The push work then completes thinking it is done, and cannot
> be restarted until the push target increases to >= X + 1. If the
> push target then never increases (because the tail is not moving),
> then we never run the push work again and we stall.
> 
> Fix it by making sure log items with a LSN that matches the target
> exactly are pushed during the loop.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
