Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50479 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751209AbdFAJdP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:33:15 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/35] ext4: Fix off-by-in in loop termination in ext4_find_unwritten_pgoff()
Date: Thu,  1 Jun 2017 11:32:13 +0200
Message-Id: <20170601093245.29238-4-jack@suse.cz>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Jan Kara <jack@suse.cz>

There is an off-by-one error in loop termination conditions in
ext4_find_unwritten_pgoff() since 'end' may index a page beyond end of
desired range if 'endoff' is page aligned. It doesn't have any visible
effects but still it is good to fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bbea2dccd584..2b00bf84c05b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -474,7 +474,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 	endoff = (loff_t)end_blk << blkbits;
 
 	index = startoff >> PAGE_SHIFT;
-	end = endoff >> PAGE_SHIFT;
+	end = (endoff - 1) >> PAGE_SHIFT;
 
 	pagevec_init(&pvec, 0);
 	do {
-- 
2.12.3

