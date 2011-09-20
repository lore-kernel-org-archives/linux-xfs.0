Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KDkIax063101 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 08:46:19 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DAB31C29078
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:46:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iqIc1vLthThhHs2e for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:46:17 -0700 (PDT)
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 0/4] 50% faster writing to your USB drive!*
Date: Tue, 20 Sep 2011 15:45:11 +0200
Message-Id: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

*if you use ntfs-3g copy files larger than main memory

or: per-zone dirty limits

There have been several discussions and patches around the issue of
dirty pages being written from page reclaim, that is, they reach the
end of the LRU list before they are cleaned.

Proposed reasons for this are the divergence of dirtying age from page
cache age, on one hand, and unequal distribution of the globally
limited dirty memory across the LRU lists of different zones.

Mel's recent patches to reduce writes from reclaim, by simply skipping
over dirty pages until a certain amount of memory pressure builds up,
do help quite a bit.  But they can only deal with a limited length of
runs of dirty pages before kswapd goes to lower priority levels to
balance the zone and begins writing.

The unequal distribution of dirty memory between zones is easily
observable through the statistics in /proc/zoneinfo, but the test
results varied between filesystems.  To get an overview of where and
how often different page cache pages are created and dirtied, I hacked
together an object tracker that remembers the instantiator of a page
cache page and associates with it the paths that dirty or activate the
page, together with counters that indicate how often those operations
occur.

Btrfs, for example, appears to be activating a significant amount of
regularly written tree data with mark_page_accessed(), even with a
purely linear, page-aligned write load.  So in addition to the already
unbounded dirty memory on smaller zones, this is a divergence between
page age and dirtying age and leads to a situation where the pages
reclaimed next are not the ones that are also flushed next:

		pgactivate
			     min|  median|     max
	      xfs:	   5.000|   6.500|  20.000
	fuse-ntfs:	   5.000|  19.000| 275.000
	     ext4:	   2.000|  67.000| 810.000 
	    btrfs:	2915.000|3316.500|5786.000

ext4's delalloc, on the other hand, refuses regular write attemps from
kjournald, but the write index of the inode is still advanced for
cyclic write ranges and so the pages are not even immediately written
when the inode is selected again.

I cc'd the filesystem people because it is at least conceivable that
things could be improved on their side, but I do think the problem is
mainly with the VM and needs fixing there.

This patch series implements per-zone dirty limits, derived from the
configured global dirty limits and the individual zone size, that the
page allocator uses to distribute pages allocated for writing across
the allowable zones.  Even with pages dirtied out of the inactive LRU
order this gives page reclaim a minimum number of clean pages on each
LRU so that balancing a zone should no longer require writeback in the
common case.

The previous version included code to wake the flushers and stall the
allocation on NUMA setups where the load is bound to a node that is in
itself not large enough to reach the global dirty limits, but I am
still trying to get it to work reliably and dropped it for now, the
series has merits even without it.

			Test results

15M DMA + 3246M DMA32 + 504 Normal = 3765M memory
40% dirty ratio
16G USB thumb drive
10 runs of dd if=/dev/zero of=disk/zeroes bs=32k count=$((10 << 15))

		seconds			nr_vmscan_write
		        (stddev)	       min|     median|        max
xfs
vanilla:	 549.747( 3.492)	     0.000|      0.000|      0.000
patched:	 550.996( 3.802)	     0.000|      0.000|      0.000

fuse-ntfs
vanilla:	1183.094(53.178)	 54349.000|  59341.000|  65163.000
patched:	 558.049(17.914)	     0.000|      0.000|     43.000

btrfs
vanilla:	 573.679(14.015)	156657.000| 460178.000| 606926.000
patched:	 563.365(11.368)	     0.000|      0.000|   1362.000

ext4
vanilla:	 561.197(15.782)	     0.000|2725438.000|4143837.000
patched:	 568.806(17.496)	     0.000|      0.000|      0.000

Even though most filesystems already ignore the write request from
reclaim, we were reluctant in the past to remove it, as it was still
theoretically our only means to stay on top of the dirty pages on a
per-zone basis.  This patchset should get us closer to removing the
dreaded writepage call from page reclaim altogether.

	Hannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
