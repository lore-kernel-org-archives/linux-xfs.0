Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:25019 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753860AbdEJP4R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 11:56:17 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/3] (to be folded into): block: remove blk_part_pack_uuid
Date: Wed, 10 May 2017 18:56:12 +0300
Message-Id: <20170510155612.55870-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
References: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 security/integrity/ima/ima_policy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 626a26d98ffd..659dbcc83d2f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -716,8 +716,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			uuid_to_bin(args[0].from, &entry->fsuuid);
-			entry->flags |= IMA_FSUUID;
+			result = uuid_to_bin(args[0].from, &entry->fsuuid);
+			if (!result)
+				entry->flags |= IMA_FSUUID;
 			break;
 		case Opt_uid_gt:
 		case Opt_euid_gt:
-- 
2.11.0

