Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfFXNoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 09:44:09 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] shared/011: run on all file system that support cgroup writeback
Date: Mon, 24 Jun 2019 15:44:07 +0200
Message-Id: <20190624134407.21365-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Run the cgroup writeback test on xfs, for which I've just posted
a patch to support cgroup writeback as well as ext2 and f2fs, which
have supported cgroup writeback for a while now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/shared/011 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shared/011 b/tests/shared/011
index a0ac375d..96ce9d1c 100755
--- a/tests/shared/011
+++ b/tests/shared/011
@@ -39,7 +39,7 @@ rm -f $seqres.full
 # real QA test starts here
 
 # Modify as appropriate.
-_supported_fs ext4 btrfs
+_supported_fs ext2 ext4 f2fs btrfs xfs
 _supported_os Linux
 _require_scratch
 _require_cgroup2 io
-- 
2.20.1
