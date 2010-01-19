Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9I8Ki180134 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:18:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F1AE1C5E0D0
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:19:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id p4WAdmFqLzIiCL0z for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:19:08 -0800 (PST)
Date: Tue, 19 Jan 2010 04:19:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfsqa: xfs_check can see stale cached blocks
Message-ID: <20100119091907.GG29269@infradead.org>
References: <1263891792-30952-1-git-send-email-david@fromorbit.com>
	<1263891792-30952-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263891792-30952-4-git-send-email-david@fromorbit.com>
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

On Tue, Jan 19, 2010 at 08:03:12PM +1100, Dave Chinner wrote:
> Test 017 is consistently failing now because the xfs_check uses
> buffered IO to read the block device and 017 runs xfs_check ona
> remount,ro filesystem. Hence the block device cache is never
> invalidated (the unmount path does this) and so xfs_check can see
> stale blocks from previous invocations instead of what is really on
> disk at the time it is run.
> 
> Manually trash the page cache before running xfs_check to ensure
> that the blockdev cache is clean and we don't get false errors
> from stale blocks.

I don't think this is correct.  We need to provide this synchronization
from kernel land.  IIRC Al even has a patch towards this in his tree,
can't point you to it to try it because his tree on kernel.org seems
messed up right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
