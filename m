Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754866AbdEIPuB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:50:01 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 09/27] nilfs2: set the mapping error when calling SetPageError on writeback
Date: Tue,  9 May 2017 11:49:12 -0400
Message-Id: <20170509154930.29524-10-jlayton@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

In a later patch, we're going to want to make the fsync codepath not do
a TestClearPageError call as that can override the error set in the
address space. To do that though, we need to ensure that filesystems
that are relying on the PG_error bit for reporting writeback errors
also set an error in the address space.

Ensure that this is set in nilfs2.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/nilfs2/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index febed1217b3f..612d4b446793 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1745,6 +1745,7 @@ static void nilfs_end_page_io(struct page *page, int err)
 	} else {
 		__set_page_dirty_nobuffers(page);
 		SetPageError(page);
+		mapping_set_error(page_mapping(page), err);
 	}
 
 	end_page_writeback(page);
-- 
2.9.3

