Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1170934AbdDXNXQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:23:16 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 02/20] mm: fix mapping_set_error call in me_pagecache_dirty
Date: Mon, 24 Apr 2017 09:22:41 -0400
Message-Id: <20170424132259.8680-3-jlayton@redhat.com>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

The error code should be negative. Since this ends up in the default
case anyway, this is harmless, but it's less confusing to negate it.
Also, later patches will require a negative error code here.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/memory-failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 27f7210e7fab..4b56e53e5378 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -674,7 +674,7 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
 		 * the first EIO, but we're not worse than other parts
 		 * of the kernel.
 		 */
-		mapping_set_error(mapping, EIO);
+		mapping_set_error(mapping, -EIO);
 	}
 
 	return me_pagecache_clean(p, pfn);
-- 
2.9.3

