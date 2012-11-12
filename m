Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAC0ualH183646 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 18:56:36 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QEGYTycxQTK4EzOf for <xfs@oss.sgi.com>;
	Sun, 11 Nov 2012 16:58:36 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TXiMF-00040Z-AR
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 11:58:35 +1100
Date: Mon, 12 Nov 2012 11:58:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix broken error handling in xfs_vm_writepage
Message-ID: <20121112005835.GP24575@dastard>
References: <1352681350-28541-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352681350-28541-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Mon, Nov 12, 2012 at 11:49:10AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we shut down the filesystem, it might first be detected in
> writeback when we are allocating a inode size transaction. This
> happens after we have moved all the pages into the writeback state
> and unlocked them. Unfortunately, if we fail to set up the
> transaction we then abort writeback and try to invalidate the
> current page. This then triggers are BUG() in block_invalidatepage()
> because we are trying to invalidate an unlocked page.

FWIW, I found this problem when testing recovery of wrapped log
buffers. The test:

$ cat t.sh
#!/bin/bash

while [ 1 ]; do
        mkfs.xfs -f /dev/vdb > /dev/null 2>&1
        mount /dev/vdb /mnt/scratch
        ./compilebench -D /mnt/scratch > /dev/null 2>&1 &
        sleep 36
        /home/dave/src/xfstests-dev/src/godown /mnt/scratch
        sleep 5
        umount /mnt/scratch
        xfs_logprint -d /dev/vdb |grep -B 1 "^\["
        mount /dev/vdb /mnt/scratch
        umount /mnt/scratch
done

would fail after 3-4 iterations due to the BUG() in
block_invalidatepage().  This fix has been running that loop for 2
hours now, so it's gone through over a hundred iterations without
failing now - it takes about 45s an iteration to run. Note that this
is also exercising the wrapped log buffer recovery fix on every
iteration, too.... :)

And FWIW, this probably should have a cc: <stable@vger.kernel.org>
on it as well, as it is a recent regression that turns a shutdown
into hard failure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
