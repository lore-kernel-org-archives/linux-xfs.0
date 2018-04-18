Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbeDRCrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:47 -0400
Subject: [PATCH 09/11] xfs_repair: don't assert if we run across a dir entry
 with null ino ptr
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:47:27 -0700
Message-ID: <152401964787.13319.7143262291746238151.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we encounter a directory with an entry that points to inode zero,
we'll crash due to an ASSERT during process_inode_chunk.  Instead, just
set the in-core parent to NULLFSINO so that phase 6 will reset it for
us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dino_chunks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 17de95f..2d34079 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -874,7 +874,8 @@ process_inode_chunk(
 			 * be solid then.
 			 */
 			if (!ino_discovery)  {
-				ASSERT(parent != 0);
+				if (parent == 0)
+					parent = NULLFSINO;
 				set_inode_parent(ino_rec, irec_offset, parent);
 				ASSERT(parent ==
 					get_inode_parent(ino_rec, irec_offset));

