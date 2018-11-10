Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728910AbeKJVgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:36:47 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] xfs: xfs_fsr requires working preallocation support
Date: Sat, 10 Nov 2018 12:51:44 +0100
Message-Id: <20181110115145.30356-5-hch@lst.de>
In-Reply-To: <20181110115145.30356-1-hch@lst.de>
References: <20181110115145.30356-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Check that the file system actually supports preallocation for defrag
tests that end up calling xfs_fsr, as they can't be supported in
always_cow mode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/defrag | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/defrag b/common/defrag
index df249dfd..79485f0d 100644
--- a/common/defrag
+++ b/common/defrag
@@ -8,6 +8,7 @@ _require_defrag()
 {
     case "$FSTYP" in
     xfs)
+        _require_xfs_io_command "falloc"
         DEFRAG_PROG="$XFS_FSR_PROG"
 	;;
     ext4|ext4dev)
-- 
2.19.1
