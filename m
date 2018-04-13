Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46920 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbeDMPyQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Apr 2018 11:54:16 -0400
Subject: [PATCH V3] xfs: enhance dinode verifier
From: Eric Sandeen <sandeen@sandeen.net>
References: <a1454c1f-e01a-5570-85d3-d55181c9ddd3@redhat.com>
 <c80d14ca-2d47-86f7-62f8-90affb06cef7@sandeen.net>
Message-ID: <1ffdb61f-d642-1310-a5df-0f166d90aa28@sandeen.net>
Date: Fri, 13 Apr 2018 10:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <c80d14ca-2d47-86f7-62f8-90affb06cef7@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: wen.xu@gatech.edu

Add several more validations to xfs_dinode_verify:

- For LOCAL data fork formats, di_nextents must be 0.
- For LOCAL attr fork formats, di_anextents must be 0.
- For inodes with no attr fork offset,
  - format must be XFS_DINODE_FMT_EXTENTS if set at all
  - di_anextents must be 0.

Thanks to dchinner for pointing out a couple related checks I had
forgotten to add.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: due credit 
V3: clarify the no-offset / no-format cases in a comment

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ef68b1d..ee8ed90 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -466,6 +466,8 @@
 				return __this_address;
 			if (di_size > XFS_DFORK_DSIZE(dip, mp))
 				return __this_address;
+			if (dip->di_nextents)
+				return __this_address;
 			/* fall through */
 		case XFS_DINODE_FMT_EXTENTS:
 		case XFS_DINODE_FMT_BTREE:
@@ -484,12 +486,31 @@
 	if (XFS_DFORK_Q(dip)) {
 		switch (dip->di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
+			if (dip->di_anextents)
+				return __this_address;
+		/* fall through */
 		case XFS_DINODE_FMT_EXTENTS:
 		case XFS_DINODE_FMT_BTREE:
 			break;
 		default:
 			return __this_address;
 		}
+	} else {
+		/*
+		 * If there is no fork offset, this may be a freshly-made inode
+		 * in a new disk cluster, in which case di_aformat is zeroed.
+		 * Otherwise, such an inode must be in EXTENTS format; this goes
+		 * for freed inodes as well.
+		 */
+		switch (dip->di_aformat) {
+		case 0:
+		case XFS_DINODE_FMT_EXTENTS:
+			break;
+		default:
+			return __this_address;
+		}
+		if (dip->di_anextents)
+			return __this_address;
 	}
 
 	/* only version 3 or greater inodes are extensively verified here */

