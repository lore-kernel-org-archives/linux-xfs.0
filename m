Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752594AbeDMCtx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Apr 2018 22:49:53 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: enhance dinode verifier
Message-ID: <a1454c1f-e01a-5570-85d3-d55181c9ddd3@redhat.com>
Date: Thu, 12 Apr 2018 21:49:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: wen.xu@gatech.edu

Add several more validations to xfs_dinode_verify:

- For LOCAL data fork formats, di_nextents must be 0.
- For LOCAL attr fork formats, di_anextents must be 0.
- For inodes with no attr fork offset,
  - format must be XFS_DINODE_FMT_EXTENTS if set at all
  - di_anextents must be 0.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4fe17b368316..72ab4d2df8cf 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -458,6 +458,8 @@ xfs_dinode_verify(
 				return __this_address;
 			if (di_size > XFS_DFORK_DSIZE(dip, mp))
 				return __this_address;
+			if (dip->di_nextents)
+				return __this_address;
 			/* fall through */
 		case XFS_DINODE_FMT_EXTENTS:
 		case XFS_DINODE_FMT_BTREE:
@@ -476,12 +478,25 @@ xfs_dinode_verify(
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
+	} else {	/* No attr fork */
+		switch (dip->di_aformat) {
+		case 0:	/* Uninitialized OK */
+		case XFS_DINODE_FMT_EXTENTS:
+			break;
+		default:
+			return __this_address;
+		}
+		if (dip->di_anextents)
+			return __this_address;
 	}
 
 	/* only version 3 or greater inodes are extensively verified here */

