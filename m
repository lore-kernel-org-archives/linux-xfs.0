Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8U7IL6m246218 for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 02:18:21 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96C50152ADCE
	for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 00:24:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kZnXBpxoV1QlUp0N for
	<xfs@oss.sgi.com>; Fri, 30 Sep 2011 00:24:33 -0700 (PDT)
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 5/5] Btrfs: pass __GFP_WRITE for buffered write page
	allocations
Date: Fri, 30 Sep 2011 09:17:24 +0200
Message-Id: <1317367044-475-6-git-send-email-jweiner@redhat.com>
In-Reply-To: <1317367044-475-1-git-send-email-jweiner@redhat.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
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

Tell the page allocator that pages allocated for a buffered write are
expected to become dirty soon.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
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
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
