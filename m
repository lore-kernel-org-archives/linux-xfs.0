Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14275 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942852AbcJSTew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Oct 2016 15:34:52 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 13/16] dax: move put_(un)locked_mapping_entry() in dax.c
Date: Wed, 19 Oct 2016 13:34:32 -0600
Message-Id: <1476905675-32581-14-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

No functional change.

The static functions put_locked_mapping_entry() and
put_unlocked_mapping_entry() will soon be used in error cases in
grab_mapping_entry(), so move their definitions above this function.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c45cc4d..0582c7c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -382,6 +382,31 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 	}
 }
 
+static void put_locked_mapping_entry(struct address_space *mapping,
+				     pgoff_t index, void *entry)
+{
+	if (!radix_tree_exceptional_entry(entry)) {
+		unlock_page(entry);
+		put_page(entry);
+	} else {
+		dax_unlock_mapping_entry(mapping, index);
+	}
+}
+
+/*
+ * Called when we are done with radix tree entry we looked up via
+ * get_unlocked_mapping_entry() and which we didn't lock in the end.
+ */
+static void put_unlocked_mapping_entry(struct address_space *mapping,
+				       pgoff_t index, void *entry)
+{
+	if (!radix_tree_exceptional_entry(entry))
+		return;
+
+	/* We have to wake up next waiter for the radix tree entry lock */
+	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+}
+
 /*
  * Find radix tree entry at given index. If it points to a page, return with
  * the page locked. If it points to the exceptional entry, return with the
@@ -486,31 +511,6 @@ void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
-static void put_locked_mapping_entry(struct address_space *mapping,
-				     pgoff_t index, void *entry)
-{
-	if (!radix_tree_exceptional_entry(entry)) {
-		unlock_page(entry);
-		put_page(entry);
-	} else {
-		dax_unlock_mapping_entry(mapping, index);
-	}
-}
-
-/*
- * Called when we are done with radix tree entry we looked up via
- * get_unlocked_mapping_entry() and which we didn't lock in the end.
- */
-static void put_unlocked_mapping_entry(struct address_space *mapping,
-				       pgoff_t index, void *entry)
-{
-	if (!radix_tree_exceptional_entry(entry))
-		return;
-
-	/* We have to wake up next waiter for the radix tree entry lock */
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
-}
-
 /*
  * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
-- 
2.7.4

