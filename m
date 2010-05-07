Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o47BdMnu160578 for <xfs@oss.sgi.com>; Fri, 7 May 2010 06:39:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ED961DE652A
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 04:41:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VuaqVjUV5deqSdLU for
	<xfs@oss.sgi.com>; Fri, 07 May 2010 04:41:33 -0700 (PDT)
Date: Fri, 7 May 2010 07:41:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/12] xfs: make the log ticket ID available outside
	the log infrastructure
Message-ID: <20100507114130.GA25474@infradead.org>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273210860-23414-7-git-send-email-david@fromorbit.com>
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

On Fri, May 07, 2010 at 03:40:54PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The ticket ID is needed to uniquely identify transactions when doing busy
> extent matching. Delayed logging changes the lifecycle of busy extents with
> respect to the transaction structure lifecycle. Hence we can no longer use
> the transaction structure as a means of determining the owner of the busy
> extent as it may be freed and reused while the busy extent is still active.
> 
> This commit provides the infrastructure to access the xlog_tid_t held in the
> ticket from a transaction handle. This avoids the need for callers to peek
> into the transaction and log structures to find this out.

No happy about exposing the tid, but given that we need it for now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
