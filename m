Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50881 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751660AbdFAJdV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:33:21 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 21/35] gfs2: Use pagevec_lookup_range_tag()
Date: Thu,  1 Jun 2017 11:32:31 +0200
Message-Id: <20170601093245.29238-22-jack@suse.cz>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Jan Kara <jack@suse.cz>

We want only pages from given range in gfs2_write_cache_jdata(). Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

CC: Bob Peterson <rpeterso@redhat.com>
CC: cluster-devel@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/aops.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index ed7a2e252ad8..158ceb900ab5 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -268,22 +268,6 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 	for(i = 0; i < nr_pages; i++) {
 		struct page *page = pvec->pages[i];
 
-		/*
-		 * At this point, the page may be truncated or
-		 * invalidated (changing page->mapping to NULL), or
-		 * even swizzled back from swapper_space to tmpfs file
-		 * mapping. However, page->index will not change
-		 * because we have a reference on the page.
-		 */
-		if (page->index > end) {
-			/*
-			 * can't be range_cyclic (1st pass) because
-			 * end == -1 in that case.
-			 */
-			ret = 1;
-			break;
-		}
-
 		*done_index = page->index;
 
 		lock_page(page);
@@ -401,8 +385,8 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
-- 
2.12.3

