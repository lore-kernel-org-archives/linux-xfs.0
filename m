Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162247AbdDURG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 13:06:59 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1aNS-0005VK-Pu
        for linux-xfs@vger.kernel.org; Fri, 21 Apr 2017 15:21:43 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] xfs: don't use bool values in trace buffers
Date: Fri, 21 Apr 2017 17:21:22 +0200
Message-Id: <20170421152123.11316-6-hch@lst.de>
In-Reply-To: <20170421152123.11316-1-hch@lst.de>
References: <20170421152123.11316-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Using bool values produces sparse warnings of this form:

fs/xfs/./xfs_trace.h:2252:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
fs/xfs/./xfs_trace.h:2252:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
fs/xfs/./xfs_trace.h:2278:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
fs/xfs/./xfs_trace.h:2278:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
fs/xfs/./xfs_trace.h:2307:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)

Just use a char instead to fix those up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4f96dc953fbe..250d08b7cfba 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2255,8 +2255,8 @@ DECLARE_EVENT_CLASS(xfs_defer_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(void *, dop)
-		__field(bool, committed)
-		__field(bool, low)
+		__field(char, committed)
+		__field(char, low)
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
@@ -2281,8 +2281,8 @@ DECLARE_EVENT_CLASS(xfs_defer_error_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(void *, dop)
-		__field(bool, committed)
-		__field(bool, low)
+		__field(char, committed)
+		__field(char, low)
 		__field(int, error)
 	),
 	TP_fast_assign(
@@ -2311,7 +2311,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 		__field(dev_t, dev)
 		__field(int, type)
 		__field(void *, intent)
-		__field(bool, committed)
+		__field(char, committed)
 		__field(int, nr)
 	),
 	TP_fast_assign(
-- 
2.11.0

