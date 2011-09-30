Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8U7I8KR246149 for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 02:18:09 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 444FB152ABAD
	for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 00:24:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0ueDYC7wH8i3HkuB for
	<xfs@oss.sgi.com>; Fri, 30 Sep 2011 00:24:19 -0700 (PDT)
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 0/5] per-zone dirty limits v3
Date: Fri, 30 Sep 2011 09:17:19 +0200
Message-Id: <1317367044-475-1-git-send-email-jweiner@redhat.com>
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
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, Shaohua Li <shaohua.li@intel.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

Hi,

this is the third revision of the per-zone dirty limits.  Changes from
the second version have been mostly documentation, changelog, and
naming fixes based on review feedback:

o add new dirty_balance_reserve instead of abusing totalreserve_pages
  for undirtyable (per-zone) reserves and document the variable and
  its calculation (Mel)
o use !ALLOC_WMARK_LOW instead of adding new ALLOC_SLOWPATH (Mel)
o rename determine_dirtyable_memory -> global_dirtyable_memory (Andrew)
o better explain behaviour on NUMA in changelog (Andrew)
o extend changelogs and code comments on how per-zone dirty limits are
  calculated, and why, and their proportions to the global limit (Mel, Andrew)
o kernel-doc zone_dirty_ok() (Andrew)
o extend changelogs and code comments on how per-zone dirty limits are
  used to protect zones from dirty pages (Mel, Andrew)
o revert back to a separate set of zone_dirtyable_memory() and zone_dirty_limit()
  for easier reading (Andrew)

Based on v3.1-rc3-mmotm-2011-08-24-14-08.

 fs/btrfs/file.c           |    2 +-
 include/linux/gfp.h       |    4 +-
 include/linux/mmzone.h    |    6 ++
 include/linux/swap.h      |    1 +
 include/linux/writeback.h |    1 +
 mm/filemap.c              |    5 +-
 mm/page-writeback.c       |  181 +++++++++++++++++++++++++++++++++------------
 mm/page_alloc.c           |   48 ++++++++++++
 8 files changed, 197 insertions(+), 51 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
