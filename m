Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932273AbeAWW7x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 17:59:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_copy: accept CRC version of ABTB_MAGIC in ASSERT
Message-ID: <9c888b88-b664-730c-a1ff-50ee438714dd@redhat.com>
Date: Tue, 23 Jan 2018 16:59:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Radek Burkat <radek@pinkbike.com>

Not sure how this was missed for so long, but to handle CRC
filesystems, this ASSERT on block magic must accept CRC magic
as well.

Reported-by: Radek Burkat <radek@pinkbike.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(yes, it's > 80 cols but .. so is most of this indented 
code block o_O)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fb37375..16ee4d9 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1140,7 +1140,8 @@ main(int argc, char **argv)
 				 ((char *) btree_buf.data +
 				  pos - btree_buf.position);
 
-			ASSERT(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC);
+			ASSERT(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC ||
+			       be32_to_cpu(block->bb_magic) == XFS_ABTB_CRC_MAGIC);
 		}
 
 		/*

