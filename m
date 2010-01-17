Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBoL6r009563 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:50:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9474D16DEA0
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:51:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id g5xAF1N9QXGgJk8N for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:51:20 -0800 (PST)
Date: Sun, 17 Jan 2010 06:51:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfsprogs: fix trivial warnings in xfs_fsr
Message-ID: <20100117115119.GB10994@infradead.org>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
	<1263463752-5052-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263463752-5052-7-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2010 at 09:09:09PM +1100, Dave Chinner wrote:
> GCC complains about assignments between (unsigned long long *)
> and (__u64 *) pointers. Just add a cast to shut it up.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
