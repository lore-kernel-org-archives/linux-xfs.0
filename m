Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1171165AbdDXNYj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:24:39 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 15/20] mm: remove AS_EIO and AS_ENOSPC flags
Date: Mon, 24 Apr 2017 09:22:54 -0400
Message-Id: <20170424132259.8680-16-jlayton@redhat.com>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

They're no longer used.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/pagemap.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 32512ffc15fa..9593eac41499 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -20,13 +20,11 @@
  * Bits in mapping->flags.
  */
 enum mapping_flags {
-	AS_EIO		= 0,	/* IO error on async write */
-	AS_ENOSPC	= 1,	/* ENOSPC on async write */
-	AS_MM_ALL_LOCKS	= 2,	/* under mm_take_all_locks() */
-	AS_UNEVICTABLE	= 3,	/* e.g., ramdisk, SHM_LOCK */
-	AS_EXITING	= 4, 	/* final truncate in progress */
+	AS_MM_ALL_LOCKS	= 0,	/* under mm_take_all_locks() */
+	AS_UNEVICTABLE	= 1,	/* e.g., ramdisk, SHM_LOCK */
+	AS_EXITING	= 2, 	/* final truncate in progress */
 	/* writeback related tags are not used */
-	AS_NO_WRITEBACK_TAGS = 5,
+	AS_NO_WRITEBACK_TAGS = 3,
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
-- 
2.9.3

