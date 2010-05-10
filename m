Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AHf1dL018475 for <xfs@oss.sgi.com>; Mon, 10 May 2010 12:41:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 419EC330B12
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 10:43:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sIzvRVAhG9gCJ1aq for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 10:43:14 -0700 (PDT)
Date: Mon, 10 May 2010 13:43:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] xfs: Ensure inode allocation buffers are fully
	replayed
Message-ID: <20100510174312.GA11849@infradead.org>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273210860-23414-13-git-send-email-david@fromorbit.com>
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

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>


> Also, move an assert in the buffer release path outside the hash
> spinlock so that if the assert is hit the system continues to run in
> a debuggable state.

But this really should be a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
