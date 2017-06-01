Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751626AbdFAJdS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:33:18 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/35] ext4: Use pagevec_lookup_range() in writeback code
Date: Thu,  1 Jun 2017 11:32:20 +0200
Message-Id: <20170601093245.29238-11-jack@suse.cz>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Jan Kara <jack@suse.cz>

Both occurences of pagevec_lookup() actually want only pages from a
given range. Use pagevec_lookup_range() for the lookup.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 784f41328dc8..59d82530d269 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1670,13 +1670,13 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, &index, PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end,
+						PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
-			if (page->index > end)
-				break;
+
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 			if (invalidate) {
@@ -2283,15 +2283,13 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 
 	pagevec_init(&pvec, 0);
 	while (start <= end) {
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &start,
-					  PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+						&start, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
-				break;
 			bh = head = page_buffers(page);
 			do {
 				if (lblk < mpd->map.m_lblk)
-- 
2.12.3

