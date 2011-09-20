Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KDkPM3063135 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 08:46:25 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E3DE1757EC
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:46:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D2hjBt71fB9Xe48r for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:46:24 -0700 (PDT)
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 4/4] Btrfs: pass __GFP_WRITE for buffered write page
	allocations
Date: Tue, 20 Sep 2011 15:45:15 +0200
Message-Id: <1316526315-16801-5-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
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

Tell the page allocator that pages allocated for a buffered write are
expected to become dirty soon.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 fs/btrfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..ea1b892 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1084,7 +1084,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = find_or_create_page(inode->i_mapping, index + i,
-					       GFP_NOFS);
+					       GFP_NOFS | __GFP_WRITE);
 		if (!pages[i]) {
 			faili = i - 1;
 			err = -ENOMEM;
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
