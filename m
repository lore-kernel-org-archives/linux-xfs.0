Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6457 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932336AbdJZOgy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 10:36:54 -0400
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH] xfsprogs: Issue smaller discards at mkfs
Date: Thu, 26 Oct 2017 08:41:31 -0600
Message-Id: <20171026144131.26885-1-keith.busch@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>

Running mkfs.xfs was discarding the entire capacity in a single range. The
block layer would split these into potentially many smaller requests
and dispatch all of them to the device at roughly the same time.

SSD capacities are getting so large that full capacity discards will
take some time to complete. When discards are deeply queued, the block
layer may trigger timeout handling and IO failure, though the device is
operating normally.

This patch uses smaller discard ranges in a loop for mkfs to avoid
risking such timeouts. The max discard range is arbitrarilly set to
128GB in this patch.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 include/linux.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 6ce344c5..702aee0c 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -132,10 +132,17 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 static __inline__ int
 platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
-	uint64_t range[2] = { start, len };
+	uint64_t end = start + len;
+	uint64_t size = 128ULL * 1024ULL * 1024ULL * 1024ULL;
 
-	if (ioctl(fd, BLKDISCARD, &range) < 0)
-		return errno;
+	for (; start < end; start += size) {
+		uint64_t range[2] = { start, MIN(len, size) };
+
+		len -= range[1];
+		if (ioctl(fd, BLKDISCARD, &range) < 0)
+			return errno;
+
+	}
 	return 0;
 }
 
-- 
2.13.6

