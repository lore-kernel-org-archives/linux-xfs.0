Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966209AbdEOPnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 11:43:52 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/17] block: remove blk_part_pack_uuid
Date: Mon, 15 May 2017 17:43:06 +0200
Message-Id: <20170515154308.26739-16-hch@lst.de>
In-Reply-To: <20170515154308.26739-1-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

This helper was only used by IMA of all things, which would get spurious
errors if CONFIG_BLOCK is disabled.  Just opencode the call there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/genhd.h               | 11 -----------
 security/integrity/ima/ima_policy.c |  3 +--
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index acff9437e5c3..e619fae2f037 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,12 +219,6 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 	return NULL;
 }
 
-static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
-{
-	uuid_be_to_bin(uuid_str, (uuid_be *)to);
-	return 0;
-}
-
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)
@@ -736,11 +730,6 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
 	dev_t devt = MKDEV(0, 0);
 	return devt;
 }
-
-static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
-{
-	return -EINVAL;
-}
 #endif /* CONFIG_BLOCK */
 
 #endif /* _LINUX_GENHD_H */
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 3ab1067db624..49fbc3e8f012 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -717,8 +717,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			result = blk_part_pack_uuid(args[0].from,
-						    entry->fsuuid);
+			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
 			if (!result)
 				entry->flags |= IMA_FSUUID;
 			break;
-- 
2.11.0

