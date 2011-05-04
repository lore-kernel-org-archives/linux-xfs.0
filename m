Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44B8cGr071836 for <xfs@oss.sgi.com>; Wed, 4 May 2011 06:08:39 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2717A1583572
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 04:12:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KoTFvHZZe55Pow55 for <xfs@oss.sgi.com>;
	Wed, 04 May 2011 04:12:15 -0700 (PDT)
Date: Wed, 4 May 2011 21:12:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110504111211.GF9114@dastard>
References: <20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
	<20110504073615.GD9114@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110504073615.GD9114@dastard>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Wed, May 04, 2011 at 05:36:15PM +1000, Dave Chinner wrote:
> On Tue, May 03, 2011 at 05:46:14PM -0700, Christian Kujau wrote:
> > And another one, please see the files marked with 15- here:
> > 
> >    https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/
> > 
> > I tried to have more concise timestamps in each of these files, hope that 
> > helps. Sadly though, trace-cmd reports still segfaults on the tracefile.
> 
> Ok, that will be helpful. Also helpful is that I've (FINALLY!)
> reproduced this myself, and i think i can now reproduce it at will
> on a highmem i686 machine. I'll look into it more later tonight....

And here's a patch for you to try. It fixes the problem on my test
machine.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: ensure reclaim cursor is reset correctly at end of AG

From: Dave Chinner <dchinner@redhat.com>

On a 32 bit highmem PowerPC machine, the XFS inode cache was growing
without bound and exhausting low memory causing the OOM killer to be
triggered. After some effort, the problem was reproduced on a 32 bit
x86 highmem machine.

The problem is that the per-ag inode reclaim index cursor was not
getting reset to the start of the AG if the radix tree tag lookup
found no more reclaimable inodes. Hence every further reclaim
attempt started at the same index beyond where any reclaimable
inodes lay, and no further background reclaim ever occurred from the
AG.

Without background inode reclaim the VM driven cache shrinker
simply cannot keep up with cache growth, and OOM is the result.

While the change that exposed the problem was the conversion of the
inode reclaim to use work queues for background reclaim, it was not
the cause of the bug. The bug was introduced when the cursor code
was added, just waiting for some weird configuration to strike....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 3253572..4e1f23a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -936,6 +936,7 @@ restart:
 					XFS_LOOKUP_BATCH,
 					XFS_ICI_RECLAIM_TAG);
 			if (!nr_found) {
+				done = 1;
 				rcu_read_unlock();
 				break;
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
