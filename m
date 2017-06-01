Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751671AbdFAJdW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:33:22 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 27/35] shmem: Use pagevec_lookup() in shmem_unlock_mapping()
Date: Thu,  1 Jun 2017 11:32:37 +0200
Message-Id: <20170601093245.29238-28-jack@suse.cz>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Jan Kara <jack@suse.cz>

The comment about find_get_pages() returning if it finds a row of swap
entries seems to be stale. Use pagevec_lookup() in
shmem_unlock_mapping() to simplify the code.

CC: Hugh Dickins <hughd@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/shmem.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e67d6ba4e98e..a614a9cfb58c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -729,24 +729,14 @@ unsigned long shmem_swap_usage(struct vm_area_struct *vma)
 void shmem_unlock_mapping(struct address_space *mapping)
 {
 	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
 	pgoff_t index = 0;
 
 	pagevec_init(&pvec, 0);
 	/*
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
-	while (!mapping_unevictable(mapping)) {
-		/*
-		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
-		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
-		 */
-		pvec.nr = find_get_entries(mapping, index,
-					   PAGEVEC_SIZE, pvec.pages, indices);
-		if (!pvec.nr)
-			break;
-		index = indices[pvec.nr - 1] + 1;
-		pagevec_remove_exceptionals(&pvec);
+	while (!mapping_unevictable(mapping) &&
+			pagevec_lookup(&pvec, mapping, &index)) {
 		check_move_unevictable_pages(pvec.pages, pvec.nr);
 		pagevec_release(&pvec);
 		cond_resched();
-- 
2.12.3

