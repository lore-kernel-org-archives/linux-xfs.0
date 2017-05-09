Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755069AbdEIPuU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:50:20 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 12/27] cifs: set mapping error when page writeback fails in writepage or launder_pages
Date: Tue,  9 May 2017 11:49:15 -0400
Message-Id: <20170509154930.29524-13-jlayton@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/cifs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 21d404535739..0bee7f8d91ad 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2234,14 +2234,16 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 	set_page_writeback(page);
 retry_write:
 	rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
-	if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL)
-		goto retry_write;
-	else if (rc == -EAGAIN)
+	if (rc == -EAGAIN) {
+		if (wbc->sync_mode == WB_SYNC_ALL)
+			goto retry_write;
 		redirty_page_for_writepage(wbc, page);
-	else if (rc != 0)
+	} else if (rc != 0) {
 		SetPageError(page);
-	else
+		mapping_set_error(page->mapping, rc);
+	} else {
 		SetPageUptodate(page);
+	}
 	end_page_writeback(page);
 	put_page(page);
 	free_xid(xid);
-- 
2.9.3

