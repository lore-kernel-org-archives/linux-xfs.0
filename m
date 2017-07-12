Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31945 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdGLRgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2017 13:36:54 -0400
Date: Wed, 12 Jul 2017 10:36:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: in iomap seek_{hole,data}, return -ENXIO for negative
 offsets
Message-ID: <20170712173650.GC4212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

In the iomap implementations of SEEK_HOLE and SEEK_DATA, make sure we
return -ENXIO for negative offsets instead of badgering the iomap
provider with garbage requests.

Inspired-by: Mateusz S <muttdini@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 432eed8..16f5c074 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -610,8 +610,8 @@ iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 	loff_t length = size - offset;
 	loff_t ret;
 
-	/* Nothing to be found beyond the end of the file. */
-	if (offset >= size)
+	/* Nothing to be found before or beyond the end of the file. */
+	if (offset < 0 || offset >= size)
 		return -ENXIO;
 
 	while (length > 0) {
@@ -656,8 +656,8 @@ iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 	loff_t length = size - offset;
 	loff_t ret;
 
-	/* Nothing to be found beyond the end of the file. */
-	if (offset >= size)
+	/* Nothing to be found before or beyond the end of the file. */
+	if (offset < 0 || offset >= size)
 		return -ENXIO;
 
 	while (length > 0) {
