Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50871 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751658AbdFAJdV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:33:21 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 22/35] nilfs2: Use pagevec_lookup_range_tag()
Date: Thu,  1 Jun 2017 11:32:32 +0200
Message-Id: <20170601093245.29238-23-jack@suse.cz>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Jan Kara <jack@suse.cz>

We want only pages from given range in
nilfs_lookup_dirty_data_buffers(). Use pagevec_lookup_range_tag()
instead of pagevec_lookup_tag() and remove unnecessary code.

CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-nilfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nilfs2/segment.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index febed1217b3f..fd9eeca5f784 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -711,18 +711,14 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 	pagevec_init(&pvec, 0);
  repeat:
 	if (unlikely(index > last) ||
-	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				min_t(pgoff_t, last - index,
-				      PAGEVEC_SIZE - 1) + 1))
+	    !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))
 		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
 		struct page *page = pvec.pages[i];
 
-		if (unlikely(page->index > last))
-			break;
-
 		lock_page(page);
 		if (!page_has_buffers(page))
 			create_empty_buffers(page, i_blocksize(inode), 0);
-- 
2.12.3

