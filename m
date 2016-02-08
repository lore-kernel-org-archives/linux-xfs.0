Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63FB57CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 16:31:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43802304039
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 14:31:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cwZwws2tVEs8G40A for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 14:31:52 -0800 (PST)
Date: Tue, 9 Feb 2016 09:31:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: rename XFS_BUF_ZEROFLAGS macro
Message-ID: <20160208223120.GM27429@dastard>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
	<1454632683-20543-7-git-send-email-david@fromorbit.com>
	<20160208091235.GN5534@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208091235.GN5534@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 01:12:36AM -0800, Christoph Hellwig wrote:
> Instead of just renaming it I'd rather dig deeper.
> 
> In xlog_bwrite we call xfs_bwrite, which already handles all flag
> clearing, so the call to XFS_BUF_ZEROFLAGS can just
> be removed.

Done.

> xlog_sync already sets a lot of these flags again, and is called on an
> iclog buffer which never has the READ or XBF_WRITE_FAIL set, so just
> replacing it with an opencoded
> 
> 	bp->b_flags &= (XBF_FUA | XBF_FLUSH);

We can't do that because there are internal flags like _XBF_PAGES
that are set on log buffers. Clearing such flags will cause problems
when the iclog buffer is finally released on unmount. Hence I'd
prefer to keep the code as it stands.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
