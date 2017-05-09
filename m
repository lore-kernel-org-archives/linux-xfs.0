Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755032AbdEIPuR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:50:17 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 10/27] 9p: set mapping error when writeback fails in launder_page
Date: Tue,  9 May 2017 11:49:13 -0400
Message-Id: <20170509154930.29524-11-jlayton@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

launder_page is just writeback under the page lock. We still need to
mark the mapping for errors there when they occur.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/9p/vfs_addr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index adaf6f6dd858..7af6e6501698 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -223,8 +223,11 @@ static int v9fs_launder_page(struct page *page)
 	v9fs_fscache_wait_on_page_write(inode, page);
 	if (clear_page_dirty_for_io(page)) {
 		retval = v9fs_vfs_writepage_locked(page);
-		if (retval)
+		if (retval) {
+			if (retval != -EAGAIN)
+				mapping_set_error(page->mapping, retval);
 			return retval;
+		}
 	}
 	return 0;
 }
-- 
2.9.3

