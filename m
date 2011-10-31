Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9VBXT0f033747 for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 06:33:29 -0500
Received: from mga03.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B14520FE61
	for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 04:33:28 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [143.182.124.21]) by
	cuda.sgi.com with ESMTP id PuCTSwt8KcLXIuw9 for
	<xfs@oss.sgi.com>; Mon, 31 Oct 2011 04:33:28 -0700 (PDT)
Date: Mon, 31 Oct 2011 19:33:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
Message-ID: <20111031113321.GA30890@localhost>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-4-git-send-email-jweiner@redhat.com>
	<20110930142805.GC869@tiehlicka.suse.cz>
	<20111028201829.GA20607@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111028201829.GA20607@localhost>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

> //regression
> 3) much increased cpu %user and %system for btrfs

Sorry I find out that the CPU time regressions for btrfs are caused by
some additional trace events enabled on btrfs (for debugging an
unrelated btrfs hang bug) which results in 7 times more trace event
lines:

 2701238 /export/writeback/thresh=1000M/btrfs-1dd-4k-8p-2941M-1000M:10-3.1.0-rc9-ioless-full-nfs-wq5-next-20111014+
19054054 /export/writeback/thresh=1000M/btrfs-1dd-4k-8p-2941M-1000M:10-3.1.0-rc9-ioless-full-per-zone-dirty-next-20111014+

So no real regressions.

Besides, the patchset also performs good on random writes:

3.1.0-rc9-ioless-full-nfs-wq5-next-20111014+  3.1.0-rc9-ioless-full-per-zone-dirty-next-20111014+  
------------------------  ------------------------  
                    1.65        -5.1%         1.57  MMAP-RANDWRITE-4K/btrfs-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
                   18.65        -6.4%        17.46  MMAP-RANDWRITE-4K/ext3-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
                    2.09        +1.2%         2.12  MMAP-RANDWRITE-4K/ext4-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
                    2.49        -0.3%         2.48  MMAP-RANDWRITE-4K/xfs-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
                   51.35        +0.0%        51.36  MMAP-RANDWRITE-64K/btrfs-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
                   45.20        +0.5%        45.43  MMAP-RANDWRITE-64K/ext3-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
                   44.77        +0.7%        45.10  MMAP-RANDWRITE-64K/ext4-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
                   45.11        +2.5%        46.23  MMAP-RANDWRITE-64K/xfs-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
                  211.31        +0.2%       211.74  TOTAL write_bw

And writes to USB key:

3.1.0-rc9-ioless-full-nfs-wq5-next-20111014+  3.1.0-rc9-ioless-full-per-zone-dirty-next-20111014+  
------------------------  ------------------------  
                    5.94        +0.8%         5.99  UKEY-thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                    2.64        -0.8%         2.62  UKEY-thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                    5.10        +0.3%         5.12  UKEY-thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                    3.26        -0.8%         3.24  UKEY-thresh=1G/ext3-2dd-4k-8p-4096M-1024M:10-X
                    5.63        -0.5%         5.60  UKEY-thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                    6.04        -0.1%         6.04  UKEY-thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                    5.90        -0.2%         5.88  UKEY-thresh=1G/ext4-2dd-4k-8p-4096M-1024M:10-X
                    2.45       +22.6%         3.00  UKEY-thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                    6.18        -0.4%         6.16  UKEY-thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                    4.81        +0.0%         4.81  UKEY-thresh=1G/xfs-2dd-4k-8p-4096M-1024M:10-X
                   47.94        +1.1%        48.45  TOTAL write_bw

In summary, I see no problem at all in these trivial writeback tests.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
