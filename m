Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56210 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/18] avl64: export avl64_firstino / avl64_firstino from avl64.h
Date: Wed, 10 Oct 2018 15:01:14 -0500
Message-Id: <1539201682-22198-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

These are flagged by the sparse checker as possibly static.
They are actually not used at this point; avl64.c has a few unused
functions and/or ones that could be made static, but for now just silence
the warnings, and save deeper surgery for later.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/avl64.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/avl64.h b/include/avl64.h
index 7a66883..4042f6c 100644
--- a/include/avl64.h
+++ b/include/avl64.h
@@ -69,6 +69,12 @@ avl64_insert_immediate(
 	avl64node_t *afterp,
 	avl64node_t *newnode);
 
+avl64node_t *
+avl64_firstino(avl64node_t *root);
+
+avl64node_t *
+avl64_lastino(avl64node_t *root);
+
 void
 avl64_init_tree(
 	avl64tree_desc_t  *tree,
-- 
1.8.3.1
