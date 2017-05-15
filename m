Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934816AbdEOPna (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 11:43:30 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/17] uuid: remove the now unused uuid_be_cmp helper
Date: Mon, 15 May 2017 17:42:58 +0200
Message-Id: <20170515154308.26739-8-hch@lst.de>
In-Reply-To: <20170515154308.26739-1-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uuid.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index aef21b580b17..21218351ae26 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -92,9 +92,4 @@ static inline int uuid_le_cmp(const guid_t u1, const guid_t u2)
 	return memcmp(&u1, &u2, sizeof(guid_t));
 }
 
-static inline int uuid_be_cmp(const uuid_t u1, const uuid_t u2)
-{
-	return memcmp(&u1, &u2, sizeof(uuid_t));
-}
-
 #endif
-- 
2.11.0

