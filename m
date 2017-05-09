Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755483AbdEIPvA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:51:00 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 26/27] mm: flesh out comments over mapping_set_error
Date: Tue,  9 May 2017 11:49:29 -0400
Message-Id: <20170509154930.29524-27-jlayton@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/pagemap.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9593eac41499..9b453eae0aa1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -27,6 +27,20 @@ enum mapping_flags {
 	AS_NO_WRITEBACK_TAGS = 3,
 };
 
+/**
+ * mapping_set_error - record a writeback error in the address_space
+ * @mapping - the mapping in which an error should be set
+ * @error - the error to set in the mapping
+ *
+ * When writeback fails in some way, we must record that error so that
+ * userspace can be informed when fsync and the like are called.  We endeavor
+ * to report errors on any file that was open at the time of the error.  Some
+ * internal callers also need to know when writeback errors have occurred.
+ *
+ * When a writeback error occurs, most will filesystems will want to call
+ * mapping_set_error to record the error in the mapping so that it will be
+ * automatically reported whenever fsync is called on the file.
+ */
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
 	return errseq_set(&mapping->wb_err, error);
-- 
2.9.3

