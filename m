Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbeKOLSh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 06:18:37 -0500
Received: from ebiggers.mtv.corp.google.com (unknown [104.132.1.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D6B2147C
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 01:12:58 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] xfs: make xfs_file_remap_range() static
Date: Wed, 14 Nov 2018 17:12:17 -0800
Message-Id: <20181115011217.104363-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

xfs_file_remap_range() is only used in fs/xfs/xfs_file.c, so make it
static.

This addresses a gcc warning when -Wmissing-prototypes is enabled.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 53c9ab8fb777f..e47425071e654 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -920,7 +920,7 @@ xfs_file_fallocate(
 }
 
 
-loff_t
+STATIC loff_t
 xfs_file_remap_range(
 	struct file		*file_in,
 	loff_t			pos_in,
-- 
2.19.1.930.g4563a0d9d0-goog
