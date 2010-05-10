Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4ABhjWe258989 for <xfs@oss.sgi.com>; Mon, 10 May 2010 06:43:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB92E97CD39
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 04:46:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lVwlGuxR7LkxLAkX for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 04:46:16 -0700 (PDT)
Date: Mon, 10 May 2010 07:45:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/12] xfs: enable background pushing of the CIL
Message-ID: <20100510114557.GC27624@infradead.org>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273210860-23414-12-git-send-email-david@fromorbit.com>
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

On Fri, May 07, 2010 at 03:40:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we let the CIL grow without bound, it will grow large enough to violate
> recovery constraints (must be at least one complete transaction in the log at
> all times) or take forever to write out through the log buffers. Hence we need
> a check during asynchronous transactions as to whether the CIL needs to be
> pushed.
> 
> We track the amount of log space the CIL consumes, so it is relatively simple
> to limit it on a pure size basis. Make the limit the minimum of just under half
> the log size (recovery constraint) or 8MB of log space (which is an awful lot
> of metadata).

Looks good except for the use of a cleanup label in xlog_cil_push
mention in the review of the main patch.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
