Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752796AbdEQMK4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 08:10:56 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] xfs: Fix off-by-in in loop termination in xfs_find_get_desired_pgoff()
Date: Wed, 17 May 2017 14:10:45 +0200
Message-Id: <20170517121046.2632-3-jack@suse.cz>
In-Reply-To: <20170517121046.2632-1-jack@suse.cz>
References: <20170517121046.2632-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>

There is an off-by-one error in loop termination conditions in
xfs_find_get_desired_pgoff(). It doesn't have any visible effects but
still it is good to fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f371812e20c6..8acb8ab79267 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1097,7 +1097,7 @@ xfs_find_get_desired_pgoff(
 				goto out;
 			}
 			/* Searching done if the page index is out of range. */
-			if (page->index > end)
+			if (page->index >= end)
 				goto out;
 
 			lock_page(page);
@@ -1153,7 +1153,7 @@ xfs_find_get_desired_pgoff(
 
 		index = pvec.pages[i - 1]->index + 1;
 		pagevec_release(&pvec);
-	} while (index <= end);
+	} while (index < end);
 
 out:
 	pagevec_release(&pvec);
-- 
2.12.0

