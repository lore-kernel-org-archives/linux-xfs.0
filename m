Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BLoHxc182081 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 15:50:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F0E415A6A1
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:51:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Hch8UYHVLDVwu4zA for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:51:13 -0800 (PST)
Date: Mon, 11 Jan 2010 16:51:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] XFS: Don't wake the aild once per second
Message-ID: <20100111215112.GC10278@infradead.org>
References: <1263210599-25067-1-git-send-email-david@fromorbit.com>
	<1263210599-25067-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263210599-25067-3-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:49:58PM +1100, Dave Chinner wrote:
> Now that the AIL push algorithm is traversal safe, we don't need a
> watchdog function in the xfsaild to catch pushes that fail to make
> progress. Remove the watchdog timeout and make pushes purely driven
> by demand. This will remove the once-per-second wakeup that is seen
> when the filesystem is idle and make laptop power misers happy.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
