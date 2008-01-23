Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 04:17:38 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NCHSDx014006
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 04:17:31 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF07354E0DB
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 04:17:43 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id pGmxEgl1VHsFCckC for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 04:17:43 -0800 (PST)
Date: Wed, 23 Jan 2008 12:17:41 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS doesn't correctly account for IO-Wait for directory reading
Message-ID: <20080123121741.GA24405@infradead.org>
References: <20080123110027.GA10366@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123110027.GA10366@citd.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com


Try this one-liner patch which should give you much better I/O wait
reporting.  There's some more I/O waits hidden in the log code, but to
fix this we'd need to dig into the sv_t abstraction.  Given that it only
has four users left I'm probably going to simply remove it and fix the
I/O wait accounting while I'm at it.


--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-01-23 13:08:48.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-01-23 13:08:54.000000000 +0100
@@ -976,7 +976,7 @@ xfs_buf_wait_unpin(
 			break;
 		if (atomic_read(&bp->b_io_remaining))
 			blk_run_address_space(bp->b_target->bt_mapping);
-		schedule();
+		io_schedule();
 	}
 	remove_wait_queue(&bp->b_waiters, &wait);
 	set_current_state(TASK_RUNNING);
