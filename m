Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753839AbdEJSCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 14:02:32 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/16] uuid: add the v1 layout to uuid_t
Date: Wed, 10 May 2017 20:02:03 +0200
Message-Id: <20170510180214.16852-6-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Turn the content of uuid_t into a union and add the fields for the v1
interpretation to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/uapi/linux/uuid.h | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 1a2914d8b225..1039d2f3e114 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -25,7 +25,34 @@ typedef struct {
 } guid_t;
 
 typedef struct {
-	__u8 b[16];
+	union {
+		__u8			b[16];
+
+		/*
+		 * V1 (time-based) UUID definition [RFC 4122]:
+		 * - the timestamp is a 60-bit value, split 32/16/12, and goes
+		 *   in 100ns increments since midnight 15th October 1582
+		 *   - add UUID_TO_UNIX_TIME to convert unix time in 100ns
+		 *     units to UUID time
+		 * - the clock sequence is a 14-bit counter to avoid duplicate
+		 *   times
+		 */
+		struct {
+			__be32		time_low;
+			__be16		time_mid;
+			__be16		time_hi_and_version;
+#define UUID_TO_UNIX_TIME	0x01b21dd213814000ULL
+#define UUID_TIMEHI_MASK	0x0fff
+#define UUID_VERSION_TIME	0x1000	/* time-based UUID */
+#define UUID_VERSION_NAME	0x3000	/* name-based UUID */
+#define UUID_VERSION_RANDOM	0x4000	/* (pseudo-)random generated UUID */
+			u8		clock_seq_hi_and_reserved;
+#define UUID_CLOCKHI_MASK	0x3f
+#define UUID_VARIANT_STD	0x80
+			u8		clock_seq_low;
+			u8		node[6];
+		} v1;
+	};
 } uuid_t;
 
 #define GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
-- 
2.11.0

