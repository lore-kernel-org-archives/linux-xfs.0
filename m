Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8BVjkN096315 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 05:31:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 797571C2262E
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 03:33:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PrXbFdtEiOQY3i3j for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 03:33:12 -0800 (PST)
Date: Mon, 8 Nov 2010 06:33:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/16] xfs: only run xfs_error_test if error injection is
	active
Message-ID: <20101108113312.GC7654@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-16-git-send-email-david@fromorbit.com>
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

> Walking btree blocks during allocation checking them requires each
> block (a cache hit, so no I/O) call xfs_error_test(), which then
> does a random32() call as teh first operation.  IOWs, ~50% of the
> CPU is being consumed just testing whether we need to inject an
> error, even though error injection is not active.
> 
> Kill this overhead when error injection is not active by adding a
> global counter of active error traps and only calling into
> xfs_error_test when fault injection is active.

Looks good.  And a good reminder that we should optimize the code to not
call xfs_btree_check_block on catch matches once putting the CRC checks
into it later.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
