Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22221 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1171068AbdDXNYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:24:08 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 10/20] fuse: set mapping error in writepage_locked when it fails
Date: Mon, 24 Apr 2017 09:22:49 -0400
Message-Id: <20170424132259.8680-11-jlayton@redhat.com>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

This ensures that we see errors on fsync when writeback fails.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fuse/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ec238fb5a584..07d0efcb050c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1669,6 +1669,7 @@ static int fuse_writepage_locked(struct page *page)
 err_free:
 	fuse_request_free(req);
 err:
+	mapping_set_error(page->mapping, error);
 	end_page_writeback(page);
 	return error;
 }
-- 
2.9.3

