Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51873 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932113AbdEJSCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 14:02:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/16] uuid: remove struct uuid_v1
Date: Wed, 10 May 2017 20:02:05 +0200
Message-Id: <20170510180214.16852-8-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uuid.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index af669f317780..28a5a894b926 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -19,30 +19,6 @@
 #include <uapi/linux/uuid.h>
 
 /*
- * V1 (time-based) UUID definition [RFC 4122].
- * - the timestamp is a 60-bit value, split 32/16/12, and goes in 100ns
- *   increments since midnight 15th October 1582
- *   - add AFS_UUID_TO_UNIX_TIME to convert unix time in 100ns units to UUID
- *     time
- * - the clock sequence is a 14-bit counter to avoid duplicate times
- */
-struct uuid_v1 {
-	__be32		time_low;			/* low part of timestamp */
-	__be16		time_mid;			/* mid part of timestamp */
-	__be16		time_hi_and_version;		/* high part of timestamp and version  */
-#define UUID_TO_UNIX_TIME	0x01b21dd213814000ULL
-#define UUID_TIMEHI_MASK	0x0fff
-#define UUID_VERSION_TIME	0x1000	/* time-based UUID */
-#define UUID_VERSION_NAME	0x3000	/* name-based UUID */
-#define UUID_VERSION_RANDOM	0x4000	/* (pseudo-)random generated UUID */
-	u8		clock_seq_hi_and_reserved;	/* clock seq hi and variant */
-#define UUID_CLOCKHI_MASK	0x3f
-#define UUID_VARIANT_STD	0x80
-	u8		clock_seq_low;			/* clock seq low */
-	u8		node[6];			/* spatially unique node ID (MAC addr) */
-};
-
-/*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
  * not including trailing NUL.
  */
-- 
2.11.0

