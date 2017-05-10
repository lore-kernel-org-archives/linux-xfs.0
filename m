Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46075 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754277AbdEJSC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 14:02:56 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/16] block: remove blk_part_pack_uuid
Date: Wed, 10 May 2017 20:02:12 +0200
Message-Id: <20170510180214.16852-15-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

This helper was only used by IMA of all things, which would get spurious
errors if CONFIG_BLOCK is disabled.  Just opencode the call there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[andy: correctly handle error returns from uuid_to_bin]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 security/integrity/ima/ima_policy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4d1178610145..49fbc3e8f012 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -717,8 +717,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			uuid_to_bin(args[0].from, (uuid_t *)entry->fsuuid);
-			entry->flags |= IMA_FSUUID;
+			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
+			if (!result)
+				entry->flags |= IMA_FSUUID;
 			break;
 		case Opt_uid_gt:
 		case Opt_euid_gt:
-- 
2.11.0

